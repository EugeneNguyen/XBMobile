//
//  XBMobile.h
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/2/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XBTableView.h"
#import "XBCollectionView.h"
#import "XBExtension.h"
#import "DDLog.h"
#import "XBForm.h"
#import "XBTagView.h"
#import "XBLanguage.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface XBMobile : UIWindow
{

}

@property (nonatomic, retain) NSString *host;

- (void)settingWithInformation:(NSDictionary *)info;
- (void)activeLog;

+ (id)sharedInstance;
+ (void)registerPush;

@end
