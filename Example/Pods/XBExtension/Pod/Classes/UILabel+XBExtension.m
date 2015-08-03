//
//  UILabel+XBExtension.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 7/19/15.
//
//

#import "UILabel+XBExtension.h"

@implementation UILabel (XBExtension)

- (void)setHTML:(NSString *)htmlCode
{
    self.attributedText = [[NSAttributedString alloc] initWithData: [htmlCode dataUsingEncoding:NSUTF8StringEncoding]
                                                           options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                             error: nil];
}

@end
