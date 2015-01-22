//
//  NSDate+XBTimeFormat.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 1/22/15.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (XBTimeFormat)

- (NSString *)niceFormatSince:(NSDate *)date;
- (NSString *)niceFormatSinceNow;

@end
