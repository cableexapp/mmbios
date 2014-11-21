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
    NSTimer *timer_tel;
    int timeCount_tel;
    
    NSString *code;
    
    UILabel *buttomLabel;
    
    UIButton *itemBtn;
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

- (void) changeMethod:(NSString *) str
{
    
    NSString *labelText = nil;
    
    if([str isEqualToString:@"已验证手机"])
    {
        [self.validateTf setFrame:CGRectMake(self.validateTf.frame.origin.x, self.validateTf.frame.origin.y, self.validateTf.frame.size.width, 40)];
        
        [itemBtn setHidden:NO];
        
        
        NSString *s1 = [_myPhone substringToIndex:3];
        
        NSString *s2 = [_myPhone substringFromIndex:7];
        
        NSString *s3 = @"****";
        NSString *tel = [NSString stringWithFormat:@"%@%@%@",s1,s3,s2];
        [self.chooseLabel setText:tel];
        [self.validateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        labelText = @"如果您没收到验证码,可直接联系买卖宝在线客服,或者拨打客服服务热线4008280188";
    }
    else if ([str isEqualToString:@"已验证邮箱"])
    {
        [self.validateTf setFrame:CGRectMake(self.validateTf.frame.origin.x, self.validateTf.frame.origin.y, self.validateTf.frame.size.width, 0)];

        [itemBtn setHidden:YES];

        
        NSString *emailStr = nil;
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
                
                emailStr = [NSString stringWithFormat:@"%@%@%@",s1,starString,s3];
                [self.chooseLabel setText:emailStr];
                break;
            }
            else
            {
                
            }
        }
        [self.validateBtn setTitle:@"获取验证邮件" forState:UIControlStateNormal];
       labelText = [NSString stringWithFormat:@"您的邮箱%@已经收到一份账号绑定确认邮件,请在24小时内去你的邮箱查收并按照邮件提示进行操作,完成绑定",emailStr];
    }
    
    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:labelText WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
    [buttomLabel setFrame:CGRectMake(10, self.validateTf.frame.origin.y+self.validateTf.frame.size.height, ScreenWidth-20, size.height)];
    [buttomLabel setText:labelText];
    [buttomLabel setFont:[UIFont systemFontOfSize:13]];
    [buttomLabel setNumberOfLines:0];
}

- (void) itemBtnClick:(UIButton *) sender
{
    if(self.validateTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入验证码"];
        return;
    }
//    if([self.validateTf.text isEqualToString:code])
//    {
        ModifyLoginSecViewController *modifyLoginSecViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"modifyLoginSecViewController"];
        [self.navigationController pushViewController:modifyLoginSecViewController animated:YES];
//    }
//    else
//    {
//        [DCFStringUtil showNotice:@"输入的验证码不正确"];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pushAndPopStyle];
    
    buttomLabel = [[UILabel alloc] init];
    [self.view addSubview:buttomLabel];
    
    itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [itemBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [itemBtn setFrame:CGRectMake(0, 0, 50, 40)];
    [itemBtn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:itemBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
   // NSString *labelString = nil;
    if(_myEmail.length != 0)
    {
        [self.chooseBtn setTitle:@"已验证邮箱" forState:UIControlStateNormal];
        [self.validateBtn setTitle:@"获取验证邮件" forState:UIControlStateNormal];
       
        
    }
    if(_myPhone.length != 0)
    {
        [self.chooseBtn setTitle:@"已验证手机" forState:UIControlStateNormal];
        [self.validateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }

    [self changeMethod:self.chooseBtn.titleLabel.text];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"修改登录密码"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    self.validateBtn.layer.borderColor = MYCOLOR.CGColor;
    self.validateBtn.layer.borderWidth = 1.0f;
    self.validateBtn.layer.cornerRadius = 5.0f;
    
    [self.validateTf setDelegate:self];
    
    

    
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

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    [self.chooseBtn setUserInteractionEnabled:YES];

    [self.validateBtn setUserInteractionEnabled:YES];
    [self.validateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
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
    
    
    NSLog(@"%@",dicRespon);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.validateTf resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

    
}

- (IBAction)chooseBtnClick:(id)sender
{
    if(_myEmail.length == 0 || [_myEmail isKindOfClass:[NSNull class]])
    {
        return;
    }
    if(_myPhone.length == 0 || [_myPhone isKindOfClass:[NSNull class]])
    {
        return;
    }
    NSMutableArray *pickerArray = [[NSMutableArray alloc] initWithObjects:@"已验证手机",@"已验证邮箱", nil];
    [self loadPickerViewWithArray:pickerArray WithTag:1010];
}


- (void) loadPickerViewWithArray:(NSMutableArray *) array WithTag:(int) tag
{
    pickerView = [[DCFPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.window.frame.size.height) WithArray:array WithTag:tag];
    pickerView.delegate = self;
    [self.view.window setBackgroundColor:[UIColor blackColor]];
    [self.view.window addSubview:pickerView];
}

- (void) pickerView:(NSString *) title WithTag:(int) tag
{

    [self.chooseBtn setTitle:title forState:UIControlStateNormal];

    [self changeMethod:self.chooseBtn.titleLabel.text];
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

- (IBAction)validateBtnClick:(id)sender
{
    [self.chooseBtn setUserInteractionEnabled:NO];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *btnTitle = [self.chooseBtn.titleLabel text];
    if([btnTitle isEqualToString:@"已验证手机"])
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

    
    timer_tel = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    [timer_tel fire];
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
