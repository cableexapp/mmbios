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
    
   [self.view endEditing:YES];
    
    self.secondTextView.delegate = self;
//    数据加载到文本框
    NSString *str = @"";
    for (NSDictionary *aDic in upArray) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@\n",[aDic objectForKey:@"typePls"]]];
    }
    [self.markView setText:str];
    
    // 2.监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}





/**
 *  当键盘改变了frame(位置和尺寸)的时候调用
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 设置窗口的颜色
    self.view.window.backgroundColor = self.markView.backgroundColor;
    
    // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height - 62;
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
//        CGAffineTransform pTransform = CGAffineTransformMakeTranslation(0, -100);
//        self.view.transform = pTransform;
     }];

}
/**
 *  当开始拖拽表格的时候就会调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 退出键盘
    [self.view endEditing:YES];
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
}

//textview文本框里的备注
- (void) textViewDidChange:(UITextView *)textView
{
 
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
