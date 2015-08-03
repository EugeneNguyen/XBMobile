//
//  XBGallery.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 2/4/15.
//
//

#import "XBGallery.h"
#import "XBCacheRequest.h"

static XBGallery *__sharedXBGallery = nil;

@interface XBGallery ()
{
}
@property (nonatomic, retain) NSMutableArray *arrayImage;
@property (nonatomic, copy) XBGMultipleImageUploaded multiCompleteBlock;

@end

@implementation XBGallery
@synthesize host;
@synthesize arrayImage;
@synthesize multiCompleteBlock;

+ (XBGallery *)sharedInstance
{
    if (!__sharedXBGallery)
    {
        __sharedXBGallery = [[XBGallery alloc] init];
    }
    return __sharedXBGallery;
}

- (XBCacheRequest *)uploadImage:(UIImage *)image withCompletion:(XBGImageUploaded)completeBlock
{
    NSString *url = [NSString stringWithFormat:@"%@/plusgallery/services/addphoto", host];
    XBCacheRequest *request = XBCacheRequest(url);
    [request addFileWithData:UIImageJPEGRepresentation([[image fixOrientation] resized], 0.7) key:@"uploadimg" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
    request.disableCache = YES;
    [request startAsynchronousWithCallback:^(XBCacheRequest *request, NSString *result, BOOL fromCache, NSError *error, id object) {
        completeBlock(object, [object[@"photo_id"] intValue]);
    }];
    return request;
}

- (XBCacheRequest *)uploadImageURL:(NSString *)url withCompletion:(XBGImageUploaded)completeBlock
{
    NSString *urlRequest = [NSString stringWithFormat:@"%@/plusgallery/services/upload_by_url", host];
    XBCacheRequest *request = XBCacheRequest(urlRequest);
    [request setDataPost:[@{@"url": url} mutableCopy]];
    request.disableCache = YES;
    [request startAsynchronousWithCallback:^(XBCacheRequest *request, NSString *result, BOOL fromCache, NSError *error, id object) {
        completeBlock(object, [object[@"photo_id"] intValue]);
    }];
    return request;
}

- (void)uploadImages:(NSArray *)images withCompletion:(XBGMultipleImageUploaded)completeBlock
{
    arrayImage = [@[] mutableCopy];
    for (UIImage *img in images)
    {
        [arrayImage addObject:[@{@"image": [img copy]} mutableCopy]];
    }
    self.multiCompleteBlock = completeBlock;
    [self uploadImageOneByOne:arrayImage withComplete:multiCompleteBlock];
}

- (void)uploadImageOneByOne:(NSMutableArray *)_arrayImage withComplete:(XBGMultipleImageUploaded)completeBlock
{
    BOOL found = NO;
    arrayImage = [_arrayImage copy];
    for (NSMutableDictionary *information in arrayImage)
    {
        if (information[@"id"])
        {
            continue;
        }
        else
        {
            if ([information[@"image"] isKindOfClass:[UIImage class]])
            {
                [self uploadImage:information[@"image"] withCompletion:^(NSDictionary *responseData, int photoid) {
                    information[@"id"] = @(photoid);
                    [self uploadImageOneByOne:arrayImage withComplete:multiCompleteBlock];
                }];
            }
            else if ([information[@"image"] isKindOfClass:[NSString class]])
            {
                [self uploadImageURL:information[@"image"] withCompletion:^(NSDictionary *responseData, int imageID) {
                    information[@"id"] = @(imageID);
                    [self uploadImageOneByOne:arrayImage withComplete:multiCompleteBlock];
                }];
            }
            found = YES;
            break;
        }
    }
    if (!found)
    {
        completeBlock([arrayImage valueForKey:@"id"]);
    }
}

- (NSURL *)urlForID:(int)imageid isThumbnail:(BOOL)isThumbnail
{
    NSString *path = [NSString stringWithFormat:@"%@/plusgallery/services/showbyid?id=%d&origin=%d", self.host, imageid, !isThumbnail];
    return [NSURL URLWithString:path];
}

- (NSURL *)urlForID:(int)imageid size:(CGSize)size
{
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    NSString *path = [NSString stringWithFormat:@"%@/plusgallery/services/showbyid?id=%d&width=%f&height=%f&keep_ratio=1", self.host, imageid, size.width * screenScale, size.height * screenScale];
    return [NSURL URLWithString:path];
}

- (void)infomationForID:(int)imageid withCompletion:(XBGImageGetInformation)completeBlock
{
    NSString *path = [NSString stringWithFormat:@"%@/plusgallery/services/showbyid/%d/1/1", host, imageid];
    XBCacheRequest *request = XBCacheRequest(path);
    request.disableCache = YES;
    [request startAsynchronousWithCallback:^(XBCacheRequest *request, NSString *result, BOOL fromCache, NSError *error, id object) {
        completeBlock(object);
    }];
}

@end
