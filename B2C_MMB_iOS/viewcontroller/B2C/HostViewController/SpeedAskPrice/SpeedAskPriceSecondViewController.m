//
//  SpeedAskPriceSecondViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-22.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "SpeedAskPriceSecondViewController.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "ChatListViewController.h"
#import "MCDefine.h"

@interface SpeedAskPriceSecondViewController ()

@end

@implementation SpeedAskPriceSecondViewController

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
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"提交成功"];
    self.navigationItem.titleView = top;
    
    self.backToHostBtn.layer.borderColor = MYCOLOR.CGColor;
    self.backToHostBtn.layer.borderWidth = 1.0f;
    
    self.anotherUpBtn.layer.borderWidth = 1.0f;
    self.anotherUpBtn.layer.borderColor = MYCOLOR.CGColor;
    
    [self pushAndPopStyle];
}

- (IBAction)backToHostBtnClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)anotherBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)telBtnClick:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"您确定要拨打热点电话么" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    [av show];

}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-828-0188"]];
            break;
        default:
            break;
    }
}


- (IBAction)askBtnClick:(id)sender
{
    NSLog(@"来自快速询价客服");
    ChatListViewController *chatVC = [[ChatListViewController alloc] init];
    chatVC.fromString = @"来自快速询价客服";
    [self.navigationController pushViewController:chatVC animated:YES];
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
