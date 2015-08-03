//
//  NSObject+XBGallery.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 4/15/15.
//
//

#import "NSObject+XBGallery.h"
#import "SDWebImageManager.h"

@implementation NSObject (XBGallery)

- (void)loadImageFromURL:(NSURL *)url callBack:(SEL)selector
{
    [SDWebImageManager.sharedManager downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        UIImage *newImage = [UIImage imageWithCGImage:image.CGImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
        if ([self respondsToSelector:selector])
        {
            [self performSelectorOnMainThread:selector withObject:newImage waitUntilDone:YES];
        }
    }];
}

@end
