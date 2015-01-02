//
//  ValidateForEmailViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-20.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "ValidateForEmailViewController.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "LoginNaviViewController.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"
#import "FindBack_ThirdViewController.h"

@interface ValidateForEmailViewController ()
{
    NSTimer *timer_tel;
    int timeCount_tel;
    NSString *email;
}
@end

@implementation ValidateForEmailViewController

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
    [self.validateBtn setTitle:@"获取验证邮件" forState:UIControlStateNormal];
    timeCount_tel = 60;  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"安全验证"];
    self.navigationItem.titleView = top;
    
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.backView.layer.cornerRadius = 5;
    
    self.validateBtn.layer.borderColor = MYCOLOR.CGColor;
    self.validateBtn.layer.borderWidth = 1.0f;
    self.validateBtn.layer.cornerRadius = 5.0f;
    
    email = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmail"]];
    NSString *emailStr = nil;
    for(int i=0;i<email.length;i++)
    {
        char c = [email characterAtIndex:i];
        if(c == '@')
        {
            NSString *s1 = [email substringToIndex:1];
            
            NSRange range = NSMakeRange(1, i-2);
            NSString *s2 = [email substringWithRange:range];
            
            NSMutableString *starString = [[NSMutableString alloc] init];
            for(int j=0;j<s2.length;j++)
            {
                [starString appendString:@"*"];
            }
            
            
            NSRange range_2 = NSMakeRange(i-1, email.length-i+1);
            NSString *s3 = [email substringWithRange:range_2];
            
            emailStr = [NSString stringWithFormat:@"%@%@%@",s1,starString,s3];
            [self.numberLabel setText:emailStr];
            break;
        }
        else
        {
            
        }
    }


    NSString *str  = [NSString stringWithFormat:@"您的邮箱%@已经收到一份账号绑定确认邮件,请在24小时内去你的邮箱查收并按照邮件提示进行操作,完成绑定",emailStr];
    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:str WithSize:CGSizeMake(ScreenWidth-40, MAXFLOAT)];
    [self.buttomLabel setFont:[UIFont systemFontOfSize:14]];
    [self.buttomLabel setText:str];
    [self.buttomLabel setNumberOfLines:0];
    [self.buttomLabel setFrame:CGRectMake(self.buttomLabel.frame.origin.x, self.buttomLabel.frame.origin.y, ScreenWidth-40, size.height+60)];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    [self.validateBtn setUserInteractionEnabled:YES];
    [self.validateBtn setTitle:@"获取验证邮件" forState:UIControlStateNormal];
    if(timer_tel)
    {
        [timer_tel invalidate];
        timer_tel = nil;
        timeCount_tel = 60;
    }
    
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
    {
        [DCFStringUtil showNotice:@"获取失败"];
        return;
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
    
    
    NSLog(@"%@",dicRespon);
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

- (IBAction)validateBtnClick:(id)sender
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"sendEmail",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&username=%@&email=%@",[self getMemberId],token,[self getUserName],email];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSendEmailTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/sendEmail.html?"];
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
