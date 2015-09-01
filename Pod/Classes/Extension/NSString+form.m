//
//  NSString+form.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/15/14.
//
//

#import "NSString+form.h"
#import "XBMobile.h"

NSString *const XBFormDataErrorMaxLength = @"XBFormDataErrorMaxLength";
NSString *const XBFormDataErrorMinLength = @"XBFormDataErrorMinLength";
NSString *const XBFormDataErrorRequired = @"XBFormDataErrorRequired";


@implementation NSString (form)

- (NSArray *)validateWithInformation:(NSDictionary *)item
{
    NSMutableArray *error = [@[] mutableCopy];
    // check Max length
    
    if (item[@"maxLength"])
    {
        int maxLength = [item[@"maxLength"] intValue];
        if (self.length > maxLength)
        {
            [error addObject:XBFormDataErrorMaxLength];
        }
    }
    
    // check Min length
    
    if (item[@"minLength"])
    {
        int minLength = [item[@"minLength"] intValue];
        if (self.length < minLength)
        {
            [error addObject:XBFormDataErrorMinLength];
        }
    }
    
    if ([item[@"required"] boolValue])
    {
        if (self.length == 0)
        {
            [error addObject:XBFormDataErrorRequired];
        }
    }
    
    // check max length
    return error;
}

@end
