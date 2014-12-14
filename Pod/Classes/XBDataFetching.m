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
#import "XBPostRequestCacheManager.h"

@interface XBDataFetching () <XBPostRequestCacheManager>
{
    
}

@property (nonatomic, retain) XBPostRequestCacheManager *cache;
@end

@implementation XBDataFetching
@synthesize datalist = _datalist;
@synthesize info;
@synthesize postParams = _postParams;
@synthesize request;
@synthesize isMultipleSection;
@synthesize cache;

- (void)setDatalist:(id)datalist
{
    _datalist = datalist;
    [self finishRequest];
}

- (void)startFetchingData
{
    [self requestData];
}

- (void)dealloc
{
    self.request.delegate = nil;
    [self.request cancel];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestData
{
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
    cache = [XBPostRequestCacheManager startRequest:[NSURL URLWithString:url] postData:_postParams delegate:self];

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

- (void)requestFinishedWithString:(NSString *)resultFromRequest
{
    DDLogVerbose(@"%@", resultFromRequest);
    [self hideHUD];
    NSDictionary *item;
    if ([info[@"isXML"] boolValue])
    {
        item = [NSDictionary dictionaryWithXMLString:resultFromRequest];
    }
    else
    {
        item = [resultFromRequest objectFromJSONString];
    }
    DDLogVerbose(@"%@", item);
    if (item)
    {
        if ([item[@"code"] intValue] != 200)
        {
            [self alert:@"Error" message:item[@"description"]];
        }
        else
        {
            if ([_datalist isKindOfClass:[NSMutableArray class]])
            {
                [(NSMutableArray *)_datalist removeAllObjects];
                if (isMultipleSection)
                {
                    [(NSMutableArray *)_datalist addObjectsFromArray:[item objectForPath:info[@"pathToContent"]]];
                }
                else
                {
                    NSDictionary *section = @{@"title": @"root", @"items": [item objectForPath:info[@"pathToContent"]]};
                    [(NSMutableArray *)_datalist addObject:section];
                }
            }
            else if ([_datalist isKindOfClass:[NSMutableDictionary class]])
            {
                [(NSMutableDictionary *)_datalist removeAllObjects];
                [(NSMutableDictionary *)_datalist addEntriesFromDictionary:[item objectForPath:info[@"pathToContent"]]];
            }
        }
    }
    else
    {
        [self alert:@"Error" message:@"Error when pasing result"];
    }
    [self finishRequest];
}

- (void)requestFailed:(ASIHTTPRequest *)_request
{
    DDLogVerbose(@"%@", _request.error);
    [self.delegate requestDidFailed:self];
    [self hideHUD];
}

@end
