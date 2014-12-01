//
//  NSObject+extension.h
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/4/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (extension)

- (void)alert:(NSString *)title message:(NSString *)message;

- (void)showHUD:(NSString *)string;

- (void)hideHUD;

- (id)objectForPath:(NSString *)string;

@end

@interface NSArray (loadPlist)

+ (NSArray *)arrayWithContentsOfPlist:(NSString *)plistname;
+ (NSArray *)arrayWithContentsOfPlist:(NSString *)plistname bundleName:(NSString *)name;

@end

@interface NSDictionary (loadPlist)

+ (NSDictionary *)dictionaryWithContentsOfPlist:(NSString *)plistname;
+ (NSDictionary *)dictionaryWithContentsOfPlist:(NSString *)plistname bundleName:(NSString *)name;

@end