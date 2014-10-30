//
//  XBTestTableViewController.m
//  XBMobileTest
//
//  Created by Binh Nguyen Xuan on 10/2/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import "XBTestTableViewController.h"
#import "XBChatViewController.h"

@interface XBTestTableViewController () <XBTableViewDelegate>

@end

@implementation XBTestTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [tableView loadInformationFromPlist:@"XBChatViewDemo"];
}

- (void)xbTableView:(XBTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath forItem:(id)item
{
    XMPPUserCoreDataStorageObject *user = item;
    XBChatViewController *vc = [[XBChatViewController alloc] init];
    vc.jidStr = user.jidStr;
    [self presentViewController:vc animated:YES completion:^{

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
