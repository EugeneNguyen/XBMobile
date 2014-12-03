//
//  XBTagView.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/28/14.
//
//

#import "XBCollectionView.h"

@class XBTagView;

@protocol XBTagViewDelegate <NSObject>

- (void)xbTagView:(XBTagView *)tagview didRemoveTag:(id)item atIndex:(int)index;
- (void)xbTagView:(XBTagView *)tagview didAddTag:(id)item;

@end

@interface XBTagView : XBCollectionView

@property (nonatomic, retain) NSMutableArray *tagList;
@property (nonatomic, retain) IBOutlet id <XBTagViewDelegate> tagViewDelegate;

- (void)addTag:(NSString *)_tag;
- (void)removeTagAtIndex:(long)index;

@end
