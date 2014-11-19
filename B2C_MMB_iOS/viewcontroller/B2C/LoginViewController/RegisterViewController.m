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
    
    NSTimer *timer;
    int timeCount_tel;     //倒计时
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
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    [self.speedGetSecBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    timeCount_tel = 60;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    timeCount_tel = 60;
    
//    NSLog(@"%@",self.navigationController)
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    DCFTopLabel *TOP = [[DCFTopLabel alloc] initWithTitle:@"电缆买卖宝注册"];
    self.navigationItem.titleView = TOP;
    
    
    [self.mySegment setFrame:CGRectMake((ScreenWidth-self.mySegment.frame.size.width)/2, (self.segmentView.frame.size.height-self.mySegment.frame.size.height)/2, self.mySegment.frame.size.width, self.mySegment.frame.size.height)];
    
    [self.sv setContentSize:CGSizeMake(ScreenWidth*2, self.sv.frame.size.height)];
    [self.sv setDelegate:self];
    [self.sv setPagingEnabled:YES];
    [self.sv setBounces:NO];
    
    [self.mySegment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.normalAccountTf setReturnKeyType:UIReturnKeyNext];
    [self.normalSecTf setReturnKeyType:UIReturnKeyNext];
    [self.normalSureSecTf setReturnKeyType:UIReturnKeyDone];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)speedAgreeBtnClick:(id)sender
{
    NSLog(@"1111");
}

- (IBAction)speedGetSecBtnClick:(id)sender
{
    [self.speedRegisterTf resignFirstResponder];
    
    if(self.speedRegisterTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入手机号码"];
        return;
    }
    if([DCFCustomExtra validateMobile:self.speedRegisterTf.text] == NO)
    {
        [DCFStringUtil showNotice:@"手机号码不正确"];
        return;
    }
    if(!timer)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
        [timer fire];
    }
}


- (void) timer:(NSTimer *) sender
{
    if(timeCount_tel == 0)
    {
        [self.speedGetSecBtn setUserInteractionEnabled:YES];
        [self.speedGetSecBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [timer invalidate];
        timer = nil;
        timeCount_tel = 60;
    }
    else
    {
        timeCount_tel = timeCount_tel - 1;
        if(timeCount_tel == 0)
        {
            [self.speedGetSecBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
        else
        {
            NSString *timeString = [NSString stringWithFormat:@"剩余%d秒",timeCount_tel];
            [self.speedGetSecBtn setTitle:timeString forState:UIControlStateNormal];
        }
        [self.speedGetSecBtn setUserInteractionEnabled:NO];
        
    }
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    if(currentPageIndex == 0)
    {
        [self.speedRegisterTf resignFirstResponder];
    }
    else
    {
        [_normalAccountTf resignFirstResponder];
        [_normalSecTf resignFirstResponder];
        [_normalSureSecTf resignFirstResponder];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.normalAccountTf resignFirstResponder];
    [self.normalSecTf resignFirstResponder];
    [self.normalSureSecTf resignFirstResponder];
    
    
    if(textField == self.normalSureSecTf)
    {
        [self regester];
    }
    return YES;
}

- (void) regester
{
    [_normalAccountTf resignFirstResponder];
    [_normalSecTf resignFirstResponder];
    [_normalSureSecTf resignFirstResponder];

    
    if(_normalAccountTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入账号"];
        return;
    }
    if(_normalSecTf.text.length == 0 || _normalSureSecTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入密码"];
        return;
    }
    if(![_normalSecTf.text isEqualToString:_normalSureSecTf.text])
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
    NSString *des = [MCdes encryptUseDES:self.normalSecTf.text key:@"cableex_app*#!Key"];
    
    NSString *pushString = [NSString stringWithFormat:@"username=%@&password=%@&token=%@",self.normalAccountTf.text,des,token];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLRegesterTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    NSLog(@"%@",dicRespon);
    [_speedGetSecBtn setUserInteractionEnabled:YES];
    [self.speedGetSecBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    if(timer)
    {
        [timer invalidate];
        timer = nil;
        timeCount_tel = 60;
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
                dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.normalAccountTf.text,@"registerAccount",self.normalSecTf.text,@"registerSecrect", nil];
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"regiserDic"];

                [self.navigationController popViewControllerAnimated:YES];
            }
        }

    }
}

- (IBAction)registerBtnClick:(id)sender
{
    [self regester];
}

- (void) segmentChange:(UISegmentedControl *) sender
{
    int index = self.mySegment.selectedSegmentIndex;
    if(index == 0)
    {
        if(currentPageIndex == 0)
        {
            [self.sv setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        else if (currentPageIndex == 1)
        {
            [self.sv setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    if(index == 1)
    {
        [_speedGetSecBtn setUserInteractionEnabled:YES];
        [self.speedGetSecBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        if(timer)
        {
            [timer invalidate];
            timer = nil;
            timeCount_tel = 60;
        }
        
        if(currentPageIndex == 0)
        {
            [self.sv setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
        }
        else if (currentPageIndex == 1)
        {
            [self.sv setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    
    if(currentPageIndex == 1)
    {
        [_speedGetSecBtn setUserInteractionEnabled:YES];
        [self.speedGetSecBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        if(timer)
        {
            [timer invalidate];
            timer = nil;
            timeCount_tel = 60;
        }
    }
    
    [self.mySegment setSelectedSegmentIndex:currentPageIndex];
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
