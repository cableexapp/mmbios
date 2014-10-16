//
//  DCFTabBarCtrl.m
//  DCFParentEnd
//
//  Created by dqf on 14-6-10.
//  Copyright (c) 2014年 dqf. All rights reserved.
//

#import "DCFTabBarCtrl.h"

#import "HostTableViewController.h"
#import "SecondTableViewController.h"
#import "ThirdTableViewController.h"
#import "FourthHostViewController.h"
//#import "DCFParentschoolViewCtrl.h"
//#import "DCFHomeSchoolViewCtrl.h"
//#import "DCFStudyGardenViewCtrl.h"
//#import "DCFSettingViewCtrl.h"

#import "HostNaviViewController.h"
#import "SecondNaviViewController.h"
#import "ThirdNaviViewController.h"
#import "FourthNaviViewController.h"

@interface DCFTabBarCtrl ()

@end

@implementation DCFTabBarCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)initCutomBar
{
    HostNaviViewController *hostNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"hostNaviViewController"];
    SecondNaviViewController *secondNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"secondNaviViewController"];
    ThirdNaviViewController *thirdNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"thirdNaviViewController"];
    FourthNaviViewController *fourthNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"fourthNaviViewController"];
    
    //set the tab bar items
    NSArray *tabbarItems = [[NSArray alloc] initWithObjects:hostNavi,secondNavi,thirdNavi,fourthNavi, nil];
    self.viewControllers = tabbarItems;
        
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initCutomBar];
    
    //设置tabbar背景颜色
//    [[UITabBar appearance] setTintColor:[UIColor redColor]];
//    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:30/255.0 green:35/255.0 blue:32/255.0 alpha:1.0]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];

    //设置tabbar图片文字颜色
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:18/255.0 green:104/255.0 blue:253/255.0 alpha:1.0]];
//    [[UITabBar appearance] setBarTintColor:[UIColor orangeColor]];

}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
