//
//  FindBackSec_FirstViewController.m
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-9.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import "FindBackSec_FirstViewController.h"
#import "DCFStringUtil.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "FindBackSec_SecondViewController.h"
#import "DCFCustomExtra.h"
#import "ValidateForPhoneViewController.h"
#import "ValidateForEmailViewController.h"
#import "MCDefine.h"
#import "LoginNaviViewController.h"

@interface FindBackSec_FirstViewController ()
{
    NSString *phone;
    NSString *email;
    NSString *memberId;
    NSString *userName;
}
@end

@implementation FindBackSec_FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"找回密码"];
    self.navigationItem.titleView = top;
    
    self.nextBtn.layer.borderColor = MYCOLOR.CGColor;
    self.nextBtn.layer.borderWidth = 1.0f;
    self.nextBtn.layer.cornerRadius = 5.0f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - 判断是不是纯数字
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


- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if([DCFCustomExtra validateString:memberid] == NO)
    {
        memberid = @"";
    }
    return memberid;
}


- (IBAction)nextBtnClick:(id)sender
{
    if([_tf_confirm isFirstResponder])
    {
        [_tf_confirm resignFirstResponder];
    }
    
    NSString *string_TF = [_tf_confirm.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    if([DCFCustomExtra validateString:string_TF] == NO)
    {
        [DCFStringUtil showNotice:@"请输入账号信息"];
        return;
    }
    
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = nil;
    NSString *pushString = nil;
    NSString *token = nil;
    NSString *urlString = nil;
    if([DCFCustomExtra validateMobile:string_TF] == NO)
    {
        NSLog(@"不是手机号码");
        
        string = [NSString stringWithFormat:@"%@%@",@"getMemberObjByUsername",time];
        token = [DCFCustomExtra md5:string];
        pushString = [NSString stringWithFormat:@"token=%@&username=%@",token,string_TF];
        urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/getMemberObjByUsername.html?"];
    }
    else
    {
        NSLog(@"是手机号码");
        
        string = [NSString stringWithFormat:@"%@%@",@"getMemberObjByPhone",time];
        token = [DCFCustomExtra md5:string];
        pushString = [NSString stringWithFormat:@"token=%@&phone=%@&memberid=%@",token,string_TF,[self getMemberId]];
        urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/getMemberObjByPhone.html?"];
    }
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetMemberObjByUsernameTag delegate:self];

    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
//    [self push];
}

- (void) next:(UIButton *) sender
{

}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLGetMemberObjByUsernameTag)
    {
        NSLog(@"%@",dicRespon);
        if(result == 1)
        {
            phone = [NSString stringWithFormat:@"%@",[[dicRespon objectForKey:@"items"] objectForKey:@"phone"]];
            [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"UserPhone"];
            
            email = [NSString stringWithFormat:@"%@",[[dicRespon objectForKey:@"items"] objectForKey:@"email"]];
            [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"UserEmail"];
            
            
            memberId = [NSString stringWithFormat:@"%@",[[dicRespon objectForKey:@"items"] objectForKey:@"memberId"]];
            [[NSUserDefaults standardUserDefaults] setObject:memberId forKey:@"memberId"];
            
            userName = [NSString stringWithFormat:@"%@",[[dicRespon objectForKey:@"items"] objectForKey:@"userName"]];
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];

            [self push];
        }
        else
        {
            if([DCFCustomExtra validateString:msg] == NO)
            {
                
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
            phone = @"";
            email = @"";
            userName = @"";
            memberId = @"";
        }
    }
    if(URLTag == URLGetMemberObjByPhoneTag)
    {
    }
}

- (void) push
{    
    if([DCFCustomExtra validateString:phone] == NO && [DCFCustomExtra validateString:email] == NO)
    {
        [DCFStringUtil showNotice:@"您尚未绑定任何设备,请联系客服"];
        return;
    }

    //只绑定邮箱没有绑定手机进入邮箱验证界面
     if(([DCFCustomExtra validateString:phone] == NO) && (email.length != 0 || ![email isKindOfClass:[NSNull class]] || email != NULL || email != nil))
    {
        ValidateForEmailViewController *validateForEmailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"validateForEmailViewController"];
        [self.navigationController pushViewController:validateForEmailViewController animated:YES];
    }
    //只绑定手机没绑定邮箱,进入手机安全验证界面
    else if((phone.length != 0 || ![phone isKindOfClass:[NSNull class]] || phone != NULL || phone != nil) && ([DCFCustomExtra validateString:email] == NO))
    {
        ValidateForPhoneViewController *validateForPhoneViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"validateForPhoneViewController"];
        [self.navigationController pushViewController:validateForPhoneViewController animated:YES];
    }
    //同时绑定了手机和邮箱进入找回密码界面
    else
    {
        FindBackSec_SecondViewController *second = [self.storyboard instantiateViewControllerWithIdentifier:@"findBackSec_SecondViewController"];
        second.myPhone = phone;
        second.myEmail = email;
        second.isMobileOrEmail = YES;
        [self.navigationController pushViewController:second animated:YES];
    }

}

- (void) tap:(UITapGestureRecognizer *) sender
{
    [_tf_confirm resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _tf_confirm)
    {
        [_tf_confirm resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
