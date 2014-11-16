//
//  ModifyLoginSecViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-17.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "ModifyLoginSecViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "DCFStringUtil.h"
#import "MCDefine.h"
#import "LoginNaviViewController.h"
#import "DCFCustomExtra.h"

@interface ModifyLoginSecViewController ()

@end

@implementation ModifyLoginSecViewController

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
}


//- (void) hudWasHidden:(MBProgressHUD *)hud
//{
//    [HUD removeFromSuperview];
//    HUD = nil;
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"修改登陆密码"];
    self.navigationItem.titleView = top;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor colorWithRed:50.0/255.0 green:99.0/255.0 blue:179.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 50, 40)];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void) btnClick:(UIButton *) sender
{
    if([self.tf_first isFirstResponder])
    {
        [self.tf_first resignFirstResponder];
    }
    if([self.tf_second isFirstResponder])
    {
        [self.tf_second resignFirstResponder];
    }
    
    if(self.tf_first.text.length == 0 && self.tf_second.text.length == 0)
    {
        [DCFStringUtil showNotice:@"密码不能为空"];
        return;
    }
    if(![self.tf_first.text isEqualToString:self.tf_second.text])
    {
        [DCFStringUtil showNotice:@"两次输入的密码必须一致"];
        return;
    }
    if([self isAllNum:self.tf_first.text] == YES || [self isAllNum:self.tf_second.text] == YES)
    {
        [DCFStringUtil showNotice:@"密码不能为纯数字"];
        return;
    }
    if(self.tf_first.text.length < 6 || self.tf_second.text.length < 6)
    {
        [DCFStringUtil showNotice:@"密码长度不能小于6位"];
        return;
    }
    if(self.tf_first.text.length > 18 || self.tf_second.text.length > 18)
    {
        [DCFStringUtil showNotice:@"密码长度不能大于18位"];
        return;
    }
    
    
    [self loadRequest];
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

- (void) loadRequest
{
    NSString *memberid = [self getMemberId];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"ChangePassword",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&oldpassword=%@&newpassword=%@",memberid,token,@"",self.tf_second.text];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLChangePasswordTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/ChangePassword.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(result == 1)
    {
        [DCFStringUtil showNotice:msg];
    }
    else
    {
        if(msg.length == 0 || [msg isKindOfClass:[NSNull class]])
        {
            [DCFStringUtil showNotice:@"修改登录密码失败"];
        }
        else
        {
            [DCFStringUtil showNotice:msg];
        }
    }
    
    
    NSLog(@"%@",dicRespon);
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


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.tf_first)
    {
        [self.tf_first resignFirstResponder];
        [self.tf_second becomeFirstResponder];
    }
    if(textField == self.tf_second)
    {
        [self.tf_second resignFirstResponder];
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
