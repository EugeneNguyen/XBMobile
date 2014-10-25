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
    [tableView loadInformationFromPlist:@"XBChatViewDemo"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
