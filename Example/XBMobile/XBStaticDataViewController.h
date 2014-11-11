//
//  XBStaticDataViewController.h
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 11/10/14.
//  Copyright (c) 2014 Eugene Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XBMobile.h>

@interface XBStaticDataViewController : UIViewController <XBTableViewDelegate>
{
    IBOutlet XBTableView *tableView;
}

@end
