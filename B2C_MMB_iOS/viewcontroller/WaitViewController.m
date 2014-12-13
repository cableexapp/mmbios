//
//  WaitViewController.m
//  B2C_MMB_iOS
//
//  Created by developer on 14-11-4.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "WaitViewController.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "Reachability.h"
#import "FBShimmeringView.h"
#import "SpeedAskPriceFirstViewController.h"
#import "SpeedAskPriceSecondViewController.h"


double secondsCountDown =0;

@interface WaitViewController ()
{
    NSTimer *timeCountTimer;
    UILabel *label3;
    UILabel *label4;
    NSString *memberCount;
    int tempCount;
    UILabel *naviTitle;
    UILabel *noNet;
    UIImageView *noNetView;
    UILabel *noNetMessage;
    FBShimmeringView *shimmeringView;
    UIStoryboard *sb;
}


@end

@implementation WaitViewController
@synthesize tempGroup;
@synthesize xmppRoom;
@synthesize tempFrom;

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
    self.view.backgroundColor = [DCFColorUtil colorFromHexRGB:@"#f1f1f1"];

    //导航栏标题
    naviTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,190, 44)];
    naviTitle.textColor = [UIColor whiteColor];
    naviTitle.backgroundColor = [UIColor clearColor];
    naviTitle.textAlignment = NSTextAlignmentCenter;
    naviTitle.font = [UIFont systemFontOfSize:20];
    naviTitle.text = @"等候咨询";
    self.navigationItem.titleView = naviTitle;
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0,0, 15,22);
    [btn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBack) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-150, self.view.frame.size.width, 2)];
    separatorView.backgroundColor = [DCFColorUtil colorFromHexRGB:@"#1465ba"];
    [self.view insertSubview:separatorView atIndex:1];
    
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-148, self.view.frame.size.width, 90)];
    timeView.backgroundColor = [DCFColorUtil colorFromHexRGB:@"#f1f1f1"];
    [self.view addSubview:timeView];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(0,8, self.view.frame.size.width, 30);
    label1.text = @"人工客服时间";
    label1.textColor = [DCFColorUtil colorFromHexRGB:@"#666666"];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:18];
    [timeView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(0, 38, self.view.frame.size.width, 30);
    label2.text = @"09:00 - 21:00";
    label2.textColor = [DCFColorUtil colorFromHexRGB:@"#666666"];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:24];
    [timeView addSubview:label2];

    //自定义网络状态通知视图
    noNet = [[UILabel alloc] init];
    noNet.frame = CGRectMake(0, 0, self.view.frame.size.width,32);
    noNet.backgroundColor = [DCFColorUtil colorFromHexRGB:@"#fff3bb"];
    noNet.hidden = YES;
    [self.view insertSubview:noNet atIndex:1];
    
    noNetView = [[UIImageView alloc] init];
    noNetView.frame = CGRectMake(20, 6, 20, 20);
    noNetView.image = [UIImage imageNamed:@"ico_error"];
    [self.view insertSubview:noNetView atIndex:2];
    
    noNetMessage = [[UILabel alloc] init];
    noNetMessage.frame = CGRectMake(55, 0, self.view.frame.size.width-55, 32);
    noNetMessage.textColor = [DCFColorUtil colorFromHexRGB:@"333333"];
    noNetMessage.font = [UIFont systemFontOfSize:15];
    noNetMessage.textAlignment = NSTextAlignmentLeft;
    noNetMessage.text = @"当前网络不可用，请检查网络设置!";
    [self.view insertSubview:noNetMessage atIndex:2];
    
    timeCountTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod)  userInfo:nil repeats:YES];
    
    shimmeringView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(0, 190, self.view.frame.size.width, 30)];
    [self.view addSubview:shimmeringView];
    
    label3 = [[UILabel alloc] init];
    label3.frame = shimmeringView.bounds;
    label3.textColor = [DCFColorUtil colorFromHexRGB:@"#1465ba"];
    label3.font = [UIFont systemFontOfSize:16];
    label3.textAlignment  = 1;
    label3.text = NSLocalizedString(@"您正在进入队列，请稍后...", nil);
    shimmeringView.contentView = label3;
    shimmeringView.shimmering = YES;
    
    label4 = [[UILabel alloc] init];
    label4.frame = CGRectMake(0, 140, self.view.frame.size.width, 60);
    label4.textColor = [DCFColorUtil colorFromHexRGB:@"#1465ba"];
    label4.font = [UIFont systemFontOfSize:80];
    label4.textAlignment  = 1;
    [self.view addSubview:label4];
    
    self.progressView = [[PICircularProgressView alloc] init];
    self.progressView.frame = CGRectMake(20, 50, 280, 240);
    self.progressView.thicknessRatio = 0.09;
    self.progressView.outerBackgroundColor = [DCFColorUtil colorFromHexRGB:@"#dddddd"];
    self.progressView.progressFillColor = [DCFColorUtil colorFromHexRGB:@"#1465ba"];
    self.progressView.showText = NO;
    self.progressView.textColor = [UIColor whiteColor];
    [self.view addSubview:self.progressView];
    
    //接收服务端自动回复
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (autoMessageToServer:) name:@"joinRoomMessage" object:nil];
    
    //关闭当前模态视图
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (backToFront:) name:@"disMissSelfPage" object:nil];
    
    //重置等待排队环形计时初值
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (resetSecondsCountDown:) name:@"resetCount" object:nil];
    
    //服务器忙消息通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (ServerisBusy:) name:@"errorMessage" object:nil];
    
    //接收网络断开消息通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (NetisDisconnection:) name:@"netErrorMessage" object:nil];
    
    //接收网络连接消息通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (NetisConnection:) name:@"NetisConnect" object:nil];
    
    //接收返回在线咨询入口页
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (goToAskPrice:) name:@"goToAskPricePage" object:nil];
    
    //发起请求加入咨询队列
    [self sendJoinRequest];
}


-(void)goBack
{
    [timeCountTimer invalidate];
    [self exitQueue];
    [self.appDelegate goOffline];
    [self.appDelegate disconnect];
    [self.appDelegate reConnect];
    if ([self.tempFrom isEqualToString:@"首页在线客服"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        [self.navigationController.tabBarController.tabBar setHidden:NO];
    }
    else if([self.tempFrom isEqualToString:@"来自快速询价客服"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }
    else if([self.tempFrom isEqualToString:@"热门型号在线咨询"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    else if([self.tempFrom isEqualToString:@"场合选择客服"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    else if([self.tempFrom isEqualToString:@"场合选择提交成功客服"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    else if([self.tempFrom isEqualToString:@"热门分类在线客服"])
    {
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
    }
    else if([self.tempFrom isEqualToString:@"热门型号提交成功在线客服"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:4] animated:YES];
    }
    else
    {
        [self.tabBarController setSelectedIndex:0];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        [self.navigationController.tabBarController.tabBar setHidden:NO];
    }
    if ([self.tempFrom rangeOfString:@"@"].location != NSNotFound)
    {
        if([[[self.tempFrom componentsSeparatedByString:@"@"] objectAtIndex:1] isEqualToString:@"家装线商品详情"])
        {
            if (self.navigationController.viewControllers.count == 6)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
            }
            if (self.navigationController.viewControllers.count == 5)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            }
            if (self.navigationController.viewControllers.count == 4)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToFirstfPage" object:nil];
}

//退出队列
-(void)exitQueue
{
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"id" stringValue:[[self.appDelegate.uesrID componentsSeparatedByString:@"@"] objectAtIndex:1]];
    [iq addAttributeWithName:@"to"stringValue:self.tempGroup];
    [iq addAttributeWithName:@"type"stringValue:@"set"];
    NSXMLElement *query = [NSXMLElement elementWithName:@"depart-queue"];
    [query addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/workgroup"];
    [iq addChild:query];
    [[self xmppStream] sendElement:iq];
}

-(void)resetSecondsCountDown:(NSNotification *)newMessage
{
    secondsCountDown = 0;
}

-(void)backToFront:(NSNotification *)newMessage
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [super.navigationController.tabBarController.tabBar setHidden:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToFirstfPage" object:nil];
}

-(void)timeFireMethod
{
    secondsCountDown += 5;
    if (secondsCountDown ==100)
    {
        secondsCountDown =0;
    }
    self.progressView.progress = secondsCountDown;

    if (self.appDelegate.uesrID != nil)
    {
        [timeCountTimer invalidate];
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        chatVC.fromStringFlag = self.tempFrom;
        [self presentViewController:chatVC animated:YES completion:nil];
    }
    else if(tempCount >= 1)
    {
        label4.text = memberCount;
        label3.frame = CGRectMake(0, shimmeringView.bounds.size.height-5, self.view.frame.size.width, 30);
        label3.font = [UIFont systemFontOfSize:17];
        label3.text = NSLocalizedString(@"您之前的用户数", nil);
        shimmeringView.shimmering = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self checkNet];
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
        [timeCountTimer invalidate];
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
}

//网络未连接提示
-(void)NetisDisconnection:(NSNotification *)busyMessage
{
    noNet.hidden = NO;
    noNetView.hidden = NO;
    noNetMessage.hidden = NO;
    [timeCountTimer invalidate];
}

-(void)sendJoinRequest
{
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:@"join"];
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    [mes addAttributeWithName:@"to" stringValue:self.tempGroup];
    [mes addAttributeWithName:@"type" stringValue:@"groupchat"];
    [mes addChild:body];
    [[self xmppStream] sendElement:mes];
}

//请求连接客服
-(void)autoMessageToServer:(NSNotification *)newMessage
{
    if ([newMessage.object isEqualToString:@"Would you like to join the chat, yes or no?"])
    {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:@"yes"];
        NSXMLElement *mess = [NSXMLElement elementWithName:@"message"];
        [mess addAttributeWithName:@"to" stringValue:self.tempGroup];
        [mess addAttributeWithName:@"type" stringValue:@"groupchat"];
        [mess addChild:body];
        [[self xmppStream] sendElement:mess];
    }
    else if ([newMessage.object isEqualToString:@"Email Address:"])
    {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:@"iOS_app_user@cableex.com"];
        NSXMLElement *mess = [NSXMLElement elementWithName:@"message"];
        [mess addAttributeWithName:@"to" stringValue:self.tempGroup];
        [mess addAttributeWithName:@"type" stringValue:@"groupchat"];
        [mess addChild:body];
        [[self xmppStream] sendElement:mess];
    }
    else if ([newMessage.object isEqualToString:@"Name:"])
    {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:self.appDelegate.chatRequestJID];
        NSXMLElement *mess = [NSXMLElement elementWithName:@"message"];
        [mess addAttributeWithName:@"to" stringValue:self.tempGroup];
        [mess addAttributeWithName:@"type" stringValue:@"groupchat"];
        [mess addChild:body];
        [[self xmppStream] sendElement:mess];
    }
    else if ([newMessage.object isEqualToString:@"Question:"])
    {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:@"在线咨询"];
        NSXMLElement *mess = [NSXMLElement elementWithName:@"message"];
        [mess addAttributeWithName:@"to" stringValue:self.tempGroup];
        [mess addAttributeWithName:@"type" stringValue:@"groupchat"];
        [mess addChild:body];
        [[self xmppStream] sendElement:mess];
    }
    if([newMessage.object rangeOfString:@"Your current position in the queue is"].location !=NSNotFound)
    {
        memberCount = [[[[newMessage.object componentsSeparatedByString:@"is"] objectAtIndex:1] componentsSeparatedByString:@" "] objectAtIndex:1];
        tempCount = [[[[[newMessage.object componentsSeparatedByString:@"is"] objectAtIndex:1] componentsSeparatedByString:@" "] objectAtIndex:1] intValue];
    }
    if ([newMessage.object isEqualToString:@"This workgroup is currently closed"])
    {
        [timeCountTimer invalidate];
        [self isBetweenFromHour:9 toHour:21];
    }
}

- (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
{
    NSDate *dateFrom = [self getCustomDateWithHour:fromHour];
    NSDate *dateTo = [self getCustomDateWithHour:toHour];
    NSDate *currentDate = [NSDate date];
    if ([currentDate compare:dateFrom]==NSOrderedDescending && [currentDate compare:dateTo]==NSOrderedAscending)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"电缆买卖宝提示"
                                                            message:@"尊敬的客户，现在暂时没有客服在线，请前往提交快速询价需求，我们将在收到需求的第一时间回复您!"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"取消",@"好的",nil];
        [alertView show];
        naviTitle.text = @"暂无在线客服";
        label3.font = [UIFont systemFontOfSize:18];
        label3.frame = CGRectMake(0, shimmeringView.bounds.size.height-55, self.view.frame.size.width, 30);
        label3.text = NSLocalizedString(@"暂时没有客服在线!", nil);
        return YES;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"电缆买卖宝提示"
                                                            message:@"尊敬的客户，客服工作时间为9：00-21:00，请前往提交快速询价需求，我们将在收到需求的第一时间回复您!"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"取消",@"好的",nil];
        [alertView show];
        naviTitle.text = @"暂无在线客服";
        label3.font = [UIFont systemFontOfSize:18];
        label3.frame = CGRectMake(0, shimmeringView.bounds.size.height-55, self.view.frame.size.width, 30);
        label3.text = NSLocalizedString(@"现在不是工作时间!", nil);
    }
    return NO;
}

- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self setHidesBottomBarWhenPushed:YES];
        SpeedAskPriceFirstViewController *speedAskPriceFirstViewController = [sb instantiateViewControllerWithIdentifier:@"speedAskPriceFirstViewController"];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type =  kCATransitionMoveIn;
        transition.subtype =  kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:speedAskPriceFirstViewController animated:NO];
    }
    else if (buttonIndex == 0)
    {
        if ([self.tempFrom isEqualToString:@"首页在线客服"])
        {
            [self.tabBarController setSelectedIndex:0];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
        else if([self.tempFrom isEqualToString:@"来自快速询价客服"])
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
        }
       
        else if([self.tempFrom isEqualToString:@"场合选择客服"])
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            
        }
        else if([self.tempFrom isEqualToString:@"热门型号在线咨询"])
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
           
        }
        else if([self.tempFrom isEqualToString:@"场合选择提交成功客服"])
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
        }
        else if([self.tempFrom isEqualToString:@"热门型号提交成功在线客服"])
        {
             NSLog(@"self.navigationController.viewControllers.count = %d",self.navigationController.viewControllers.count);
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:4] animated:YES];
        }
        else if([self.tempFrom isEqualToString:@"热门分类在线客服"])
        {
            [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -3)] animated:YES];
            
        }
        else
        {
            [self.tabBarController setSelectedIndex:0];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
        if ([self.tempFrom rangeOfString:@"@"].location != NSNotFound)
        {
            if([[[self.tempFrom componentsSeparatedByString:@"@"] objectAtIndex:1] isEqualToString:@"家装线商品详情"])
            {
                if (self.navigationController.viewControllers.count == 6)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
                }
                if (self.navigationController.viewControllers.count == 5)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                }
                if (self.navigationController.viewControllers.count == 4)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }
            }
        }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"goToFirstfPage" object:nil];
    }
}

-(void)goToAskPrice:(NSNotification *)newMessage
{
    if([self.tempFrom isEqualToString:@"来自快速询价客服"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }
    else if([self.tempFrom isEqualToString:@"热门型号在线咨询"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    else if([self.tempFrom isEqualToString:@"场合选择客服"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    else if([self.tempFrom isEqualToString:@"场合选择提交成功客服"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
    }
    else if([self.tempFrom isEqualToString:@"热门型号提交成功在线客服"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:4] animated:YES];
    }
    else if([self.tempFrom isEqualToString:@"热门分类在线客服"])
    {
        [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -3)] animated:YES];
    }
    if ([self.tempFrom rangeOfString:@"@"].location != NSNotFound)
    {
        if([[[self.tempFrom componentsSeparatedByString:@"@"] objectAtIndex:1] isEqualToString:@"家装线商品详情"])
        {
            if (self.navigationController.viewControllers.count == 6)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
            }
            if (self.navigationController.viewControllers.count == 5)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            }
            if (self.navigationController.viewControllers.count == 4)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        }
    }
}
- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(XMPPStream *)xmppStream
{
    return [[self appDelegate] xmppStream];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
