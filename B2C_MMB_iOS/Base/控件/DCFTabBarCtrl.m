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
#import "FifthNaviViewController.h"

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
    UIImage *selecthomeImg = [UIImage imageNamed:@"HomeSelect.png"];
    UIImage *unSelecthomeImg = [UIImage imageNamed:@"HomeUnSelect.png"];
    selecthomeImg = [UIImage imageWithCGImage:selecthomeImg.CGImage scale:1.5 orientation:selecthomeImg.imageOrientation];
    unSelecthomeImg = [UIImage imageWithCGImage:unSelecthomeImg.CGImage scale:1.5 orientation:unSelecthomeImg.imageOrientation];
    hostNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:unSelecthomeImg selectedImage:selecthomeImg];
    [hostNavi.tabBarItem setTag:1];
    //    [hostNavi.tabBarItem setImageInsets:UIEdgeInsetsMake(10, 0, 0, 10)];
    
    SecondNaviViewController *secondNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"secondNaviViewController"];
    UIImage *selectClassifySelectImg = [UIImage imageNamed:@"classifySelect.png"];
    UIImage *unClassifyUnSelectImImg = [UIImage imageNamed:@"classifyUnSelect.png"];
    selectClassifySelectImg = [UIImage imageWithCGImage:selectClassifySelectImg.CGImage scale:1.5 orientation:selectClassifySelectImg.imageOrientation];
    unClassifyUnSelectImImg = [UIImage imageWithCGImage:unClassifyUnSelectImImg.CGImage scale:1.5 orientation:unClassifyUnSelectImImg.imageOrientation];
    secondNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"分类" image:unClassifyUnSelectImImg selectedImage:selectClassifySelectImg];
    [secondNavi.tabBarItem setTag:2];
    //    [secondNavi.tabBarItem setImageInsets:UIEdgeInsetsMake(10, 0, 0, 10)];
    
    ThirdNaviViewController *thirdNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"thirdNaviViewController"];
    UIImage *selectImImg = [UIImage imageNamed:@"imSelect.png"];
    UIImage *unSelectImImg = [UIImage imageNamed:@"imUnSelect.png"];
    selectImImg = [UIImage imageWithCGImage:selectImImg.CGImage scale:1.5 orientation:selectImImg.imageOrientation];
    unSelectImImg = [UIImage imageWithCGImage:unSelectImImg.CGImage scale:1.5 orientation:unSelectImImg.imageOrientation];
    thirdNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"在线咨询" image:unSelectImImg selectedImage:selectImImg];
    [thirdNavi.tabBarItem setTag:3];
    //    [thirdNavi.tabBarItem setImageInsets:UIEdgeInsetsMake(10, 0, 0, 10)];
    
    FourthNaviViewController *fourthNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"fourthNaviViewController"];
    UIImage *selectp_centerSelectImg = [UIImage imageNamed:@"p_centerSelect.png"];
    UIImage *unSelectp_centerUnSelectImg = [UIImage imageNamed:@"p_centerUnSelect.png"];
    selectp_centerSelectImg = [UIImage imageWithCGImage:selectp_centerSelectImg.CGImage scale:1.5 orientation:selectp_centerSelectImg.imageOrientation];
    unSelectp_centerUnSelectImg = [UIImage imageWithCGImage:unSelectp_centerUnSelectImg.CGImage scale:1.5 orientation:unSelectp_centerUnSelectImg.imageOrientation];
    fourthNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人中心" image:unSelectp_centerUnSelectImg selectedImage:selectp_centerSelectImg];
    [fourthNavi.tabBarItem setTag:4];
    //    [fourthNavi.tabBarItem setImageInsets:UIEdgeInsetsMake(10, 0, 0, 10)];
    
    FifthNaviViewController *fifthNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"fifthNaviViewController"];
    UIImage *selectmoreSelectImg = [UIImage imageNamed:@"moreSelectpng"];
    UIImage *unSelectmoreUnSelectImg = [UIImage imageNamed:@"moreUnSelect.png"];
    selectmoreSelectImg = [UIImage imageWithCGImage:selectmoreSelectImg.CGImage scale:1.5 orientation:selectmoreSelectImg.imageOrientation];
    unSelectmoreUnSelectImg = [UIImage imageWithCGImage:unSelectmoreUnSelectImg.CGImage scale:1.5 orientation:unSelectmoreUnSelectImg.imageOrientation];
    fifthNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"更多" image:unSelectmoreUnSelectImg selectedImage:selectmoreSelectImg];
    [fifthNavi.tabBarItem setTag:5];
//    [fifthNavi.tabBarItem setTitle:@"分类"];
    
    //set the tab bar items
    NSArray *tabbarItems = [[NSArray alloc] initWithObjects:hostNavi,secondNavi,thirdNavi,fourthNavi,fifthNavi, nil];
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
