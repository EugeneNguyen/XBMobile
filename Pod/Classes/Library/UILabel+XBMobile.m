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

- (void)setAttributeText:(NSString *)text
{
    self.text = text;
}

- (void)setAttributeTextFont
{
    [self setFont:[UIFont fontWithName:self.viewInformation[@"text-font"]
                                  size:[self.viewInformation[@"text-size"] floatValue]]];
}

- (void)setAttributeTextColor:(NSString *)hexString
{
    self.textColor = XBHexColor(hexString);
}

- (void)reloadFromRemoteData
{
    [super reloadFromRemoteData];
    if ([self dataForKey:@"text-path"])
    {
        self.text = [self dataForKey:@"text-path"];
    }
}


@end
