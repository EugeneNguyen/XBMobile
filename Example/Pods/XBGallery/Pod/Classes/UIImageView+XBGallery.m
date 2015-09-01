//
//  UIImageView+XBGallery.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 4/15/15.
//
//

#import "UIImageView+XBGallery.h"
#import "XBGallery.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (XBGallery)

- (void)loadImage:(int)imageId
{
    [self loadImageFromURL:[[XBGallery sharedInstance] urlForID:imageId size:self.bounds.size] callBack:@selector(setImage:)];
}

- (void)loadImage:(int)imageId withIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    indicator.tag = 999999;
    indicator.layer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addSubview:indicator];
    
    [self loadImageFromURL:[[XBGallery sharedInstance] urlForID:imageId size:self.bounds.size] callBack:@selector(setImageAndRemoveIndicator:)];
}

- (void)setImageAndRemoveIndicator:(UIImage *)img
{
    UIView *indicator = [self viewWithTag:999999];
    [indicator removeFromSuperview];
    [self setImage:img];
}

- (void)loadImageNumber:(id)imageID
{
    [self loadImage:[imageID intValue]];
}

- (void)loadImageNumberWithGrayIndicator:(id)imageID
{
    [self loadImage:[imageID intValue] withIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void)loadImageNumberWithWhiteIndicator:(id)imageID
{
    [self loadImage:[imageID intValue] withIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}

- (void)loadImageNumberWithLargeWhiteIndicator:(id)imageID
{
    [self loadImage:[imageID intValue] withIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
}

@end
