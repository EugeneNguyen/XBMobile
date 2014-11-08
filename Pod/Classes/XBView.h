//
//  XBView.h
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/17/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBView : UIView
{

}

@property (nonatomic, retain) NSDictionary *informations;

@property (nonatomic, retain) NSDictionary *postParams;

@property (nonatomic, assign) BOOL usingHUD, usingErrorAlert;

- (void)loadInformationFromPlist:(NSString *)plist;
- (void)loadData:(NSDictionary *)data;

@end