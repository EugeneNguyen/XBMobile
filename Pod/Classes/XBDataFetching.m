//
//  XBDataFetching.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/10/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import "XBDataFetching.h"
#import "XBMobile.h"
#import "ASIFormDataRequest.h"
#import "XBExtension.h"
#import "JSONKit.h"
#import "XMLDictionary.h"

@interface XBDataFetching () <XBCacheRequestDelegate>
{
    
}

@end

@implementation XBDataFetching
@synthesize datalist = _datalist;
@synthesize info;
@synthesize postParams = _postParams;
@synthesize isMultipleSection;
@synthesize cacheRequest;
@synthesize disableCache;
@synthesize resultCount;
@synthesize startDate;

- (id)init
{
    self = [super init];
    if (self)
    {
        disableCache = NO;
        resultCount = 20;
        self.isEndOfData = YES;
    }
    return self;
}

- (void)setDatalist:(id)datalist
{
    _datalist = datalist;
    [self finishRequest];
}

- (void)startFetchingData
{
    [self requestData];
}

- (void)fetchMore
{
    [self requestDataWithMore:YES];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestData
{
    [self requestDataWithMore:NO];
}

- (void)requestDataWithMore:(BOOL)isMore
{
    if (isMore && self.isEndOfData && [cacheRequest isRunning])
    {
        return;
    }
    NSString *url = info[@"remoteLink"];
    NSString *predefaultHost = info[@"predefinedHostInUserdefault"];
    if (predefaultHost && [predefaultHost length] > 0 && [[NSUserDefaults standardUserDefaults] stringForKey:predefaultHost])
    {
        url = [NSString stringWithFormat:@"%@/%@", [[NSUserDefaults standardUserDefaults] stringForKey:predefaultHost], url];
    }
    if (!_postParams)
    {
        _postParams = @{};
    }
    [cacheRequest cancel];
    cacheRequest = XBCacheRequest(url);
    cacheRequest.disableCache = self.disableCache;
    
    NSMutableDictionary * mutablePostParams = [_postParams mutableCopy];
    if (isMore)
    {
        if (startDate)
        {
            mutablePostParams[@"time"] = [@([[NSDate date] timeIntervalSinceDate:startDate]) stringValue];
        }
        else
        {
            startDate = [NSDate date];
        }
        mutablePostParams[@"offset"] = @([[self.datalist firstObject][@"items"] count]);
        mutablePostParams[@"count"] = @(self.resultCount);
    }
    else
    {
        self.isEndOfData = NO;
    }
    cacheRequest.dataPost = [mutablePostParams mutableCopy];
    
    if ([info[@"isXML"] boolValue])
    {
        cacheRequest.responseType = XBCacheRequestTypeXML;
    }
    else
    {
        cacheRequest.responseType = XBCacheRequestTypeJSON;
    }
    
    [cacheRequest startAsynchronousWithCallback:^(XBCacheRequest *request, NSString *result, BOOL fromCache, NSError *error, id object) {
        
        [self hideHUD];
        if (!isMore)
        {
            [_datalist removeAllObjects];
        }
        if (error)
        {
            DDLogVerbose(@"%@", error);
            [self.delegate requestDidFailed:self];
        }
        else
        {
            if (object)
            {
                if ([object[@"code"] intValue] != 200)
                {
                    if ([info[@"isUsingAlert"] boolValue]) [self alert:@"Error" message:object[@"description"]];
                }
                else
                {
                    if ([_datalist isKindOfClass:[NSMutableArray class]])
                    {
                        if (!request.dataPost[@"count"] || (request.dataPost[@"offset"] && ([request.dataPost[@"offset"] intValue] == 0)))
                        {
                            [(NSMutableArray *)_datalist removeAllObjects];
                        }
                        if (isMultipleSection)
                        {
                            [(NSMutableArray *)_datalist addObjectsFromArray:[object objectForPath:info[@"pathToContent"]]];
                        }
                        else
                        {
                            NSMutableArray *sections = (NSMutableArray *)_datalist;
                            if ([sections count] == 0)
                            {
                                NSDictionary *section = @{@"title": @"root", @"items": [[object objectForPath:info[@"pathToContent"]] mutableCopy]};
                                [(NSMutableArray *)_datalist addObject:section];
                            }
                            else
                            {
                                [[sections lastObject][@"items"] addObjectsFromArray:[object objectForPath:info[@"pathToContent"]]];
                                if ([[object objectForPath:info[@"pathToContent"]] count] == 0)
                                {
                                    self.isEndOfData = YES;
                                }
                            }
                        }
                    }
                    else if ([_datalist isKindOfClass:[NSMutableDictionary class]])
                    {
                        [(NSMutableDictionary *)_datalist removeAllObjects];
                        [(NSMutableDictionary *)_datalist addEntriesFromDictionary:[object objectForPath:info[@"pathToContent"]]];
                    }
                }
            }
            else
            {
                if ([info[@"isUsingAlert"] boolValue]) [self alert:@"Error" message:@"Error when pasing result"];
            }
            [self finishRequest];
        }
    }];

    if ([info[@"usingHUD"] boolValue])
    {
        [self showHUD:@"Loading"];
    }
}

- (void)finishRequest
{
    [self.delegate requestDidFinish:self];
    if ([self.delegate respondsToSelector:@selector(reloadData)])
    {
        [self.delegate performSelector:@selector(reloadData)];
    }
}

@end
