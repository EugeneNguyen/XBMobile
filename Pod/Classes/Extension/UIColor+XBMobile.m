//
//  UIColor+XBMobile.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 4/26/15.
//
//

#import "UIColor+XBMobile.h"
#import "AVHexColor.h"

@implementation UIColor (XBMobile)

- (UIColor *)colorWithR:(int)r G:(int)g B:(int)b
{
    return [UIColor colorWithRed:(float)r / 255.0f green:(float)g / 255.0f blue:(float) b / 255.0f alpha:1];
}

@end
