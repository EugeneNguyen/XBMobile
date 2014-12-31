//
//  ASIHTTPRequest+extension.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 12/12/14.
//
//

#import "ASIHTTPRequest+extension.h"
#import "JSONKit.h"

@implementation ASIHTTPRequest (extension)

@dynamic responseJSON;

- (id)responseJSON
{
    return [self.responseString mutableObjectFromJSONString];
}

@end
