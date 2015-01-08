//
//  BangDingWithOutMobileOrEmailViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "BangDingWithOutMobileOrEmailViewController.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "LoginNaviViewController.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"
#import "ModifyLogSecSuccessViewController.h"

@interface BangDingWithOutMobileOrEmailViewController ()

@end

@implementation BangDingWithOutMobileOrEmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"修改登录密码"];
    self.navigationItem.titleView = top;
    
    self.backView.layer.borderWidth = 1;
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [self pushAndPopStyle];
    
    self.sureBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:99/255.0 blue:206/255.0 alpha:1.0];
    self.sureBtn.layer.cornerRadius = 5.0f;
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureBtn.frame = CGRectMake(15, self.view.frame.size.height-205, self.view.frame.size.width-30, 40);
    
    [self.oldSecTf setDelegate:self];
    [self.setNewSecTf setDelegate:self];
    [self.sureSecTf setDelegate:self];
    
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(result == 1)
    {
        ModifyLogSecSuccessViewController *modifyLogSecSuccessViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"modifyLogSecSuccessViewController"];
        [self.navigationController pushViewController:modifyLogSecSuccessViewController animated:YES];
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
    
    
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.sureSecTf)
    {
        if(ScreenHeight <= 500)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.3f];
            [self.view setFrame:CGRectMake(0, -20, ScreenWidth, ScreenHeight)];
            [UIView commitAnimations];
        }
        else
        {
            
        }
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.oldSecTf)
    {
        [self.oldSecTf resignFirstResponder];
    }
    if(textField == self.setNewSecTf)
    {
        [self.setNewSecTf resignFirstResponder];
    }
    if(textField == self.sureSecTf)
    {
        [self.sureSecTf resignFirstResponder];
        if(ScreenHeight <= 500)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.3f];
            [self.view setFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
            [UIView commitAnimations];
        }
        else
        {
            
        }
    }
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sureBtncLICK:(id)sender
{
    [self.oldSecTf resignFirstResponder];
    [self.setNewSecTf resignFirstResponder];
    [self.sureSecTf resignFirstResponder];
    
    if(ScreenHeight <= 500)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3f];
        [self.view setFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
        [UIView commitAnimations];
    }
    else
    {
        
    }
    
    if(self.oldSecTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入旧密码"];
        return;
    }
    if(self.setNewSecTf.text.length == 0 || self.sureSecTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入新密码"];
        return;
    }
    
    if(![self.setNewSecTf.text isEqualToString:self.sureSecTf.text])
    {
        [DCFStringUtil showNotice:@"两次输入密码不一致,请检查"];
        return;
    }
    if([self.oldSecTf.text isEqualToString:self.setNewSecTf.text] || [self.oldSecTf.text isEqualToString:self.sureSecTf.text])
    {
        [DCFStringUtil showNotice:@"新密码不能和旧密码相同"];
        return;
    }
    
    if(self.setNewSecTf.text.length < 6 || self.setNewSecTf.text.length > 18)
    {
        [DCFStringUtil showNotice:@"密码长度必须在6-18位"];
        return;
    }
    
    if(self.sureSecTf.text.length < 6 || self.sureSecTf.text.length > 18)
    {
        [DCFStringUtil showNotice:@"密码长度必须在6-18位"];
        return;
    }
    
    NSString *memberid = [self getMemberId];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"ChangePassword",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&oldpassword=%@&newpassword=%@",memberid,token,self.oldSecTf.text,self.setNewSecTf.text];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLChangePasswordTag delegate:self];
    conn.LogIn = YES;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/ChangePassword.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
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
