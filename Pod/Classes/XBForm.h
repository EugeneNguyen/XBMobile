//
//  XBForm.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/15/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface XBForm : NSObject
{
    
}

- (void)loadForm:(UIView *)view information:(NSDictionary *)information;
- (void)loadForm:(UIView *)view informationPlist:(NSString *)plist;

+ (NSMutableDictionary *)errorList;
+ (void)loadErrorList:(NSString *)plist;

@end
