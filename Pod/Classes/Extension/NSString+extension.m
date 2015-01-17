//
//  NSString+extension.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/17/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import "NSString+extension.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSObject+extension.h"

@implementation NSString (extension)

- (NSString *)applyData:(NSDictionary *)data
{
    NSString *resultString = [self copy];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{[^\\{\\}]*\\}" options:NSRegularExpressionAnchorsMatchLines error:&error];
    NSArray *keys = [regex matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, [self length])];
    
    for (NSTextCheckingResult *result in keys)
    {
        NSString *s = [self substringWithRange:result.range];
        s = [s substringWithRange:NSMakeRange(1, [s length] - 2)];
        
        NSString *key = [data objectForPath:s];
        resultString = [resultString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%@}", s] withString:[NSString stringWithFormat:@"%@", key]];
    }
    return resultString;
}

- (BOOL)validateEmail
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (NSDate *)mysqlDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [df dateFromString:self];
}

+ (NSString *)uuidString {
    // Returns a UUID
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidString;
}

- (NSString *)emojiEncode
{
    NSString *uniText = [NSString stringWithUTF8String:[self UTF8String]];
    NSData *msgData = [uniText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    return [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding] ;
}

- (NSString *)emojiDecode
{
    const char *jsonString = [self UTF8String];
    NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
    return [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
}

@end
