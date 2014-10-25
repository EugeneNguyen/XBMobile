//
//  XBChatFriendListView.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 10/27/14.
//
//

#import "XBChatFriendListView.h"
#import <CoreData/CoreData.h>
#import "XBChatModule.h"
#import "XBMobile.h"

@interface XBChatFriendListView () <NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
}

@end

@implementation XBChatFriendListView

- (void)loadInformationFromPlist:(NSString *)plist
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"XBMobile" ofType:@"bundle"];
    NSString *path = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"XBChatFriendListView" ofType:@"plist"];
    NSMutableDictionary *_info = [NSMutableDictionary dictionaryWithContentsOfFile:path];

    NSString *path2 = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    [_info addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path2]];

    [super setInformations:_info];
    [self loadDataToTable];

    [self setupNotification];
}

- (void)setupNotification
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
    [center addObserver:self selector:@selector(loadDataToTable) name:XBChatEventConnected object:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController == nil)
    {

        NSManagedObjectContext *moc = [[XBChatModule sharedInstance] managedObjectContext_roster];

        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                                  inManagedObjectContext:moc];

        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
        NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];

        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setFetchBatchSize:10];

        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:moc
                                                                         sectionNameKeyPath:@"sectionNum"
                                                                                  cacheName:nil];
        [fetchedResultsController setDelegate:self];


        NSError *error = nil;
        if (![fetchedResultsController performFetch:&error])
        {
            DDLogError(@"Error performing fetch: %@", error);
        }
        
    }
    
    return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self loadDataToTable];
}

- (void)loadDataToTable
{
    NSMutableArray *sections = [@[] mutableCopy];
    for (int sectionIndex = 0; sectionIndex < [[[self fetchedResultsController] sections] count]; sectionIndex ++)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:sectionIndex];
        int sectionname = [sectionInfo.name intValue];
        NSMutableArray *items = [@[] mutableCopy];
        for (int i = 0; i < [sectionInfo numberOfObjects]; i ++)
        {
            [items addObject:[[self fetchedResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:sectionIndex]]];
        }
        [sections addObject:@{@"title": (@[@"Available", @"Away", @"Offline"])[sectionname],
                              @"items": items}];
    }
    [self loadData:sections];
    NSLog(@"%@", sections);
}

@end
