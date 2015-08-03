//
//  XBGImageResizer.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 5/7/15.
//
//

#import <Foundation/Foundation.h>

#define XBGResizedImage(X) [[XBGImageResizer sharedInstance] resizeImage:X]

@interface XBGImageResizer : NSObject
{
    
}

@property (nonatomic, assign) float maxWidth, maxHeight;
@property (nonatomic, assign) float maxMB;

+ (instancetype)sharedInstance;
- (UIImage *)resizeImage:(UIImage *)image;

@end
