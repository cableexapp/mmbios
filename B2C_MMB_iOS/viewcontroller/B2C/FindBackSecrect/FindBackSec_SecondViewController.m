//
//  FindBackSec_SecondViewController.m
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-9.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import "FindBackSec_SecondViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "FindBack_ThirdViewController.h"
#import "DCFStringUtil.h"
#import "MCDefine.h"
#import "SendEmailViewController.h"
#import "DCFCustomExtra.h"
#import "LoginNaviViewController.h"

@interface FindBackSec_SecondViewController ()
{
    DCFPickerView *pickerView;
    
    NSString *showString;
    
    NSTimer *timer_tel;
    int timeCount_tel;     //倒计时
    
    
    
    UILabel *buttomLabel;
    
    NSString *code;

}
@end

@implementation FindBackSec_SecondViewController

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
    
    [_getValidateBtn setUserInteractionEnabled:YES];
    
//    isMobileOrEmail = YES;
    NSLog(@"_isMobileOrEmail = %d",_isMobileOrEmail);
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    if(timer_tel)
    {
        [timer_tel invalidate];
        timer_tel = nil;
    }
    
    if(_isMobileOrEmail == YES)
    {
        [self.getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    else
    {
        [self.getValidateBtn setTitle:@"获取验证短信" forState:UIControlStateNormal];
    }
    timeCount_tel = 60;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"找回密码"];
    self.navigationItem.titleView = top;

    _nextBtn.layer.cornerRadius = 5.0f;
    [_nextBtn setBackgroundColor:[UIColor colorWithRed:10.0/255.0 green:79.0/255.0 blue:191.0/255.0 alpha:1.0]];
    
    [_chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _chooseBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _chooseBtn.layer.borderWidth = 1.5f;
    _chooseBtn.layer.cornerRadius = 5.0f;
    _chooseBtn.layer.masksToBounds = YES;
    [_chooseBtn setBackgroundColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0]];
    [_chooseBtn setTitle:@"已验证手机" forState:UIControlStateNormal];
    
    
    _getValidateBtn.layer.borderColor = MYCOLOR.CGColor;
    _getValidateBtn.layer.borderWidth = 1.0f;
    _getValidateBtn.layer.cornerRadius = 5;
    _getValidateBtn.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *TAP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:TAP];
    
    buttomLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nextBtn.frame.origin.x, self.nextBtn.frame.origin.y + self.nextBtn.frame.size.height, self.nextBtn.frame.size.width, 80)];
    [buttomLabel setNumberOfLines:0];
    [buttomLabel setText:@"如果您没有收到验证码,可以直接联系买卖宝在线客服,或者拨打客服服务热线4008280188"];
    [buttomLabel setFont:[UIFont systemFontOfSize:14]];
    [buttomLabel setTextColor:[UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1.0]];
    [self.view addSubview:buttomLabel];
    
    showString = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserPhone"]];
    NSString *s1 = [showString substringToIndex:3];
    
    NSString *s2 = [showString substringFromIndex:7];
    
    NSString *s3 = @"****";
    NSString *tel = [NSString stringWithFormat:@"%@%@%@",s1,s3,s2];
    
    [_showLabel setText:tel];
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    [self adjustTheScreen];
    [_tf_getValidate resignFirstResponder];
}

- (void) pickerView:(NSString *)title WithTag:(int)tag
{
    [_getValidateBtn setTitle:title forState:UIControlStateNormal];

    [_getValidateBtn setUserInteractionEnabled:YES];
    
    if(timer_tel)
    {
        [timer_tel invalidate];
        timer_tel = nil;
    }
    timeCount_tel = 60;
    
    [_chooseBtn setTitle:title forState:UIControlStateNormal];

    
    
    if([title isEqualToString:@"已验证手机"])
    {

        _isMobileOrEmail = YES;
        
        [self.nextBtn setHidden:NO];
//
//        [_firstView setHidden:NO];
//        [_getValidateBtn setHidden:NO];
//        [_showLabel setHidden:NO];
//        [_secondLine setHidden:NO];
//        [_tf_getValidate setHidden:NO];
//        
//        [_nextBtn setHidden:NO];
        
        [self.getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        showString = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserPhone"]];
        
        NSString *s1 = [showString substringToIndex:3];
        
        NSString *s2 = [showString substringFromIndex:7];
        
        NSString *s3 = @"****";
        NSString *tel = [NSString stringWithFormat:@"%@%@%@",s1,s3,s2];
        
        [_showLabel setText:tel];
        
        [buttomLabel setText:@"如果您没有收到验证码,可以直接联系买卖宝在线客服,或者拨打客服服务热线4008280188"];
        
        [buttomLabel setTextColor:[UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1.0]];
        
        [self.backView setFrame:CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y, self.backView.frame.size.width, 171)];
        [self.nextBtn setFrame:CGRectMake(self.nextBtn.frame.origin.x, self.backView.frame.origin.y + self.backView.frame.size.height + 10, self.nextBtn.frame.size.width, 43)];

        [self.firstView setFrame:CGRectMake(self.firstView.frame.origin.x, 58, self.firstView.frame.size.width, 1)];
        
        [self.showLabel setFrame:CGRectMake(self.showLabel.frame.origin.x, 67, self.showLabel.frame.size.width, 40)];
        
        [self.getValidateBtn setFrame:CGRectMake(self.getValidateBtn.frame.origin.x, 67, self.getValidateBtn.frame.size.width, 40)];
        
        [self.secondLine setFrame:CGRectMake(self.secondLine.frame.origin.x, 113, self.secondLine.frame.size.width, 1)];
        
        [self.tf_getValidate setFrame:CGRectMake(self.tf_getValidate.frame.origin.x, 122, self.tf_getValidate.frame.size.width, 38)];
       
        self.nextBtn.layer.cornerRadius = 5.0f;
        [self.nextBtn setBackgroundColor:[UIColor colorWithRed:10.0/255.0 green:79.0/255.0 blue:191.0/255.0 alpha:1.0]];
    }
    else if ([title isEqualToString:@"已验证邮箱"])
    {
//        [_firstView setHidden:NO];
//        [_getValidateBtn setHidden:NO];
//        [_showLabel setHidden:NO];
//        [_secondLine setHidden:YES];
//        [_tf_getValidate setHidden:YES];
//        
        [self.nextBtn setHidden:YES];
        
        _isMobileOrEmail = NO;
        
        [self.getValidateBtn setTitle:@"获取验证邮件" forState:UIControlStateNormal];
        
        showString = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmail"]];
        NSString *string = nil;
        
        for(int i=0;i<showString.length;i++)
        {
            char c = [showString characterAtIndex:i];
            if(c == '@')
            {
                NSString *s1 = [showString substringToIndex:1];
                
                NSRange range = NSMakeRange(1, i-2);
                NSString *s2 = [showString substringWithRange:range];
                
                NSMutableString *starString = [[NSMutableString alloc] init];
                for(int j=0;j<s2.length;j++)
                {
                    [starString appendString:@"*"];
                }
                
                
                NSRange range_2 = NSMakeRange(i-1, showString.length-i+1);
                NSString *s3 = [showString substringWithRange:range_2];
                
                string = [NSString stringWithFormat:@"%@%@%@",s1,starString,s3];
                [_showLabel setText:string];
                break;
            }
            else
            {
                
            }
        }

        [self.backView setFrame:CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y, self.backView.frame.size.width, 113)];
        [self.nextBtn setFrame:CGRectMake(self.nextBtn.frame.origin.x, self.backView.frame.origin.y + self.backView.frame.size.height + 10, self.nextBtn.frame.size.width,0)];

        
        [buttomLabel setText:[NSString stringWithFormat:@"您的邮箱%@已经收到一份账号绑定确认邮件,请在24小时内去你的邮箱查收并按照邮件提示进行操作,完成绑定",string]];
        [buttomLabel setTextColor:[UIColor orangeColor]];
        
        [self.firstView setFrame:CGRectMake(self.firstView.frame.origin.x, 58, self.firstView.frame.size.width, 1)];
        
        [self.showLabel setFrame:CGRectMake(self.showLabel.frame.origin.x, 67, self.showLabel.frame.size.width, 40)];
        
        [self.getValidateBtn setFrame:CGRectMake(self.getValidateBtn.frame.origin.x, 67, self.getValidateBtn.frame.size.width, 40)];
        
        [self.secondLine setFrame:CGRectMake(self.secondLine.frame.origin.x, 113, self.secondLine.frame.size.width, 0)];
        
        [self.tf_getValidate setFrame:CGRectMake(self.tf_getValidate.frame.origin.x, 122, self.tf_getValidate.frame.size.width, 0)];
      

    }
    
    [buttomLabel setFrame:CGRectMake(buttomLabel.frame.origin.x, self.nextBtn.frame.origin.y + self.nextBtn.frame.size.height, buttomLabel.frame.size.width, buttomLabel.frame.size.height)];
//    [self adjustTheScreen];
}

- (void) adjustTheScreen
{
//    if(ScreenHeight >= 500)
//    {
//        
//    }
//    else
//    {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.3];
//        [UIView setAnimationDelegate:self];
//        [self.view setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//        [UIView commitAnimations];
//    }
//    
//    if([_chooseBtn.titleLabel.text isEqualToString:@"已验证手机"])
//    {
//
//    }
//    else
//    {
//
//       
//
//    }

}


- (IBAction)nextBtnClick:(id)sender
{
    [self adjustTheScreen];
    
    _tf_getValidate.text = [_tf_getValidate.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(_tf_getValidate.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入验证码"];
        return;
    }
    
    if([self.tf_getValidate.text isEqualToString:code])
    {
        FindBack_ThirdViewController *third = [self.storyboard instantiateViewControllerWithIdentifier:@"findBack_ThirdViewController"];
        _isMobileOrEmail = YES;
        [self.navigationController pushViewController:third animated:YES];
    }
    else
    {
        [DCFStringUtil showNotice:@"输入的验证码不正确"];
    }
    

}


- (IBAction)chooseBtnClick:(id)sender
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@"已验证手机",@"已验证邮箱", nil];
    pickerView = [[DCFPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.window.frame.size.height) WithArray:arr WithTag:100];
    pickerView.delegate = self;
    [self.view.window setBackgroundColor:[UIColor blackColor]];
    [self.view.window addSubview:pickerView];
}

- (IBAction)getValidateBtnClick:(id)sender
{
    timer_tel = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    [timer_tel fire];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];

    if(_isMobileOrEmail == YES)
    {
        NSString *string = [NSString stringWithFormat:@"%@%@",@"sendMessage",time];
        NSString *token = [DCFCustomExtra md5:string];
        
        NSString *pushString = [NSString stringWithFormat:@"phone=%@&token=%@&username=%@",showString,token,[self getUserName]];
        NSLog(@"push = %@",pushString);
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSendMsgTag delegate:self];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/sendMessage.html?"];
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    }
    else
    {
        NSString *string = [NSString stringWithFormat:@"%@%@",@"sendEmail",time];
        NSString *token = [DCFCustomExtra md5:string];
        
        NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&username=%@&email=%@",[self getMemberId],token,[self getUserName],showString];
        NSLog(@"push = %@",pushString);
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSendEmailTag delegate:self];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/sendEmail.html?"];
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    }
    
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    [self.getValidateBtn setUserInteractionEnabled:YES];

    if(timer_tel)
    {
        [timer_tel invalidate];
        timer_tel = nil;
        timeCount_tel = 60;
    }
    
    
    if(URLTag == URLSendMsgTag)
    {
        [self.getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];

        
        
        if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            [DCFStringUtil showNotice:@"获取验证码失败"];
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
                [DCFStringUtil showNotice:@"获取验证码失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
    
    
    if(URLTag == URLSendEmailTag)
    {
        if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            [DCFStringUtil showNotice:@"获取验证短信失败"];
        }
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            _isMobileOrEmail = NO;
            SendEmailViewController *sendEmail = [self.storyboard instantiateViewControllerWithIdentifier:@"sendEmailViewController"];
            [self.navigationController pushViewController:sendEmail animated:YES];
        }
        else
        {
            if(msg.length == 0 || [msg isKindOfClass:[NSNull class]])
            {
                [DCFStringUtil showNotice:@"获取验证短信失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
    NSLog(@"%@",dicRespon);
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

- (void) timer:(NSTimer *) sender
{
    if(timeCount_tel == 0)
    {
        [_getValidateBtn setUserInteractionEnabled:YES];
        if(_isMobileOrEmail == YES)
        {
            [self.getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
        else
        {
            [self.getValidateBtn setTitle:@"获取验证短信" forState:UIControlStateNormal];
        }
        [timer_tel invalidate];
        timer_tel = nil;
        timeCount_tel = 60;
    }
    else
    {
        timeCount_tel = timeCount_tel - 1;
        if(timeCount_tel == 0)
        {
            if(_isMobileOrEmail == YES)
            {
                [self.getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            }
            else
            {
                [self.getValidateBtn setTitle:@"获取验证短信" forState:UIControlStateNormal];
            }
        }
        else
        {
            NSString *timeString = [NSString stringWithFormat:@"剩余%d秒",timeCount_tel];
            [self.getValidateBtn setTitle:timeString forState:UIControlStateNormal];
        }
        [_getValidateBtn setUserInteractionEnabled:NO];
        
    }

}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(ScreenHeight >= 500)
    {
        
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        [self.view setFrame:CGRectMake(0, -44, 320, ScreenHeight)];
        [UIView commitAnimations];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _tf_getValidate)
    {
        [_tf_getValidate resignFirstResponder];
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
