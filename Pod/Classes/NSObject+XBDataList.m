//
//  NSObject+XBDataList.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/11/14.
//
//

#import "NSObject+XBDataList.h"
#import "ASIFormDataRequest.h"
#import "NSObject+extension.h"

@implementation NSObject (XBDataList)
@dynamic informations;
@dynamic postParams;
@dynamic datalist;
@dynamic isMultipleSection;
@dynamic dataFetching;
@dynamic refreshControl;

#pragma mark - Loading Information

- (void)loadInformationFromPlist:(NSString *)plist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:path];
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
    [self setupDelegate];
    self.informations = info;
    
    if (info[@"section"])
    {
        self.isMultipleSection = YES;
    }
    
    [self requestData];
    for (NSDictionary *item in self.informations[@"cells"])
    {
        [self registerNib:[UINib nibWithNibName:item[@"xibname"] bundle:nil] forCellReuseIdentifier:item[@"cellIdentify"]];
    }
    
    if ([self.informations[@"isUsingRefreshControl"] boolValue])
    {
        [self initRefreshControl];
    }
    
    if ([self.informations[@"loadMore"][@"enable"] boolValue])
    {
        [self registerNib:[UINib nibWithNibName:self.informations[@"loadMore"][@"xib"] bundle:nil] forCellReuseIdentifier:self.informations[@"loadMore"][@"identify"]];
    }
}

#pragma mark - Data method & DataFetching Delegate

- (void)requestData
{
    if ([self.informations[@"isRemoteData"] boolValue])
    {
        if (!self.datalist)
        {
            self.datalist = [NSMutableArray new];
        }
        
        self.dataFetching = [[XBDataFetching alloc] init];
        self.dataFetching.datalist = self.datalist;
        self.dataFetching.info = self.informations;
        self.dataFetching.delegate = self;
        self.dataFetching.postParams = self.postParams;
        [self.dataFetching startFetchingData];
    }
    else
    {
        [self configHeightAfterFillData];
    }
}

- (void)requestDidFinish:(XBDataFetching *)_dataFetching
{
    [self configHeightAfterFillData];
    if ([self.informations[@"isUsingRefreshControl"] boolValue])
    {
        [self.refreshControl endRefreshing];
    }
}

- (void)requestDidFailed:(XBDataFetching *)_dataFetching
{
    if ([self.informations[@"isUsingAlert"] boolValue])
    {
        [self alert:@"Error" message:[self.dataFetching.request.error description]];
    }
    
    if ([self.informations[@"isUsingRefreshControl"] boolValue])
    {
        [self.refreshControl endRefreshing];
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
            NSMutableString *predicateFormat = [@"ANY " mutableCopy];
            NSMutableArray *args = [@[] mutableCopy];
            for (NSString *field in self.informations[@"searchOptions"][@"fields"])
            {
                [predicateFormat appendFormat:@"%@ ", field];
                [predicateFormat appendString:@"CONTAINS %@"];
                if ([self.informations[@"searchOptions"][@"fields"] indexOfObject:field] != [self.informations[@"searchOptions"][@"fields"] count] - 1)
                {
                    [predicateFormat appendString:@" OR "];
                }
                [args addObject:searchKey];
            }
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:predicateFormat argumentArray:args];
            NSArray *result = [self.datalist filteredArrayUsingPredicate:pred];
            self.backupWhenSearch = [self.datalist mutableCopy];
            [self.datalist removeAllObjects];
            [self.datalist addObjectsFromArray:result];
            [self reloadData];
        }
    }
}

- (void)cancelSearch
{
    
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
        return self.informations[@"cells"][[self.datalist[indexPath.section][@"items"][indexPath.row][path] intValue]];
    }
    return self.informations[@"cells"][0];
}

@end
