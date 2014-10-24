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

@implementation UIView (extension)

- (void)applyTemplate:(NSArray *)temp andInformation:(NSDictionary *)info
{
    if ([self isKindOfClass:[UITableViewCell class]])
    {
        [(UITableViewCell *)self contentView].bounds = CGRectMake(0, 0, 99999, 99999);
    }
    for (NSDictionary *element in temp)
    {
        UIView *v = [self viewWithTag:[element[@"tag"] intValue]];
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
        if ([v isKindOfClass:[UILabel class]] || [v isKindOfClass:[UITextView class]])
        {
            [(UILabel *)v setText:data];
        }
        else if ([v isKindOfClass:[UIImageView class]])
        {
            if ([data rangeOfString:@"(BUNDLE)"].location == 0)
            {
                [(UIImageView *)v setImage:[UIImage imageNamed:data]];
            }
            else
            {
                NSString *predefaultHost = element[@"predefinedHostInUserdefault"];
                if (predefaultHost && [predefaultHost length] > 0 && [[NSUserDefaults standardUserDefaults] stringForKey:predefaultHost])
                {
                    data = [NSString stringWithFormat:@"%@/%@", [[NSUserDefaults standardUserDefaults] stringForKey:predefaultHost], data];
                }
                if ([element[@"disableCache"] intValue])
                {
                    [(UIImageView *)v sd_setImageWithURL:[NSURL URLWithString:data] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if ([element[@"autoHeight"] boolValue])
                        {
                            CGRect f = v.frame;
                            CGSize s = image.size;
                            f.size.height = f.size.width / s.width * s.height;
                            v.frame = f;
                            [self layoutSubviews];
                        }
                    }];
                }
                else
                {
                    [(UIImageView *)v sd_setImageWithURL:[NSURL URLWithString:data]];
                }
            }
        }
        else if ([v isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)v;
            [btn setTitle:data forState:UIControlStateNormal];

            if ([self respondsToSelector:NSSelectorFromString(@"didPressButton:")])
            {
                [btn removeTarget:self action:NSSelectorFromString(@"didPressButton:") forControlEvents:UIControlEventTouchUpInside];
                [btn addTarget:self action:NSSelectorFromString(@"didPressButton:") forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else if ([v isKindOfClass:[XBTableView class]])
        {
            XBTableView *tableview = (XBTableView *)v;
            [tableview loadData:data];
            tableview.informations = element;
        }
        else if ([v isKindOfClass:[XBCollectionView class]])
        {
            XBCollectionView *tableview = (XBCollectionView *)v;
            [tableview loadData:data];
            tableview.informations = element;
        }
    }
    [self setNeedsDisplay];
}

- (void)loadImage:(NSString *)data
{

}

- (void)loadInformation:(NSDictionary *)information
{

}

- (void)loadInformationFromPlist:(NSString *)plist
{

}

@end
