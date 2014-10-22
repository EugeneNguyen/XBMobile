//
//  NSString+extension.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/17/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import "NSString+extension.h"
#import <Foundation/Foundation.h>

@implementation NSString (extension)

- (NSString *)applyData:(NSDictionary *)data
{
    NSString *result = [self copy];
    for (NSString *s in [data allKeys])
    {
        result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%@}", s] withString:[NSString stringWithFormat:@"%@", data[s]]];
    }
    return result;
}

@end
