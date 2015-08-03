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
@synthesize host = _host;

+ (XBMobile *)sharedInstance
{
    if (!__sharedXBMobileInstance)
    {
        __sharedXBMobileInstance = [[XBMobile alloc] init];
    }
    return __sharedXBMobileInstance;
}

- (void)setHost:(NSString *)host
{
    _host = host;
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
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        Class userNotifyClass = NSClassFromString(@"UIUserNotificationSettings");
        if(userNotifyClass != nil)
        {
            id notifyInstance = [userNotifyClass settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
            [application registerUserNotificationSettings:notifyInstance];
            [application registerForRemoteNotifications];
        }
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        int notifyType = (UIRemoteNotificationTypeAlert |
                          UIRemoteNotificationTypeBadge |
                          UIRemoteNotificationTypeSound);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationType)notifyType];
#pragma clang diagnostic pop
    }
}

@end
