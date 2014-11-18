//
//  XBForm.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/15/14.
//
//

#import "XBForm.h"
#import "NSString+form.h"
#import "NSString+extension.h"

static NSMutableDictionary *__sharedFormErrorList = nil;

@interface XBForm ()
{
    NSMutableArray *elements;
}

@property (nonatomic, retain) NSDictionary *information;
@property (nonatomic, assign) UIView *view;

@end

@implementation XBForm
@synthesize information = _information;
@synthesize view = _view;

+ (void)loadErrorList:(NSString *)plist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    NSDictionary *errorList = [NSDictionary dictionaryWithContentsOfFile:path];
    [[XBForm errorList] addEntriesFromDictionary:errorList];
}

+ (NSMutableDictionary *)errorList
{
    if (!__sharedFormErrorList)
    {
        __sharedFormErrorList = [NSMutableDictionary new];
    }
    return __sharedFormErrorList;
}

- (void)loadForm:(UIView *)view information:(NSDictionary *)information
{
    _information = information;
    _view = view;
    [self applyData];
}

- (void)loadForm:(UIView *)view informationPlist:(NSString *)plist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    NSDictionary *item = [NSDictionary dictionaryWithContentsOfFile:path];
    
    [self loadForm:view information:item];
}

- (void)applyData
{
    elements = [NSMutableArray new];
    for (NSDictionary *item in _information[@"elements"])
    {
        int tag = [item[@"tag"] intValue];
        NSString *type = item[@"type"];
        
        if ([type isEqualToString:@"text"])
        {
            UITextField *textField = (UITextField *)[_view viewWithTag:tag];
            [elements addObject:textField];
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        else if ([type isEqualToString:@"password"])
        {
            UITextField *textField = (UITextField *)[_view viewWithTag:tag];
            textField.secureTextEntry = YES;
            [elements addObject:textField];
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        else if ([type isEqualToString:@"submit"])
        {
            UIButton *btn = (UIButton *)[_view viewWithTag:tag];
            [btn addTarget:self action:@selector(submitDidPress:) forControlEvents:UIControlEventTouchUpInside];
            [elements addObject:btn];
        }
    }
    [self checkEnableButton];
}

#pragma mark - Callback

- (void)submitDidPress:(id)sender
{
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    NSDictionary *item = [self itemForElement:textField];
    NSArray *error = [textField.text validateWithInformation:item];
    if (item[@"errorTag"])
    {
        int tag = [item[@"errorTag"] intValue];
        UILabel *label = (UILabel *)[_view viewWithTag:tag];
        
        NSDictionary *errorList = [XBForm errorList];
        NSMutableString *s = [@"" mutableCopy];
        for (NSString *errorKey in error)
        {
            [s appendFormat:@"%@\n", [errorList[errorKey] applyData:item]];
        }
        label.text = s;
    }
    
    [self checkEnableButton];
}

#pragma mark - private method

- (void)checkEnableButton
{
    [self enableButton:([[self validateAllField] count] == 0)];
}

- (void)enableButton:(BOOL)enable
{
    for (NSDictionary *item in _information[@"elements"])
    {
        int tag = [item[@"tag"] intValue];
        NSString *type = item[@"type"];
        if ([type isEqualToString:@"submit"])
        {
            UIButton *btn = (UIButton *)[_view viewWithTag:tag];
            btn.enabled = enable;
        }
    }
}

- (NSArray *)validateAllField
{
    NSMutableArray *result = [@[] mutableCopy];
    for (NSDictionary *item in _information[@"elements"])
    {
        if ([item[@"type"] isEqualToString:@"text"] || [item[@"type"] isEqualToString:@"password"])
        {
            UITextField *textField = (UITextField *)[_view viewWithTag:[item[@"tag"] intValue]];
            NSArray *error = [textField.text validateWithInformation:item];
            [result addObjectsFromArray:error];
        }
    }
    return result;
}

- (NSDictionary *)itemForElement:(UIView *)element
{
    long tag = element.tag;
    for (NSDictionary *item in _information[@"elements"])
    {
        if ([item[@"tag"] intValue] == tag)
        {
            return item;
        }
    }
    return nil;
}

@end
