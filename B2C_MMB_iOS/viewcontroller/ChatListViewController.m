//
//  ChatListViewController.m
//  B2C_MMB_iOS
//
//  Created by developer on 14-11-4.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//
#import "ChatListViewController.h"
#import "AppDelegate.h"
#import "WaitViewController.h"
#import "Reachability.h"

@interface ChatListViewController ()
{
    UILabel *noNet;
    UIImageView *noNetView;
    UILabel *noNetMessage;
}

@end

int flagPage = 0;

@implementation ChatListViewController
@synthesize memberTableView;
@synthesize tempArray;
@synthesize fromString;

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
    self.view.backgroundColor = [UIColor colorWithRed:16.0/255 green:78.0/255 blue:139.0/255 alpha:1.0];
    //导航栏标题
    UILabel *naviTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,190, 44)];
    naviTitle.textColor = [UIColor blackColor];
    naviTitle.backgroundColor = [UIColor clearColor];
    naviTitle.textAlignment = NSTextAlignmentCenter;
    naviTitle.text = @"客服分组";
    self.navigationItem.titleView = naviTitle;
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction)];
    
    self.memberTableView = [[UITableView alloc] initWithFrame:CGRectMake(5,7, self.view.frame.size.width-10, self.view.frame.size.height-147) style:UITableViewStylePlain];
    self.memberTableView.dataSource = self;
    self.memberTableView.delegate = self;
    if (self.appDelegate.roster.count >= 7)
    {
        self.memberTableView.scrollEnabled = YES;
    }
    else
    {
        self.memberTableView.scrollEnabled = NO;
    }
    self.memberTableView.backgroundColor = [UIColor clearColor];
    self.memberTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    self.memberTableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.memberTableView];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-140, self.view.frame.size.width, 2)];
    separatorView.backgroundColor = [UIColor redColor];
    [self.view insertSubview:separatorView atIndex:1];
    
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-138, self.view.frame.size.width, 80)];
    timeView.backgroundColor = [UIColor colorWithRed:54.0/255 green:54.0/255 blue:54.0/255 alpha:1.0];
    [self.view insertSubview:timeView atIndex:1];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(0,3, self.view.frame.size.width, 30);
    label1.text = @"人工客服时间";
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:16];
    [timeView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(0, 35, self.view.frame.size.width, 30);
    label2.text = @"09:00 - 21:00";
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:22];
    [timeView addSubview:label2];
    
    //自定义网络状态提示视图
    noNet = [[UILabel alloc] init];
    noNet.frame = CGRectMake(0, 0, self.view.frame.size.width,32);
    noNet.backgroundColor = [UIColor colorWithRed:255.0/255 green:160.0/255.0 blue:122.0/255.0 alpha:1.0];
    noNet.hidden = YES;
    [self.view insertSubview:noNet atIndex:1];
    
    noNetView = [[UIImageView alloc] init];
    noNetView.frame = CGRectMake(20, 6, 20, 20);
    noNetView.image = [UIImage imageNamed:@"ico_error"];
    [self.view insertSubview:noNetView atIndex:2];
    
    noNetMessage = [[UILabel alloc] init];
    noNetMessage.frame = CGRectMake(55, 0, self.view.frame.size.width-55, 32);
    noNetMessage.textColor = [UIColor whiteColor];
    noNetMessage.font = [UIFont systemFontOfSize:15];
    noNetMessage.textAlignment = NSTextAlignmentLeft;
    noNetMessage.text = @"当前网络不可用，请检查网络设置!";
    [self.view insertSubview:noNetMessage atIndex:2];

    //回到首页
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (goToFirstPage:) name:@"goToFirstfPage" object:nil];
    
    //服务器忙消息通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (ServerisBusy:) name:@"errorMessage" object:nil];
    
    //接收网络断开消息通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (NetisDisconnection:) name:@"netErrorMessage" object:nil];
    
    //接收网络连接消息通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (NetisConnection:) name:@"NetisConnect" object:nil];
    
    //接收分组列表
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (memberGroupList:) name:@"memberGroupName" object:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:YES];
    [self checkNet];
    [self reloadMemberList];
    //检查服务器是否连接
    if ([[self appDelegate].xmppStream isDisconnected])
    {
//        [self showTopMessage:@"服务器未连接，请稍后重试！"];
    }
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view tag] == 101)
        {
            [view setHidden:YES];
        }
        if([view isKindOfClass:[UISearchBar class]])
        {
            [view setHidden:YES];
        }
    }
}

//网络连接后刷新加载客服列表
-(void)reloadMemberList
{
    if (self.appDelegate.roster.count == 0)
    {
        [self.appDelegate reConnect];
        [self.memberTableView removeFromSuperview];
        self.tempArray = self.appDelegate.roster;
        self.memberTableView = [[UITableView alloc] initWithFrame:CGRectMake(5,7, self.view.frame.size.width-10, self.view.frame.size.height-147) style:UITableViewStylePlain];
        self.memberTableView.dataSource = self;
        self.memberTableView.delegate = self;
        if (self.appDelegate.roster.count >= 7)
        {
            self.memberTableView.scrollEnabled = YES;
        }
        else
        {
            self.memberTableView.scrollEnabled = NO;
        }
        self.memberTableView.backgroundColor = [UIColor clearColor];
        self.memberTableView.separatorColor = [UIColor clearColor];
        self.memberTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        [self.view addSubview:self.memberTableView];
    }
    else
    {
        self.tempArray = self.appDelegate.roster;
    }
}

//检查网络是否连接
-(void)checkNet
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([r currentReachabilityStatus]==NotReachable)
    {
        noNet.hidden = NO;
        noNetView.hidden = NO;
        noNetMessage.hidden = NO;
    }
    else
    {
        noNet.hidden = YES;
        noNetView.hidden = YES;
        noNetMessage.hidden = YES;
    }
}

//服务器繁忙提示
-(void)ServerisBusy:(NSNotification *)busyMessage
{
//    noNetMessage.text = @"服务器忙，请稍后重试!";
}

//网络已连接提示
-(void)NetisConnection:(NSNotification *)NetisConnectionMessage
{
    noNet.hidden = YES;
    noNetView.hidden = YES;
    noNetMessage.hidden = YES;
    [self reloadMemberList];
}

//网络未连接提示
-(void)NetisDisconnection:(NSNotification *)busyMessage
{
    noNet.hidden = NO;
    noNetView.hidden = NO;
    noNetMessage.hidden = NO;
}

//获取客服组列表提示
-(void)memberGroupList:(NSNotification *)memberList
{
    [self.memberTableView removeFromSuperview];
    self.tempArray = memberList.object;
    self.memberTableView = [[UITableView alloc] initWithFrame:CGRectMake(5,7, self.view.frame.size.width-10, self.view.frame.size.height-147) style:UITableViewStylePlain];
    self.memberTableView.dataSource = self;
    self.memberTableView.delegate = self;
    if (self.appDelegate.roster.count >= 7)
    {
        self.memberTableView.scrollEnabled = YES;
    }
    else
    {
        self.memberTableView.scrollEnabled = NO;
    }
    self.memberTableView.backgroundColor = [UIColor clearColor];
    self.memberTableView.separatorColor = [UIColor clearColor];
    self.memberTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.memberTableView];
}

-(void)goToFirstPage:(NSNotification *)newMessage
{
    if ([self.fromString isEqualToString:@"首页在线客服"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if([self.fromString isEqualToString:@"来自快速询价客服"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if([self.fromString isEqualToString:@"热门型号在线咨询"])
    {
        flagPage = 1;
    }
    else
    {
        [self.tabBarController setSelectedIndex:0];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if (flagPage == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)goBackAction
{
    if ([self.fromString isEqualToString:@"首页在线客服"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if([self.fromString isEqualToString:@"来自快速询价客服"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if([self.fromString isEqualToString:@"热门型号在线咨询"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.tabBarController setSelectedIndex:0];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
   [self.navigationController.tabBarController.tabBar setHidden:NO];
    self.navigationController.tabBarItem.badgeValue = nil;
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
        view.backgroundColor = [UIColor colorWithRed:16.0/255 green:78.0/255 blue:139.0/255 alpha:1.0];
        [cell.contentView addSubview:view];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor colorWithRed:232.0/255 green:232.0/255 blue:232.0/255 alpha:1.0];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.tempArray[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WaitViewController *waitVC = [[WaitViewController alloc] init];
    waitVC.tempGroup = [NSString stringWithFormat:@"%@",self.tempArray[indexPath.row]];
    waitVC.tempFrom = self.fromString;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =  kCATransitionMoveIn;
    transition.subtype =  kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:waitVC animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
