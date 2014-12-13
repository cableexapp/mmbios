//
//  HotScreenSuccessViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-10.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "HotScreenSuccessViewController.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "HotScreenFirstViewController.h"
#import "ChatListViewController.h"

@interface HotScreenSuccessViewController ()

@end

@implementation HotScreenSuccessViewController

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
    self.anotherBtn.layer.cornerRadius = 5;
    
    self.imBtn.layer.borderWidth = 1;
    self.imBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.imBtn.layer.cornerRadius = 5;
    
    [self pushAndPopStyle];
}

- (IBAction)backToHostBtnClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)anotherBtnClick:(id)sender
{
//    [self.navigationController popToRootViewControllerAnimated:YES];

    HotScreenFirstViewController *hotScreenFirstViewController = [[self.navigationController viewControllers] objectAtIndex:1];

    [self.navigationController popToViewController:hotScreenFirstViewController animated:YES];
    
    
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
    // Dispose of any resources that can be recreated.
}

- (IBAction)hotLineBtn:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"您确定要拨打热线电话么" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    [av show];
}
- (IBAction)imBtn:(id)sender
{
     NSLog(@"场合选择提交成功—在线咨询");
#pragma mark - 在线客服
    ChatListViewController *chatVC = [[ChatListViewController alloc] init];
    chatVC.fromString = @"场合选择提交成功客服";
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =  kCATransitionMoveIn;
    transition.subtype =  kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:chatVC animated:NO];
    
}
@end
