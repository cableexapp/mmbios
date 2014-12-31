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
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.appDelegate.isConnect isEqualToString:@"连接"])
    {
        NSMutableArray *ViewArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        NSLog(@"工具栏入口ViewArray = %@",ViewArray);
        
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        chatVC.fromStringFlag = @"工具栏客服";
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.4f;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//        transition.type =  kCATransitionMoveIn;
//        transition.subtype =  kCATransitionFromTop;
//        transition.delegate = self;
//        [self.view.layer addAnimation:transition forKey:nil];
        [self setHidesBottomBarWhenPushed:YES];
        [self pushViewController:chatVC animated:YES];
    
//      [self setViewControllers:[NSArray arrayWithObject:chatVC]];
        
        NSLog(@"工具栏入口连接状态ViewArray = %@",self.viewControllers);
    }
    else
    {
        ChatListViewController *chatListVC = [[ChatListViewController alloc] init];
        chatListVC.fromString = @"工具栏客服";
        
         [self setHidesBottomBarWhenPushed:YES];
//      [self pushViewController:chatListVC animated:YES];
       
        [self setViewControllers:[NSArray arrayWithObject:chatListVC]];
       
        NSLog(@"工具栏入口连接状态ViewArray = %@",self.viewControllers);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
