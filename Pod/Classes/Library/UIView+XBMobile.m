//
//  UIView+XBMobile.m
//  
//
//  Created by Binh Nguyen Xuan on 6/30/15.
//
//

#import "UIView+XBMobile.h"
#import "XBMobile.h"
#import <objc/runtime.h>

NSString * const kViewInformationKey = @"kViewInformationKey";
NSString * const kOwner = @"kOwner";

@implementation UIView (XBMobile)
@dynamic viewInformation;
@dynamic owner;

- (void)setOwner:(id)owner
{
    objc_setAssociatedObject(self, (__bridge const void *)(kOwner), owner, OBJC_ASSOCIATION_ASSIGN);
}

- (id)owner
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kOwner));
}

- (void)setViewInformation:(NSMutableDictionary *)viewInformation
{
    objc_setAssociatedObject(self, (__bridge const void *)(kViewInformationKey), viewInformation, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)viewInformation
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kViewInformationKey));
}

- (void)load:(NSDictionary *)viewInformation
{
    self.viewInformation = [viewInformation mutableCopy];
    
    [self createSubviews];
    [self process];
    [self position];
    [self loadRemoteInformation];
}

- (void)createSubviews
{
    NSArray *subviews = self.viewInformation[@"subviews"];
    for (NSDictionary *subviewInformation in subviews)
    {
        UIView *view;
        if (subviewInformation[@"tag"])
        {
            view = [self viewWithTag:[subviewInformation[@"tag"] intValue]];
            [view load:subviewInformation];
        }
        if (!view)
        {
            view = [self initView:subviewInformation];
            [self addSubview:view];
        }
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

- (void)position
{
    float x = [self.viewInformation[@"x"] floatValue];
    float y = [self.viewInformation[@"y"] floatValue];
    CGSize s = self.frame.size;
    CGSize superSize = self.superview.frame.size;
    
    self.frame = CGRectMake(superSize.width / 2 + x - s.width / 2, superSize.height / 2 - y - s.height / 2, s.width, s.height);
}

#pragma mark - Remote information

- (void)loadRemoteInformation
{
    
}

#pragma mark - ImageView process

- (void)process
{
    NSDictionary *keyToSelector = @{@"text": @"setAttributeText:",
                                    @"image": @"setAttributeImage:",
                                    @"background-image": @"setAttributeBackgroundImage:",
                                    @"text-font": @"setAttributeTextFont:",
                                    @"text-color": @"setAttributeTextColor:",
                                    @"action": @"setAttributeAction:",
                                    @"tag": @"setAttributeTag:"};
    for (NSString *key in [keyToSelector allKeys])
    {
        [self applyKey:key toSelector:keyToSelector[key]];
    }
}

- (void)applyKey:(NSString *)key toSelector:(NSString *)selectorName
{
    SEL selector = NSSelectorFromString(selectorName);
    if (self.viewInformation[key] && self.viewInformation[key] != [NSNull null] && [self respondsToSelector:selector])
    {
        [self performSelector:selector withObject:self.viewInformation[key]];
    }
}

- (void)setAttributeAction:(NSString *)action
{
    SEL selector = NSSelectorFromString(action);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.owner action:selector];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
}

@end
