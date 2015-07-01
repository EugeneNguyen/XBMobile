//
//  UIView+XBMobile.m
//  
//
//  Created by Binh Nguyen Xuan on 6/30/15.
//
//

#import "UIView+XBMobile.h"
#import "XBMobile.h"

NSString * const kViewInformationKey = @"kViewInformationKey";

@implementation UIView (XBMobile)

- (void)load:(NSDictionary *)viewInformation
{
    [self createSubviews:viewInformation[@"subviews"]];
    [self process:viewInformation];
    [self position:viewInformation];
}

- (void)createSubviews:(NSArray *)subviews
{
    for (NSDictionary *subviewInformation in subviews)
    {
        UIView *view = [self initView:subviewInformation];
        [self addSubview:view];
        
        [view load:subviewInformation];
    }
}

- (UIView *)initView:(NSDictionary *)information
{
    NSString *type = information[@"type"];
    if ([type isEqualToString:@"image"])
    {
        return [[UIImageView alloc] init];
    }
    if ([type isEqualToString:@"button"])
    {
        return [[UIButton alloc] init];
    }
    if ([type isEqualToString:@"label"])
    {
        return [[UILabel alloc] init];
    }
    return [[UIView alloc] init];
}

- (void)position:(NSDictionary *)information
{
    float x = [information[@"x"] floatValue];
    float y = [information[@"y"] floatValue];
    CGSize s = self.frame.size;
    CGSize superSize = self.superview.frame.size;
    
    self.frame = CGRectMake(superSize.width / 2 + x - s.width / 2, superSize.height / 2 - y - s.height / 2, s.width, s.height);
}

#pragma mark - ImageView process

- (void)process:(NSDictionary *)information
{
    
}

@end
