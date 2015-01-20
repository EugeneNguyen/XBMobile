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
    [self giveBorderWithCornerRadious:self.cornerRadius borderColor:color andBorderWidth:self.borderWidth];
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

- (void)giveBorderWithCornerRadious:(CGFloat)radius borderColor:(UIColor *)borderColor andBorderWidth:(CGFloat)borderWidth
{
    CGRect rect = self.bounds;
    
    //Make round
    // Create the path for to make circle
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = rect;
    maskLayer.path  = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the view's layer
    self.mask = maskLayer;
    
    //Give Border
    //Create path for border
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                     byRoundingCorners:UIRectCornerAllCorners
                                                           cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    
    borderLayer.frame       = rect;
    borderLayer.path        = borderPath.CGPath;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    borderLayer.fillColor   = [UIColor clearColor].CGColor;
    borderLayer.lineWidth   = borderWidth;
    
    //Add this layer to give border.
    [self addSublayer:borderLayer];
}

@end
