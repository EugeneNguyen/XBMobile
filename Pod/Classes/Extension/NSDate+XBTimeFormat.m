//
//  NSDate+XBTimeFormat.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 1/22/15.
//
//

#import "NSDate+XBTimeFormat.h"
#import "XBLanguage.h"

@implementation NSDate (XBTimeFormat)

- (NSString *)niceFormatSince:(NSDate *)date
{
    NSString * agoString;
    NSTimeInterval second = [self timeIntervalSinceDate:date];
    if (second < 0)
    {
        agoString = XBText(@"ago", @"timeformat");
    }
    else
    {
        agoString = XBText(@"left", @"timeformat");
    }
    second = ABS(second);
    
    if (second < 60)
    {
        return [NSString stringWithFormat:XBText(@"%d seconds %@", @"timeformat"), (int)second, agoString];
    }
    else
    {
        second = second / 60;
        if (second < 60)
        {
            return [NSString stringWithFormat:XBText(@"%d minutes %@", @"timeformat"), (int)second, agoString];
        }
        else
        {
            second = second / 60;
            if (second < 24)
            {
                return [NSString stringWithFormat:XBText(@"%d hours %@", @"timeformat"), (int)second, agoString];
            }
            else
            {
                
            }
        }
    }
    
}

- (NSString *)niceFormatSinceNow
{
    return  [self niceFormatSince:[NSDate date]];
}

@end
