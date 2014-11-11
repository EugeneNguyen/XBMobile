//
//  XBRSSViewController.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 11/10/14.
//  Copyright (c) 2014 Eugene Nguyen. All rights reserved.
//

#import "XBRSSViewController.h"

@interface XBRSSViewController ()
{
    IBOutlet UITextField *tfSearch;
}

@end

@implementation XBRSSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [tableView loadInformationFromPlist:@"XBRSSViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressSearch:(id)sender
{
    [tableView applySearch:tfSearch.text];
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
