//
//  XBDatabase_plist.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 5/4/15.
//
//

#import "XBDatabase_plist.h"
#import "XBCacheRequest.h"
#import "XBDatabase.h"

@implementation XBDatabase_plist

@dynamic id;
@dynamic content;
@dynamic name;

+ (NSDictionary *)plistForKey:(NSString *)name
{
    NSArray *items = [XBDatabase_plist getFormat:@"name=%@" argument:@[name]];
    if ([items count] == 0)
    {
        return nil;
    }
    else
    {
        NSString *plistString = [[items lastObject] content];
        return [NSPropertyListSerialization propertyListFromData:[plistString dataUsingEncoding:NSUTF8StringEncoding]
                                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                          format:nil
                                                errorDescription:nil];
    }
}

+ (void)updatePlist
{
    XBCacheRequest *request = XBCacheRequest(@"servicemanagement/get_all_plist");
    [request startAsynchronousWithCallback:^(XBCacheRequest *request, NSString *result, BOOL fromCache, NSError *error, id object) {
        for (NSDictionary *item in object)
        {
            [XBDatabase_plist addPlist:item];
        }
    }];
}

+ (void)addPlist:(NSDictionary *)item
{
    NSArray * matched = [XBDatabase_plist getFormat:@"name=%@ or id=%@" argument:@[item[@"name"], item[@"id"]]];
    
    XBDatabase_plist *plist = nil;
    if ([matched count] > 0)
    {
        plist = [matched lastObject];
    }
    else
    {
        plist  = [NSEntityDescription insertNewObjectForEntityForName:@"XBDatabase_plist" inManagedObjectContext:[[XBDatabase sharedInstance] managedObjectContext]];
    }
    plist.id = @([item[@"id"] intValue]);
    plist.name = item[@"name"];
    plist.content = item[@"content"];
    
    [[XBDatabase sharedInstance] saveContext];
}

+ (NSArray *)getFormat:(NSString *)format argument:(NSArray *)argument
{
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"XBDatabase_plist" inManagedObjectContext:[[XBDatabase sharedInstance] managedObjectContext]];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    [fr setEntity:ed];
    
    NSPredicate *p1 = [NSPredicate predicateWithFormat:format argumentArray:argument];
    [fr setPredicate:p1];
    
    NSArray *result = [[[XBDatabase sharedInstance] managedObjectContext] executeFetchRequest:fr error:nil];
    return result;
}

+ (NSArray *)getAll
{
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"XBDatabase_plist" inManagedObjectContext:[[XBDatabase sharedInstance] managedObjectContext]];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    [fr setEntity:ed];
    
    NSArray *result = [[[XBDatabase sharedInstance] managedObjectContext] executeFetchRequest:fr error:nil];
    return result;
}

@end
