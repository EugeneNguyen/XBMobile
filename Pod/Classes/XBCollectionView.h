//
//  XBCollectionView.h
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/10/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+XBDataList.h"

@class XBCollectionView;
@class XBDataFetching;

@protocol XBCollectionViewDelegate <UIScrollViewDelegate>

@optional

- (void)xbCollectionView:(XBCollectionView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath forItem:(id)item;
- (void)xbCollectionView:(XBCollectionView *)tableView didSelectButton:(UIButton *)btn atIndexPath:(NSIndexPath *)indexPath forItem:(id)item;
- (UICollectionViewCell *)xbCollectionView:(XBCollectionView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withPreparedCell:(UICollectionViewCell *)cell withItem:(id)item;

@end

@interface XBCollectionView : UICollectionView <XBDataList>
{

}

@property (nonatomic, retain) IBOutlet id <XBCollectionViewDelegate> xbDelegate;
@property (nonatomic, assign) IBOutlet UIPageControl *pageControl;

- (void)didPressButton:(UIButton *)btn;

@end
