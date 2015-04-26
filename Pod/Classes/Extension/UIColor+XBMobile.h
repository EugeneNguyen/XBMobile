//
//  UIColor+XBMobile.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 4/26/15.
//
//

#import <UIKit/UIKit.h>

#define XBRGBColor(X, Y, Z) [UIColor colorWithR:X G:Y B:Z]
#define XBHexColor(X) [AVHexColor colorWithHexString:X]

@interface UIColor (XBMobile)

- (UIColor *)colorWithR:(int)r G:(int)g B:(int)b;

@end
