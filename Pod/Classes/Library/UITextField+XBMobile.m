//
//  UITextField+XBMobile.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 7/6/15.
//
//

#import "UITextField+XBMobile.h"
#import "UIView+XBMobile.h"

@implementation UITextField (XBMobile)

- (void)setAttributeText:(NSString *)text
{
    self.text = text;
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
