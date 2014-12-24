//
//  XBCollectionView.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/10/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import "XBCollectionView.h"
#import "ASIFormDataRequest.h"
#import "XBExtension.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "XBDataFetching.h"
#import "CHTCollectionViewWaterfallLayout.h"

@interface XBCollectionView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XBDataFetchingDelegate, CHTCollectionViewDelegateWaterfallLayout>
{
    
}

@end


@implementation XBCollectionView
@synthesize xbDelegate;
@synthesize postParams;
@synthesize datalist;
@synthesize informations;
@synthesize dataFetching;
@synthesize isMultipleSection;
@synthesize refreshControl;
@synthesize backupWhenSearch;
@synthesize pageControl;
@synthesize requestDelegate;

- (void)setupDelegate
{
    self.delegate = self;
    self.dataSource = self;
    [self reloadPageControl];
}

- (void)reloadPageControl
{
    if (pageControl)
    {
        pageControl.numberOfPages = self.contentSize.width / self.frame.size.width;
        pageControl.currentPage = self.contentOffset.x / self.frame.size.width;
    }
}

- (void)reloadData
{
    [super reloadData];
    [self reloadPageControl];
}

- (void)setupWaterFall
{
    CHTCollectionViewWaterfallLayout *waterfallLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    waterfallLayout.columnCount = [self.informations[@"waterfall"][@"numberOfColumns"] intValue];
    self.collectionViewLayout = waterfallLayout;
}

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier
{
    [self registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)configHeightAfterFillData
{
    if ([self.informations[@"isFullTable"] boolValue])
    {
        self.translatesAutoresizingMaskIntoConstraints = YES;
        CGRect f = self.frame;
        if ([(UICollectionViewFlowLayout *)self.collectionViewLayout scrollDirection] == UICollectionViewScrollDirectionVertical)
        {
            CGSize s = self.contentSize;
            f.size.height = s.height;
        }
        else if ([self.datalist count] == 0)
        {
            f.size.height = 0;
        }
        self.frame = f;
        [self.superview setNeedsUpdateConstraints];
    }
}

#pragma mark - UITableViewDelegateAndDataSource

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (pageControl && [self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]])
    {
        [self reloadPageControl];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.datalist count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    long count = [self.datalist[section][@"items"] count];
    if ([self.informations[@"loadMore"][@"enable"] boolValue] && (section == [self.datalist count] - 1))
    {
        count ++;
    }
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)_collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([informations[@"waterfall"][@"enable"] boolValue])
    {
        NSDictionary *item = [self cellInfoForPath:indexPath];
        UINib *nib = [UINib loadResourceWithInformation:item];
        UICollectionViewCell *sizingCell = [[nib instantiateWithOwner:nil options:nil] lastObject];
        CGRect f = sizingCell.frame;
        f.size.width = [(CHTCollectionViewWaterfallLayout *)self.collectionViewLayout itemWidthInSectionAtIndex:indexPath.section];
        sizingCell.frame = f;
        [sizingCell applyTemplate:item[@"elements"] andInformation:datalist[indexPath.section][@"items"][indexPath.row]];
        return [self calculateSizeForConfiguredSizingCell:sizingCell];
    }
    else
    {
        NSDictionary *size = self.informations[@"size"];
        if ([size[@"autoResize"] boolValue])
        {
            NSDictionary *item = [self cellInfoForPath:indexPath];
            UINib *nib = [UINib loadResourceWithInformation:item];
            UICollectionViewCell *sizingCell = [[nib instantiateWithOwner:nil options:nil] lastObject];
            [sizingCell applyTemplate:item[@"elements"] andInformation:datalist[indexPath.section][@"items"][indexPath.row]];
            return [self calculateSizeForConfiguredSizingCell:sizingCell];
        }
        else
        {
            if ([size[@"percentage"] boolValue])
            {
                return CGSizeMake([size[@"width"] floatValue] * self.frame.size.width, [size[@"height"] floatValue] * self.frame.size.width);
            }
            else
            {
                return CGSizeMake([size[@"width"] floatValue], [size[@"height"] floatValue]);
            }
        }
    }
}

- (CGSize)calculateSizeForConfiguredSizingCell:(UICollectionViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.informations[@"loadMore"][@"enable"] boolValue] && (indexPath.row == [[self.datalist lastObject][@"items"] count]) && (indexPath.section == ([self.datalist count] - 1)))
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.informations[@"loadMore"][@"identify"] forIndexPath:indexPath];
        return cell;
    }
    NSDictionary *item = [self cellInfoForPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:item[@"cellIdentify"] forIndexPath:indexPath];
    [cell applyTemplate:item[@"elements"] andInformation:self.datalist[indexPath.section][@"items"][indexPath.row] withTarget:self];

    if ([xbDelegate respondsToSelector:@selector(xbCollectionView:cellForRowAtIndexPath:withPreparedCell:withItem:)])
    {
        cell = [xbDelegate xbCollectionView:self cellForRowAtIndexPath:indexPath withPreparedCell:cell withItem:self.datalist[indexPath.section][@"items"][indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (xbDelegate && [xbDelegate respondsToSelector:@selector(xbCollectionView:didSelectRowAtIndexPath:forItem:)])
    {
        [xbDelegate xbCollectionView:self didSelectRowAtIndexPath:indexPath forItem:self.datalist[indexPath.section][@"items"][indexPath.row]];
    }
}

- (void)didPressButton:(UIButton *)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:buttonPosition];
    if (indexPath != nil && xbDelegate && [xbDelegate respondsToSelector:@selector(xbCollectionView:didSelectButton:atIndexPath:forItem:)])
    {
        [xbDelegate xbCollectionView:self didSelectButton:btn atIndexPath:indexPath forItem:self.datalist[indexPath.section][@"items"][indexPath.row]];
    }
}

@end
