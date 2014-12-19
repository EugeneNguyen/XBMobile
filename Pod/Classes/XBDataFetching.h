//
//  XBDataFetching.h
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/10/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBExtension.h"

@class XBDataFetching;
@class ASIFormDataRequest;

@protocol  XBDataFetchingDelegate <NSObject>

- (void)requestDidFinish:(XBDataFetching *)dataFetching;
- (void)requestDidFailed:(XBDataFetching *)dataFetching;

@end

@interface XBDataFetching : NSObject
{

}

@property (nonatomic, assign) id datalist;

@property (nonatomic, retain) NSDictionary *info;

@property (nonatomic, retain) NSDictionary *postParams;

@property (nonatomic, retain) id <XBDataFetchingDelegate> delegate;

@property (nonatomic, assign) BOOL isMultipleSection;

@property (nonatomic, retain) XBCacheRequest *cacheRequest;

- (void)startFetchingData;

@end
