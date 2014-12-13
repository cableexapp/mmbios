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

@interface B2BAskPriceUpSuccessViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self pushAndPopStyle];
    
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

#pragma mark - 在线客服
- (IBAction)imBtn:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    ChatListViewController *chatVC = [[ChatListViewController alloc] init];
    chatVC.fromString = @"热门型号提交成功在线客服";
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =  kCATransitionMoveIn;
    transition.subtype =  kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:chatVC animated:NO];
}

- (IBAction)telBtnClick:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"您确定要拨打热线电话么" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    [av show];
}
@end
