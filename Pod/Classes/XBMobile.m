//
//  XBMobile.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/2/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import "XBMobile.h"
#import "XBViewController.h"
#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

static XBMobile *__sharedXBMobileInstance = nil;

@interface XBMobile ()
{
    NSDictionary *info;
}

@end

@implementation XBMobile
@synthesize host;

+ (id)sharedInstance
{
    if (!__sharedXBMobileInstance)
    {
        __sharedXBMobileInstance = [[XBMobile alloc] init];
    }
    return __sharedXBMobileInstance;
}

- (void)activeLog
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)settingWithInformation:(NSDictionary *)_info
{
    info = _info;
}

- (void)initRootViewController
{
    
}

+ (void)registerPush
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

@end
