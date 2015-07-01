//
//  UILabel+XBMobile.m
//  
//
//  Created by Binh Nguyen Xuan on 6/30/15.
//
//

#import "UILabel+XBMobile.h"
#import "UIView+XBMobile.h"
#import "XBMobile.h"

@implementation UILabel (XBMobile)

- (void)process:(NSDictionary *)information
{
    [super process:information];
    if (information[@"text"])
    {
        self.text = information[@"text"];
    }
    if (information[@"text-color"])
    {
        self.textColor = XBHexColor(information[@"text-color"]);
    }
    if (information[@"text-font"])
    {
        [self setFont:[UIFont fontWithName:information[@"text-font"] size:[information[@"text-size"] floatValue]]];
    }
}

@end
