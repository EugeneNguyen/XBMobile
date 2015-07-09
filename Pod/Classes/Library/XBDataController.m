//
//  XBDataController.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 7/6/15.
//
//

#import "XBDataController.h"
#import "XBMobile.h"

@implementation XBDataController
@synthesize information = _information;
@synthesize data = _data;
@synthesize completedCallback;
@synthesize postParams;

- (void)load
{
    NSString *urlPath = self.information[@"request"][@"url"];
    XBCacheRequest *request = XBCacheRequest(urlPath);
    if (postParams)
    {
        [request setDataPost:postParams];
    }
    [request startAsynchronousWithCallback:^(XBCacheRequest *request, NSString *result, BOOL fromCache, NSError *error, id object) {
        
        NSString *codePath = [self codePath];
        if ([[object objectForPath:codePath] intValue] == 200)
        {
            NSString *dataPath = [self dataPath];
            [self updateData:[object objectForPath:dataPath]];
        }
        
        completedCallback();
    }];
}

- (void)updateData:(id)dataObject
{
    if (!self.data)
    {
        self.data = dataObject;
    }
    self.data = dataObject;
}

- (NSString *)dataPath
{
    NSString *dataPath = self.information[@"request"][@"data-path"];
    if (!dataPath)
    {
        dataPath = @"data";
    }
    return dataPath;
}

- (NSString *)codePath
{
    NSString *codePath = self.information[@"request"][@"code-path"];
    if (!codePath)
    {
        codePath = @"code";
    }
    return codePath;
}

@end
