//
//  XBTableView.h
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/2/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+XBDataList.h"
#import "TPKeyboardAvoidingTableView.h"

@class XBTableView;
@class XBDataFetching;

@protocol XBTableViewDelegate <UIScrollViewDelegate>

@optional

- (void)xbTableView:(XBTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath forItem:(id)item;
- (void)xbTableView:(XBTableView *)tableView didDeleteRowAtIndexPath:(NSIndexPath *)indexPath forItem:(id)item;
- (void)xbTableView:(XBTableView *)tableView didSelectButton:(UIButton *)btn atIndexPath:(NSIndexPath *)indexPath forItem:(id)item;
- (UITableViewCell *)xbTableView:(XBTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withPreparedCell:(UITableViewCell *)cell withItem:(id)item;

@end

@interface XBTableView : TPKeyboardAvoidingTableView <XBDataList>
{
    
}

@property (nonatomic, assign) IBOutlet id <XBTableViewDelegate> xbDelegate;

@property (nonatomic, assign) IBOutlet id <XBDataListSource> dataListSource;

- (void)didPressButton:(UIButton *)btn;

@end
