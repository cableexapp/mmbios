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
    [self pushAndPopStyle];
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"提交成功"];
    self.navigationItem.titleView = top;
    [super viewDidLoad];

    
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
    
 //  跳转到首页
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//   隐藏底部
    [self setHidesBottomBarWhenPushed:YES];
    
}

#pragma mark - 再提交一单
- (IBAction)backSecond:(id)sender
{
     //  倒退到页面2
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -3)] animated:YES];
}
@end
