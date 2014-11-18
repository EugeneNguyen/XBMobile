//
//  NSString+extension.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/17/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import "NSString+extension.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@implementation NSString (extension)

- (NSString *)applyData:(NSDictionary *)data
{
    NSString *result = [self copy];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        for (NSString *s in [data allKeys])
        {
            result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%@}", s] withString:[NSString stringWithFormat:@"%@", data[s]]];
        }
    }
    else if ([data isKindOfClass:[NSManagedObject class]])
    {
        NSManagedObject *obj = (NSManagedObject *)data;
        for (NSString *s in [[obj.entity attributesByName] allKeys])
        {
            result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%@}", s] withString:[NSString stringWithFormat:@"%@", [obj valueForKey:s]]];
        }
    }
    return result;
}

- (BOOL)validateEmail
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
