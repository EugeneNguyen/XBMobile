//
//  XBCacheRequest.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 12/19/14.
//
//

#import "ASIFormDataRequest.h"

@protocol XBCacheRequestDelegate <ASIHTTPRequestDelegate>

- (void)requestFinishedWithString:(NSString *)result;

@end

@interface XBCacheRequest : ASIFormDataRequest <ASIHTTPRequestDelegate>
{
    
}

@property (nonatomic, retain) NSMutableDictionary *dataPost;
@property (nonatomic, assign) id <XBCacheRequestDelegate> cacheDelegate;

@end
