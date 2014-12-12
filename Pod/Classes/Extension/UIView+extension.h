//
//  UIView+extension.h
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/10/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (extension)

@property (nonatomic, assign) float bottomMargin;
@property (nonatomic, assign) float originalHeight;

- (void)applyTemplate:(NSArray *)temp andInformation:(NSDictionary *)info;
- (void)applyTemplate:(NSArray *)temp andInformation:(NSDictionary *)info withTarget:(id)target;

+ (id)viewWithXib:(NSString *)xibName templatePlist:(NSString *)tempString information:(NSDictionary *)information;
+ (id)viewWithXib:(NSString *)xibName templatePlist:(NSString *)tempString information:(NSDictionary *)information withTarget:(id)target;

+ (id)viewWithXib:(NSString *)xibName template:(NSArray *)temp information:(NSDictionary *)information;
+ (id)viewWithXib:(NSString *)xibName template:(NSArray *)temp information:(NSDictionary *)information withTarget:(id)target;

- (void)dim;
- (void)undim;

- (UIViewController *) firstAvailableUIViewController;
- (id) traverseResponderChainForUIViewController;

@end
