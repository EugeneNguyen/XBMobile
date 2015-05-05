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
#import "XBDatabase_plist.h"

#import "NSObject+XBDataList.h"
#import "UINib+load.h"
#import "NSObject+extension.h"
#import "UIView+extension.h"
#import "NSString+extension.h"
#import "UIColor+XBMobile.h"

#import <AVHexColor.h>

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface XBMobile : UIWindow
{

}

@property (nonatomic, retain) NSString *host;

- (void)settingWithInformation:(NSDictionary *)info;
- (void)activeLog;

+ (XBMobile *)sharedInstance;
+ (void)registerPush;

@end
