//
//  LoginViewController.m
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-8-29.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "RegisterViewController.h"
#import "MCdes.h"
#import "DCFCustomExtra.h"
#import "MCDefine.h"

@interface LoginViewController ()
{
    DCFTopLabel *top;
}
@end

@implementation LoginViewController

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
    
    [self pushAndPopStyle];
    
    top = [[DCFTopLabel alloc] initWithTitle:@"电缆买卖宝登录"];
    self.navigationItem.titleView = top;
    
    
    _tf_BackView.layer.borderWidth = 1.0f;
    _tf_BackView.layer.borderColor = [UIColor grayColor].CGColor;
    _tf_BackView.layer.masksToBounds = YES;
    
    [_tf_Account setReturnKeyType:UIReturnKeyNext];
    [_tf_Secrect setReturnKeyType:UIReturnKeyDone];
    
    for(int i = 0; i < 2; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor blackColor]];
        [label setFont:[UIFont systemFontOfSize:15]];
        switch (i) {
            case 0:
                [label setText:@"账 号"];
                [_tf_Account setLeftView:label];
                [_tf_Account setLeftViewMode:UITextFieldViewModeAlways];
                break;
            case 1:
                [label setText:@"密 码"];
                [_tf_Secrect setLeftView:label];
                [_tf_Secrect setLeftViewMode:UITextFieldViewModeAlways];
                break;
            default:
                break;
        }
    }
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    [self.forgetBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
    
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registerBtn setFrame:CGRectMake(0, 5, 40, 30)];
    [registerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.layer.borderColor = [UIColor blueColor].CGColor;
    registerBtn.layer.borderWidth = 1.0f;
    registerBtn.layer.cornerRadius = 5.0f;
    registerBtn.layer.masksToBounds = 1.0f;
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:registerBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelBtn setFrame:CGRectMake(0, 5, 40, 30)];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = [UIColor blueColor].CGColor;
    cancelBtn.layer.borderWidth = 1.0f;
    cancelBtn.layer.cornerRadius = 5.0f;
    cancelBtn.layer.masksToBounds = 1.0f;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = left;
    
    self.loginBtn.layer.cornerRadius = 5.0f;
    
}

- (void) cancelBtnClick:(UIButton *) sender
{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) registerBtnClick:(UIButton *) sender
{
    RegisterViewController *regist = [self.storyboard instantiateViewControllerWithIdentifier:@"registerViewController"];
    [self.navigationController pushViewController:regist animated:YES];
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    if([_tf_Secrect isFirstResponder])
    {
        [_tf_Secrect resignFirstResponder];
//        [_tf_Account becomeFirstResponder];
    }
    if([_tf_Account isFirstResponder])
    {
        [_tf_Account resignFirstResponder];
//        [_tf_Secrect becomeFirstResponder];
    }

}

- (IBAction)loginBtnClick:(id)sender
{
    NSLog(@"登陆");
    
//    cableex
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"UserLogin",time];
    
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/UserLogin.html?"];
    NSString *des = [MCdes encryptUseDES:@"123456" key:@"cableex_app*#!Key"];
    
    NSString *pushString = [NSString stringWithFormat:@"username=%@&password=%@&token=%@",@"chenxiao",des,token];

    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLLoginTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLLoginTag)
    {
        NSLog(@"%@",dicRespon);
    }
}

- (IBAction)forgetBtnClick:(id)sender
{
    NSLog(@"忘记密码");
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == _tf_Account)
    {
        if([_tf_Secrect isFirstResponder])
        {
            [_tf_Secrect resignFirstResponder];
        }
        [_tf_Account becomeFirstResponder];
    }
    if(textField == _tf_Secrect)
    {
        if([_tf_Account isFirstResponder])
        {
            [_tf_Account resignFirstResponder];
        }
        [_tf_Secrect becomeFirstResponder];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == _tf_Secrect)
    {
        NSLog(@"去登陆");
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
