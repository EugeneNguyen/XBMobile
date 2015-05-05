//
//  XBDatabase_plist.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 5/4/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface XBDatabase_plist : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * name;

+ (void)updatePlist;

+ (void)addPlist:(NSDictionary *)item;
+ (NSArray *)getFormat:(NSString *)format argument:(NSArray *)argument;
+ (NSArray *)getAll;

+ (NSDictionary *)plistForKey:(NSString *)name;

@end
