//
//  UIView+XBMobile.m
//  
//
//  Created by Binh Nguyen Xuan on 6/30/15.
//
//

#import "UIView+XBMobile.h"
#import "XBMobile.h"
#import <objc/runtime.h>

NSString * const kViewInformationKey = @"kViewInformationKey";
NSString * const kDataController = @"kDataController";
NSString * const kOwner = @"kOwner";
NSString * const kPostParams = @"kPostParams";
NSString * const kCallback = @"kCallback";

@implementation UIView (XBMobile)
@dynamic viewInformation;
@dynamic owner;
@dynamic dataController;
@dynamic postParams;
@dynamic callback;
@dynamic data;

#pragma mark - Associate variable

- (void)setData:(id)data
{
    if (!self.dataController)
    {
        self.dataController = [[XBDataController alloc] init];
    }
    self.dataController.data = [data copy];
}

- (id)data
{
    if (!self.dataController)
    {
        self.dataController = [[XBDataController alloc] init];
    }
    return self.dataController.data;
}

- (void)setCallback:(XBMobileDidLoadRemoteInformation)callback
{
    objc_setAssociatedObject(self, (__bridge const void *)(kCallback), callback, OBJC_ASSOCIATION_COPY);
}

- (XBMobileDidLoadRemoteInformation)callback
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kCallback));
}

- (void)setPostParams:(NSMutableDictionary *)postParams
{
    objc_setAssociatedObject(self, (__bridge const void *)(kPostParams), postParams, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)postParams
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kPostParams));
}

- (void)setOwner:(id)owner
{
    objc_setAssociatedObject(self, (__bridge const void *)(kOwner), owner, OBJC_ASSOCIATION_ASSIGN);
}

- (id)owner
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kOwner));
}

- (void)setViewInformation:(NSMutableDictionary *)viewInformation
{
    objc_setAssociatedObject(self, (__bridge const void *)(kViewInformationKey), viewInformation, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)viewInformation
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kViewInformationKey));
}

- (void)setDataController:(XBDataController *)dataController
{
    objc_setAssociatedObject(self, (__bridge const void *)(kDataController), dataController, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Main function

- (XBDataController *)dataController
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kDataController));
}

- (void)loadPlist:(NSString *)plist
{
    NSDictionary *information = [NSDictionary dictionaryWithContentsOfPlist:plist];
    [self load:information];
}

- (void)load:(NSDictionary *)viewInformation
{
    self.viewInformation = [viewInformation mutableCopy];
    
    [self createSubviews];
    [self process];
    [self position];
    [self loadRemoteInformation];
}

- (void)createSubviews
{
    NSArray *subviews = self.viewInformation[@"subviews"];
    for (NSDictionary *subviewInformation in subviews)
    {
        UIView *view;
        // check if it already assigned in the owner
        if (subviewInformation[@"variable"] && [self.owner valueForKey:subviewInformation[@"variable"]]);
        {
            view = [self.owner valueForKey:subviewInformation[@"variable"]];
        }
        if (!view && subviewInformation[@"tag"])
        {
            view = [self viewWithTag:[subviewInformation[@"tag"] intValue]];
        }
        if (!view)
        {
            view = [self initView:subviewInformation];
            [self addSubview:view];
        }
        [view load:subviewInformation];
        if (subviewInformation[@"variable"])
        {
            [self.owner setValue:view forKey:subviewInformation[@"variable"]];
        }
        if (subviewInformation[@"tag"])
        {
            view.tag = [subviewInformation[@"tag"] intValue];
        }
    }
}

- (UIView *)initView:(NSDictionary *)information
{
    NSString *type = information[@"type"];
    if ([type isEqualToString:@"image"])
    {
        return [[UIImageView alloc] init];
    }
    if ([type isEqualToString:@"button"])
    {
        return [[UIButton alloc] init];
    }
    if ([type isEqualToString:@"label"])
    {
        return [[UILabel alloc] init];
    }
    if ([type isEqualToString:@"textfield"])
    {
        return [[UITextField alloc] init];
    }
    return [[UIView alloc] init];
}

- (void)position
{
    if ([self.viewInformation[@"ignore-possition"] boolValue])
    {
        return;
    }
    float x = [self.viewInformation[@"x"] floatValue];
    float y = [self.viewInformation[@"y"] floatValue];
    CGSize s = self.frame.size;
    CGSize superSize = self.superview.frame.size;
    
    self.frame = CGRectMake(superSize.width / 2 + x - s.width / 2, superSize.height / 2 - y - s.height / 2, s.width, s.height);
}

#pragma mark - Remote information

- (void)loadRemoteInformation
{
    if (!self.dataController)
    {
        self.dataController = [[XBDataController alloc] init];
    }
    if (self.viewInformation[@"data-controller"] && [self.viewInformation[@"data-controller"][@"type"] isEqualToString:@"remote"])
    {
        self.dataController.information = self.viewInformation[@"data-controller"];
        self.dataController.postParams = self.postParams;
        self.dataController.completedCallback = ^(){
            [self reloadFromRemoteData];
            if (self.callback)
            {
                self.callback();
            }
        };
        [self.dataController load];
    }
}

- (void)reloadFromRemoteData
{
    NSArray *subviews = self.viewInformation[@"subviews"];
    for (NSDictionary *subviewInformation in subviews)
    {
        UIView *view;
        if (subviewInformation[@"variable"] && [self.owner valueForKey:subviewInformation[@"variable"]]);
        {
            view = [self.owner valueForKey:subviewInformation[@"variable"]];
        }
        if (!view && subviewInformation[@"tag"])
        {
            view = [self viewWithTag:[subviewInformation[@"tag"] intValue]];
        }
        if (view.viewInformation)
        {
            if (!view.viewInformation[@"data-controller"] || [view.viewInformation[@"data-controller"][@"type"] isEqualToString:@"inherited"])
            {
                NSString *path = view.viewInformation[@"data-controller"][@"path-to-content"];
                if (!path)
                {
                    path = @"/";
                }
                id subData = [self.data objectForPath:path];
                view.dataController.data = subData;
                [view reloadFromRemoteData];
            }
        }
    }
    if ([self dataForKey:@"background-color-path"])
    {
        self.backgroundColor = XBHexColor([self dataForKey:@"background-color-path"]);
    }
}

- (id)dataForKey:(NSString *)key
{
    NSLog(@"%@ %@ %@", self.viewInformation, self.data, key);
    if (self.viewInformation[key] && [self.data objectForPath:self.viewInformation[key]])
    {
        return [self.data objectForPath:self.viewInformation[key]];
    }
    return nil;
}

#pragma mark - ImageView process

- (void)process
{
    NSDictionary *keyToSelector = @{@"text": @"setAttributeText:",
                                    @"image": @"setAttributeImage:",
                                    @"background-image": @"setAttributeBackgroundImage:",
                                    @"text-font": @"setAttributeTextFont:",
                                    @"text-color": @"setAttributeTextColor:",
                                    @"action": @"setAttributeAction:",
                                    @"tag": @"setAttributeTag:"};
    for (NSString *key in [keyToSelector allKeys])
    {
        [self applyKey:key toSelector:keyToSelector[key]];
    }
}

- (void)applyKey:(NSString *)key toSelector:(NSString *)selectorName
{
    SEL selector = NSSelectorFromString(selectorName);
    if (self.viewInformation[key] && self.viewInformation[key] != [NSNull null] && [self respondsToSelector:selector])
    {
        [self performSelector:selector withObject:self.viewInformation[key]];
    }
}

- (void)setAttributeAction:(NSString *)action
{
    SEL selector = NSSelectorFromString(action);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.owner action:selector];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
}

@end
