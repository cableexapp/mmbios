//
//  AddBangDingMobileViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-16.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "AddBangDingMobileViewController.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "LoginNaviViewController.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"
#import "ModifyBangDingMobileSuccessViewController.h"

@interface AddBangDingMobileViewController ()
{
    NSString *code;
    NSTimer *timer_tel;
    int timeCount_tel;
}
@end

@implementation AddBangDingMobileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    timeCount_tel = 60;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
    
    if(timer_tel)
    {
        [timer_tel invalidate];
        timer_tel = nil;
    }
    [self.validateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    timeCount_tel = 60;
    
    
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if([self.teltf isFirstResponder])
    {
        [self.teltf resignFirstResponder];
    }
    if([self.validateTf isFirstResponder])
    {
        [self.validateTf resignFirstResponder];
    }
    
    if(textField == self.teltf)
    {
        if([DCFCustomExtra validateMobile:self.teltf.text] == NO)
        {
            [DCFStringUtil showNotice:@"请输入正确的手机号码"];
        }
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"修改/新增绑定手机"];
    self.navigationItem.titleView = top;
    
    
    self.validateBtn.layer.borderColor = MYCOLOR.CGColor;
    self.validateBtn.layer.borderWidth = 1.0f;
    self.validateBtn.layer.cornerRadius = 5.0f;
    
    
    self.upBtn.layer.borderColor = MYCOLOR.CGColor;
    self.upBtn.layer.borderWidth = 1.0f;
    self.upBtn.layer.cornerRadius = 5.0f;
    
    [self.teltf setDelegate:self];
    [self.validateTf setDelegate:self];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLSendMsgTag)
    {
        [self.validateBtn setUserInteractionEnabled:YES];
        [self.validateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        if(timer_tel)
        {
            [timer_tel invalidate];
            timer_tel = nil;
            timeCount_tel = 60;
        }
        

        
        if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            [DCFStringUtil showNotice:@"获取失败"];
        }
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            
        }
        else
        {
            if(msg.length == 0 || [msg isKindOfClass:[NSNull class]])
            {
                [DCFStringUtil showNotice:@"获取失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }

    
    if(URLTag == URLChangeBindPhoneTag)
    {
        if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            [DCFStringUtil showNotice:@"修改绑定手机失败"];
        }
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            ModifyBangDingMobileSuccessViewController *modifyBangDingMobileSuccessViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"modifyBangDingMobileSuccessViewController"];
            [self.navigationController pushViewController:modifyBangDingMobileSuccessViewController animated:YES];
        }
        else
        {
            if(msg.length == 0 || [msg isKindOfClass:[NSNull class]])
            {
                [DCFStringUtil showNotice:@"修改绑定手机失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
    NSLog(@"%@",dicRespon);
}

- (IBAction)validateBtnClick:(id)sender
{
    if(self.teltf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入绑定手机"];
        return;
    }
    [self.teltf resignFirstResponder];
    [self.validateTf resignFirstResponder];
    
    timer_tel = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    [timer_tel fire];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"sendMessage",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"phone=%@&token=%@&username=%@",self.teltf.text,token,[self getUserName]];
    NSLog(@"push = %@",pushString);
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSendMsgTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/sendMessage.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) timer:(NSTimer *) sender
{
    if(timeCount_tel == 0)
    {
        [self.validateBtn setUserInteractionEnabled:YES];
        [self.validateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [timer_tel invalidate];
        timer_tel = nil;
        timeCount_tel = 60;
    }
    else
    {
        timeCount_tel = timeCount_tel - 1;
        if(timeCount_tel == 0)
        {
            [self.validateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
        else
        {
            NSString *timeString = [NSString stringWithFormat:@"剩余%d秒",timeCount_tel];
            [self.validateBtn setTitle:timeString forState:UIControlStateNormal];
        }
        [self.validateBtn setUserInteractionEnabled:NO];
        
    }
}

- (NSString *) getUserName
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    if(userName.length == 0)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
    }
    return userName;
    
}

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    if(memberid.length == 0 || [memberid isKindOfClass:[NSNull class]])
    {
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}

- (IBAction)upbtnClick:(id)sender
{
    [self.teltf resignFirstResponder];
    [self.validateTf resignFirstResponder];
    
    if(self.validateTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入验证码"];
        return;
    }
    if(self.teltf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入绑定手机"];
        return;
    }

        if([DCFCustomExtra validateMobile:self.teltf.text] == NO)
        {
            [DCFStringUtil showNotice:@"请输入正确的手机号码"];
            return;
        }

    if(![self.validateTf.text isEqualToString:code])
    {
        [DCFStringUtil showNotice:@"请输入正确的验证码"];
        return;
    }
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"ChangeBindPhone",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&phone=%@",[self getMemberId],token,self.teltf.text];
    NSLog(@"push = %@",pushString);
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLChangeBindPhoneTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/ChangeBindPhone.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
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
