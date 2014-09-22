//
//  RegisterViewController.m
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-9.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import "RegisterViewController.h"
#import "DCFTopLabel.h"
#import "DCFStringUtil.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    // Do any additional setup after loading the view.
    
    
    DCFTopLabel *TOP = [[DCFTopLabel alloc] initWithTitle:@"电缆买卖宝注册"];
    self.navigationItem.titleView = TOP;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    [_tf_account resignFirstResponder];
    [_tf_sec resignFirstResponder];
    [_tf_confirm resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _tf_account)
    {
        [_tf_confirm resignFirstResponder];
        [_tf_sec resignFirstResponder];
    }
    if(textField == _tf_sec)
    {
        [_tf_account resignFirstResponder];
        [_tf_confirm resignFirstResponder];
    }
    if(textField == _tf_confirm)
    {
        [_tf_account resignFirstResponder];
        [_tf_sec resignFirstResponder];
    }
    return YES;
}


- (IBAction)registerBtnClick:(id)sender
{
    [_tf_account resignFirstResponder];
    [_tf_sec resignFirstResponder];
    [_tf_confirm resignFirstResponder];
    
    if(_tf_account.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入账号"];
        return;
    }
    if(_tf_sec.text.length == 0 || _tf_confirm.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入密码"];
        return;
    }
    if(![_tf_sec.text isEqualToString:_tf_confirm.text])
    {
        [DCFStringUtil showNotice:@"输入密码不一致,请检查"];
        return;
    }
    NSLog(@"注册");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
