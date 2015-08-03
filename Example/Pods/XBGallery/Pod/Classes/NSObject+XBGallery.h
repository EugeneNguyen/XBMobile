//
//  NSObject+XBGallery.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 4/15/15.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (XBGallery)

- (void)loadImageFromURL:(NSURL *)url callBack:(SEL)selector;

@end
