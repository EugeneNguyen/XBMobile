//
//  UIButton+XBMobile.m
//  
//
//  Created by Binh Nguyen Xuan on 6/30/15.
//
//

#import "UIButton+XBMobile.h"
#import "UIView+XBMobile.h"
#import "XBMobile.h"

@implementation UIButton (XBMobile)

- (void)process:(NSDictionary *)information
{
    [super process:information];
    if (information[@"background-image"])
    {
        UIImage *image = [UIImage imageNamed:information[@"background-image"]];
        if (image)
        {
            CGSize s = image.size;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, s.width, s.height);
            [self setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
    if (information[@"text"])
    {
        [self setTitle:information[@"text"] forState:UIControlStateNormal];
    }
    if (information[@"text-color"])
    {
        [self setTitleColor:XBHexColor(information[@"text-color"]) forState:UIControlStateNormal];
    }
    if (information[@"text-font"])
    {
        [self.titleLabel setFont:[UIFont fontWithName:information[@"text-font"] size:[information[@"text-size"] floatValue]]];
    }
}

@end
