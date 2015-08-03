//
//  UITextField+XBExtension.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 7/3/15.
//
//

#import <UIKit/UIKit.h>

@interface UITextField (XBExtension)

@property (nonatomic, retain) NSCharacterSet *disabledCharacterSet;
@property (nonatomic, retain) NSDictionary *replacementSet;

- (void)activeUsernameLimitation;
- (void)activePasswordLimitation;
- (void)activeEmailLimitation;

@end
