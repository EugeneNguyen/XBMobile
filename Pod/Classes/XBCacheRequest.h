//
//  XBCacheRequest.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 12/19/14.
//
//

#import "ASIFormDataRequest.h"

@class XBCacheRequest;

@protocol XBCacheRequestDelegate <ASIHTTPRequestDelegate>

- (void)requestFinishedWithString:(NSString *)result;
- (void)request:(XBCacheRequest *)request finishedWithString:(NSString *)result;

@end

@interface XBCacheRequest : ASIFormDataRequest <ASIHTTPRequestDelegate>
{
    
}

@property (nonatomic, retain) NSMutableDictionary *dataPost;
@property (nonatomic, assign) id <XBCacheRequestDelegate> cacheDelegate;
@property (nonatomic, assign) BOOL disableCache;

+ (void)clearCache;

@end
