//
//  NSObject+XBDataList.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/11/14.
//
//

#import "NSObject+XBDataList.h"
#import "ASIFormDataRequest.h"
#import "XBExtension.h"
#import "XBMobile.h"
#import "XBDatabase_plist.h"

@implementation NSObject (XBDataList)
@dynamic informations;
@dynamic postParams;
@dynamic datalist;
@dynamic isMultipleSection;
@dynamic dataFetching;
@dynamic refreshControl;
@dynamic requestDelegate;
@dynamic dataListSource;
@dynamic XBID;

#pragma mark - Loading Information

- (void)cleanup
{
    [self loadData:@[]];
    [self loadInformations:@{}];
    [self reloadData];
}

- (void)setPlist:(NSString *)plist
{
    [self loadInformationFromPlist:plist];
}

- (void)loadFromXBID
{
    if (!self.XBID || self.informations)
    {
        return;
    }
    NSDictionary *item = [XBDatabase_plist plistForKey:self.XBID];
    if (item)
    {
        [self loadInformations:item];
    }
    else
    {
        NSString *path = [NSString stringWithFormat:@"servicemanagement/download_service_xml?table=%@", self.XBID];
        XBCacheRequest *request = XBCacheRequest(path);
        request.responseType = XBCacheRequestTypePlain;
        [request startAsynchronousWithCallback:^(XBCacheRequest *request, NSString *result, BOOL fromCache, NSError *error, id object) {
            NSMutableDictionary *item =[NSPropertyListSerialization propertyListFromData:[request.responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                                        mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                                  format:nil
                                                                        errorDescription:nil];
            if (item)
            {
                [self loadInformations:item];
            }
        }];
    }
}

- (void)setPlistData:(NSString *)plistdata
{
    [self loadData:[NSArray arrayWithContentsOfPlist:plistdata]];
}

- (void)loadInformationFromPlist:(NSString *)plist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    [self loadInformations:info];
}

- (void)loadData:(NSArray *)data
{
    if (self.isMultipleSection)
    {
        self.datalist = [data mutableCopy];
    }
    else
    {
        self.datalist = [@[@{@"title": @"root", @"items": data}] mutableCopy];
    }
    [self reloadData];
}

- (void)loadInformations:(NSDictionary *)info
{
    [self loadInformations:info withReload:NO];
}

- (void)loadInformations:(NSDictionary *)info withReload:(BOOL)withReload
{
    [self setupDelegate];
    
    self.informations = info;
    
    self.isMultipleSection = [info[@"section"] boolValue];
    
    if ([self respondsToSelector:@selector(setupWaterFall)] && [self.informations[@"waterfall"][@"enable"] boolValue])
    {
        [self setupWaterFall];
    }
    [self requestDataWithReload:withReload];
    for (NSDictionary *item in self.informations[@"cells"])
    {
        UINib *nib = [UINib loadResourceWithInformation:item];
        [self registerNib:nib forCellReuseIdentifier:item[@"cellIdentify"]];
    }
    
    if ([self.informations[@"isUsingRefreshControl"] boolValue])
    {
        [self initRefreshControl];
    }
    
    if (self.informations[@"loadMore"][@"cellIdentify"] && self.informations[@"loadMore"][@"xibname"])
    {
        [self registerNib:[UINib nibWithNibName:self.informations[@"loadMore"][@"xibname"] bundle:nil] forCellReuseIdentifier:self.informations[@"loadMore"][@"cellIdentify"]];
    }
    
    if (self.informations[@"NoDataCell"][@"cellIdentify"] && self.informations[@"NoDataCell"][@"xibname"])
    {
        [self registerNib:[UINib nibWithNibName:self.informations[@"NoDataCell"][@"xibname"] bundle:nil] forCellReuseIdentifier:self.informations[@"NoDataCell"][@"cellIdentify"]];
    }
    [self reloadData];
}

- (void)initRefreshControl
{
    if (!self.refreshControl)
    {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(requestData) forControlEvents:UIControlEventValueChanged];
        [(UIView *)self addSubview:self.refreshControl];
    }
}

- (int)totalRows
{
    int count = 0;
    for (NSDictionary *item in self.datalist)
    {
        count += [item[@"items"] count];
    }
    return count;
}

- (BOOL)ableToShowNoData
{
    if (self.informations[@"NoDataCell"] && [self.informations[@"NoDataCell"][@"enable"] boolValue])
    {
        if (self.totalRows == 0)
        {
            [self setScrollEnabled:![self.informations[@"NoDataCell"][@"disableScrolling"] boolValue]];
        }
        else
        {
            [self setScrollEnabled:YES];
        }
    }
    return self.informations[@"NoDataCell"] && [self.informations[@"NoDataCell"][@"enable"] boolValue] && ([self totalRows] == 0);
}

- (void)scrolledToBottom
{
    if ([self.informations[@"loadMore"][@"enable"] boolValue])
    {
        [self.dataFetching fetchMore];
    }
}

#pragma mark - Personal Modification

- (void)setEnableNoDataCell:(BOOL)isNoData
{
    if (self.informations[@"NoDataCell"])
    {
        self.informations[@"NoDataCell"][@"enable"] = @(isNoData);
    }
    [self reloadData];
}

#pragma mark - Data method & DataFetching Delegate

- (void)requestData
{
    [self requestDataWithReload:NO];
}

- (void)requestDataWithReload:(BOOL)withReload
{
    if ([self.informations[@"isRemoteData"] boolValue])
    {
        [self setEnableNoDataCell:NO];
        if (!self.datalist)
        {
            self.datalist = [NSMutableArray new];
        }
        
        self.dataFetching = [[XBDataFetching alloc] init];
        self.dataFetching.datalist = self.datalist;
        self.dataFetching.info = self.informations;
        self.dataFetching.delegate = self;
        self.dataFetching.postParams = self.postParams;
        self.dataFetching.disableCache = [self.informations[@"disableCache"] boolValue];
        if ([self.informations[@"loadMore"][@"enable"] boolValue])
        {
            [self.dataFetching fetchMore];
        }
        else
        {
            [self.dataFetching startFetchingData];
        }
    }
    else
    {
        [self reloadData];
        [self configHeightAfterFillData];
    }
}

- (void)requestDidFinish:(XBDataFetching *)_dataFetching
{
    [self setEnableNoDataCell:YES];
    if (self.dataListSource && [self.dataListSource respondsToSelector:@selector(modifiedDataFor:andSource:)])
    {
        self.datalist = [self.dataListSource modifiedDataFor:self andSource:self.datalist];
    }
    [self reloadData];
    [self configHeightAfterFillData];
    if ([self.informations[@"isUsingRefreshControl"] boolValue])
    {
        [self.refreshControl endRefreshing];
    }
    if ([self.requestDelegate respondsToSelector:@selector(requestFinished:)])
    {
        [self.requestDelegate requestFinished:_dataFetching.cacheRequest];
    }
}

- (void)requestDidFailed:(XBDataFetching *)_dataFetching
{
    [self setEnableNoDataCell:YES];
    if ([self.informations[@"isUsingAlert"] boolValue])
    {
        [self alert:@"Error" message:[self.dataFetching.cacheRequest.error description]];
    }
    
    if ([self.informations[@"isUsingRefreshControl"] boolValue])
    {
        [self.refreshControl endRefreshing];
    }
    if ([self.requestDelegate respondsToSelector:@selector(requestFailed:)])
    {
        [self.requestDelegate requestFailed:_dataFetching.cacheRequest];
    }
}

#pragma mark - Search

- (void)applySearch:(NSString *)searchKey
{
    if (self.informations[@"searchOptions"])
    {
        if ([self.informations[@"searchOptions"][@"online"] boolValue])
        {
            NSString *searchParams = self.informations[@"searchOptions"][@"searchParam"];
            
            NSMutableDictionary *post = [self.postParams copy];
            post[searchParams] = searchKey;
            
            self.dataFetching = [[XBDataFetching alloc] init];
            self.dataFetching.datalist = self.datalist;
            self.dataFetching.info = self.informations;
            self.dataFetching.delegate = self;
            self.dataFetching.postParams = post;
            [self.dataFetching startFetchingData];
        }
        else
        {
            if (!self.backupWhenSearch)
            {
                self.backupWhenSearch = [self.datalist mutableCopy];
            }
            self.datalist = [self.backupWhenSearch mutableCopy];
            if ([searchKey length] != 0)
            {
                NSMutableString *predicateFormat = [@"" mutableCopy];
                NSMutableArray *args = [@[] mutableCopy];
                for (NSString *field in self.informations[@"searchOptions"][@"fields"])
                {
                    [predicateFormat appendFormat:@"%@ ", field];
                    [predicateFormat appendString:@"CONTAINS[cd] %@"];
                    if ([self.informations[@"searchOptions"][@"fields"] indexOfObject:field] != [self.informations[@"searchOptions"][@"fields"] count] - 1)
                    {
                        [predicateFormat appendString:@" OR "];
                    }
                    [args addObject:searchKey];
                }
                
                NSPredicate *pred = [NSPredicate predicateWithFormat:predicateFormat argumentArray:args];
                
                NSMutableArray *result = [@[] mutableCopy];
                for (int i = 0; i < [self.datalist count]; i ++)
                {
                    NSMutableDictionary *item = [self.datalist[i] mutableCopy];
                    NSArray *array = item[@"items"];
                    item[@"items"] = [array filteredArrayUsingPredicate:pred];
                    [result addObject:item];
                }
                self.datalist = [result mutableCopy];
            }
            [self reloadData];
        }
    }
}

- (void)cancelSearch
{
    self.datalist = [self.backupWhenSearch mutableCopy];
}

#pragma mark - Cell generation

- (NSDictionary *)cellInfoForPath:(NSIndexPath *)indexPath
{
    if ([self.informations[@"isMutipleType"] boolValue])
    {
        NSString *path = self.informations[@"cellTypePath"];
        if (!path)
        {
            path = @"cell_type";
        }
        return self.informations[@"cells"][[[self.datalist[indexPath.section][@"items"][indexPath.row] objectForPath:path] intValue]];
    }
    if ([self.informations[@"cells"] count] > 0)
    {
        return self.informations[@"cells"][0];
    }
    return nil;
}

#pragma mark - SearchField

- (IBAction)searchFieldDidChange:(UITextField *)_searchField
{
    [self applySearch:_searchField.text];
}

@end
