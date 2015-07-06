//
//  UIImageView+XBMobile.m
//  
//
//  Created by Binh Nguyen Xuan on 6/30/15.
//
//

#import "UIImageView+XBMobile.h"
#import "UIView+XBMobile.h"

@implementation UIImageView (XBMobile)

- (void)setAttributeImage:(NSString *)imageString
{
    UIImage *image = [UIImage imageNamed:imageString];
    if (image)
    {
        CGSize s = image.size;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, s.width, s.height);
        self.image = image;
    }
}

@end
