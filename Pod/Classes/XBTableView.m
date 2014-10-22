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
    datalist = [data mutableCopy];
}

- (void)setInformations:(NSDictionary *)info
{
    _informations = info;
    self.dataSource = self;
    self.delegate = self;
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
        [self reloadData];
        [self configHeightAfterFillData];
    }
}

- (void)configHeightAfterFillData
{
    if ([_informations[@"isFullTable"] boolValue])
    {
        CGSize s = self.contentSize;
        NSLog(@"%@", NSStringFromCGSize(s));
        CGRect f = self.frame;
        f.size.height = s.height;
        self.frame = f;
        [self.superview setNeedsLayout];
    }
}

#pragma mark - DataFetching Delegate

- (void)requestDidFinish:(XBDataFetching *)_dataFetching
{
    NSLog(@"%@", [[_dataFetching.request responseString] objectFromJSONString]);
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [datalist count])
    {
        NSDictionary *item = [self cellInfoForPath:indexPath];
        if ([item[@"fixedHeight"] floatValue] > 0)
        {
            return [item[@"fixedHeight"] floatValue];
        }
        UITableViewCell *sizingCell = [self dequeueReusableCellWithIdentifier:item[@"cellIdentify"]];
        [sizingCell applyTemplate:item[@"elements"] andInformation:datalist[indexPath.row]];
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
    long count = [datalist count];
    if ([_informations[@"loadMore"][@"enable"] boolValue])
    {
        count ++;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_informations[@"loadMore"][@"enable"] boolValue] && indexPath.row == [datalist count])
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_informations[@"loadMore"][@"identify"] forIndexPath:indexPath];
        return cell;
    }

    NSDictionary *item = [self cellInfoForPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item[@"cellIdentify"] forIndexPath:indexPath];
    [cell applyTemplate:item[@"elements"] andInformation:datalist[indexPath.row]];

    if ([xbDelegate respondsToSelector:@selector(xbTableView:cellForRowAtIndexPath:withPreparedCell:)])
    {
        cell = [xbDelegate xbTableView:self cellForRowAtIndexPath:indexPath withPreparedCell:cell];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (xbDelegate && [xbDelegate respondsToSelector:@selector(xbTableView:didSelectRowAtIndexPath:forItem:)])
    {
        [xbDelegate xbTableView:self didSelectRowAtIndexPath:indexPath forItem:datalist[indexPath.row]];
    }
}

- (void)didPressButton:(UIButton *)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:self];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil && xbDelegate && [xbDelegate respondsToSelector:@selector(xbTableView:didSelectButton:atIndexPath:forItem:)])
    {
        [xbDelegate xbTableView:self didSelectButton:btn atIndexPath:indexPath forItem:datalist[indexPath.row]];
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
        return _informations[@"cells"][[datalist[indexPath.row][path] intValue]];
    }
    else
    {
        return _informations[@"cells"][0];
    }
}

@end
