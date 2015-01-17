//
//  NSString+extension.h
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/17/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (extension)

- (NSString *)applyData:(NSDictionary *)data;

- (BOOL)validateEmail;

- (NSDate *)mysqlDate;

+ (NSString *)uuidString;

- (NSString *)emojiEncode;

- (NSString *)emojiDecode;

@end
