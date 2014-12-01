//
//  XBTagView.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/28/14.
//
//

#import "XBCollectionView.h"

@interface XBTagView : XBCollectionView

@property (nonatomic, retain) NSMutableArray *tagList;

- (void)addTag:(NSString *)_tag;
- (void)removeTagAtIndex:(long)index;

@end
