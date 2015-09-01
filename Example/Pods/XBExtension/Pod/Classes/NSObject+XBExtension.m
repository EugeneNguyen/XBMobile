//
//  NSObject+XBExtension.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 5/19/15.
//
//

#import "NSObject+XBExtension.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@implementation NSObject (XBExtension)

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

- (void)alert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

- (MBProgressHUD *)showHUD:(NSString *)string
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = string;
    return hud;
}

- (void)hideHUD
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
}

@end
