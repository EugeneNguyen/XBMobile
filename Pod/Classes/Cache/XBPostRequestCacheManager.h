//
//  XBPostRequestCacheManager.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 12/14/14.
//
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import <CoreData/CoreData.h>
#import "XBM_storageRequest.h"

@protocol XBPostRequestCacheManager <ASIHTTPRequestDelegate>

- (void)requestFinishedWithString:(NSString *)resultFromRequest;

@end

@interface XBPostRequestCacheManager : NSObject <ASIHTTPRequestDelegate>
{
    
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSDictionary *dataPost;
@property (nonatomic, assign) id <XBPostRequestCacheManager> delegate;
@property (nonatomic, retain) ASIFormDataRequest *request;

- (void)start;
+ (XBPostRequestCacheManager *)startRequest:(NSURL *)_url postData:(NSDictionary *)_dataPost delegate:(id<XBPostRequestCacheManager>)_delegate;
+ (XBPostRequestCacheManager *)sharedInstance;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
