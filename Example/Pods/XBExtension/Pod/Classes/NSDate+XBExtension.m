//
//  NSDate+XBExtension.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 6/3/15.
//
//

#import "NSDate+XBExtension.h"

@implementation NSDate (XBExtension)

- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    return [df stringFromDate:self];
}

@end
