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
    int currentPageIndex;
    
    int timeCount_tel;     //倒计时
    
    BOOL phoneOrUserName;  //判断用户用手机注册还是用户名注册
    
    NSString *code;
    NSTimer *timer_tel;
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
    
    if(timer_tel)
    {
        [timer_tel invalidate];
        timer_tel = nil;
    }
    [self.getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    timeCount_tel = 60;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    timeCount_tel = 60;
    
    phoneOrUserName = NO;
    [self checkStatus];
}

#pragma mark - 监测注册状态(手机还是用户名)
- (void) checkStatus
{
    if(phoneOrUserName == YES)
    {
        [self.sureSecLabel setText:@"验证码"];
        [self.getValidateBtn setHidden:NO];
        [self.sureSecTf setFrame:CGRectMake(self.sureSecTf.frame.origin.x, self.sureSecTf.frame.origin.y, self.subView.frame.size.width-20-self.sureSecLabel.frame.size.width, self.sureSecTf.frame.size.height)];
    }
    else
    {
        [self.sureSecLabel setText:@"确认密码"];
        [self.getValidateBtn setHidden:YES];
        [self.sureSecTf setFrame:CGRectMake(self.sureSecTf.frame.origin.x, self.sureSecTf.frame.origin.y, self.subView.frame.size.width-20, self.sureSecTf.frame.size.height)];
    }
}

- (IBAction)getValidateBtnClick:(id)sender
{
    if([self.userTf isFirstResponder])
    {
        [self.userTf resignFirstResponder];
    }
    if([self.sureSecTf isFirstResponder])
    {
        [self.sureSecTf resignFirstResponder];
    }
    if([self.secTf isFirstResponder])
    {
        [self.secTf resignFirstResponder];
    }
    
    
    timer_tel = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    [timer_tel fire];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"sendMessage",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"phone=%@&token=%@&username=%@",self.userTf.text,token,self.userTf.text];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSendMsgTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/sendMessage.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) timer:(NSTimer *) sender
{
    if(timeCount_tel == 0)
    {
        [self.getValidateBtn setUserInteractionEnabled:YES];
        [self.getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [timer_tel invalidate];
        timer_tel = nil;
        timeCount_tel = 60;
    }
    else
    {
        timeCount_tel = timeCount_tel - 1;
        if(timeCount_tel == 0)
        {
            [self.getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
        else
        {
            NSString *timeString = [NSString stringWithFormat:@"剩余%d秒",timeCount_tel];
            [self.getValidateBtn setTitle:timeString forState:UIControlStateNormal];
        }
        [self.getValidateBtn setUserInteractionEnabled:NO];
        
    }
}


- (IBAction)agreeBtnClick:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    DCFTopLabel *TOP = [[DCFTopLabel alloc] initWithTitle:@"电缆买卖宝注册"];
    self.navigationItem.titleView = TOP;
    
    self.regesterBtn.layer.cornerRadius = 5.0f;
    
    [self.sv setContentSize:CGSizeMake(ScreenWidth-50, self.sv.frame.size.height-200)];
    [self.sv setDelegate:self];
    [self.sv setPagingEnabled:YES];
    [self.sv setBounces:NO];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    [self.agreeBtn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
    [self.agreeBtn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
    
}




- (void) tap:(UITapGestureRecognizer *) sender
{
    if([self.userTf isFirstResponder])
    {
        [self.userTf resignFirstResponder];
    }
    if([self.sureSecTf isFirstResponder])
    {
        [self.sureSecTf resignFirstResponder];
    }
    if([self.secTf isFirstResponder])
    {
        [self.secTf resignFirstResponder];
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.secTf || textField == self.sureSecTf)
    {
        if([DCFCustomExtra validateMobile:self.userTf.text] == YES)
        {
            phoneOrUserName = YES;
        }
        else
        {
            phoneOrUserName = NO;
        }
        [self checkStatus];
    }
}

- (BOOL) checkUseAndSec:(UITextField *) sender
{
    if(sender == self.userTf)
    {
        if([DCFCustomExtra validateMobile:self.userTf.text] == YES)
        {
            phoneOrUserName = YES;
        }
        else
        {
            phoneOrUserName = NO;
        }
        if(self.userTf.text.length < 4)
        {
            [DCFStringUtil showNotice:@"用户名长度不能小于4位"];
            return NO;
        }
        if(self.userTf.text.length > 30)
        {
            [DCFStringUtil showNotice:@"用户名长度不能大于30位"];
            return NO;
        }
        
#pragma mark - 只含有汉字、数字、字母、下划线，下划线位置不限：
        NSString * regex_1 = @"^[a-zA-Z0-9_\u4e00-\u9fa5]{4,30}$";
        NSPredicate *pred_1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_1];
        BOOL isMatch_1 = [pred_1 evaluateWithObject:self.userTf.text];
        if(isMatch_1 == NO)
        {
            [DCFStringUtil showNotice:@"用户名只支持数字、字母、下划线、中文"];
            return NO;
        }
        
        NSString *allChinese_1 = @"^[\u4E00-\u9FA5]*$";
        NSPredicate *predallChinese_1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allChinese_1];
        BOOL isMatchAllChinese_1 = [predallChinese_1 evaluateWithObject:self.userTf.text];
        if(isMatchAllChinese_1 == YES)
        {
            [DCFStringUtil showNotice:@"用户名不能是纯中文"];
            return NO;
        }
        else
        {
        }
        
        
        if([self isAllNum:self.userTf.text] == YES && phoneOrUserName == NO)
        {
            [DCFStringUtil showNotice:@"用户名不能是纯数字"];
            return NO;
        }
        
        if([self PureLetters:self.userTf.text] == YES)
        {
            [DCFStringUtil showNotice:@"用户名不能是纯字母"];
            return NO;
        }
        
        int n=0;
        for(int i=0;i<self.userTf.text.length;i++)
        {
            char c = [self.userTf.text characterAtIndex:i];
            if(c == '_')
            {
                n++;
            }
        }
        if(n == self.userTf.text.length && self.userTf.text.length != 0)
        {
            [DCFStringUtil showNotice:@"用户名不能是纯字符"];
            return NO;
        }
        
        [self checkStatus];
    }
    if(sender == self.secTf)
    {
        int m=0;
        for(int i=0;i<self.secTf.text.length;i++)
        {
            char c = [self.secTf.text characterAtIndex:i];
            if(c == '_')
            {
                m++;
            }
        }
        if(m == self.secTf.text.length && self.secTf.text.length != 0)
        {
            [DCFStringUtil showNotice:@"密码不能是纯字符"];
            return NO;
        }
        
        
        NSString *allChinese_2 = @"^[\u4E00-\u9FA5]$";
        NSPredicate *predallChinese_2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allChinese_2];
        BOOL isMatchAllChinese_2 = [predallChinese_2 evaluateWithObject:self.secTf.text];
        if(isMatchAllChinese_2 == YES)
        {
            [DCFStringUtil showNotice:@"密码不能是纯中文"];
            return NO;
        }
        
        
        if(self.secTf.text.length == 0)
        {
            [DCFStringUtil showNotice:@"密码长度不能为空"];
            return NO;
        }
        
        if(self.secTf.text.length < 6)
        {
            [DCFStringUtil showNotice:@"密码长度不能小于6位"];
            return NO;
        }
        if(self.secTf.text.length > 18)
        {
            [DCFStringUtil showNotice:@"密码长度不能大于18位"];
            return NO;
        }
        
        NSString * regex_2 = @"^[A-Za-z0-9_]{6,18}$";
        NSPredicate *pred_2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_2];
        BOOL isMatch_2 = [pred_2 evaluateWithObject:self.secTf.text];
        if(isMatch_2 == NO)
        {
            [DCFStringUtil showNotice:@"密码只能是数字字母下划线"];
            return NO;
        }
        if([self isAllNum:self.secTf.text] == YES)
        {
            [DCFStringUtil showNotice:@"密码不能是纯数字"];
            return NO;
        }
        
        if([self PureLetters:self.secTf.text] == YES)
        {
            [DCFStringUtil showNotice:@"密码不能是纯字母"];
            return NO;
        }
        
    }
    
    
    return YES;
    //    }
    
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self checkUseAndSec:textField];
}

#pragma mark - 纯字母
-(BOOL)PureLetters:(NSString*)str
{
    
    for(int i=0;i<str.length;i++){
        
        unichar c=[str characterAtIndex:i];
        
        if((c<'A'||c>'Z')&&(c<'a'||c>'z'))
            
            return NO;
        
    }
    
    return YES;
    
}

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

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.userTf)
    {
        [self.userTf resignFirstResponder];
        
        //校验是否是手机注册
        if([DCFCustomExtra validateMobile:self.userTf.text] == YES)
        {
            phoneOrUserName = YES;
            
            NSString *time = [DCFCustomExtra getFirstRunTime];
            NSString *string = [NSString stringWithFormat:@"%@%@",@"CheckPhone",time];
            NSString *token = [DCFCustomExtra md5:string];
            
            NSString *pushString = [NSString stringWithFormat:@"phone=%@&token=%@",self.userTf.text,token];
            conn = [[DCFConnectionUtil alloc] initWithURLTag:URLCheckPhoneTag delegate:self];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/CheckPhone.html?"];
            [conn getResultFromUrlString:urlString postBody:pushString method:POST];
        }
        else
        {
            phoneOrUserName = NO;
        }
        [self checkStatus];
    }
    if(textField == self.secTf)
    {
        [self.secTf resignFirstResponder];
    }
    
    if(textField == self.sureSecTf)
    {
        [self.sureSecTf resignFirstResponder];
    }
    return YES;
}

- (void) regester
{
    if([self.userTf isFirstResponder])
    {
        [self.userTf resignFirstResponder];
    }
    if([self.sureSecTf isFirstResponder])
    {
        [self.sureSecTf resignFirstResponder];
    }
    if([self.secTf isFirstResponder])
    {
        [self.secTf resignFirstResponder];
    }
    
    if([self checkUseAndSec:self.userTf] == NO)
    {
        return;
    }
    
    if([self checkUseAndSec:self.secTf] == NO)
    {
        return;
    }
    
    if(self.agreeBtn.selected == NO)
    {
        [DCFStringUtil showNotice:@"您确定不同意电缆买卖宝用户注册协议吗"];
        return;
    }
    if(self.userTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入账号"];
        return;
    }
    if(self.secTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入密码"];
        return;
    }
    
    if(self.sureSecTf.text.length == 0 && phoneOrUserName == YES)
    {
        [DCFStringUtil showNotice:@"请输入验证码"];
        return;
    }
    if(self.sureSecTf.text.length == 0 && phoneOrUserName == NO)
    {
        [DCFStringUtil showNotice:@"请确认密码"];
        return;
    }
    if(![self.secTf.text isEqualToString:self.sureSecTf.text] && phoneOrUserName == NO)
    {
        [DCFStringUtil showNotice:@"两次输入的密码不一致,请核对"];
        return;
    }
    
    if(![code isEqualToString:self.sureSecTf.text] && phoneOrUserName == YES)
    {
        [DCFStringUtil showNotice:@"验证码输入不正确,请核对"];
        return;
    }
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setDelegate:self];
    [HUD setLabelText:@"正在注册....."];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = nil;
    NSString *urlString = nil;
    if(phoneOrUserName == YES)
    {
        string = [NSString stringWithFormat:@"%@%@",@"PhoneUserRegister",time];
        urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/PhoneUserRegister.html?"];
    }
    else
    {
        string = [NSString stringWithFormat:@"%@%@",@"UserRegister",time];
        urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/UserRegister.html?"];
    }
    
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *des = [MCdes encryptUseDES:self.secTf.text key:@"cableex_app*#!Key"];
    
    NSString *pushString = [NSString stringWithFormat:@"username=%@&password=%@&token=%@",self.userTf.text,des,token];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLRegesterTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}



- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if(URLTag == URLSendMsgTag)
    {
//        [self.getValidateBtn setUserInteractionEnabled:YES];
//        [self.getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//        if(timer_tel)
//        {
//            [timer_tel invalidate];
//            timer_tel = nil;
//            timeCount_tel = 60;
//        }
        
        
        
        if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            [DCFStringUtil showNotice:@"获取失败"];
            return;
        }
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            code = [NSString stringWithFormat:@"%@",[dicRespon objectForKey:@"code"]];
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
    
    if(URLTag == URLRegesterTag)
    {
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"regiserDic"])
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"regiserDic"];
        }
        NSDictionary *dic = nil;
        
        [HUD hide:YES];
        int result = [[dicRespon objectForKey:@"result"] intValue];
        NSString *msg = [dicRespon objectForKey:@"msg"];
        
        if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            dic = [[NSDictionary alloc] init];
        }
        else
        {
            if(result == 0)
            {
                dic = [[NSDictionary alloc] init];
                if(msg.length == 0)
                {
                    [DCFStringUtil showNotice:@"注册失败"];
                }
                else
                {
                    [DCFStringUtil showNotice:msg];
                }
            }
            else if (result == 1)
            {
                dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.userTf.text,@"registerAccount",self.secTf.text,@"registerSecrect", nil];
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"regiserDic"];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    }
    
    if(URLTag == URLCheckPhoneTag)
    {
        if(result == 0)
        {
            if([DCFCustomExtra validateString:msg] == YES)
            {
                [DCFStringUtil showNotice:msg];
            }
            else
            {
                [DCFStringUtil showNotice:@"此用户已经存在"];
            }
        }
        else
        {
            
        }
    }
}

- (IBAction)registerBtnClick:(id)sender
{
    [self regester];
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    
    if(currentPageIndex == 1)
    {
        
    }
    
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
