//
//  NSObject+XBDataList.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/11/14.
//
//

#import <Foundation/Foundation.h>
#import "XBDataFetching.h"

@protocol XBDataList

@property (nonatomic, retain) NSDictionary *informations;

@property (nonatomic, retain) NSDictionary *postParams;

@property (nonatomic, retain) NSMutableArray *datalist;

@property (nonatomic, assign) BOOL isMultipleSection;

@property (nonatomic, retain) XBDataFetching *dataFetching;

@property (nonatomic, retain) UIRefreshControl *refreshControl;

- (void)loadInformationFromPlist:(NSString *)plist;

- (void)loadData:(NSArray *)data;

- (void)loadInformations:(NSDictionary *)info;

- (void)requestData;

- (NSDictionary *)cellInfoForPath:(NSIndexPath *)indexPath;

- (void)applySearch:(NSString *)searchKey;

@optional

@property (nonatomic, retain) NSMutableArray *backupWhenSearch;

- (void)setupWaterFall;

- (void)reloadData;

- (void)configHeightAfterFillData;

- (void)initRefreshControl;

- (void)setupDelegate;

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;

@end

@interface NSObject (XBDataList) <XBDataList, XBDataFetchingDelegate>

@end
