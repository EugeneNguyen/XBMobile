//
//  NSString+XBExtension.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 6/3/15.
//
//

#import "NSString+XBExtension.h"
#import "NSDate+XBExtension.h"

@implementation NSString (XBExtension)

- (NSDate *)dateWithFormat:(NSString *)format
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    return [df dateFromString:self];
}

- (NSString *)convertFromDateFormat:(NSString *)fromFormat toDateFormat:(NSString *)toFormat
{
    NSDate *date = [self dateWithFormat:fromFormat];
    return [date stringWithFormat:toFormat];
}

@end
