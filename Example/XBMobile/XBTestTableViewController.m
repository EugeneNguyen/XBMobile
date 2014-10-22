//
//  XBTestTableViewController.m
//  XBMobileTest
//
//  Created by Binh Nguyen Xuan on 10/2/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import "XBTestTableViewController.h"

@interface XBTestTableViewController ()

@end

@implementation XBTestTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [tableView setPostParams:@{@"store_id": @(28), @"token": @"ea0eea115cccb9c41919f16ee4a92ebb"}];
    [tableView loadInformationFromPlist:@"TestTableViewData"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
