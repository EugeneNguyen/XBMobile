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
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            obj = obj[s];
        }
        else if ([obj isKindOfClass:[NSArray class]])
        {
            obj = obj[[s intValue]];
        }
        else if ([s length] == 0)
        {
            obj = obj;
        }
    }
    return obj;
}

@end
