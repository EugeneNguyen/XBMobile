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

- (void)setAttributeText:(NSString *)text
{
    [self setTitle:text forState:UIControlStateNormal];
}

- (void)setAttributeImage:(NSString *)imageString
{
    UIImage *image = [UIImage imageNamed:imageString];
    if (image)
    {
        CGSize s = image.size;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, s.width, s.height);
        [self setImage:image forState:UIControlStateNormal];
    }
}

- (void)setAttributeBackgroundImage:(NSString *)imageString
{
    UIImage *image = [UIImage imageNamed:imageString];
    if (image)
    {
        CGSize s = image.size;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, s.width, s.height);
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
}

- (void)setAttributeTextFont
{
    [self.titleLabel setFont:[UIFont fontWithName:self.viewInformation[@"text-font"]
                                             size:[self.viewInformation[@"text-size"] floatValue]]];
}

- (void)setAttributeTextColor:(NSString *)hexString
{
    self.titleLabel.textColor = XBHexColor(hexString);
}

- (void)setAttributeAction:(NSString *)action
{
    SEL selector = NSSelectorFromString(action);
    [self addTarget:self.owner action:selector forControlEvents:UIControlEventTouchUpInside];
}

@end
