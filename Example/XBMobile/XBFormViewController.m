//
//  XBFormViewController.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 11/15/14.
//  Copyright (c) 2014 Eugene Nguyen. All rights reserved.
//

#import "XBFormViewController.h"
#import <XBMobile.h>

@interface XBFormViewController ()
{
    XBForm *formControl;
}

@end

@implementation XBFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    formControl = [[XBForm alloc] init];
    [formControl loadForm:self.view informationPlist:@"XBFormViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
