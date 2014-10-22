//
//  XBMobile.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/2/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import "XBMobile.h"
#import "XBViewController.h"

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
    }
    return __sharedXBMobileInstance;
}

- (void)settingWithInformation:(NSDictionary *)_info
{
    info = _info;
}

- (void)initRootViewController
{
    
}

@end
