//
//  NSArray+extension.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/10/14.
//
//

#import "NSArray+extension.h"

@implementation NSArray (extension)

+ (NSArray *)arrayWithContentsOfPlist:(NSString *)path
{
    NSString *plistpath = [[NSBundle mainBundle] pathForResource:path ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:plistpath];
}

@end
