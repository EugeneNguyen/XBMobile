//
//  UIView+extension.m
//  XBMobile
//
//  Created by Binh Nguyen Xuan on 10/10/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import "UIView+extension.h"
#import "XBExtension.h"
#import "UIImageView+WebCache.h"
#import <XBTableView.h>
#import <XBCollectionView.h>
#import <AVHexColor.h>
#import <UIImage-Helpers.h>
#import "XBMobile.h"
#import <NSDate+TimeAgo.h>

@implementation UIView (extension)
@dynamic bottomMargin;
@dynamic originalHeight;

- (void)applyTemplate:(NSArray *)temp andInformation:(NSDictionary *)info
{
    [self applyTemplate:temp andInformation:info withTarget:nil];
}

- (void)applyTemplate:(NSArray *)temp andInformation:(NSDictionary *)info withTarget:(id)target
{
    if ([self isKindOfClass:[UITableViewCell class]])
    {
        [(UITableViewCell *)self contentView].bounds = CGRectMake(0, 0, 99999, 99999);
    }
    for (NSDictionary *element in temp)
    {
        UIView *v = [self viewWithTag:[element[@"tag"] intValue]];
        
        if (element[@"backgroundColor"])
        {
            NSString *backgroundColorString = [info objectForPath:element[@"backgroundColor"]];
            if (backgroundColorString && [backgroundColorString length] >= 6)
            {
                v.backgroundColor = [AVHexColor colorWithHexString:backgroundColorString];
            }
        }
        
        id data = [info objectForPath:element[@"path"]];
        if (data == [NSNull null])
        {
            data = @"";
        }
        if (element[@"format"])
        {
            data = [NSString stringWithFormat:element[@"format"], data];
            data = [data applyData:info];
        }
        if (element[@"cases"])
        {
            for (NSDictionary *c in element[@"cases"])
            {
                if ([c[@"case"] isEqualToString:[NSString stringWithFormat:@"%@", data]])
                {
                    data = c[@"result"];
                    data = [data applyData:info];
                    break;
                }
            }
        }
        
        if (element[@"screen"])
        {
            data = XBText(data, element[@"screen"]);
        }
        
        if (element[@"dateFormat"])
        {
            NSDate *date;
            if ([data isKindOfClass:[NSDate class]])
            {
                date = data;
            }
            else
            {
                date = [data mysqlDate];
            }
            
            if ([element[@"dateFormat"] isEqualToString:@"fuzzy"])
            {
                data = [date timeAgoWithLimit:5184000];
            }
            else
            {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:element[@"dateFormat"]];
                data = [df stringFromDate:date];
            }
        }
        if ([v isKindOfClass:[UILabel class]] || [v isKindOfClass:[UITextView class]])
        {
            [(UILabel *)v setText:data];
        }
        else if ([v isKindOfClass:[UIImageView class]])
        {
            UIImageView *imgView = (UIImageView *)v;
            if ([data rangeOfString:@"(BUNDLE)"].location == 0)
            {
                data = [data substringFromIndex:8];
                [imgView setImage:[UIImage imageNamed:data]];
            }
            else
            {
                NSString *predefaultHost = element[@"predefinedHostInUserdefault"];
                if (predefaultHost && [predefaultHost length] > 0 && [[NSUserDefaults standardUserDefaults] stringForKey:predefaultHost])
                {
                    data = [NSString stringWithFormat:@"%@/%@", [[NSUserDefaults standardUserDefaults] stringForKey:predefaultHost], data];
                }
                SDWebImageOptions option;
                if ([element[@"disableCache"] boolValue])
                {
                    option = SDWebImageRefreshCached;
                }
                else
                {
                    option = 0;
                }
                
                UIImage *placeHolderImage = nil;
                if (element[@"widthPath"] && element[@"heightPath"] && [element[@"autoHeight"] boolValue])
                {
                    [self layoutIfNeeded];
                    float h = [[info objectForPath:element[@"heightPath"]] floatValue];
                    float w = [[info objectForPath:element[@"widthPath"]] floatValue];
                    
                    if (h != 0 && w != 0)
                    {
                        for (NSLayoutConstraint *constraint in v.constraints)
                        {
                            if (constraint.firstAttribute == NSLayoutAttributeWidth || constraint.firstAttribute == NSLayoutAttributeHeight)
                            {
                                [v removeConstraint:constraint];
                            }
                        }
                        float scale = w / h;
                        
                        w = v.frame.size.width;
                        h = w / scale;
                        [v addConstraint:[NSLayoutConstraint constraintWithItem:v
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:h]];
                        [v addConstraint:[NSLayoutConstraint constraintWithItem:v
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:w]];
                    }
                    
                    [self layoutSubviews];
                }
                
                __block BOOL noPrevImage = [(UIImageView *)v image] == NULL;
                [imgView sd_setImageWithURL:[NSURL URLWithString:data] placeholderImage:placeHolderImage options:option completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    if (error) return;
                    if (noPrevImage && [element[@"fadein"] boolValue])
                    {
                        [UIView transitionWithView:imgView
                                          duration:0.5
                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                        animations:^{
                                            [imgView setImage:image];
                                            v.alpha = 1.0;
                                        } completion:NULL];
                    }
                    else
                    {
                        imgView.image = image;
                    }
                    
                    if ([element[@"autoHeight"] boolValue] && !(element[@"widthPath"] && element[@"heightPath"]))
                    {
                        CGRect f = v.frame;
                        CGSize s = image.size;
                        f.size.height = f.size.width / s.width * s.height;
                        v.frame = f;
                        [self layoutIfNeeded];
                    }
                }];
            }
        }
        else if ([v isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)v;
            if (element[@"path"] || element[@"format"])
            {
                if (element[@"screen"])
                {
                    [btn setTitle:XBText(data, element[@"screen"]) forState:UIControlStateNormal];
                }
                else
                {
                    [btn setTitle:data forState:UIControlStateNormal];
                }
            }
            
            if (element[@"selector"] && [target respondsToSelector:NSSelectorFromString(element[@"selector"])])
            {
                [btn removeTarget:target action:NSSelectorFromString(element[@"selector"]) forControlEvents:UIControlEventTouchUpInside];
                [btn addTarget:target action:NSSelectorFromString(element[@"selector"]) forControlEvents:UIControlEventTouchUpInside];
            }
            
            if ([target respondsToSelector:NSSelectorFromString(@"didPressButton:")])
            {
                [btn removeTarget:target action:NSSelectorFromString(@"didPressButton:") forControlEvents:UIControlEventTouchUpInside];
                [btn addTarget:target action:NSSelectorFromString(@"didPressButton:") forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else if ([v isKindOfClass:[XBTableView class]])
        {
            XBTableView *tableview = (XBTableView *)v;
            [tableview loadData:data];
            [tableview loadInformations:element withReload:YES];
        }
        else if ([v isKindOfClass:[XBCollectionView class]])
        {
            XBCollectionView *tableview = (XBCollectionView *)v;
            [tableview loadData:data];
            [tableview loadInformations:element withReload:YES];
        }
    }
    
    [self layoutSubviews];
    [self setNeedsDisplay];
}

+ (id)viewWithXib:(NSString *)xibName templatePlist:(NSString *)tempString information:(NSDictionary *)information
{
    return [UIView viewWithXib:xibName templatePlist:tempString information:information withTarget:nil];
}

+ (id)viewWithXib:(NSString *)xibName templatePlist:(NSString *)tempString information:(NSDictionary *)information withTarget:(id)target
{
    NSString *path = [[NSBundle mainBundle] pathForResource:tempString ofType:@"plist"];
    NSArray *temp = [NSArray arrayWithContentsOfFile:path];
    return [UIView viewWithXib:xibName template:temp information:information withTarget:target];
}


+ (id)viewWithXib:(NSString *)xibName template:(NSArray *)temp information:(NSDictionary *)information
{
    return [UIView viewWithXib:xibName template:temp information:information withTarget:nil];
}

+ (id)viewWithXib:(NSString *)xibName template:(NSArray *)temp information:(NSDictionary *)information withTarget:(id)target
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil];
    if ([array count] == 0) return nil;
    UIView *v = [array firstObject];
    [v applyTemplate:temp andInformation:information withTarget:target];
    return v;
}

- (void)dim
{
    UIView *view = [self.superview viewWithTag:999];
    if (!view)
    {
        UIView *view = [[UIView alloc] initWithFrame:self.frame];
        view.tag = 999;
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        view.userInteractionEnabled = YES;
        view.alpha = 0;
        [self.superview addSubview:view];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapDim)];
        [view addGestureRecognizer:tapGesture];
        
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            view.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)didTapDim
{
    [self undim];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)undim
{
    UIView *view = [self.superview viewWithTag:999];
    if (view)
    {
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
}

- (UIViewController *) firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

//- (void)setBottomMargin:(float)bottomMargin
//{
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc addObserver:self selector:@selector(keyboardChangedStatus:) name:UIKeyboardWillShowNotification object:nil];
//    [nc addObserver:self selector:@selector(keyboardChangedStatus:) name:UIKeyboardWillHideNotification object:nil];
//}
//
//- (void)keyboardChangedStatus:(NSNotification*)notification {
//    //get the size!
//    CGRect keyboardRect;
//    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
//    float keyboardHeight = keyboardRect.size.height;
//    //move your view to the top, to display the textfield..
//    [self moveView:notification keyboardHeight:keyboardHeight];
//}
//
//- (void)moveView:(NSNotification *) notification keyboardHeight:(int)height{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    
//    CGRect rect = self.frame;
//    
//    CGRect superRect = [self convertRect:rect toView:self.window];
//    
//    if ([[notification name] isEqual:UIKeyboardWillHideNotification])
//    {
//        rect.origin.y = self.originalHeight;
//    }
//    else
//    {
//        NSDictionary *info = [notification userInfo];
//        CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//        self.originalHeight = rect.size.height;
//        rect.size.height = self.window.frame.size.height - superRect.origin.y - keyboardSize.height - height;
//    }
//    
//    self.frame = rect;
//    
//    [UIView commitAnimations];
//}
//
//- (void)dealloc
//{
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}

@end
