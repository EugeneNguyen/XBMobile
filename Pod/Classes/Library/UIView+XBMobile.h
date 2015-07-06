//
//  UIView+XBMobile.h
//  
//
//  Created by Binh Nguyen Xuan on 6/30/15.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIView (XBMobile)
@property (nonatomic, retain) NSMutableDictionary *viewInformation;
@property (nonatomic, assign) id owner;

- (void)load:(NSDictionary *)viewInformation;
- (void)process;

@end
