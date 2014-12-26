//
//  HotSecondViewController.m
//  B2C_MMB_iOS
//
//  Created by cyumen on 14-11-12.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "HotSecondViewController.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "MBProgressHUD.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"
#import "LoginNaviViewController.h"
#import "MCDefine.h"


@interface HotSecondViewController ()

@end

@implementation HotSecondViewController

@synthesize upArray;

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

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSString *userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPhone"];
    NSString *tel = [[NSUserDefaults standardUserDefaults] objectForKey:@"HotKindNum"];
    
    if([DCFCustomExtra validateString:userPhone] == YES)
    {
        [self.PhoneNumber setText:userPhone];
    }
    else
    {
        if([DCFCustomExtra validateString:tel] == NO)
        {
            [self.PhoneNumber setPlaceholder:@"手机号码/固定号码"];
        }
        else
        {
            [self.PhoneNumber setText:tel];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     //每个界面都要加这句话‘返回’
    [self pushAndPopStyle];
    
    self.markView.editable = NO;
    [self.markView setReturnKeyType:UIReturnKeyDone];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"提交所选分类"];
    self.navigationItem.titleView = top;
    [super viewDidLoad];
    
   [self.view endEditing:YES];
    
    self.submit.backgroundColor = [UIColor colorWithRed:237/255.0 green:137/255.0 blue:0/255.0 alpha:1.0];
    [self.submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submit.layer.cornerRadius = 5;
    self.submit.frame = CGRectMake(5, self.view.frame.size.height-160,self.view.frame.size.width-37 , 40);
    self.secondTextView.delegate = self;
//    数据加载到文本框
    NSString *str = @"";
    for (NSDictionary *aDic in upArray) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@\n",[aDic objectForKey:@"typePls"]]];
    }
    [self.markView setText:str];
    self.secondTextView.delegate = self;
    [self.secondTextView setReturnKeyType:UIReturnKeyDone];
    self.PhoneNumber.delegate = self;
    [self.PhoneNumber addTarget:self action:@selector(textViewDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [self.PhoneNumber addTarget:self action:@selector(textViewDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3f];
    self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}


- (void)textViewDidBeginEditing:(UITextField *)textView
{
//    CGRect frame = textView.frame;
//    int offset = frame.origin.y + 60 - (self.view.frame.size.height-200.0);
//    NSTimeInterval animationDuration=0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    if (offset)
//    {
//        self.view.frame=CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//        [UIView commitAnimations];
//    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3f];
    if(MainScreenHeight <= 500)
    {
        [self.view setFrame:CGRectMake(0, -60, ScreenWidth, ScreenHeight)];
    }
    else if (MainScreenHeight > 500 && MainScreenHeight <= 600)
    {
        [self.view setFrame:CGRectMake(0, -10, ScreenWidth, ScreenHeight)];
    }
    else
    {
        
    }
    [UIView commitAnimations];
}




// 隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [self.view endEditing:YES];
    [self.PhoneNumber resignFirstResponder];
}

- (NSString *) getMemberId
{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    if([DCFCustomExtra validateString:memberid] == NO)
    {
        memberid = @"";
//        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
//        [self presentViewController:loginNavi animated:YES completion:nil];
    }
    return memberid;
}

- (NSString *) getUserName
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    if([DCFCustomExtra validateString:userName] == NO)
    {
        userName = @"";
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
//        [self presentViewController:loginNavi animated:YES completion:nil];
    }
    return userName;
    
}

#pragma mark - actionsheet的代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) return;
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if(URLTag == URLSubHotTypeTag)
    {
        NSLog(@"%@",dicRespon);
        
        if(result == 1)
        {
            [[NSUserDefaults standardUserDefaults] setObject:self.PhoneNumber.text forKey:@"HotKindNum"];
            
            [self performSegueWithIdentifier:@"submit2win" sender:nil];
        }
        else
        {
            if([DCFCustomExtra validateString:msg] == NO)
            {
                [DCFStringUtil showNotice:msg];
            }
            else
            {
                [DCFStringUtil showNotice:@"提交失败"];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submitNews:(UIButton *)sender
{
    
    [self.PhoneNumber resignFirstResponder];
    if(self.PhoneNumber.text.length == 0 )
    {
        [DCFStringUtil showNotice:@"手机号码不能为空"];
        return;
    }
    

        if([DCFCustomExtra validateMobile:self.PhoneNumber.text] == NO)
        {
            [DCFStringUtil showNotice:@"请输入正确的手机号码"];
            return;
        }

    
    if(self.secondTextView.text.length > 1000)
    {
        [DCFStringUtil showNotice:@"备注内容已超出1000字"];
        return;
    }
    
    NSString *memberid = [self getMemberId];

        NSString *time = [DCFCustomExtra getFirstRunTime];
        NSString *string = [NSString stringWithFormat:@"%@%@",@"SubHotType",time];
        NSString *token = [DCFCustomExtra md5:string];
    
    NSString *phoneNum = nil;
    if([DCFCustomExtra validateString:self.PhoneNumber.text] == NO)
    {
        phoneNum = @"";
    }
    else
    {
        phoneNum = self.PhoneNumber.text;
    }
    NSString *markView = nil;
    if([DCFCustomExtra validateString:self.markView.text] == NO)
    {
        markView = @"";
    }
    else
    {
        markView = self.markView.text;
    }
//    loginid,token,memberid,membername,phone(联系电话),linkman(联系人),content(内容)
        NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&membername=%@&phone=%@&linkman=%@&content=%@",memberid,token,[self getUserName],phoneNum,[self getUserName],markView];
        
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSubHotTypeTag delegate:self];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/SubHotType.html?"];
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self.secondTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView
{
    [self.countLabel setText:[NSString stringWithFormat:@"%d",self.secondTextView.text.length]];
    if(self.secondTextView.text.length > 1000)
    {
        [self.countLabel setTextColor:[UIColor redColor]];
    }else{
        [self.countLabel setTextColor:[UIColor blackColor]];

    }
    if(self.secondTextView.text.length == 0)
    {
        [self.labelText setHidden:NO];
    }
    else
    {
        [self.labelText setHidden:YES];
    }
}




@end
