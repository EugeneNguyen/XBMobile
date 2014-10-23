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
#import "DDNSLoggerLogger.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

static XBMobile *__sharedXBMobileInstance = nil;

@interface XBMobile ()
{
    NSDictionary *info;
}

@end

@implementation XBMobile

+ (id)sharedInstance
{
    if (!__sharedXBMobileInstance)
    {
        __sharedXBMobileInstance = [[XBMobile alloc] init];

        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [DDLog addLogger:[DDNSLoggerLogger sharedInstance]];
    }
    return __sharedXBMobileInstance;
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

@end
