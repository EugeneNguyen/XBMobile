//
//  XBDataController.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 7/6/15.
//
//

#import <Foundation/Foundation.h>

typedef void (^XBDataControllerRequestCompleted)();

@interface XBDataController : NSObject

@property (nonatomic, retain) NSDictionary *information;
@property (nonatomic, retain) id data;
@property (nonatomic, retain) NSMutableDictionary *postParams;
@property (nonatomic, copy) XBDataControllerRequestCompleted completedCallback;

- (void)load;

@end
