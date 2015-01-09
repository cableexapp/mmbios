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
#import "MCdes.h"
#import "DCFCustomExtra.h"
#import "MCDefine.h"
#import "DCFStringUtil.h"
#import "AppDelegate.h"
#import "FindBackSec_FirstViewController.h"

@interface LoginViewController ()
{
    DCFTopLabel *top;
    AppDelegate *app;
    
    NSDictionary *regiserDic;
    
    BOOL logInSuccess;
    
    NSString *loginid;
}
@end

@implementation LoginViewController

@synthesize xmppStream;

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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    regiserDic = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"regiserDic"]];
    if([[regiserDic allKeys] count] == 0 || [regiserDic isKindOfClass:[NSNull class]])
    {
        
    }
    else
    {
        NSString *account = [regiserDic objectForKey:@"registerAccount"];
        NSString *secrect = [regiserDic objectForKey:@"registerSecrect"];
        [self.tf_Account setText:account];
        [self.tf_Secrect setText:secrect];
        
        [self logWithAccount:account WithSec:secrect];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(app.speedRegister == YES)
    {
        RegisterViewController *regist = [self.storyboard instantiateViewControllerWithIdentifier:@"registerViewController"];
        [self.navigationController pushViewController:regist animated:NO];
    }
    
    
    logInSuccess = NO;
    
    
    [self pushAndPopStyle];
    
    top = [[DCFTopLabel alloc] initWithTitle:@"用户登录"];
    self.navigationItem.titleView = top;
    
    UIImageView *titleImageView = [[UIImageView alloc] init];
    titleImageView.frame = CGRectMake((ScreenWidth-176)/2, 20, 176, 50);
    titleImageView.image = [UIImage imageNamed:@"mmb"];
    [self.view addSubview:titleImageView];
    
    _tf_BackView.layer.borderWidth = 1.0f;
    _tf_BackView.layer.cornerRadius = 5;
    _tf_BackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tf_BackView.frame = CGRectMake(20, 100, ScreenWidth-40, 101);
    _tf_BackView.layer.masksToBounds = YES;
    
    [_tf_Account setReturnKeyType:UIReturnKeyNext];
    _tf_Account.tintColor = [UIColor colorWithRed:9/255.0 green:99/255.0 blue:189/255.0 alpha:1.0];
    _tf_Account.frame = CGRectMake(20, 0, ScreenWidth-40, 50);
    [_tf_Account setReturnKeyType:UIReturnKeyNext];
    _tf_Account.text = @"竹海";
    _tf_Secrect.text = @"sal123";
    _tf_Secrect.frame = CGRectMake(20, 51, ScreenWidth-40, 50);
    _tf_Secrect.tintColor = [UIColor colorWithRed:9/255.0 green:99/255.0 blue:189/255.0 alpha:1.0];
    
    
    [_tf_Secrect setReturnKeyType:UIReturnKeyDone];
    
    self.loginBtn.frame =CGRectMake(20, 240, ScreenWidth-40, 43);
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.layer.cornerRadius = 5.0f;
    self.loginBtn.backgroundColor = [UIColor colorWithRed:9/255.0 green:99/255.0 blue:189/255.0 alpha:1.0];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [forgetBtn setFrame:CGRectMake(ScreenWidth-93, 255, 80, 30)];
    [forgetBtn setTitleColor:MYCOLOR forState:UIControlStateNormal];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registerBtn setFrame:CGRectMake(ScreenWidth-170, 255, 80, 30)];
    [registerBtn setTitleColor:MYCOLOR forState:UIControlStateNormal];
    [registerBtn setTitle:@"用户注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 23);
    //    [btn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = left;
    
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
                 _tf_Account.placeholder = @"用户名/手机号码";
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
}

- (void) cancelBtnClick:(UIButton *) sender
{
    [self dismissCurrentView];
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

//登录
- (IBAction)loginBtnClick:(id)sender
{
    [self logWithAccount:self.tf_Account.text WithSec:self.tf_Secrect.text];
}

- (void) logWithAccount:(NSString *) acc WithSec:(NSString *) sec
{
    if([self.tf_Account isFirstResponder])
    {
        [self.tf_Account resignFirstResponder];
    }
    if([self.tf_Secrect isFirstResponder])
    {
        [self.tf_Secrect resignFirstResponder];
    }
    
    if([DCFCustomExtra validateString:acc] == NO)
    {
        [DCFStringUtil showNotice:@"请输入账号"];
        return;
    }
    if([DCFCustomExtra validateString:sec] == NO)
    {
        [DCFStringUtil showNotice:@"请输入密码"];
        return;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setDelegate:self];
    [HUD setLabelText:@"正在登录....."];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"UserLogin",time];
    
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/UserLogin.html?"];
    NSString *des = [MCdes encryptUseDES:sec key:@"cableex_app*#!Key"];
    
    if([DCFCustomExtra validateString:app.baiduPushUserId] == NO)
    {
        app.baiduPushUserId = @"";
    }
    if([DCFCustomExtra validateString:app.channelId] == NO)
    {
        app.channelId = @"";
    }
    
    NSString *pushString = [NSString stringWithFormat:@"username=%@&password=%@&token=%@&visitorid=%@&userid=%@&channelid=%@&devicetype=%@",acc,des,token,[app getUdid],app.baiduPushUserId,app.channelId,@"4"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLLoginTag delegate:self];
    conn.LogIn = YES;
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLLoginTag)
    {
        if(HUD)
        {
            [HUD hide:YES];
        }
        if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            [DCFStringUtil showNotice:@"登录失败"];
            logInSuccess = NO;
            return;
        }
        int reslut = [[dicRespon objectForKey:@"result"] intValue];
        NSString *msg = [dicRespon objectForKey:@"msg"];
        if(reslut == 0)
        {
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"您输入的密码和账户名不匹配，请重新输入"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
            logInSuccess = NO;
        }
        else
        {
            [DCFStringUtil showNotice:@"登录成功"];
            
            logInSuccess = YES;
            
            //切换登录账号，结束之前对话
            [app goOffline];
            [[NSUserDefaults standardUserDefaults] setObject:self.tf_Account.text forKey:@"userName_IM"];
            [app registerInSide];
            [app disconnect];
            [app reConnect];
            app.isConnect = @"断开";
            
            [[NSUserDefaults standardUserDefaults] setObject:self.tf_Account.text forKey:@"app_username"];
            
            NSDictionary *iems = [NSDictionary dictionaryWithDictionary:[dicRespon objectForKey:@"items"]];
            
            NSString *memberId = [NSString stringWithFormat:@"%@",[iems objectForKey:@"memberId"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:memberId forKey:@"memberId"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLogin"];
           
#pragma mark - UTF8编码
//            NSString *userName = [self.tf_Account.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults] setObject:self.tf_Account.text forKey:@"userName"];
            
            
            NSString *phone = [NSString stringWithFormat:@"%@",[iems objectForKey:@"phone"]];
            [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"UserPhone"];
            
            NSString *email = [NSString stringWithFormat:@"%@",[iems objectForKey:@"email"]];
            [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"UserEmail"];
            
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.tf_Account.text,@"registerAccount",self.tf_Secrect.text,@"registerSecrect", nil];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"regiserDic"];
            
            NSString *headPortraitUrl = [NSString stringWithFormat:@"%@%@%@",URL_HOST_CHEN,@"/",[iems objectForKey:@"ext2"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:headPortraitUrl forKey:@"headPortraitUrl"];
            
            loginid = [NSString stringWithFormat:@"%@",[iems objectForKey:@"ext3"]];
            [[NSUserDefaults standardUserDefaults] setObject:loginid forKey:@"loginid"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self dismissCurrentView];
        }
    }
}

- (void) dismissCurrentView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFourthNaviRootViewController" object:[NSNumber numberWithBool:logInSuccess]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)forgetBtnClick:(UIButton *)sender
{    
    FindBackSec_FirstViewController *findBackSec_FirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"findBackSec_FirstViewController"];
    [self.navigationController pushViewController:findBackSec_FirstViewController animated:YES];
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
    
    [_tf_Secrect becomeFirstResponder];
    
    if(textField == _tf_Secrect)
    {
        [self logWithAccount:self.tf_Account.text WithSec:self.tf_Secrect.text];
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
}

@end
