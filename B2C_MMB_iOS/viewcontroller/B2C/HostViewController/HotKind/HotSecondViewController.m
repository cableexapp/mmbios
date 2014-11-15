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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     //每个界面都要加这句话
    [self pushAndPopStyle];

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
    [self.PhoneNumber resignFirstResponder];
    [self.markView resignFirstResponder];
}


- (IBAction)submitNews:(id)sender
{
    
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"请登录后再提交" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alter show];
     UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请登陆后再提交" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
      [sheet showInView:self.view];

}




#pragma mark - actionsheet的代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) return;
    [self performSegueWithIdentifier:@"submit2win" sender:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];

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
