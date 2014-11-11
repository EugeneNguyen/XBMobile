//
//  XBRSSCollectionView.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 11/11/14.
//  Copyright (c) 2014 Eugene Nguyen. All rights reserved.
//

#import "XBRSSCollectionView.h"

@implementation XBRSSCollectionView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [collectionView loadInformationFromPlist:@"XBRSSCollectionView"];
}

@end
