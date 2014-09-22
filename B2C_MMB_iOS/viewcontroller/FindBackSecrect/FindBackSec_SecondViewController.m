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

@interface FindBackSec_SecondViewController ()
{
    DCFPickerView *pickerView;
    
    NSString *showString;
    
    NSTimer *timer_tel;
    int timeCount_tel;     //倒计时
    
    UIButton *nextBtn;
    
    BOOL isMobileOrEmail;
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
    
    [_getValidateBtn setUserInteractionEnabled:NO];
    
    isMobileOrEmail = YES;
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    if(timer_tel)
    {
        [timer_tel invalidate];
        timer_tel = nil;
    }
    [self.getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    timeCount_tel = 60;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"找回密码"];
    self.navigationItem.titleView = top;
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor colorWithRed:21.0/255.0 green:100.0/255.0 blue:249.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [nextBtn setFrame:CGRectMake(100, 0, 50, 30)];
    [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setHidden:YES];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    
    [_chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _chooseBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _chooseBtn.layer.borderWidth = 1.5f;
    _chooseBtn.layer.cornerRadius = 5.0f;
    _chooseBtn.layer.masksToBounds = YES;
    [_chooseBtn setBackgroundColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0]];
    [_chooseBtn setTitle:@"请选择已验证方式" forState:UIControlStateNormal];
    
    
    _getValidateBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _getValidateBtn.layer.borderWidth = 1.0f;
    _getValidateBtn.layer.cornerRadius = 5;
    _getValidateBtn.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *TAP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:TAP];
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    [self adjustTheScreen];
    [_tf_getValidate resignFirstResponder];
}

- (void) pickerView:(NSString *)title
{
    [_getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
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
        
        isMobileOrEmail = YES;
        
        [nextBtn setHidden:NO];
        
        [_tf_getValidate setHidden:NO];
        
        showString = @"13921307054";
        
        NSString *s1 = [showString substringToIndex:3];
        
        NSString *s2 = [showString substringFromIndex:7];
        
        NSString *s3 = @"****";
        NSString *tel = [NSString stringWithFormat:@"%@%@%@",s1,s3,s2];
        
        [_showLabel setText:tel];
        
    }
    else if ([title isEqualToString:@"已验证邮箱"])
    {
        
        isMobileOrEmail = NO;
        
        [nextBtn setHidden:YES];
        
        showString = @"306233304@qq.com";
        
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
                
                NSString *string = [NSString stringWithFormat:@"%@%@%@",s1,starString,s3];
                [_showLabel setText:string];
                break;
            }
            else
            {
                
            }
        }
        [_tf_getValidate setHidden:YES];
    }
}

- (void) adjustTheScreen
{
    if(ScreenHeight >= 500)
    {
        
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [self.view setFrame:CGRectMake(0, 0, 320, ScreenHeight)];
        [UIView commitAnimations];
    }
}

- (void) next:(UIButton *) sender
{
    
    [self adjustTheScreen];
    
    _tf_getValidate.text = [_tf_getValidate.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(_tf_getValidate.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入验证码"];
        return;
    }
    
    FindBack_ThirdViewController *third = [self.storyboard instantiateViewControllerWithIdentifier:@"findBack_ThirdViewController"];
    [self.navigationController pushViewController:third animated:YES];
}

- (IBAction)chooseBtnClick:(id)sender
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@"已验证手机",@"已验证邮箱", nil];
    pickerView = [[DCFPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.window.frame.size.height) WithArray:arr];
    pickerView.delegate = self;
    [self.view.window setBackgroundColor:[UIColor blackColor]];
    [self.view.window addSubview:pickerView];
}

- (IBAction)getValidateBtnClick:(id)sender
{
    timer_tel = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    [timer_tel fire];
}


- (void) timer:(NSTimer *) sender
{
    if(timeCount_tel == 0)
    {
        [_getValidateBtn setUserInteractionEnabled:YES];
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
        [_getValidateBtn setUserInteractionEnabled:NO];
        
    }
    
    if(isMobileOrEmail == YES)
    {
        
    }
    else
    {
        SendEmailViewController *sendEmail = [self.storyboard instantiateViewControllerWithIdentifier:@"sendEmailViewController"];
        [self.navigationController pushViewController:sendEmail animated:YES];
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
