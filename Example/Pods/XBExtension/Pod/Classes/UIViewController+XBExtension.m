//
//  UIViewController+XBExtension.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 8/17/15.
//
//

#import "UIViewController+XBExtension.h"

@implementation UIViewController (XBExtension)

- (IBAction)didPressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressHideKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

@end
