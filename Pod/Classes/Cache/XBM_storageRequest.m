//
//  XBM_storageRequest.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 12/14/14.
//
//

#import "XBM_storageRequest.h"
#import "XBPostRequestCacheManager.h"
#import "JSONKit.h"

@implementation XBM_storageRequest

@dynamic url;
@dynamic postData;
@dynamic response;

+ (void)addCache:(NSURL *)url postData:(NSDictionary *)postData response:(NSString *)response
{
    XBM_storageRequest *cache = [XBM_storageRequest getCache:url postData:postData];
    
    if (!cache)
    {
        cache  = [NSEntityDescription insertNewObjectForEntityForName:@"XBM_storageRequest" inManagedObjectContext:[[XBPostRequestCacheManager sharedInstance] managedObjectContext]];
    }
    
    cache.url = [url absoluteString];
    cache.postData = [postData JSONString];
    cache.response = response;
    
    [[XBPostRequestCacheManager sharedInstance] saveContext];
}

+ (XBM_storageRequest *)getCache:(NSURL *)url postData:(NSDictionary *)postData
{
    NSString *urlString = [url absoluteString];
    NSString *postString = [postData JSONString];
    NSArray *result = [XBM_storageRequest getFormat:@"url=%@ and postData=%@" argument:@[urlString, postString]];
    if ([result count] == 0)
    {
        return nil;
    }
    return [result lastObject];
}

+ (NSArray *)getFormat:(NSString *)format argument:(NSArray *)argument
{
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"XBM_storageRequest" inManagedObjectContext:[[XBPostRequestCacheManager sharedInstance] managedObjectContext]];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    [fr setEntity:ed];
    
    NSPredicate *p1 = [NSPredicate predicateWithFormat:format argumentArray:argument];
    [fr setPredicate:p1];
    
    NSArray *result = [[[XBPostRequestCacheManager sharedInstance] managedObjectContext] executeFetchRequest:fr error:nil];
    return result;
}

@end
