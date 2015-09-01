//
//  UITextField+XBExtension.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 7/3/15.
//
//

#import "UITextField+XBExtension.h"
#import <objc/runtime.h>

NSString * const kDisabledCharacterSet = @"kDisabledCharacterSet";
NSString * const kReplacementSet = @"kReplacementSet";

@implementation UITextField (XBExtension)
@dynamic disabledCharacterSet;
@dynamic replacementSet;

- (void)setDisabledCharacterSet:(NSCharacterSet *)disabledCharacterSet
{
    objc_setAssociatedObject(self, (__bridge const void *)(kDisabledCharacterSet), disabledCharacterSet, OBJC_ASSOCIATION_RETAIN);
    if (disabledCharacterSet)
    {
        [self removeTarget:self action:@selector(didChangeText:) forControlEvents:UIControlEventEditingChanged];
        [self addTarget:self action:@selector(didChangeText:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (id)disabledCharacterSet
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kDisabledCharacterSet));
}

- (void)setReplacementSet:(NSDictionary *)replacementSet
{
    objc_setAssociatedObject(self, (__bridge const void *)(kReplacementSet), replacementSet, OBJC_ASSOCIATION_RETAIN);
    if (replacementSet)
    {
        [self removeTarget:self action:@selector(didChangeText:) forControlEvents:UIControlEventEditingChanged];
        [self addTarget:self action:@selector(didChangeText:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (NSDictionary *)replacementSet
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kReplacementSet));
}

- (void)didChangeText:(id)sender
{
    for (NSString *key in self.replacementSet)
    {
        self.text = [self.text stringByReplacingOccurrencesOfString:key withString:self.replacementSet[key]];
    }
    self.text = [[self.text componentsSeparatedByCharactersInSet:self.disabledCharacterSet] componentsJoinedByString:@""];
}

- (void)activeUsernameLimitation
{
    self.disabledCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."] invertedSet];
    self.replacementSet = @{@" ": @"_"};
}

- (void)s
{
    self.disabledCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."] invertedSet];
}

- (void)activeEmailLimitation
{
    self.disabledCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-.@"] invertedSet];
}

@end
