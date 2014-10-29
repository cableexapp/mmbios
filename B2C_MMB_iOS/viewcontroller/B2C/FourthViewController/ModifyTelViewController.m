//
//  ModifyTelViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-18.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "ModifyTelViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "DCFStringUtil.h"

@interface ModifyTelViewController ()
{
    NSTimer *timer;
    int timeCount_tel;     //倒计时
}
@end

@implementation ModifyTelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)identifyBtnClick:(id)sender
{
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
        [_identifyBtn setUserInteractionEnabled:YES];
        [self.identifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [timer invalidate];
        timer = nil;
        timeCount_tel = 60;
    }
    else
    {
        timeCount_tel = timeCount_tel - 1;
        if(timeCount_tel == 0)
        {
            [self.identifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
        else
        {
            NSString *timeString = [NSString stringWithFormat:@"剩余%d秒",timeCount_tel];
            [self.identifyBtn setTitle:timeString forState:UIControlStateNormal];
        }
        [self.identifyBtn setUserInteractionEnabled:NO];
        
    }
}

- (IBAction)upBtnClick:(id)sender
{
    if([self.myTextField isFirstResponder])
    {
        [self.myTextField resignFirstResponder];
    }
    [self up];
}

- (void) up
{
    if(self.myTextField.text.length == 0)
    {
        [DCFStringUtil showNotice:@"验证码不能为空"];
        return;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    timeCount_tel = 60;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"修改绑定手机"];
    self.navigationItem.titleView = top;
    
    self.identifyBtn.layer.borderColor = [UIColor colorWithRed:69.0/255.0 green:97.0/255.0 blue:127.0/255.0 alpha:1.0].CGColor;
    self.identifyBtn.layer.borderWidth = 1.0f;
    self.identifyBtn.layer.cornerRadius = 5;
    
    self.upBtn.layer.borderColor = [UIColor colorWithRed:69.0/255.0 green:97.0/255.0 blue:127.0/255.0 alpha:1.0].CGColor;
    self.upBtn.layer.borderWidth = 1.0f;
    self.upBtn.layer.cornerRadius = 5;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    if([self.myTextField isFirstResponder])
    {
        [self.myTextField resignFirstResponder];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
    
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    [self.identifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    timeCount_tel = 60;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self up];
    return YES;
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    [_identifyBtn setUserInteractionEnabled:YES];
    [self.identifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    if(timer)
    {
        [timer invalidate];
        timer = nil;
        timeCount_tel = 60;
    }

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
