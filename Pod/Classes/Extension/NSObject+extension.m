//
//  NSObject+extension.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/4/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+extension.h"
#import <CoreData/CoreData.h>

@implementation NSObject (extension)

- (id)objectForPath:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"/"];
    id obj = self;
    for (NSString *s in array)
    {
        SEL selector = NSSelectorFromString(s);
        if ([s length] == 0)
        {
            obj = obj;
        }
        else if ([obj isKindOfClass:[NSDictionary class]])
        {
            if (obj[s])
            {
                obj = obj[s];
            }
            else
            {
                return nil;
            }
        }
        else if ([obj isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)obj;
            if ([s intValue] < 0 || [s intValue] >= [array count])
            {
                return nil;
            }
            else
            {
                obj = obj[[s intValue]];
            }
        }
        else if ([obj isKindOfClass:[NSManagedObject class]])
        {
            NSManagedObject *managedObject = (NSManagedObject *)obj;
            BOOL foundKey = [[[managedObject.entity attributesByName] allKeys] indexOfObjectPassingTest:^BOOL(id object, NSUInteger idx, BOOL *stop) {
                return [object isEqualToString:s];
            }] != NSNotFound;
            if (foundKey)
            {
                obj = [(NSManagedObject *)obj valueForKey:s];
            }
            else if ([obj respondsToSelector:selector])
            {
                obj = [obj performSelector:selector];
            }
            else
            {
                return nil;
            }
        }
        else if ([obj respondsToSelector:selector])
        {
            obj = [obj performSelector:selector];
        }
    }
    return obj;
}

@end
