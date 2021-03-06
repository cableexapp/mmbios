//
//  HotScreenSecondViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-10.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "HotScreenSecondViewController.h"
#import "MCDefine.h"
#import "DCFStringUtil.h"
#import "DCFCustomExtra.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "LoginNaviViewController.h"
#import "HotScreenSuccessViewController.h"

@interface HotScreenSecondViewController ()

@end

@implementation HotScreenSecondViewController

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
    NSString *userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPhone"];
    NSString *tel = [[NSUserDefaults standardUserDefaults] objectForKey:@"HotScreenNum"];
    
    if([DCFCustomExtra validateString:userPhone] == YES)
    {
        [self.myTextField setText:userPhone];
    }
    else
    {
        if([DCFCustomExtra validateString:tel] == NO)
        {
            [self.myTextField setPlaceholder:@"手机号码"];
        }
        else
        {
            [self.myTextField setText:tel];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.upBtn.layer.cornerRadius = 5;
    self.upBtn.layer.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0].CGColor;
    
    [self.topLabel setText:[NSString stringWithFormat:@"已选场合: %@",self.screen]];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"提交所选场合"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    self.myTextField.backgroundColor = [UIColor whiteColor];
}

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if(memberid.length == 0)
    {
        memberid = @"";
//        LoginNaviViewController *loginNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
//        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}

- (NSString *) getUserName
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    userName = [DCFCustomExtra UTF8Encoding:userName];

    if(userName.length == 0)
    {
        userName = @"";
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//        LoginNaviViewController *loginNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
//        [self presentViewController:loginNavi animated:YES completion:nil];
    }
    else
    {
//        NSString *userName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    }
    return userName;
    
}

- (IBAction)upBtnClick:(id)sender
{
    if([self.myTextView isFirstResponder])
    {
        [self.myTextView resignFirstResponder];
    }
    if([self.myTextField isFirstResponder])
    {
        [self.myTextField resignFirstResponder];
    }
    
    if(self.myTextView.text.length > 1000)
    {
        [DCFStringUtil showNotice:@"备注文字不能长于1000字"];
        return;
    }
    
    if(self.myTextField.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入手机号码"];
        return;
    }
    
    BOOL validateTel = [DCFCustomExtra validateMobile:self.myTextField.text];
    if(validateTel == NO)
    {
        [DCFStringUtil showNotice:@"请输入正确的手机号码"];
        return;
    }
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"SubHotType",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *content = [NSString stringWithFormat:@"%@%@",self.topLabel.text,self.myTextView.text];
#pragma mark - 一级分类
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&membername=%@&phone=%@&linkman=%@&content=%@&source=%@",token,[self getMemberId],[self getUserName],self.myTextField.text,[self getUserName],content,@"5"];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSubHotTypeTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/SubHotType.html?"];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int reslut = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if(URLTag == URLSubHotTypeTag)
    {
        if(reslut == 1)
        {
            [[NSUserDefaults standardUserDefaults] setObject:self.myTextField.text forKey:@"HotScreenNum"];
            
            HotScreenSuccessViewController *hotScreenSuccessViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"hotScreenSuccessViewController"];
            [self.navigationController pushViewController:hotScreenSuccessViewController animated:YES];
        }
        else
        {
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"提交失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.myTextField)
    {
        [self.myTextField resignFirstResponder];
    }
    
    BOOL validateTel = [DCFCustomExtra validateMobile:self.myTextField.text];
    if(validateTel == NO)
    {
        [DCFStringUtil showNotice:@"请输入正确的手机号码"];
    }
    
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
}


- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    
    if([text isEqualToString:@"\n"])
    {
        [self.myTextView resignFirstResponder];
    }
    return YES;
}


- (void) textViewDidChange:(UITextView *)textView
{
    
    if(self.myTextView.text.length == 0)
    {
        [self.textViewLabel setHidden:NO];
    }
    else
    {
        [self.textViewLabel setHidden:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
