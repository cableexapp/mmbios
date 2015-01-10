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
#import "AppDelegate.h"

@interface DCFTabBarCtrl ()
{
    FourthNaviViewController *fourthNavi;
    AppDelegate *app;
    ThirdNaviViewController *thirdNavi;
}
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
    
//    UIStoryboard *secondSB = [UIStoryboard storyboardWithName:@"SecondSB" bundle:nil];
    
    SecondNaviViewController *secondNavi = [[SecondNaviViewController alloc] initWithRootViewController:nil];
    UIImage *selectClassifySelectImg = [UIImage imageNamed:@"classifySelect.png"];
    UIImage *unClassifyUnSelectImImg = [UIImage imageNamed:@"classifyUnSelect.png"];
    selectClassifySelectImg = [UIImage imageWithCGImage:selectClassifySelectImg.CGImage scale:1.5 orientation:selectClassifySelectImg.imageOrientation];
    unClassifyUnSelectImImg = [UIImage imageWithCGImage:unClassifyUnSelectImImg.CGImage scale:1.5 orientation:unClassifyUnSelectImImg.imageOrientation];
    secondNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"购物车" image:unClassifyUnSelectImImg selectedImage:selectClassifySelectImg];
    
    [secondNavi.tabBarItem setTag:2];
    
    UIStoryboard *thirdSB = [UIStoryboard storyboardWithName:@"ThirdSB" bundle:nil];
    thirdNavi = [thirdSB instantiateViewControllerWithIdentifier:@"thirdNaviViewController"];
    UIImage *selectImImg = [UIImage imageNamed:@"imSelect.png"];
    UIImage *unSelectImImg = [UIImage imageNamed:@"imUnSelect.png"];
    selectImImg = [UIImage imageWithCGImage:selectImImg.CGImage scale:1.5 orientation:selectImImg.imageOrientation];
    unSelectImImg = [UIImage imageWithCGImage:unSelectImImg.CGImage scale:1.5 orientation:unSelectImImg.imageOrientation];
    thirdNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"在线咨询" image:unSelectImImg selectedImage:selectImImg];
    [thirdNavi.tabBarItem setTag:3];
    //    [thirdNavi.tabBarItem setImageInsets:UIEdgeInsetsMake(10, 0, 0, 10)];
    
    UIStoryboard *fourthSB = [UIStoryboard storyboardWithName:@"FourthSB" bundle:nil];
    fourthNavi = [fourthSB instantiateViewControllerWithIdentifier:@"fourthNaviViewController"];
    UIImage *selectp_centerSelectImg = [UIImage imageNamed:@"p_centerSelect.png"];
    UIImage *unSelectp_centerUnSelectImg = [UIImage imageNamed:@"p_centerUnSelect.png"];
    selectp_centerSelectImg = [UIImage imageWithCGImage:selectp_centerSelectImg.CGImage scale:1.5 orientation:selectp_centerSelectImg.imageOrientation];
    unSelectp_centerUnSelectImg = [UIImage imageWithCGImage:unSelectp_centerUnSelectImg.CGImage scale:1.5 orientation:unSelectp_centerUnSelectImg.imageOrientation];
    fourthNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:unSelectp_centerUnSelectImg selectedImage:selectp_centerSelectImg];
    [fourthNavi.tabBarItem setTag:4];
    //    [fourthNavi.tabBarItem setImageInsets:UIEdgeInsetsMake(10, 0, 0, 10)];
    
    UIStoryboard *fifthSB = [UIStoryboard storyboardWithName:@"FifthSB" bundle:nil];
    FifthNaviViewController *fifthNavi = [fifthSB instantiateViewControllerWithIdentifier:@"fifthNaviViewController"];
    UIImage *selectmoreSelectImg = [UIImage imageNamed:@"moreSelect.png"];
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

- (void) changeSelectItem
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initCutomBar];
    
    //设置tabbar背景颜色
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    //    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
    
    //设置tabbar图片文字颜色
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:18/255.0 green:104/255.0 blue:253/255.0 alpha:1.0]];
    //    [[UITabBar appearance] setTintColor:[UIColor orangeColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetMessageCount:) name:@"sendMessageToBadge" object:nil];
}

-(void)resetMessageCount:(NSNotification *)sender
{
    if ([sender.object isEqualToString:@"0"])
    {
        thirdNavi.tabBarItem.badgeValue = nil;
        return;
    }
    thirdNavi.tabBarItem.badgeValue = sender.object;
    [self messageSoundRemaind];
}

-(void)messageSoundRemaind
{
    NSString *strPath = [[NSBundle mainBundle]pathForResource:@"sms01" ofType:@"mp3"];
    
    NSData * voiceData = [[NSData alloc]initWithContentsOfFile:strPath];
    
    messageSound = [[AVAudioPlayer alloc]initWithData:voiceData error:nil];
    
    
    if ([messageSound isPlaying])
    {
        [messageSound stop];
    }
    else
    {
        [messageSound play];
    }
    
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
}

@end
