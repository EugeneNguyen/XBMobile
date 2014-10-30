//
//  XBView.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/17/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import "XBView.h"
#import "XBDataFetching.h"
#import "UIView+extension.h"

@interface XBView ()
{
    NSMutableArray *datalist;
    UITableViewController *tableViewController;
    XBDataFetching *dataFetching;

    UICollectionViewLayout *viewlayout;
}

@end

@implementation XBView

- (void)loadInformationFromPlist:(NSString *)plist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:path];
    [self setInformations:info];
}

- (void)loadData:(NSArray *)data
{
    datalist = [data mutableCopy];
}

- (void)setInformations:(NSDictionary *)info
{
    _informations = info;
    if (datalist)
    {
        [self applyTemplate:info andInformation:datalist];
    }
}

@end
