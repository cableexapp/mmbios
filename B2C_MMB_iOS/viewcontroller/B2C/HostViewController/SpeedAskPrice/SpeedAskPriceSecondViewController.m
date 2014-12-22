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
#import "ChatViewController.h"
#import "AppDelegate.h"

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

    self.backToHostBtn.layer.cornerRadius = 5;
    self.anotherUpBtn.layer.cornerRadius = 5;
    
    self.askBtn.layer.cornerRadius = 5;
    self.askBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.askBtn.layer.borderWidth = 1;
    
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
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"您确定要拨打热线电话么" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    [av show];

}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008280188"]];
            break;
        default:
            break;
    }
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - 在线客服
- (IBAction)askBtnClick:(id)sender
{
    if ([self.appDelegate.isConnect isEqualToString:@"连接"])
    {
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        chatVC.fromStringFlag = @"来自快速询价客服";
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
        chatVC.fromString = @"来自快速询价客服";
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type =  kCATransitionMoveIn;
        transition.subtype =  kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:chatVC animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
