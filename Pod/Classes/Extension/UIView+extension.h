//
//  UIView+extension.h
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/10/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (extension)

- (void)applyTemplate:(NSArray *)temp andInformation:(NSDictionary *)info;
- (void)loadInformation:(NSDictionary *)information;
- (void)loadInformationFromPlist:(NSString *)plist;

@end
