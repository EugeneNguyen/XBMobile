//
//  UIImage+XBGallery.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 5/12/15.
//
//

#import <UIKit/UIKit.h>
#import "XBGImageResizer.h"

@interface UIImage (XBGallery)

- (UIImage *)fixOrientation;
- (UIImage *)resized;
- (UIImage *)resizeTo:(CGSize)newSize;

@end
