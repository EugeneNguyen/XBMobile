//
//  UIViewController+support.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 1/22/15.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (support)

+ (UIViewController*)topViewController;
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;

@end
