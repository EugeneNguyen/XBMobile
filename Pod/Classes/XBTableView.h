//
//  XBTableView.h
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/2/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBTableView;
@class XBDataFetching;

@protocol XBTableViewDelegate <NSObject>

@optional

- (void)xbTableView:(XBTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath forItem:(id)item;
- (void)xbTableView:(XBTableView *)tableView didSelectButton:(UIButton *)btn atIndexPath:(NSIndexPath *)indexPath forItem:(id)item;
- (UITableViewCell *)xbTableView:(XBTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withPreparedCell:(UITableViewCell *)cell;

@end

@interface XBTableView : UITableView
{

}

@property (nonatomic, retain) NSDictionary *informations;

@property (nonatomic, retain) NSDictionary *postParams;

@property (nonatomic, assign) BOOL usingHUD, usingErrorAlert;

@property (nonatomic, retain) IBOutlet id <XBTableViewDelegate> xbDelegate;

@property (nonatomic, retain) XBDataFetching *dataFetching;

- (void)loadInformationFromPlist:(NSString *)plist;
- (void)loadData:(NSArray *)data;

@end
