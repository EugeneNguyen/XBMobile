//
//  XBChatViewController.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/29/14.
//  Copyright (c) 2014 Eugene Nguyen. All rights reserved.
//

#import "XBChatViewController.h"
#import <XBMobile.h>

@interface XBChatViewController ()
{
    IBOutlet XBChatSendView * sendView;
    IBOutlet XBChatView *chatView;
}

@end

@implementation XBChatViewController
@synthesize jidStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    sendView.jidStr = self.jidStr;
    [chatView loadInformationFromPlist:@"XBChatTimeLine"];
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
