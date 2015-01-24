//
//  NSObject+XBDataList.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/11/14.
//
//

#import <Foundation/Foundation.h>
#import "XBDataFetching.h"
#import "ASIHTTPRequest.h"

@protocol XBDataList;

@protocol XBDataListSource <NSObject>

- (id)modifiedDataFor:(id <XBDataList>)view andSource:(id)data;

@end

@protocol XBDataList

@property (nonatomic, retain) NSDictionary *informations;

@property (nonatomic, retain) NSDictionary *postParams;

@property (nonatomic, retain) NSMutableArray *datalist;

@property (nonatomic, assign) BOOL isMultipleSection;

@property (nonatomic, retain) IBOutlet XBDataFetching *dataFetching;

@property (nonatomic, retain) UIRefreshControl *refreshControl;

@property (nonatomic, assign) IBOutlet id <ASIHTTPRequestDelegate> requestDelegate;

@property (nonatomic, assign) IBOutlet id <XBDataListSource> dataListSource;

- (void)cleanup;

- (void)setPlist:(NSString *)plist;

- (void)setPlistData:(NSString *)plistdata;

- (void)loadInformationFromPlist:(NSString *)plist;

- (void)loadData:(NSArray *)data;

- (void)loadInformations:(NSDictionary *)info;

- (void)loadInformations:(NSDictionary *)info withReload:(BOOL)withReload;

- (void)requestData;

- (NSDictionary *)cellInfoForPath:(NSIndexPath *)indexPath;

- (void)applySearch:(NSString *)searchKey;

- (int)totalRows;

- (BOOL)ableToShowNoData;

- (void)scrolledToBottom;

// no data cell

- (void)setEnableNoDataCell:(BOOL)isNoData;

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
