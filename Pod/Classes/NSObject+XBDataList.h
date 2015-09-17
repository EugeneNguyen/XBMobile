//
//  NSObject+XBDataList.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/11/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XBDataFetching.h"

@protocol XBDataList;

@protocol XBDataListSource <NSObject>

@optional
- (id)modifiedDataFor:(id <XBDataList>)view andSource:(id)data;
- (void)xbDataListRequestData;

@end

@protocol XBDataList

@property (nonatomic, retain) NSDictionary *informations;

@property (nonatomic, retain) NSDictionary *postParams;

@property (nonatomic, retain) NSMutableArray *datalist;

@property (nonatomic, assign) BOOL isMultipleSection;

@property (nonatomic, retain) XBDataFetching *dataFetching;

@property (nonatomic, retain) UIRefreshControl *refreshControl;

@property (nonatomic, assign) IBOutlet id <XBDataListSource> dataListSource;

@property (nonatomic, retain) IBOutlet UITextField *searchField;

@property (nonatomic, retain) NSString * XBID;

@property (nonatomic, retain) NSString *plist;
@property (nonatomic, retain) NSString *plistData;

- (void)loadFromXBID;

- (void)cleanup;

- (void)loadInformationFromPlist:(NSString *)plist;

- (void)loadData:(NSArray *)data;

- (void)loadInformations:(NSDictionary *)info;

- (void)loadInformations:(NSDictionary *)info withReload:(BOOL)withReload;

- (void)requestData;

- (NSDictionary *)cellInfoForPath:(NSIndexPath *)indexPath;

- (void)applySearch:(NSString *)searchKey;

- (int)totalRows;

- (BOOL)ableToShowNoData;
- (BOOL)ableToShowNoData:(int)section;

- (void)scrolledToBottom;

- (void)setScrollEnabled:(BOOL)scrollable;

// no data cell

- (void)setEnableNoDataCell:(BOOL)isNoData;

@optional

- (IBAction)searchFieldDidChange:(UITextField *)_searchField;

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
