//
//  XBTagView.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/28/14.
//
//

#import "XBTagView.h"
#import "NSObject+extension.h"

@implementation XBTagView
@synthesize tagList = _tagList;

- (void)loadInformations:(NSDictionary *)info
{
    NSMutableDictionary *_info = [[NSDictionary dictionaryWithContentsOfPlist:@"XBTagViewDefault" bundleName:@"XBMobile"] mutableCopy];
    [_info addEntriesFromDictionary:info];
    [super loadInformations:_info];
}

- (void)setTagList:(NSMutableArray *)__tagList
{
    _tagList = __tagList;
    [self loadData:_tagList];
    [self reloadData];
}

- (void)addTag:(NSString *)tagString
{
    [_tagList addObject:tagString];
    [self reloadData];
}

- (void)removeTagAtIndex:(long)index
{
    [self performBatchUpdates:^{
        [self deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        [_tagList removeObjectAtIndex:index];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didPressButton:(UIButton *)btn
{
    [super didPressButton:btn];
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:buttonPosition];
    [self removeTagAtIndex:indexPath.row];
}

@end
