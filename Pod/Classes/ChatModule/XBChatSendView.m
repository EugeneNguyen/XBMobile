//
//  XBChatSendView.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 10/29/14.
//
//

#import "XBChatSendView.h"
#import "XBMobile.h"

@interface XBChatSendView () <UITextFieldDelegate>
{
    UIButton *sendButton; // tag 99
    UITextField *textField; // tag 98
}

@end

@implementation XBChatSendView
@synthesize jidStr;

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!sendButton)
    {
        sendButton = (UIButton *)[self viewWithTag:99];
        [sendButton removeTarget:self action:@selector(didPressSend:) forControlEvents:UIControlEventTouchUpInside];
        [sendButton addTarget:self action:@selector(didPressSend:) forControlEvents:UIControlEventTouchUpInside];

        textField = (UITextField *)[self viewWithTag:98];
        textField.delegate = self;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:) name: UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide:) name: UIKeyboardDidHideNotification object:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self didPressSend:nil];
    [self endEditing:YES];
    return YES;
}

-(void) keyboardDidShow: (NSNotification *)notif
{
    NSDictionary* info = [notif userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;

    [UIView beginAnimations:nil context:nil];
    CGRect f = self.frame;
    f.origin.y = self.superview.frame.size.height - f.size.height - keyboardSize.height;
    self.frame = f;
    [UIView commitAnimations];
}

-(void) keyboardDidHide: (NSNotification *)notif
{
    [UIView beginAnimations:nil context:nil];
    CGRect f = self.frame;
    f.origin.y = self.superview.frame.size.height - f.size.height;
    self.frame = f;
    [UIView commitAnimations];
}

- (void)didPressSend:(id)sender
{
    if ([textField hasText])
    {
        [[XBChatModule sharedInstance] sendMessage:textField.text toID:self.jidStr];
        UITextPosition *p0 = [textField beginningOfDocument];
        UITextPosition *p1 = [textField positionFromPosition:p0 offset:[[textField text] length]];
        UITextRange *complete = [textField textRangeFromPosition:p0 toPosition:p1];
        [textField replaceRange:complete withText:@""];
    }
}

@end
