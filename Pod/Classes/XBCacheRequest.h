//
//  XBCacheRequest.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 12/19/14.
//
//

#import "ASIFormDataRequest.h"

@class XBCacheRequest;

typedef void (^XBPostRequestCallback)(XBCacheRequest * request, NSString * result, BOOL fromCache, NSError * error);

@protocol XBCacheRequestDelegate <ASIHTTPRequestDelegate>

@optional

- (void)requestFinishedWithString:(NSString *)result;
- (void)request:(XBCacheRequest *)request finishedWithString:(NSString *)result;

@end

@interface XBCacheRequest : ASIFormDataRequest <ASIHTTPRequestDelegate>
{
    XBPostRequestCallback callback;
}

@property (nonatomic, retain) NSMutableDictionary *dataPost;
@property (nonatomic, assign) id <XBCacheRequestDelegate> cacheDelegate;
@property (nonatomic, assign) BOOL disableCache;

- (void)setCallback:(XBPostRequestCallback)_callback;
- (void)startAsynchronousWithCallback:(XBPostRequestCallback)_callback;

+ (void)clearCache;

@end
