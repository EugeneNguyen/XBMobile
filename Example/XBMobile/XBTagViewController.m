//
//  XBTagViewController.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 11/28/14.
//  Copyright (c) 2014 Eugene Nguyen. All rights reserved.
//

#import "XBTagViewController.h"
#import <XBMobile.h>

@interface XBTagViewController ()
{
    IBOutlet XBTagView *tagView;
    IBOutlet UITextField *tfTag;
}

@end

@implementation XBTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [tagView loadInformations:@{}];
    tagView.tagList = [[NSArray arrayWithContentsOfPlist:@"XBTagViewControllerData"] mutableCopy];
}

- (IBAction)didPressAddTag:(id)sender
{
    [tagView addTag:tfTag.text];
    tfTag.text = @"";
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
