//
//  XBStaticDataViewController.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 11/10/14.
//  Copyright (c) 2014 Eugene Nguyen. All rights reserved.
//

#import "XBStaticDataViewController.h"
#import "XBRSSViewController.h"

@implementation XBStaticDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [tableView loadInformationFromPlist:@"XBStaticDataInformation"];
    [tableView loadData:[NSArray arrayWithContentsOfPlist:@"XBStaticData"]];
}

- (void)xbTableView:(XBTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath forItem:(id)item
{
    switch (indexPath.row) {
        case 0:
        {
            XBRSSViewController *rss = [[XBRSSViewController alloc] init];
            [self.navigationController pushViewController:rss animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
