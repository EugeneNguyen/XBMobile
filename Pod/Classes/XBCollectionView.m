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

@interface XBCollectionView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XBDataFetchingDelegate>
{
    NSMutableArray *datalist;
    UIRefreshControl *refreshControl;
    BOOL isMultipleSection;
}

@end


@implementation XBCollectionView
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

    [self requestData];
    for (NSDictionary *item in _informations[@"cells"])
    {
        [self registerNib:[UINib nibWithNibName:item[@"xibname"] bundle:nil] forCellWithReuseIdentifier:item[@"cellIdentify"]];
    }

    if ([_informations[@"isUsingRefreshControl"] boolValue])
    {
        refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(requestData) forControlEvents:UIControlEventValueChanged];
        [self addSubview:refreshControl];
    }

    if ([_informations[@"loadMore"][@"enable"] boolValue])
    {
        [self registerNib:[UINib nibWithNibName:_informations[@"loadMore"][@"xib"] bundle:nil] forCellWithReuseIdentifier:_informations[@"loadMore"][@"identify"]];
    }
}

- (void)configHeightAfterFillData
{
    if ([_informations[@"isFullTable"] boolValue])
    {
        self.translatesAutoresizingMaskIntoConstraints = YES;
        CGRect f = self.frame;
        if ([(UICollectionViewFlowLayout *)self.collectionViewLayout scrollDirection] == UICollectionViewScrollDirectionVertical)
        {
            CGSize s = self.contentSize;
            f.size.height = s.height;
        }
        else if ([datalist count] == 0)
        {
            f.size.height = 0;
        }
        self.frame = f;
        [self.superview setNeedsUpdateConstraints];
    }
}

- (void)requestData
{
    if ([_informations[@"isRemoteData"] boolValue])
    {
        if (!datalist)
        {
            datalist = [[NSMutableArray alloc] init];
        }

        dataFetching = [[XBDataFetching alloc] init];;
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

#pragma mark - DataFetching Delegate

- (void)requestDidFinish:(XBDataFetching *)dataFetching
{
    [self configHeightAfterFillData];
    if ([_informations[@"isUsingRefreshControl"] boolValue])
    {
        [refreshControl endRefreshing];
    }
}

- (void)requestDidFailed:(XBDataFetching *)_dataFetching
{
    [self configHeightAfterFillData];
    if (usingErrorAlert)
    {
        [self alert:@"Error" message:[_dataFetching.request.error description]];
    }

    if ([_informations[@"isUsingRefreshControl"] boolValue])
    {
        [refreshControl endRefreshing];
    }
}

#pragma mark - UITableViewDelegateAndDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [datalist count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    long count = [datalist[section][@"items"] count];
    if ([_informations[@"loadMore"][@"enable"] boolValue] && (section == [datalist count] - 1))
    {
        count ++;
    }
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)_collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *size = _informations[@"size"];
    if ([size[@"percentage"] boolValue])
    {
        return CGSizeMake([size[@"width"] floatValue] * self.frame.size.width, [size[@"height"] floatValue] * self.frame.size.width);
    }
    else
    {
        return CGSizeMake([size[@"width"] floatValue], [size[@"height"] floatValue]);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_informations[@"loadMore"][@"enable"] boolValue] && (indexPath.row == [[datalist lastObject][@"items"] count]) && (indexPath.section == ([datalist count] - 1)))
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_informations[@"loadMore"][@"identify"] forIndexPath:indexPath];
        return cell;
    }
    NSDictionary *item = [self cellInfoForPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:item[@"cellIdentify"] forIndexPath:indexPath];
    [cell applyTemplate:item[@"elements"] andInformation:datalist[indexPath.section][@"items"][indexPath.row]];

    if ([xbDelegate respondsToSelector:@selector(xbCollectionView:cellForRowAtIndexPath:withPreparedCell:withItem:)])
    {
        cell = [xbDelegate xbCollectionView:self cellForRowAtIndexPath:indexPath withPreparedCell:cell withItem:datalist[indexPath.section][@"items"][indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (xbDelegate && [xbDelegate respondsToSelector:@selector(xbCollectionView:didSelectRowAtIndexPath:forItem:)])
    {
        [xbDelegate xbCollectionView:self didSelectRowAtIndexPath:indexPath forItem:datalist[indexPath.section][@"items"][indexPath.row]];
    }
}

- (void)didPressButton:(UIButton *)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:buttonPosition];
    if (indexPath != nil && xbDelegate && [xbDelegate respondsToSelector:@selector(xbCollectionView:didSelectButton:atIndexPath:forItem:)])
    {
        [xbDelegate xbCollectionView:self didSelectButton:btn atIndexPath:indexPath forItem:datalist[indexPath.section][@"items"][indexPath.row]];
    }
}

- (NSDictionary *)cellInfoForPath:(NSIndexPath *)indexPath
{
    if ([_informations[@"isMutipleType"] boolValue])
    {
        return _informations[@"cells"][[datalist[indexPath.section][@"items"][indexPath.row][@"cell_type"] intValue]];
    }
    else
    {
        return _informations[@"cells"][0];
    }
}

@end
