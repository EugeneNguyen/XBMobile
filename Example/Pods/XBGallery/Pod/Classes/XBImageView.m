//
//  XBImageView.m
//  
//
//  Created by Binh Nguyen Xuan on 8/3/15.
//
//

#import "XBImageView.h"
#import <XBGallery.h>

@implementation XBImageView
@synthesize imageID;
@synthesize enableLoadingIndicator;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */


-(void)setBounds:(CGRect)newBounds {
     BOOL const isResize = !CGSizeEqualToSize(newBounds.size, self.bounds.size);
     if (isResize && imageID != 0)
     {
         if (enableLoadingIndicator)
         {
             [self loadImage:self.imageID withIndicatorStyle:UIActivityIndicatorViewStyleGray];
         }
         else
         {
             [self loadImage:self.imageID];
         }
     }
 }

@end
