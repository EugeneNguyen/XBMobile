//
//  XBGallery.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 2/4/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "NSObject+XBGallery.h"
#import "UIImageView+XBGallery.h"
#import "UIImage+XBGallery.h"
#import "XBImageView.h"

@class XBCacheRequest;

typedef void (^XBGImageUploaded)(NSDictionary * responseData, int imageID);
typedef void (^XBGMultipleImageUploaded)(NSArray * responseData);
typedef void (^XBGImageGetInformation)(NSDictionary * responseData);

@interface XBGallery : NSObject
{
    
}

@property (nonatomic, retain) NSString *host;

+ (XBGallery *)sharedInstance;

- (XBCacheRequest *)uploadImage:(UIImage *)image withCompletion:(XBGImageUploaded)completeBlock;
- (XBCacheRequest *)uploadImageURL:(NSString *)url withCompletion:(XBGImageUploaded)completeBlock;
- (void)uploadImages:(NSArray *)images withCompletion:(XBGMultipleImageUploaded)completeBlock;

- (NSURL *)urlForID:(int)imageid isThumbnail:(BOOL)isThumbnail;
- (NSURL *)urlForID:(int)imageid size:(CGSize)size;
- (void)infomationForID:(int)imageid withCompletion:(XBGImageGetInformation)completeBlock;

@end
