//
//  XBTableView.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/2/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import "XBTableView.h"
#import "ASIFormDataRequest.h"
#import "XBExtension.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "XBDataFetching.h"

@interface XBTableView() <UITableViewDelegate, UITableViewDataSource, XBDataFetchingDelegate>
{
    NSMutableArray *datalist;
    UITableViewController *tableViewController;
    BOOL isMultipleSection;
}

@end

@implementation XBTableView
@synthesize informations = _informations;
@synthesize usingHUD, usingErrorAlert;
@synthesize postParams = _postParams;
@synthesize xbDelegate;
@synthesize dataFetching;

- (void)loadInformationFromPlist:(NSString *)plist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:path];
    [self setInformations:info];
}

- (void)loadData:(NSArray *)data
{
    if (isMultipleSection)
    {
        datalist = [data mutableCopy];
    }
    else
    {
        datalist = [@[@{@"title": @"root", @"items": data}] mutableCopy];
    }
    [self reloadData];
}

- (void)setInformations:(NSDictionary *)info
{
    _informations = info;
    self.dataSource = self;
    self.delegate = self;

    if (info[@"section"])
    {
        isMultipleSection = YES;
    }

    [self requestData];
    for (NSDictionary *item in _informations[@"cells"])
    {
        [self registerNib:[UINib nibWithNibName:item[@"xibname"] bundle:nil] forCellReuseIdentifier:item[@"cellIdentify"]];
    }

    if ([_informations[@"isUsingRefreshControl"] boolValue])
    {
        tableViewController = [[UITableViewController alloc] init];
        tableViewController.tableView = self;

        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(requestData) forControlEvents:UIControlEventValueChanged];
        tableViewController.refreshControl = refreshControl;
    }

    if ([_informations[@"loadMore"][@"enable"] boolValue])
    {
        [self registerNib:[UINib nibWithNibName:_informations[@"loadMore"][@"xib"] bundle:nil] forCellReuseIdentifier:_informations[@"loadMore"][@"identify"]];
    }
}

- (void)requestData
{
    if ([_informations[@"isRemoteData"] boolValue])
    {
        if (!datalist)
        {
            datalist = [NSMutableArray new];
        }

        dataFetching = [[XBDataFetching alloc] init];
        dataFetching.datalist = datalist;
        dataFetching.info = _informations;
        dataFetching.delegate = self;
        dataFetching.postParams = _postParams;
        [dataFetching startFetchingData];
    }
    else
    {
        [self configHeightAfterFillData];
    }
}

- (void)configHeightAfterFillData
{
    if ([_informations[@"isFullTable"] boolValue])
    {
        CGSize s = self.contentSize;
        CGRect f = self.frame;
        f.size.height = s.height;
        self.frame = f;
        [self.superview setNeedsLayout];
    }
}

#pragma mark - DataFetching Delegate

- (void)requestDidFinish:(XBDataFetching *)_dataFetching
{
    [self configHeightAfterFillData];
    if ([_informations[@"isUsingRefreshControl"] boolValue])
    {
        [tableViewController.refreshControl endRefreshing];
    }
}

- (void)requestDidFailed:(XBDataFetching *)_dataFetching
{
    if (usingErrorAlert)
    {
        [self alert:@"Error" message:[_dataFetching.request.error description]];
    }

    if ([_informations[@"isUsingRefreshControl"] boolValue])
    {
        [tableViewController.refreshControl endRefreshing];
    }
}

#pragma mark - UITableViewDelegateAndDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [datalist count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section < [datalist count]) && (indexPath.row < [[datalist lastObject][@"items"] count]))
    {
        NSDictionary *item = [self cellInfoForPath:indexPath];
        if ([item[@"fixedHeight"] floatValue] > 0)
        {
            return [item[@"fixedHeight"] floatValue];
        }
        UITableViewCell *sizingCell = [self dequeueReusableCellWithIdentifier:item[@"cellIdentify"]];
        [sizingCell applyTemplate:item[@"elements"] andInformation:datalist[indexPath.section][@"items"][indexPath.row]];
        return [self calculateHeightForConfiguredSizingCell:sizingCell];
    }
    else
    {
        UITableViewCell *sizingCell = [self dequeueReusableCellWithIdentifier:_informations[@"loadMore"][@"identify"]];
        return sizingCell.frame.size.height;
    }
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];

    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    long count = [datalist[section][@"items"] count];
    if ([_informations[@"loadMore"][@"enable"] boolValue] && (section == [datalist count] - 1))
    {
        count ++;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_informations[@"loadMore"][@"enable"] boolValue] && (indexPath.row == [[datalist lastObject][@"items"] count]) && (indexPath.section == ([datalist count] - 1)))
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_informations[@"loadMore"][@"identify"] forIndexPath:indexPath];
        return cell;
    }

    NSDictionary *item = [self cellInfoForPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item[@"cellIdentify"] forIndexPath:indexPath];
    [cell applyTemplate:item[@"elements"] andInformation:datalist[indexPath.section][@"items"][indexPath.row] withTarget:self];
    
    if ([xbDelegate respondsToSelector:@selector(xbTableView:cellForRowAtIndexPath:withPreparedCell:withItem:)])
    {
        cell = [xbDelegate xbTableView:self cellForRowAtIndexPath:indexPath withPreparedCell:cell withItem:datalist[indexPath.section][@"items"][indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (xbDelegate && [xbDelegate respondsToSelector:@selector(xbTableView:didSelectRowAtIndexPath:forItem:)])
    {
        [xbDelegate xbTableView:self didSelectRowAtIndexPath:indexPath forItem:datalist[indexPath.section][@"items"][indexPath.row]];
    }
}

- (void)didPressButton:(UIButton *)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:self];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil && xbDelegate && [xbDelegate respondsToSelector:@selector(xbTableView:didSelectButton:atIndexPath:forItem:)])
    {
        [xbDelegate xbTableView:self didSelectButton:btn atIndexPath:indexPath forItem:datalist[indexPath.section][@"items"][indexPath.row]];
    }
}

- (NSDictionary *)cellInfoForPath:(NSIndexPath *)indexPath
{
    if ([_informations[@"isMutipleType"] boolValue])
    {
        NSString *path = _informations[@"cellTypePath"];
        if (!path)
        {
            path = @"cell_type";
        }
        return _informations[@"cells"][[datalist[indexPath.section][@"items"][indexPath.row][path] intValue]];
    }
    return _informations[@"cells"][0];
}

@end
