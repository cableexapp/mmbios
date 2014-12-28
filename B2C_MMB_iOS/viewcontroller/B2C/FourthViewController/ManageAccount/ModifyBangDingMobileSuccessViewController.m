//
//  ModifyBangDingMobileSuccessViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-16.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "ModifyBangDingMobileSuccessViewController.h"
#import "DCFTopLabel.h"
#import "AccountManagerTableViewController.h"

@interface ModifyBangDingMobileSuccessViewController ()

@end

@implementation ModifyBangDingMobileSuccessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) back:(id) sender
{
    //  跳转到首页
    NSLog(@"%@",self.navigationController.viewControllers);
    for(UIViewController *vc in self.navigationController.viewControllers)
    {
        if([vc isKindOfClass:[AccountManagerTableViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
//        else if([vc isKindOfClass:[B2CShoppingListViewController class]])
//        {
//            [self.navigationController popToViewController:vc animated:YES];
//            return;
//        }
//        else if ([vc isKindOfClass:[ShoppingHostViewController class]])
//        {
//            [self.navigationController popToViewController:vc
//                                                  animated:YES];
//            return;
//        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"新增绑定手机"];
    self.navigationItem.titleView = top;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 18, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
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
