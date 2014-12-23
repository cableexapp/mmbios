//
//  ThirdNaviViewController.m
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-8-30.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import "ThirdNaviViewController.h"
#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "AppDelegate.h"

@interface ThirdNaviViewController ()

@end

@implementation ThirdNaviViewController

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

    self.view.backgroundColor = [UIColor whiteColor];
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"工具栏入口状态 = %@",self.appDelegate.isConnect);
    if ([self.appDelegate.isConnect isEqualToString:@"连接"])
    {
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        chatVC.fromStringFlag = @"工具栏客服";
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
        ChatListViewController *chatListVC = [[ChatListViewController alloc] init];
        chatListVC.fromString = @"工具栏客服";
        [self pushViewController:chatListVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
