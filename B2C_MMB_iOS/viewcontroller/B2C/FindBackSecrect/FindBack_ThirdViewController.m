//
//  FindBack_ThirdViewController.m
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-9.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import "FindBack_ThirdViewController.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "LoginNaviViewController.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"
#import "LoginNaviViewController.h"

@interface FindBack_ThirdViewController ()
{
    UIStoryboard *sb;
}
@end

@implementation FindBack_ThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) sure:(UIButton *) sender
{

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"找回密码"];
    self.navigationItem.titleView = top;
    
    
    self.sureBtn.layer.cornerRadius = 5.0f;
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


- (IBAction)sureBtnClick:(id)sender
{
    if([_tf_newSec isFirstResponder])
    {
        [_tf_newSec resignFirstResponder];
    }
    if([_tf_sureSec isFirstResponder])
    {
        [_tf_sureSec resignFirstResponder];
    }
    
    
    if(_tf_newSec.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入密码"];
        return;
    }
    if(_tf_newSec.text.length < 6)
    {
        [DCFStringUtil showNotice:@"密码长度不能小于6位"];
        return;
    }
    if(_tf_newSec.text.length > 18)
    {
        [DCFStringUtil showNotice:@"密码长度不能大于18位"];
        return;
    }
    BOOL isAllNum = [self isAllNum:_tf_newSec.text];
    if(isAllNum == 1)
    {
        [DCFStringUtil showNotice:@"密码不能为纯数字"];
        return;
    }
    
    if(![_tf_newSec.text isEqualToString:_tf_sureSec.text])
    {
        [DCFStringUtil showNotice:@"两次输入密码不一致"];
        return;
    }
    
    if(!HUD)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setLabelText:@"正在修改..."];
        [HUD setDelegate:self];
    }
    
    NSString *memberid = [self getMemberId];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"ChangePassword",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&oldpassword=%@&newpassword=%@",memberid,token,@"",self.tf_newSec.text];
    NSLog(@"%@",pushString);
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLChangePasswordTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/ChangePassword.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(HUD)
    {
        [HUD hide:YES];
    }
    
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if(URLTag == URLChangePasswordTag)
    {
        if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            [DCFStringUtil showNotice:@"修改绑定手机失败"];
        }
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"regiserDic"]];
            NSString *userName = [dic objectForKey:@"registerAccount"];
            NSString *password = [self.tf_newSec text];
            
            NSDictionary *newDic = [[NSDictionary alloc] initWithObjectsAndKeys:userName,@"registerAccount",password,@"registerSecrect", nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:newDic forKey:@"regiserDic"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            if([DCFCustomExtra validateString:msg] == NO)
            {
                [DCFStringUtil showNotice:@"修改绑定手机失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
    NSLog(@"%@",dicRespon);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if([_tf_newSec isFirstResponder])
    {
        [_tf_newSec resignFirstResponder];
    }
    if([_tf_sureSec isFirstResponder])
    {
        [_tf_sureSec resignFirstResponder];
    }
    return YES;
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    if([_tf_newSec isFirstResponder])
    {
        [_tf_newSec resignFirstResponder];
    }
    if([_tf_sureSec isFirstResponder])
    {
        [_tf_sureSec resignFirstResponder];
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
