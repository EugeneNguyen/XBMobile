//
//  UIView+XBExtension.h
//  
//
//  Created by Binh Nguyen Xuan on 6/13/15.
//
//

#import <UIKit/UIKit.h>

@interface UIView (XBExtension)

- (void)removeAllGestures;
- (void)removeAllSubviews;

- (void)addTapTarget:(id)target action:(SEL)selector;

@end
