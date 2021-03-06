//
//  HotThirdViewController.m
//  B2C_MMB_iOS
//
//  Created by cyumen on 14-11-12.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "HotThirdViewController.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "HotKindFirstViewController.h"
#import "ChatListViewController.h"
#import "AppDelegate.h"
#import "ChatViewController.h"

@interface HotThirdViewController ()

@end

@implementation HotThirdViewController

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
//    [self pushAndPopStyle];
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"提交成功"];
    self.navigationItem.titleView = top;
    [super viewDidLoad];
    
    self.backBtn.frame = CGRectMake((self.view.frame.size.width-240)/3, 110, 120, 38);
    self.backBtn.layer.cornerRadius = 5;
    
    self.oneMoreBtn .frame = CGRectMake(((self.view.frame.size.width-240)/3)*2+120, 110, 120, 38);
    self.oneMoreBtn.layer.cornerRadius = 5;
    
//    self.imBtn.frame = CGRectMake(148, 55, 110, 32);
    self.imBtn.layer.borderWidth = 1;
    self.imBtn.layer.cornerRadius = 5;
    self.imBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
   
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 18, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}


- (void) back:(id) sender
{
    //  跳转到首页
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 返回首页
- (IBAction)backHome:(id)sender
{
  //  返回上一级
//   [self.navigationController popViewControllerAnimated:YES];
    

    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - 再提交一单
- (IBAction)backSecond:(id)sender
{
     //  倒退到页面2
//    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -3)] animated:YES];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

}



- (IBAction)taPhone:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"您确定要拨打热线电话么" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    [av show];
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - 在线客服
- (IBAction)clickAsk:(id)sender
{
    if ([self.appDelegate.isConnect isEqualToString:@"连接"])
    {
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        chatVC.fromStringFlag = @"热门分类在线客服";
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        transition.type =  kCATransitionMoveIn;
        transition.subtype =  kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:chatVC animated:NO];
    }
    else
    {
        ChatListViewController *chatVC = [[ChatListViewController alloc] init];
        chatVC.fromString = @"热门分类在线客服";
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type =  kCATransitionMoveIn;
        transition.subtype =  kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:chatVC animated:NO];
    }

}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008280188"]];
            break;
        default:
            break;
    }
}

@end
