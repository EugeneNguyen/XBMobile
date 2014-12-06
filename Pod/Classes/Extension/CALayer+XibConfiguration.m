//
//  CALayer+XibConfiguration.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 12/6/14.
//
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
