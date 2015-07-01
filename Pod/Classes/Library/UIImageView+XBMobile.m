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

- (void)process:(NSDictionary *)information
{
    [super process:information];
    
    if (information[@"image"])
    {
        UIImage *image = [UIImage imageNamed:information[@"image"]];
        if (image)
        {
            CGSize s = image.size;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, s.width, s.height);
            self.image = image;
        }
    }
}

@end
