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
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor colorWithRed:21.0/255.0 green:100.0/255.0 blue:249.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [nextBtn setFrame:CGRectMake(100, 0, 50, 30)];
    [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
    self.navigationItem.rightBarButtonItem = right;
    
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

- (void) next:(UIButton *) sender
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
    
    [self push];
//    for(int i = 0;i < string.length; i++)
//    {
//        char c = [string characterAtIndex:i];
//        if(c == '@')
//        {
//            NSLog(@"是邮箱");
//            
//            if([DCFCustomExtra isValidateEmail:string] == 0)
//            {
//                [DCFStringUtil showNotice:@"请输入正确的邮箱"];
//                return;
//            }
//            else
//            {
//                [self push];
//            }
//        }
//   
//    }
//    
//    if(string.length <= 10 || string.length >= 12)
//    {
//        if([self isAllNum:string] == 1)
//        {
//            [DCFStringUtil showNotice:@"用户名不能为纯数字"];
//            return;
//        }
//        else
//        {
//            [self push];
//        }
//   
//    }
//    else if (string.length == 11)
//    {
//        if([DCFCustomExtra validateMobile:string] == 0)
//        {
//            [DCFStringUtil showNotice:@"请输入正确的手机号码"];
//            return;
//        }
//        else
//        {
//            [self push];
//        }
//    }
}


- (void) push
{
    FindBackSec_SecondViewController *second = [self.storyboard instantiateViewControllerWithIdentifier:@"findBackSec_SecondViewController"];
    [self.navigationController pushViewController:second animated:YES];
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
