//
//  XBCacheRequest.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 12/19/14.
//
//

#import "XBCacheRequest.h"
#import "XBPostRequestCacheManager.h"

@implementation XBCacheRequest
@synthesize dataPost = _dataPost, cacheDelegate, disableCache;

- (void)setCallback:(XBPostRequestCallback)_callback
{
    callback = _callback;
}

- (void)startAsynchronousWithCallback:(XBPostRequestCallback)_callback
{
    [self setCallback:_callback];
    [self startAsynchronous];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        disableCache = NO;
    }
    return self;
}

- (void)setDataPost:(NSMutableDictionary *)dataPost
{
    _dataPost = dataPost;
    for (NSString *key in [dataPost allKeys])
    {
        [self setPostValue:dataPost[key] forKey:key];
    }
}

- (void)startAsynchronous
{
    [super setDelegate:self];
    [super startAsynchronous];
    if (disableCache)
    {
        return;
    }
    XBM_storageRequest *cache = [XBM_storageRequest getCache:self.url postData:_dataPost];
    if (cache)
    {
        if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(requestFinishedWithString:)])
        {
            [cacheDelegate requestFinishedWithString:cache.response];
        }
        if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(request:finishedWithString:)])
        {
            [cacheDelegate request:self finishedWithString:cache.response];
        }
        if (callback) callback(self, cache.response, YES, nil);
    }
}

- (void)requestFailed:(ASIHTTPRequest *)_request
{
    if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(requestFailed:)])
    {
        [cacheDelegate requestFailed:_request];
    }
    if (callback) callback(self, nil, NO, self.error);
}

- (void)requestFinished:(ASIHTTPRequest *)_request
{
    [XBM_storageRequest addCache:url postData:_dataPost response:_request.responseString];
    if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(requestFinished:)])
    {
        [cacheDelegate requestFinished:_request];
    }
    if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(requestFinishedWithString:)])
    {
        [cacheDelegate requestFinishedWithString:_request.responseString];
    }
    if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(request:finishedWithString:)])
    {
        [cacheDelegate request:self finishedWithString:_request.responseString];
    }
    if (callback) callback(self, _request.responseString, NO, nil);
}

+ (void)clearCache
{
    [XBM_storageRequest clear];
}

@end
