//
//  XBMobile.h
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/2/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XBTableView.h"
#import "XBCollectionView.h"

@interface XBMobile : UIWindow
{

}

- (void)settingWithInformation:(NSDictionary *)info;

+ (id)sharedInstance;

@end
