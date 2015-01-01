//
//  BangDingWithMobileOrEmailViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "BangDingWithMobileOrEmailViewController.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "LoginNaviViewController.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"
#import "ModifyLoginSecViewController.h"

@interface BangDingWithMobileOrEmailViewController ()
{
    DCFPickerView *pickerView;
    
    NSString *thePhone;
    NSString *theEmail;
    
    NSTimer *timer_tel;
    int timeCount_tel;     //倒计时
    
    
    
//    UILabel *buttomLabel;
    
    NSString *code;
    
}
@end

@implementation BangDingWithMobileOrEmailViewController

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
    
    
    [_nextBtn setFrame:CGRectMake(self.nextBtn.frame.origin.x, self.backView.frame.origin.y + self.backView.frame.size.height+20, self.nextBtn.frame.size.width, self.nextBtn.frame.size.height)];

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"修改登录密码"];
    self.navigationItem.titleView = top;
    
    [self.tf_getValidate setDelegate:self];
    
    self.backView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.backView.layer.borderWidth = 1;
    _getValidateBtn.layer.cornerRadius = 5;
    _getValidateBtn.layer.masksToBounds = YES;
    [_getValidateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _chooseBtn.frame = CGRectMake(_getValidateBtn.frame.origin.x, (_getValidateBtn.frame.origin.y-_getValidateBtn.frame.size.height-18)                            , _getValidateBtn.frame.size.width,_getValidateBtn.frame.size.height+5);
    [_chooseBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _chooseBtn.backgroundColor = [UIColor colorWithRed:4.0/255.0 green:94.0/255.0 blue:253.0/255.0 alpha:1.0];
    _chooseBtn.layer.cornerRadius = 5.0f;
   
    
    UITapGestureRecognizer *TAP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:TAP];
    
    [_buttomLabel setNumberOfLines:0];
    [_buttomLabel setFont:[UIFont systemFontOfSize:14]];
    [_buttomLabel setTextColor:[UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1.0]];
    
    [_buttomLabel setFrame:CGRectMake(_buttomLabel.frame.origin.x, _nextBtn.frame.origin.y + _nextBtn.frame.size.height + 20, _buttomLabel.frame.size.width, _buttomLabel.frame.size.height)];

    
    if(self.myEmail.length == 0 || [self.myEmail isKindOfClass:[NSNull class]])
    {
        [self.chooseBtn setTitle:@"已验证手机" forState:UIControlStateNormal];
    }
    else
    {
        //

        
        for(int i=0;i<self.myEmail.length;i++)
        {
            char c = [self.myEmail characterAtIndex:i];
            if(c == '@')
            {
                NSString *s1 = [self.myEmail substringToIndex:1];
                
                NSRange range = NSMakeRange(1, i-2);
                NSString *s2 = [self.myEmail substringWithRange:range];
                
                NSMutableString *starString = [[NSMutableString alloc] init];
                for(int j=0;j<s2.length;j++)
                {
                    [starString appendString:@"*"];
                }
                
                
                NSRange range_2 = NSMakeRange(i-1, self.myEmail.length-i+1);
                NSString *s3 = [self.myEmail substringWithRange:range_2];
                
                theEmail = [NSString stringWithFormat:@"%@%@%@",s1,starString,s3];
                [_showLabel setText:theEmail];
                break;
            }
            else
            {
                
            }
        }

        [self whenShowEmail:theEmail];
    }
    
    if(self.myPhone.length == 0 || [self.myPhone isKindOfClass:[NSNull class]])
    {
        [self.chooseBtn setTitle:@"已验证邮箱" forState:UIControlStateNormal];
    }
    else
    {
        [self whenShowPhone];
        
    }

    if(self.myPhone.length != 0 && self.myEmail.length != 0)
    {
        [self.chooseBtn setUserInteractionEnabled:YES];
    }
    else
    {
        [self.chooseBtn setUserInteractionEnabled:NO];
    }
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    [self adjustTheScreen];
    [_tf_getValidate resignFirstResponder];
}

- (void) whenShowPhone
{
    NSLog(@"%@",self.myPhone);
    
    thePhone = [NSString stringWithFormat:@"%@",self.myPhone];
    NSString *s1 = [thePhone substringToIndex:3];
    
    NSString *s2 = [thePhone substringFromIndex:7];
    
    NSString *s3 = @"****";
    NSString *tel = [NSString stringWithFormat:@"%@%@%@",s1,s3,s2];
    
    [_showLabel setText:tel];
    
    _isMobileOrEmail = YES;
    
    [self.nextBtn setHidden:NO];
    
    [self.getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    
    [_showLabel setText:thePhone];
    
    
    [_buttomLabel setTextColor:[UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1.0]];
    
    [self.backView setFrame:CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y, self.backView.frame.size.width, 171)];
    

    
    
    [self.firstView setFrame:CGRectMake(self.firstView.frame.origin.x, 58, self.firstView.frame.size.width, 1)];
    
    [self.showLabel setFrame:CGRectMake(self.showLabel.frame.origin.x, 67, self.showLabel.frame.size.width, 40)];
    
    [self.getValidateBtn setFrame:CGRectMake(self.getValidateBtn.frame.origin.x, 67, self.getValidateBtn.frame.size.width, 40)];
    
    [self.secondLine setFrame:CGRectMake(self.secondLine.frame.origin.x, 113, self.secondLine.frame.size.width, 1)];
    
    [self.tf_getValidate setFrame:CGRectMake(self.tf_getValidate.frame.origin.x, 122, self.tf_getValidate.frame.size.width, 38)];
    
    _chooseBtn.frame = CGRectMake(_getValidateBtn.frame.origin.x, (_getValidateBtn.frame.origin.y-_getValidateBtn.frame.size.height-20)                            , _getValidateBtn.frame.size.width,_getValidateBtn.frame.size.height);

    [self.chooseBtn setTitle:@"已验证手机" forState:UIControlStateNormal];

    self.nextBtn.layer.cornerRadius = 5.0f;
    [self.nextBtn setBackgroundColor:[UIColor colorWithRed:10.0/255.0 green:79.0/255.0 blue:191.0/255.0 alpha:1.0]];
    [_nextBtn setFrame:CGRectMake(self.nextBtn.frame.origin.x, self.backView.frame.origin.y + self.backView.frame.size.height+20, self.nextBtn.frame.size.width, self.nextBtn.frame.size.height)];
    
    [_buttomLabel setText:@"如果您没有收到验证码,可以直接联系买卖宝在线客服,或者拨打客服服务热线4008280188"];
    [_buttomLabel setFrame:CGRectMake(_buttomLabel.frame.origin.x, _nextBtn.frame.origin.y + _nextBtn.frame.size.height + 20, _buttomLabel.frame.size.width, _buttomLabel.frame.size.height)];
    

}

- (void) whenShowEmail:(NSString *) email
{
    [self.nextBtn setHidden:YES];
    
    _isMobileOrEmail = NO;
    
    [self.getValidateBtn setTitle:@"获取验证邮件" forState:UIControlStateNormal];
    
    
    [_showLabel setText:theEmail];
    
    [self.backView setFrame:CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y, self.backView.frame.size.width, 113)];

    self.nextBtn.layer.cornerRadius = 5.0f;
    [self.nextBtn setBackgroundColor:[UIColor colorWithRed:10.0/255.0 green:79.0/255.0 blue:191.0/255.0 alpha:1.0]];
    [_nextBtn setFrame:CGRectMake(self.nextBtn.frame.origin.x, self.backView.frame.origin.y + self.backView.frame.size.height+20, self.nextBtn.frame.size.width, self.nextBtn.frame.size.height)];
    
    [self.firstView setFrame:CGRectMake(self.firstView.frame.origin.x, 58, self.firstView.frame.size.width, 1)];
    
    [self.showLabel setFrame:CGRectMake(self.showLabel.frame.origin.x, 67, self.showLabel.frame.size.width, 40)];
    
    [self.getValidateBtn setFrame:CGRectMake(self.getValidateBtn.frame.origin.x, 67, self.getValidateBtn.frame.size.width, 40)];
    
     _chooseBtn.frame = CGRectMake(_getValidateBtn.frame.origin.x, (_getValidateBtn.frame.origin.y-_getValidateBtn.frame.size.height-20)                            , _getValidateBtn.frame.size.width,_getValidateBtn.frame.size.height);
    
    [self.secondLine setFrame:CGRectMake(self.secondLine.frame.origin.x, 113, self.secondLine.frame.size.width, 0)];
    
    [self.tf_getValidate setFrame:CGRectMake(self.tf_getValidate.frame.origin.x, 122, self.tf_getValidate.frame.size.width, 0)];
    [_buttomLabel setTextColor:[UIColor orangeColor]];
    
    
    [self.chooseBtn setTitle:@"已验证邮箱" forState:UIControlStateNormal];

    NSLog(@"%@",email);
    [_buttomLabel setFrame:CGRectMake(_buttomLabel.frame.origin.x, _backView.frame.origin.y+_backView.frame.size.height + 20, _buttomLabel.frame.size.width, _buttomLabel.frame.size.height)];
    [_buttomLabel setText:[NSString stringWithFormat:@"您的邮箱%@已经收到一份账号绑定确认邮件,请在24小时内去你的邮箱查收并按照邮件提示进行操作,完成绑定",email]];
    [_buttomLabel setTextColor:[UIColor orangeColor]];

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
        [self whenShowPhone];
    }
    else if ([title isEqualToString:@"已验证邮箱"])
    {

        [self whenShowEmail:theEmail];
    }
    
//    [_nextBtn setFrame:CGRectMake(self.nextBtn.frame.origin.x, self.backView.frame.origin.y + self.backView.frame.size.height+20, self.nextBtn.frame.size.width, self.nextBtn.frame.size.height)];
    //    [self adjustTheScreen];
}

- (void) adjustTheScreen
{
    if(ScreenHeight >= 500)
    {
        
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        [self.view setFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
        [UIView commitAnimations];
    }
    
}


- (IBAction)nextBtnClick:(id)sender
{
    [self.nextBtn resignFirstResponder];
    
    [self adjustTheScreen];
    
    _tf_getValidate.text = [_tf_getValidate.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(_tf_getValidate.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入验证码"];
        return;
    }
    
    if([self.tf_getValidate.text isEqualToString:code])
    {
        ModifyLoginSecViewController *modifyLoginSecViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"modifyLoginSecViewController"];
        _isMobileOrEmail = YES;
        [self.navigationController pushViewController:modifyLoginSecViewController animated:YES];
    }
    else
    {
        [DCFStringUtil showNotice:@"输入的验证码不正确"];
    }
    
    
}


- (IBAction)chooseBtnClick:(id)sender
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@"已验证手机",@"已验证邮箱", nil];
    pickerView = [[DCFPickerView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, self.view.window.frame.size.height) WithArray:arr WithTag:100];
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
        
        NSString *pushString = [NSString stringWithFormat:@"phone=%@&token=%@&username=%@",self.myPhone,token,[self getUserName]];
        NSLog(@"push = %@",pushString);
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSendMsgTag delegate:self];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/sendMessage.html?"];
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    }
    else
    {
        NSString *string = [NSString stringWithFormat:@"%@%@",@"sendEmail",time];
        NSString *token = [DCFCustomExtra md5:string];
        
        NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&username=%@&email=%@",[self getMemberId],token,[self getUserName],self.myEmail];
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
    
//    [self.getValidateBtn setUserInteractionEnabled:YES];
//    
//    if(timer_tel)
//    {
//        [timer_tel invalidate];
//        timer_tel = nil;
//        timeCount_tel = 60;
//    }
    
    
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
        [self.getValidateBtn setTitle:@"获取验证短信" forState:UIControlStateNormal];
        
        if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            [DCFStringUtil showNotice:@"获取验证短信失败"];
        }
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            _isMobileOrEmail = NO;
//            SendEmailViewController *sendEmail = [self.storyboard instantiateViewControllerWithIdentifier:@"sendEmailViewController"];
//            [self.navigationController pushViewController:sendEmail animated:YES];
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
        [self.view setFrame:CGRectMake(0, -20, ScreenWidth, ScreenHeight)];
        [UIView commitAnimations];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _tf_getValidate)
    {
        [_tf_getValidate resignFirstResponder];
    }
    [self adjustTheScreen];
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
