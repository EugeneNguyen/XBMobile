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
@synthesize imageID = _imageID;
@synthesize enableLoadingIndicator;

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (enableLoadingIndicator)
    {
        [self loadImage:self.imageID withIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    else
    {
        [self loadImage:self.imageID];
    }
}

- (void)setImageID:(int)imageID
{
    _imageID = imageID;
    
    if (enableLoadingIndicator)
    {
        [self loadImage:self.imageID withIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    else
    {
        [self loadImage:self.imageID];
    }
}

@end
