//
//  XBRSSViewController.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 11/10/14.
//  Copyright (c) 2014 Eugene Nguyen. All rights reserved.
//

#import "XBRSSViewController.h"

@interface XBRSSViewController () <XBDataListSource>
{
    IBOutlet UITextField *tfSearch;
}

@end

@implementation XBRSSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.dataListSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didPressSearch:(id)sender
{
    [tableView applySearch:tfSearch.text];
}

- (id)modifiedDataFor:(id<XBDataList>)view andSource:(id)data
{
    NSArray *array = data;
    NSLog(@"%@", array);
    if ([array count] == 0)
    {
        
    }
    else
    {
        
    }
    return array;
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
