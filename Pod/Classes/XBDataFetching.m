//
//  XBDataFetching.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/10/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import "XBDataFetching.h"
#import "ASIFormDataRequest.h"
#import "XBExtension.h"
#import "JSONKit.h"

@interface XBDataFetching () <ASIHTTPRequestDelegate>

@end

@implementation XBDataFetching
@synthesize datalist = _datalist;
@synthesize info;
@synthesize postParams = _postParams;
@synthesize request;

- (void)setDatalist:(id)datalist
{
    _datalist = datalist;
    [self finishRequest];
}

- (void)startFetchingData
{
    [self requestData];
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
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    request.cachePolicy = ASIFallbackToCacheIfLoadFailsCachePolicy;
    request.delegate = self;
    for (NSString *key in [_postParams allKeys])
    {
        [request setPostValue:_postParams[key] forKey:key];
    }
    [request startAsynchronous];

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

- (void)requestFinished:(ASIHTTPRequest *)_request
{
    [self hideHUD];
    NSDictionary *item = [_request.responseString mutableObjectFromJSONString];
    NSLog(@"%@", item);
    if (item)
    {
        if ([_datalist isKindOfClass:[NSMutableArray class]])
        {
            [(NSMutableArray *)_datalist removeAllObjects];
            [(NSMutableArray *)_datalist addObjectsFromArray:[item objectForPath:info[@"pathToContent"]]];
        }
        else if ([_datalist isKindOfClass:[NSMutableDictionary class]])
        {
            [(NSMutableDictionary *)_datalist removeAllObjects];
            [(NSMutableDictionary *)_datalist addEntriesFromDictionary:[item objectForPath:info[@"pathToContent"]]];
        }
    }
    else
    {
        [self alert:@"Error" message:@"Error when pasing result"];
    }
    [self finishRequest];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self.delegate requestDidFailed:self];
    [self hideHUD];
}

@end
