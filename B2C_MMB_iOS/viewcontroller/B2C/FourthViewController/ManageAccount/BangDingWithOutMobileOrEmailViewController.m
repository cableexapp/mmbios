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
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"修改登录密码"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    self.sureBtn.layer.borderColor = MYCOLOR.CGColor;
    self.sureBtn.layer.borderWidth = 1.0f;
    self.sureBtn.layer.cornerRadius = 5.0f;
    
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
    
    
    NSLog(@"%@",dicRespon);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.oldSecTf resignFirstResponder];
    [self.setNewSecTf resignFirstResponder];
    [self.sureSecTf resignFirstResponder];
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
    
    NSString *memberid = [self getMemberId];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"ChangePassword",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&oldpassword=%@&newpassword=%@",memberid,token,self.oldSecTf.text,self.setNewSecTf.text];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLChangePasswordTag delegate:self];
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
