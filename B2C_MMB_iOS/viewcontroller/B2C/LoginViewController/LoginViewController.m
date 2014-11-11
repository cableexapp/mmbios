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
#import "DCFStringUtil.h"
#import "AppDelegate.h"

@interface LoginViewController ()
{
    DCFTopLabel *top;
    AppDelegate *app;
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

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(HUD)
    {
        [HUD hide:YES];
    }
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
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
    [registerBtn setTitleColor:MYCOLOR forState:UIControlStateNormal];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.layer.borderColor = MYCOLOR.CGColor;
    registerBtn.layer.borderWidth = 1.0f;
    registerBtn.layer.cornerRadius = 5.0f;
    registerBtn.layer.masksToBounds = 1.0f;
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:registerBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelBtn setFrame:CGRectMake(0, 5, 40, 30)];
    [cancelBtn setTitleColor:MYCOLOR forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = MYCOLOR.CGColor;
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
    
//    cableex

    [self log];
}

- (void) log
{
    [self.tf_Account resignFirstResponder];
    [self.tf_Secrect resignFirstResponder];
    
    if(self.tf_Account.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入账号"];
        return;
    }
    if(self.tf_Secrect.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入密码"];
        return;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setDelegate:self];
    [HUD setLabelText:@"正在登陆....."];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"UserLogin",time];
    
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/UserLogin.html?"];
    NSString *des = [MCdes encryptUseDES:self.tf_Secrect.text key:@"cableex_app*#!Key"];
    
    NSString *pushString = [NSString stringWithFormat:@"username=%@&password=%@&token=%@&visitorid=%@",self.tf_Account.text,des,token,[app getUdid]];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLLoginTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{

    if(URLTag == URLLoginTag)
    {
        [HUD hide:YES];
        
        int reslut = [[dicRespon objectForKey:@"result"] intValue];
        NSString *msg = [dicRespon objectForKey:@"msg"];
        if(reslut == 0)
        {
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"登录失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
        else
        {
            NSString *memberId = [NSString stringWithFormat:@"%@",[dicRespon objectForKey:@"value"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:memberId forKey:@"memberId"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLogin"];
            [[NSUserDefaults standardUserDefaults] setObject:self.tf_Account.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (IBAction)forgetBtnClick:(id)sender
{
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
//    [textField resignFirstResponder];

    if(textField == _tf_Secrect)
    {
        [self log];
    }
    return YES;
}

- (void) hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
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
