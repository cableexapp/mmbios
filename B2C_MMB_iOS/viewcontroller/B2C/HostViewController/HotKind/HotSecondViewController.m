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

#define kMaxLength 11

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
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     //每个界面都要加这句话‘返回’
    [self pushAndPopStyle];
    
    self.markView.editable = NO;

    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"提交所选分类"];
    self.navigationItem.titleView = top;
    [super viewDidLoad];
    
//    [self.PhoneNumber resignFirstResponder];
   [self.view endEditing:YES];
    
//    数据加载到文本框
    NSString *str = @"";
    for (NSDictionary *aDic in upArray) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@\n",[aDic objectForKey:@"typePls"]]];
    }
    [self.markView setText:str];
    
}



// 隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.PhoneNumber resignFirstResponder];
//    [self.markView resignFirstResponder];
    [self.view endEditing:YES];
 [self.PhoneNumber resignFirstResponder];

}

- (IBAction)phoneText:(id)sender
{
 }

- (NSString *) getMemberId
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSLog(@"%@",memberid);
    if(memberid.length == 0)
    {
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}


- (NSString *) getUserName
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    if(userName.length == 0)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
    }
    return userName;
    
}

#pragma mark - actionsheet的代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) return;
    

    
//    [self.navigationController popToRootViewControllerAnimated:YES];

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
            [self performSegueWithIdentifier:@"submit2win" sender:nil];
        }
        else
        {
            if(msg.length == 0)
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



- (IBAction)submitNews:(UIButton *)sender {
    
    if(sender == self.submit)
    {
        [self.PhoneNumber resignFirstResponder];
    }
    
    
    if(self.PhoneNumber.text.length == 0)
    {
        [DCFStringUtil showNotice:@"手机号码不能为空"];
        return;
    }
    if([DCFCustomExtra validateMobile:self.PhoneNumber.text] == NO)
    {
        [DCFStringUtil showNotice:@"请输入正确的手机号码"];
        return;
    }
    
    NSString *memberid = [self getMemberId];
    if(memberid.length == 0 || [memberid isKindOfClass:[NSNull class]] || memberid == NULL)
    {
        
    }
    else
    {
        NSString *time = [DCFCustomExtra getFirstRunTime];
        NSString *string = [NSString stringWithFormat:@"%@%@",@"SubHotType",time];
        NSString *token = [DCFCustomExtra md5:string];
        
        NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&membername=%@&phone=%@&linkman=%@&content=%@",memberid,token,[self getUserName],self.PhoneNumber.text,[self getUserName],self.markView.text];
        
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSubHotTypeTag delegate:self];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/SubHotType.html?"];
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    }

//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请登陆后再提交" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [sheet showInView:self.view];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"111111");
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    if (_secondTextView.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            _labelText.hidden=NO;//隐藏文字
        }else{
            _labelText.hidden=YES;
        }
    }else{//textview长度不为0
        if (_secondTextView.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                _labelText.hidden=NO;
            }else{//不是删除
                _labelText.hidden=YES;
            }
        }else{//长度不为1时候
            _labelText.hidden=YES;
        }
    }
    return YES;
}
@end
