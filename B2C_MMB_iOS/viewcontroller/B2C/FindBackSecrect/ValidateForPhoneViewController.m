//
//  ValidateForPhoneViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-20.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "ValidateForPhoneViewController.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "LoginNaviViewController.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"
#import "FindBack_ThirdViewController.h"

@interface ValidateForPhoneViewController ()
{
    NSTimer *timer_tel;
    int timeCount_tel;
    NSString *code;
    NSString *phone;
}
@end

@implementation ValidateForPhoneViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"安全验证"];
    self.navigationItem.titleView = top;
    
    phone = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserPhone"]];
    NSString *s1 = [phone substringToIndex:3];
    
    NSString *s2 = [phone substringFromIndex:7];
    
    NSString *s3 = @"****";
    NSString *tel = [NSString stringWithFormat:@"%@%@%@",s1,s3,s2];
    [self.numberLabel setText:[NSString stringWithFormat:@"%@",tel]];
    
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.backView.layer.cornerRadius = 5;
    
    self.validateBtn.layer.cornerRadius = 5.0f;
    self.telTf.layer.borderColor = [UIColor whiteColor].CGColor;
    self.telTf.layer.borderWidth = 1.0f;

    self.validateBtn.layer.cornerRadius = 5.0f;
    

    self.buttomBtn.layer.cornerRadius = 5.0f;
    
    [self.telTf setDelegate:self];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.telTf resignFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    [UIView commitAnimations];
    
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    if(ScreenHeight < 500)
    {

        [self.view setFrame:CGRectMake(0, -20, ScreenWidth, ScreenHeight)];
    }
    else
    {
//        [self.view setFrame:CGRectMake(0, -64, ScreenWidth, ScreenHeight)];
    }
    [UIView commitAnimations];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLSendMsgTag)
    {
//        [self.validateBtn setUserInteractionEnabled:YES];
//        [self.validateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//        if(timer_tel)
//        {
//            [timer_tel invalidate];
//            timer_tel = nil;
//            timeCount_tel = 60;
//        }
        
        
        
        if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            [DCFStringUtil showNotice:@"获取失败"];
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
}

- (IBAction)validateBtnClick:(id)sender
{
    timer_tel = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    [timer_tel fire];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"sendMessage",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"phone=%@&token=%@&username=%@",phone,token,[self getUserName]];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSendMsgTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/sendMessage.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (IBAction)buttomBtnClick:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    [UIView commitAnimations];
    
    [self.telTf resignFirstResponder];
    
    if(self.telTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入验证码"];
        return;
    }
#pragma mark - 验证码暂时写死
    if(![self.telTf.text isEqualToString:code])
    {
        [DCFStringUtil showNotice:@"请输入正确的验证码"];
        return;
    }
    
    [self.telTf resignFirstResponder];
    
    
    FindBack_ThirdViewController *findBack_ThirdViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"findBack_ThirdViewController"];
    [self.navigationController pushViewController:findBack_ThirdViewController animated:YES];

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
    userName = [DCFCustomExtra UTF8Encoding:userName];

    if([DCFCustomExtra validateString:userName] == NO)
    {
        userName = @"";
    }
    return userName;
    
}

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if([DCFCustomExtra validateString:memberid] == NO)
    {
        memberid = @"";
    }
    return memberid;
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
