//
//  UIViewController+support.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 1/22/15.
//
//

#import "UIViewController+support.h"

@implementation UIViewController (support)

+ (UIViewController*)topViewController {
    return [UIViewController topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [UIViewController topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [UIViewController topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [UIViewController topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
