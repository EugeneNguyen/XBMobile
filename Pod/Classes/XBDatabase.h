//
//  XBPlistManager.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 5/4/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface XBDatabase : NSObject
{
    
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, assign) BOOL isDebug;

- (void)saveContext;

+ (instancetype)sharedInstance;

@end
