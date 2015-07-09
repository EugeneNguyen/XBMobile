//
//  UIView+XBMobile.h
//  
//
//  Created by Binh Nguyen Xuan on 6/30/15.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "XBDataController.h"

typedef void (^XBMobileDidLoadRemoteInformation)();

@interface UIView (XBMobile)
@property (nonatomic, retain) NSMutableDictionary *viewInformation;
@property (nonatomic, retain) XBDataController *dataController;
@property (nonatomic, retain) NSMutableDictionary *postParams;
@property (nonatomic, copy) id data;
@property (nonatomic, copy) XBMobileDidLoadRemoteInformation callback;

@property (nonatomic, assign) id owner;

- (void)load:(NSDictionary *)viewInformation;
- (void)loadPlist:(NSString *)plist;

- (void)process;
- (void)reloadFromRemoteData;

- (id)dataForKey:(NSString *)key;

@end
