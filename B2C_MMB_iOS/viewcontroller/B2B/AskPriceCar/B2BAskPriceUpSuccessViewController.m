//
//  B2BAskPriceUpSuccessViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-6.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2BAskPriceUpSuccessViewController.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "MyInquiryListFirstViewController.h"
#import "MCDefine.h"
#import "ChatListViewController.h"
#import "B2BAskPriceCarViewController.h"
#import "ChatViewController.h"
#import "AppDelegate.h"

@interface B2BAskPriceUpSuccessViewController ()
{
    UIButton *backBtn;
    UIBarButtonItem *leftItem;
}
@end

@implementation B2BAskPriceUpSuccessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}

- (void) back:(UIButton *) SENDER
{
    for(UIViewController *vc in self.navigationController.viewControllers)
    {
        if([vc isKindOfClass:[B2BAskPriceCarViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self pushAndPopStyle];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 15, 22)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"提交成功"];
    self.navigationItem.titleView = top;
    
    self.lookForMyOrderBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
    self.lookForMyOrderBtn.layer.cornerRadius = 5.0f;
    
    self.backToHomeBtn.layer.cornerRadius = 5.0f;
    
    self.imBTN.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.imBTN.layer.borderWidth = 1;
    self.imBTN.layer.cornerRadius = 5;
}

- (IBAction)lookForMyOrderBtnClick:(id)sender
{
    MyInquiryListFirstViewController *myInquiryListFirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myInquiryListFirstViewController"];
    [self.navigationController pushViewController:myInquiryListFirstViewController animated:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backToHomeBtn:(id)sender
{
     [self.navigationController popToRootViewControllerAnimated:YES];
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - 在线客服
- (IBAction)imBtn:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    
    if ([self.appDelegate.isConnect isEqualToString:@"连接"])
    {
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        chatVC.fromStringFlag = @"热门型号提交成功在线客服";
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
        chatVC.fromString = @"热门型号提交成功在线客服";
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

- (IBAction)telBtnClick:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"您确定要拨打热线电话么" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    [av show];
}
@end
