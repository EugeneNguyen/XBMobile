//
//  XBChatView.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 10/29/14.
//
//

#import "XBChatView.h"
#import <XBMobile.h>

@interface XBChatView () <NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
}

@end

@implementation XBChatView

- (void)loadInformationFromPlist:(NSString *)plist
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"XBMobile" ofType:@"bundle"];
    NSString *path = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"XBChatFriendListView" ofType:@"plist"];
    NSMutableDictionary *_info = [NSMutableDictionary dictionaryWithContentsOfFile:path];

    NSString *path2 = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    [_info addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path2]];

    [super setInformations:_info];
    [self loadDataToTable];
    [self fetchData];
}

- (void)fetchData
{
    NSXMLElement *iQ = [NSXMLElement elementWithName:@"iq"];
    [iQ addAttributeWithName:@"type" stringValue:@"get"];
    [iQ addAttributeWithName:@"id" stringValue:@"page1"];

    NSXMLElement *retrieve = [NSXMLElement elementWithName:@"retrieve"];
    [retrieve addAttributeWithName:@"xmlns" stringValue:@"urn:xmpp:archive"];
    [retrieve addAttributeWithName:@"with" stringValue:@"binh.nx@sflashcard.com"];
    [retrieve addAttributeWithName:@"start" stringValue:@"1469-07-21T02:56:15Z"];

    NSXMLElement *set = [NSXMLElement elementWithName:@"set"];
    [set addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/rsm"];
    NSXMLElement *max = [NSXMLElement elementWithName:@"max"];
    max.stringValue = @"100";
    [set addChild:max];

    [retrieve addChild:set];
    [iQ addChild:retrieve];
    
    [[[XBChatModule sharedInstance] xmppStream] sendElement:iQ];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController == nil)
    {
        XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];

        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                  inManagedObjectContext:moc];
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];

        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, nil];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setFetchBatchSize:10];

        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
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
    NSMutableArray *items = [@[] mutableCopy];
    for (int sectionIndex = 0; sectionIndex < [[[self fetchedResultsController] sections] count]; sectionIndex ++)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:sectionIndex];
        for (int i = 0; i < [sectionInfo numberOfObjects]; i ++)
        {
            [items addObject:[[self fetchedResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:sectionIndex]]];
        }
    }
    [self loadData:items];
}

@end
