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
#import "DCFCustomExtra.h"
#import "MCdes.h"
#import "MCDefine.h"

@interface RegisterViewController ()
{
    DCFConnectionUtil *conn;
}
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

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
    if(HUD)
    {
        [HUD hide:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    DCFTopLabel *TOP = [[DCFTopLabel alloc] initWithTitle:@"电缆买卖宝注册"];
    self.navigationItem.titleView = TOP;
    
    [self.tf_account setReturnKeyType:UIReturnKeyNext];
    [self.tf_sec setReturnKeyType:UIReturnKeyNext];
    [self.tf_confirm setReturnKeyType:UIReturnKeyDone];
    
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
    [self.tf_account resignFirstResponder];
    [self.tf_sec resignFirstResponder];
    [self.tf_confirm resignFirstResponder];
    

    if(textField == self.tf_confirm)
    {
        [self regester];
    }
    return YES;
}

- (void) regester
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
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setDelegate:self];
    [HUD setLabelText:@"正在注册....."];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"UserRegister",time];
    
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/UserRegister.html?"];
    NSString *des = [MCdes encryptUseDES:self.tf_sec.text key:@"cableex_app*#!Key"];
    
    NSString *pushString = [NSString stringWithFormat:@"username=%@&password=%@&token=%@",self.tf_account.text,des,token];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLRegesterTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLRegesterTag)
    {
        [HUD hide:YES];
        int result = [[dicRespon objectForKey:@"result"] intValue];
        NSString *msg = [dicRespon objectForKey:@"msg"];
        if(result == 0)
        {
            [DCFStringUtil showNotice:msg];
        }
        else if (result == 1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)registerBtnClick:(id)sender
{
    [self regester];
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


@end
