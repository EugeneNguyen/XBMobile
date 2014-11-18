//
//  NSString+form.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/15/14.
//
//

#import <Foundation/Foundation.h>

extern NSString *const XBFormDataErrorMaxLength;
extern NSString *const XBFormDataErrorMinLength;
extern NSString *const XBFormDataErrorRequired;

@interface NSString (form)

- (NSArray *)validateWithInformation:(NSDictionary *)item;

@end
