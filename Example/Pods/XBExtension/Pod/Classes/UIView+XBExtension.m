//
//  UIView+XBExtension.m
//  
//
//  Created by Binh Nguyen Xuan on 6/13/15.
//
//

#import "UIView+XBExtension.h"

@implementation UIView (XBExtension)

- (void)removeAllGestures
{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers)
    {
        [self removeGestureRecognizer:gesture];
    }
}

- (void)removeAllSubviews
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
}

- (void)addTapTarget:(id)target action:(SEL)selector
{
    if ([self respondsToSelector:@selector(addTarget:action:forControlEvents:)])
    {
        [(UIButton *)self removeTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        [(UIButton *)self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        BOOL found = NO;
        for (UIGestureRecognizer *gesture in self.gestureRecognizers)
        {
            if ([gesture isKindOfClass:[UITapGestureRecognizer class]])
            {
                found = YES;
                break;
            }
        }
        if (!found)
        {
            self.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
            [self addGestureRecognizer:tap];
        }
    }
}

@end
