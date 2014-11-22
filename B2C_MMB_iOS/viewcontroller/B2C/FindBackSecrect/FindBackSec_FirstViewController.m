//
//  FindBackSec_FirstViewController.m
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-9.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import "FindBackSec_FirstViewController.h"
#import "DCFStringUtil.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "FindBackSec_SecondViewController.h"
#import "DCFCustomExtra.h"
#import "ValidateForPhoneViewController.h"
#import "ValidateForEmailViewController.h"
#import "MCDefine.h"

@interface FindBackSec_FirstViewController ()

@end

@implementation FindBackSec_FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"找回密码"];
    self.navigationItem.titleView = top;
    
    self.nextBtn.layer.borderColor = MYCOLOR.CGColor;
    self.nextBtn.layer.borderWidth = 1.0f;
    self.nextBtn.layer.cornerRadius = 5.0f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - 判断是不是纯数字
- (BOOL)isAllNum:(NSString *)string
{
    unichar c;
    for (int i=0; i<string.length; i++)
    {
        c=[string characterAtIndex:i];
        if (!isdigit(c))
        {
            return NO;
        }
    }
    return YES;
}

- (IBAction)nextBtnClick:(id)sender
{
    if([_tf_confirm isFirstResponder])
    {
        [_tf_confirm resignFirstResponder];
    }
    
    NSString *string = [_tf_confirm.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    if(string.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入账号信息"];
        return;
    }
    
    if([DCFCustomExtra validateMobile:self.tf_confirm.text] == NO)
    {
        [DCFStringUtil showNotice:@"请输入正确的手机号码"];
        return;
    }
    [self push];
}

- (void) next:(UIButton *) sender
{

}


- (void) push
{
    NSString *phone = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserPhone"]];
    NSString *email = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmail"]];
    NSLog(@"%@  %@",phone,email);
//    email = @"";
    //只绑定邮箱没有绑定手机进入邮箱验证界面
     if((phone.length == 0 || [phone isKindOfClass:[NSNull class]] || phone == NULL || phone == nil) && (email.length != 0 || ![email isKindOfClass:[NSNull class]] || email != NULL || email != nil))
    {
        ValidateForEmailViewController *validateForEmailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"validateForEmailViewController"];
        [self.navigationController pushViewController:validateForEmailViewController animated:YES];
    }
    //只绑定手机没绑定邮箱,进入手机安全验证界面
    else if((phone.length != 0 || ![phone isKindOfClass:[NSNull class]] || phone != NULL || phone != nil) && (email.length == 0 || [email isKindOfClass:[NSNull class]] || email == NULL || email == nil))
    {
        ValidateForPhoneViewController *validateForPhoneViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"validateForPhoneViewController"];
        [self.navigationController pushViewController:validateForPhoneViewController animated:YES];
    }
    //同时绑定了手机和邮箱进入找回密码界面
    else
    {
        FindBackSec_SecondViewController *second = [self.storyboard instantiateViewControllerWithIdentifier:@"findBackSec_SecondViewController"];
        second.myPhone = phone;
        second.myEmail = email;
        second.isMobileOrEmail = YES;
        [self.navigationController pushViewController:second animated:YES];
    }

}

- (void) tap:(UITapGestureRecognizer *) sender
{
    [_tf_confirm resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _tf_confirm)
    {
        [_tf_confirm resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
