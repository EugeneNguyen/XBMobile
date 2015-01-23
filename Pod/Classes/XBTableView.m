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
@synthesize postParams = _postParams;
@synthesize datalist;
@synthesize isMultipleSection;
@synthesize xbDelegate;
@synthesize dataFetching;
@synthesize refreshControl;
@synthesize backupWhenSearch;
@synthesize requestDelegate;
@synthesize dataListSource;

- (void)setupDelegate
{
    self.delegate = self;
    self.dataSource = self;
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

#pragma mark - UITableViewDelegateAndDataSource

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 10;
    if(y > h + reload_distance) {
        [self scrolledToBottom];
    }
    if ([xbDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [xbDelegate scrollViewDidScroll:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self ableToShowNoData]) return 1;
    return [datalist count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self ableToShowNoData]) return self.frame.size.height;
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
        
        UINib *nib = [UINib loadResourceWithInformation:item];
        UITableViewCell *sizingCell = [[nib instantiateWithOwner:nil options:nil] lastObject];
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
    return size.height + 1.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self ableToShowNoData]) return 1;
    long count = [datalist[section][@"items"] count];
    if ([self.informations[@"loadMore"][@"enable"] boolValue] && self.informations[@"loadMore"][@"identify"] && self.informations[@"loadMore"][@"xib"] && (section == [datalist count] - 1))
    {
        count ++;
    }
    return count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [self cellInfoForPath:indexPath];
    return [item[@"deletable"] boolValue];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (xbDelegate && [xbDelegate respondsToSelector:@selector(xbTableView:didDeleteRowAtIndexPath:forItem:)])
        {
            [xbDelegate xbTableView:self didDeleteRowAtIndexPath:indexPath forItem:datalist[indexPath.section][@"items"][indexPath.row]];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self ableToShowNoData])
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_informations[@"NoDataCell"][@"cellIdentify"] forIndexPath:indexPath];
        return cell;
    }
    if ([self.informations[@"loadMore"][@"enable"] boolValue] && self.informations[@"loadMore"][@"identify"] && self.informations[@"loadMore"][@"xib"] && (indexPath.row == [[datalist lastObject][@"items"] count]) && (indexPath.section == ([datalist count] - 1)))
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
    if ([self ableToShowNoData])
    {
        [self requestData];
        return;
    }
    if (xbDelegate && [xbDelegate respondsToSelector:@selector(xbTableView:didSelectRowAtIndexPath:forItem:)])
    {
        [xbDelegate xbTableView:self didSelectRowAtIndexPath:indexPath forItem:datalist[indexPath.section][@"items"][indexPath.row]];
    }
    else if (datalist[indexPath.section][@"items"][indexPath.row][@"push"])
    {
        UIViewController *viewController = [self firstAvailableUIViewController];
        if (viewController && viewController.navigationController)
        {
            NSString *push = datalist[indexPath.section][@"items"][indexPath.row][@"push"];
            Class class = NSClassFromString(push);
            if (class)
            {
                id nextView = [[class alloc] init];
                [viewController.navigationController pushViewController:nextView animated:YES];
            }
            else
            {
                push = [self cellInfoForPath:indexPath][@"push"];
                class = NSClassFromString(push);
                if (class)
                {
                    id nextView = [[class alloc] init];
                    [viewController.navigationController pushViewController:nextView animated:YES];
                }
            }
        }
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

@end
