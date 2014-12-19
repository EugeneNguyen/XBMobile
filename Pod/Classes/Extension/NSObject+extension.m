//
//  NSObject+extension.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/4/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+extension.h"
#import "MBProgressHUD.h"
#import <CoreData/CoreData.h>

@implementation NSObject (extension)

- (void)alert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

- (void)showHUD:(NSString *)string
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = string;
}

- (void)hideHUD
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
}

- (id)objectForPath:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"/"];
    id obj = self;
    for (NSString *s in array)
    {
        if ([s length] == 0)
        {
            obj = obj;
        }
        else if ([obj isKindOfClass:[NSDictionary class]])
        {
            obj = obj[s];
        }
        else if ([obj isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)obj;
            if ([s intValue] < 0 || [s intValue] >= [array count])
            {
                return @"";
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
            else if ([obj respondsToSelector:NSSelectorFromString(s)])
            {
                obj = [obj performSelector:NSSelectorFromString(s)];
            }
            else
            {
                return @"";
            }
        }
        else if ([obj respondsToSelector:NSSelectorFromString(s)])
        {
            obj = [obj performSelector:NSSelectorFromString(s)];
        }
    }
    return obj;
}

@end

@implementation NSArray (loadPlist)

+ (NSArray *)arrayWithContentsOfPlist:(NSString *)plistname
{
    NSString *path = [[NSBundle mainBundle] pathForResource:plistname ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}

+ (NSArray *)arrayWithContentsOfPlist:(NSString *)plistname bundleName:(NSString *)name
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:plistname ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}

@end

@implementation NSDictionary (loadPlist)

+ (NSDictionary *)dictionaryWithContentsOfPlist:(NSString *)plistname
{
    NSString *path = [[NSBundle mainBundle] pathForResource:plistname ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

+ (NSDictionary *)dictionaryWithContentsOfPlist:(NSString *)plistname bundleName:(NSString *)name
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:plistname ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

@end
