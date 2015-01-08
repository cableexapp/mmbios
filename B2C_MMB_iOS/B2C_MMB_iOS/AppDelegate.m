
//
//  AppDelegate.m
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-8-29.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "MCDefine.h"
#import "PhoneHelper.h"
#import "DCFStringUtil.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "MCDefine.h"
#import "DCFRootNaviController.h"
#import "DCFTabBarCtrl.h"
#import "DCFCustomExtra.h"
#import <CommonCrypto/CommonDigest.h>
#import "WelComeViewController.h"
#import "UIImage (fixOrientation).h"
#import "BPush.h"
#import "MobClick.h"
#import "LoginNaviViewController.h"
#import <AlipaySDK/AlipaySDK.h>

#define SUPPORT_IOS8 1

//XMPP
#import <AudioToolbox/AudioToolbox.h>
#import "XMPPStream.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "NSXMLElement+XMPP.h"

//讯飞
#import "iflyMSC/IFlySpeechUtility.h"
#define APPID_VALUE   @"546454f4"
#define TIMEOUT_VALUE @"20000"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

NSString *strUserId = @"";
@implementation AppDelegate
{
    UIStoryboard *sb;
    
    NSString *messageg_noLogin;
    
    NSString *messageg_hasLogin;
}
@synthesize mainQueue;
@synthesize db;

//XMPP
@synthesize personName;
@synthesize sendMessageInfo;
@synthesize roster;
//@synthesize xmppRosterStorage;
@synthesize xmppStream;
@synthesize xmppRoom;
@synthesize uesrID;
@synthesize chatRequestJID;
@synthesize roomJID;

@synthesize pushChatView;
@synthesize isOnLine;
@synthesize tempID;
@synthesize errorMessage;
@synthesize isConnect;


- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability *curReach = [note object];
    if (![curReach isKindOfClass:[Reachability class]])
        return;
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:  //无网络
        {
            [DCFStringUtil showNotice:@"似乎断开了互联网连接"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"netErrorMessage" object:nil];
        }
            break;
        case ReachableViaWWAN:  //使用3g/gprs网络
        {
//            [self reConnect];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NetisConnect" object:nil];
        }
            break;
        case ReachableViaWiFi:  //使用wifi网络
        {
//            [self reConnect];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NetisConnect" object:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

-(NSString*) getUdid
{
    NSString *udid = [PhoneHelper getDeviceId];
    return udid;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [BPush registerDeviceToken:deviceToken]; // 必须
    [BPush bindChannel]; // 必须。可以在其它时机调用，只有在该方法返回（通过onMethod:response:回调）绑定成功时，app才能接收到Push消息。一个app绑定成功至少一次即可（如果access token变更请重新绑定）。
}


- (void) onMethod:(NSString*)method response:(NSDictionary*)data
{
    if ([BPushRequestMethod_Bind isEqualToString:method])
    {
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        
        self.appId = [res valueForKey:BPushRequestAppIdKey];
        self.baiduPushUserId = [res valueForKey:BPushRequestUserIdKey];
        self.channelId = [res valueForKey:BPushRequestChannelIdKey];
//        NSLog(@"appId = %@  baiduPushUserId = %@   channelId = %@",self.appId,self.baiduPushUserId,self.channelId);
        
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        
        //        BPushRequestResponseParamsKey
    }
    else if ([BPushRequestMethod_Unbind isEqualToString:method])
    {
        
    }
}

#pragma mark - 推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
//    NSLog(@"%@",userInfo);
    
    NSString *pushTitle = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    _key1 = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"key1"]];
    _key2 = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"key2"]];
    _key3 = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"key3"]];
    //    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    //    NSLog(@"memberId = %@",memberid);
    //    if([_key2 isEqualToString:memberid])
    //    {
    
    
//    NSLog(@"修改memberid");
    
    if (application.applicationState == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:pushTitle
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    [application setApplicationIconBadgeNumber:0];
    
    if([_key1 intValue] == 3)
    {
        _isB2BPush = YES;
        _isB2CPush = NO;
    }
    else if ([_key1 intValue] == 4)
    {
        _isB2BPush = NO;
        _isB2CPush = YES;
    }
    
//    [[NSUserDefaults standardUserDefaults] setObject:_key2 forKey:@"memberId"];
    
    //    UIStoryboard *FourthSB = [UIStoryboard storyboardWithName:@"FourthSB" bundle:nil];
    //    if([DCFCustomExtra validateString:memberid] == NO)
    //    {
    //
    //    }
    //    else
    //    {
    [BPush handleNotification:userInfo];
    //    }
}


#if SUPPORT_IOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif

- (void)onlineConfigCallBack:(NSNotification *)note
{
    
}

- (void)umengTrack
{
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];

    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#pragma mark - 修改测试
    //检测是否第一次安装，还是第一次启动
    [self isFirstOpen];
    
    //信号栏字体为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //创建讯飞语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",APPID_VALUE,TIMEOUT_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
    //友盟
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    
    //百度云推送
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    
    [application setApplicationIconBadgeNumber:0];
#if SUPPORT_IOS8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
#endif
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    self.roster  = [[NSMutableArray alloc] init];
    
    //xmpp初始化
    [self setupStream];
    
    
    

    //数据库创建
    [self SQLDataSteup];
    
    NSString *p = [[NSBundle mainBundle] pathForResource:@"t_prov_city_area_street" ofType:@"db"];
    //    sqlite3 *dataBase;
    //    if(sqlite3_open([p UTF8String], &dataBase) != SQLITE_OK)
    
    NSString *userId = [NSString stringWithFormat:@"%@",@"12345"];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    if (hasLogin == YES)
    {
        NSString *tempUserName = [[NSUserDefaults standardUserDefaults]  objectForKey:@"app_username"];
        [[NSUserDefaults standardUserDefaults] setObject:tempUserName forKey:@"userName_IM"];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[PhoneHelper getDeviceId] forKey:@"userName_IM"];
    }
    NSLog(@"IM_name = %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName_IM"]);
    [self connect]; //连接openfire
    
    //启动页滞留2秒
    [NSThread sleepForTimeInterval:2.0];
    
   
    
    //接收关闭推送
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"closeOrOpenPush"])
    {
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeAlert
         | UIRemoteNotificationTypeBadge
         | UIRemoteNotificationTypeSound];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"closeOrOpenPush"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"closeOrOpenPush"] boolValue] == YES)
        {
            [application registerForRemoteNotificationTypes:
             UIRemoteNotificationTypeAlert
             | UIRemoteNotificationTypeBadge
             | UIRemoteNotificationTypeSound];
        }
        else
        {
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        }
    }
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"] )
    {
        WelComeViewController *welcome = [sb instantiateViewControllerWithIdentifier:@"welComeViewController"];
        self.window.rootViewController = welcome;
        [[NSUserDefaults standardUserDefaults] setObject:[PhoneHelper getDeviceId] forKey:@"userName_IM"];
        
        
    }

    

   
    

    [PhoneHelper sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    mainQueue = [[NSOperationQueue alloc] init] ;
    [self.mainQueue setMaxConcurrentOperationCount:30];
    
    [self loadFMDB];
    
    return YES;
}

-(void)isFirstOpen
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
}

- (void) loadFMDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    if(!documentDirectory)
    {
        //        NSLog(@"Not Found!");
        return;
    }
    
    
    //NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDB.db"];
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"t_prov_city_area_street" ofType:@"db"];
    
    //self.db = [[FMDatabase alloc] initWithPath:dbPath];
    self.db = [FMDatabase databaseWithPath:dbPath];
    [self.db setLogsErrors:YES];
    [self.db setTraceExecution:YES];
    [self.db setCrashOnErrors:YES];
    [self.db setShouldCacheStatements:YES];
    
    [self.db open];
    [self openDatabase];
}

- (void) openDatabase
{
    if(![self.db open])
    {
        return;
    }
    [self.db beginTransaction];
    
    //    //用户集合
    //    if(![self.db tableExists:@"UserIdCollection"])
    //    {
    //        [self.db executeQuery:@"CREATE TABLE UserIdCollection (Name text,UserId text)"];
    //    }
    //
    //    //主页用户查询商品集合
    //    if(![self.db tableExists:@"HostCabelCollection"])
    //    {
    //        [self.db executeQuery:@"CREATE TABLE HostCabelCollection (SearchCabelName text,UserId text)"];
    //    }
    [self.db commit];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void) logOutMethod
{
    if(_hideNotice == YES)
    {
        
    }
    else
    {
        [DCFStringUtil showNotice:@"您的账号在其他地方登录,请重新登录"];
        self.appDelegate.isConnect = @"断开";
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"app_username"];
        [[NSUserDefaults standardUserDefaults] setObject:[PhoneHelper getDeviceId] forKey:@"userName_IM"];
        //切换登录账号，结束之前对话
        [self.appDelegate goOffline];
        [self.appDelegate disconnect];
        [self.appDelegate reConnect];
    }
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"deleteAppCartItems",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    
    NSString *visitorid = [self getUdid];
    
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    if([DCFCustomExtra validateString:memberid] == NO)
    {
        memberid = @"";
    }
    NSString *pushString = nil;
    if(hasLogin == YES)
    {
        pushString = [NSString stringWithFormat:@"memberid=%@&token=%@",memberid,token];
    }
    else
    {
        pushString = [NSString stringWithFormat:@"visitorid=%@&token=%@",visitorid,token];
    }
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLDeleteAppCartItemsTag delegate:self];
    conn.LogOut = YES;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/deleteAppCartItems.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLDeleteAppCartItemsTag)
    {
        int result = [[dicRespon objectForKey:@"result"] intValue];
        if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            
        }
        if(result == 0)
        {
            
        }
        else if(result == 1 || result == 99)
        {
            [DCFCustomExtra cleanData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hasLogOut" object:[NSNumber numberWithBool:YES]];
            
            [self performSelector:@selector(EnterToLogin) withObject:nil afterDelay:2.5];
        }
    }
}

- (void) EnterToLogin
{
    DCFTabBarCtrl *tabbar = [sb instantiateViewControllerWithIdentifier:@"dcfTabBarCtrl"];
    self.window.rootViewController = tabbar;
    [tabbar setSelectedIndex:3];
}

- (void) aliPayChange
{
    _aliPayHasFinished = YES;
    
    DCFTabBarCtrl *tabbar = [sb instantiateViewControllerWithIdentifier:@"dcfTabBarCtrl"];
    self.window.rootViewController = tabbar;
    [tabbar setSelectedIndex:3];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
//             NSLog(@"result = %@", resultDic);
             if([[resultDic allKeys] count] == 0 || [resultDic isKindOfClass:[NSNull class]])
             {
                 
             }
             else
             {
                 NSString *resultStatus = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]];
//                 NSLog(@"resultStatus = %@",resultStatus);
                 
                 DCFTabBarCtrl *tabbar = [sb instantiateViewControllerWithIdentifier:@"dcfTabBarCtrl"];
                 self.window.rootViewController = tabbar;
                 [tabbar setSelectedIndex:3];
                 
                 _aliPayHasFinished = YES;
             }
         }];
    }
    
    return YES;
}

//独立客户端回调函数
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //	[self parse:url application:application];
	return YES;
}
//
//- (void)parse:(NSURL *)url application:(UIApplication *)application {
//
//    //结果处理
//    AlixPayResult* result = [self handleOpenURL:url];
//
//
//	if (result)
//    {
//
//
//		if (result.statusCode == 9000)
//        {
//			/*
//			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
//			 */
//
//            //交易成功
//            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
//			id<DataVerifier> verifier;
//            verifier = CreateRSADataVerifier(key);
//
//			if ([verifier verifyString:result.resultString withSign:result.signString])
//            {
//                //验证签名成功，交易结果无篡改
//			}
//
//            DCFTabBarCtrl *tabbar = [sb instantiateViewControllerWithIdentifier:@"dcfTabBarCtrl"];
//            self.window.rootViewController = tabbar;
//            [tabbar setSelectedIndex:3];
//
//            _aliPayHasFinished = YES;
//        }
//        else
//        {
//            //交易失败
//            _aliPayHasFinished = NO;
//        }
//    }
//    else
//    {
//        //失败
//        _aliPayHasFinished = NO;
//    }
//}
//
//- (AlixPayResult *)resultFromURL:(NSURL *)url {
//	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//#if ! __has_feature(objc_arc)
//    return [[[AlixPayResult alloc] initWithString:query] autorelease];
//#else
//	return [[AlixPayResult alloc] initWithString:query];
//#endif
//}
//
//- (AlixPayResult *)handleOpenURL:(NSURL *)url {
//	AlixPayResult * result = nil;
//
//	if (url != nil && [[url host] compare:@"safepay"] == 0) {
//		result = [self resultFromURL:url];
//	}
//
//	return result;
//}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"message_Push"];
    //接收客服会话通知栏推送
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (chatRoomMessage:) name:@"chatRoomMessagePush" object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self reConnect];
    [self queryRoster];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //当程序恢复活跃的时候 连接上xmpp聊天服务器
    [self reConnect];
    [self queryRoster];
    
    NSLog(@"程序进入前台+++++++++++++++");
    
    if(self.isB2CPush == YES || self.isB2BPush == YES)
    {
        DCFTabBarCtrl *tabbar = [sb instantiateViewControllerWithIdentifier:@"dcfTabBarCtrl"];
        self.window.rootViewController = tabbar;
        [tabbar setSelectedIndex:3];
    }
}

//点击通知栏推送聊天消息，进入聊天窗口
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if ([self.pushChatView isEqualToString:@"push"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToChatView" object:nil];
    }
}

-(void)chatRoomMessage:(NSNotification *)chatRoomMessage
{
#if SUPPORT_IOS8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else
#endif
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    UILocalNotification *_localNotification;
    if (!_localNotification)
    {
        _localNotification = [[UILocalNotification alloc] init];
        //_localNotification.applicationIconBadgeNumber = 1;
        _localNotification.timeZone = [NSTimeZone defaultTimeZone];
        BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
        if (hasLogin == YES)
        {
            _localNotification.alertBody = messageg_hasLogin;
        }
        else
        {
            _localNotification.alertBody = messageg_noLogin;
        }
        _localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        _localNotification.soundName= UILocalNotificationDefaultSoundName;
        //判断重复与否
        _localNotification.repeatInterval = NSWeekCalendarUnit;
        
        // 设定通知的userInfo，用来标识该通知
        NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:@"mmb_ios_push",@"ydmmbkey",nil];
        
        [_localNotification setUserInfo:dict];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:_localNotification];
        
        NSLog(@"running in the background");
    }
    self.appDelegate.pushChatView = @"push";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushChatView" object:@"push"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if([self.db open] == YES)
    {
        [self.db close];
    }
}

#pragma mark - Xmpp初始化
- (void)setupStream
{
    NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    // 初始化XmppStream
    xmppStream = [[XMPPStream alloc] init];
#if !TARGET_IPHONE_SIMULATOR
    {
        xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    // 初始化 reconnect
    xmppStream.enableBackgroundingOnSocket = YES;
    xmppReconnect = [[XMPPReconnect alloc] init];
    
    // 激活xmpp的模块
    [xmppReconnect         activate:xmppStream];
    [xmppRoster            activate:xmppStream];
    
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 域名和端口
    [xmppStream setHostName:IM_hostName];
    [xmppStream setHostPort:5222];
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSError *error = nil;
    if (![xmppStream authenticateWithPassword:@"cableex123@yd?" error:&error])
    {
    }
    else
    {
        //注册
        [self registerInSide];
        NSLog(@"连接服务器++++++++++++++++++++++");
    }
}

//验证通过上线、
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    [self goonline];
    
    NSLog(@"验证通过上线+++++++++++++++++");
    //如果客服列表数组为空
    if (self.roster.count == 0)
    {
        //查询客服组列表
        [self queryRoster];
    }
}

-(void)goonline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [xmppStream sendElement:presence];
     [self queryRoster];
    NSLog(@"上线goonline++++++++++++++++++++++");
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

//连接服务器
- (BOOL)connect
{
     NSLog(@"connect++++++++++++++++++++++11111");
    if (![xmppStream isDisconnected])
    {
        [self goonline];
        return YES;
    }
    NSLog(@"connect++++++++++++++++++++++22222");
    NSString *username_IM = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName_IM"];
    
    NSString *myJID = [NSString stringWithFormat:@"%@@%@",username_IM,IM_hostName];
    
    NSString *myPassword = @"cableex123@yd?";
    
    if (myJID == nil || myPassword == nil)
    {
        return NO;
    }
    NSLog(@"connect++++++++++++++++++++++333333 = %@",myJID);
    
    [xmppStream setMyJID:[XMPPJID jidWithString:myJID resource:@"Mobile"]];
    
    NSError *error = nil;
    
    if (![xmppStream connect:&error])
    {
        return NO;
    }
    NSLog(@"connect++++++++++++++++++++++444444");
    return YES;
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册帐号成功++++++++++++++++++++++");
    [self disconnect];
    [self reConnect];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSLog(@"账号已注册++++++++++++++++++++ = %@",error.description);
    [self disconnect];
    [self reConnect];
}

//注册
- (void)registerInSide
{
    NSError *error;
    NSString *username_IM = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName_IM"];
    NSString *tjid = [[NSString alloc] initWithFormat:@"%@@%@",username_IM,IM_hostName];
//    [xmppStream setMyJID:[XMPPJID jidWithString:tjid resource:@"Mobile"]];
    
    if([xmppStream isConnected])
    {
        if (![xmppStream registerWithPassword:@"cableex123@yd?" error:&error])
        {
        }
        else
        {
            [xmppStream setMyJID:[XMPPJID jidWithString:tjid]];
            NSLog(@"注册成功++++++++++++++++++++++++");
        }
    }
    else
    {
        [xmppStream setMyJID:[XMPPJID jidWithString:tjid]];
        [self reConnect];
    }
    
}

//注册账号成功后，重新登录连接
- (BOOL)reConnect
{
    NSString *username_IM = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName_IM"];
    NSString *myJID =[NSString stringWithFormat:@"%@@%@",username_IM,IM_hostName];
    NSString *myPassword = @"cableex123@yd?";
    if (![xmppStream isDisconnected])
    {
        [self goonline];
        return YES;
    }
    if (myJID == nil || myPassword == nil)
    {
        return NO;
    }
    XMPPJID *jid = [XMPPJID jidWithString:myJID resource:@"Mobile"];
    [xmppStream setMyJID:jid];
    
    NSError *error = nil;
    
    if (![xmppStream connect:&error])
    {
        return NO;
    }
    return YES;
}


//下线
-(void)goOffline
{
    //    NSLog(@"goOffline");
    if (self.roster.count > 0)
    {
        [self.roster removeAllObjects];
    }
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [xmppStream sendElement:presence];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    
    //取得好友当前状态
    NSString *presenceType = [presence type];
    
    NSLog(@"客服状态presence = %@",presenceType);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noFriendOnLine" object:presenceType];

    if ([presenceType isEqualToString:@"unavailable"])
    {    self.isOnLine = @"unavailable";
        [self goOffline];
        self.uesrID = nil;
    }
    else
    {
        self.isOnLine = @"available";
    }
}

- (void)disconnect
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
    [self.xmppStream disconnect];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
}

//查询客服组列表
- (void)queryRoster
{
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"from" stringValue:self.personName];
    [iq addAttributeWithName:@"id" stringValue:@"disco2"];
    [iq addAttributeWithName:@"to"stringValue:@"workgroup.cableex.com"];
    [iq addAttributeWithName:@"type"stringValue:@"get"];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
    [query addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/disco#items"];
    [iq addChild:query];
    [[self xmppStream] sendElement:iq];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    DDLogVerbose(@"%@", [iq description]);
    if (self.roster.count == 0)
    {
        if ([@"result" isEqualToString:iq.type])
        {
            NSXMLElement *query = iq.childElement;
            if ([@"query" isEqualToString:query.name])
            {
                NSArray *items = [query children];
                for (NSXMLElement *item in items)
                {
                    NSString *jid = [item attributeStringValueForName:@"jid"];
                    XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
                    [self.roster addObject:xmppJID];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"memberGroupName" object:self.roster];
            }
        }
        NSLog(@"self.roster = %@\n\n",self.roster);
    }
    if ([iq.type isEqualToString:@"error"] && [[[[[iq elementsForName:@"error"] objectAtIndex:0] attributeForName:@"type"] stringValue] isEqualToString:@"cancel"])
    {
        //        self.errorMessage = [[[[iq elementsForName:@"error"] objectAtIndex:0] attributeForName:@"type"] stringValue];
        
        
        self.errorMessage = @"cancel";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckTheStatus_offline" object:nil];
    }
    return NO;
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    //消息内容
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString *type= [[message attributeForName:@"type"] stringValue];
    NSString *to= [[message attributeForName:@"to"] stringValue];

    
    //排队等候，队列位置
    if([DCFCustomExtra validateString:[[message.children objectAtIndex:0] elementForName:@"position"].stringValue] == YES)
    {
        self.tempID = [[message.children objectAtIndex:0] elementForName:@"position"].stringValue;
        self.errorMessage = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckTheStatus_online" object:nil];
    }
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    
    NSString *tempUserName = [[NSUserDefaults standardUserDefaults]  objectForKey:@"app_username"];
    
    if([from rangeOfString:@"workgroup"].location !=NSNotFound)
    {
        self.personName = to;
        
        if(hasLogin == YES)
        {
            self.chatRequestJID = tempUserName;
        }
        else
        {
            self.chatRequestJID = [PhoneHelper getDeviceId];
        }
    }
    else if([from rangeOfString:@"conference"].location !=NSNotFound && [from rangeOfString:@"/"].location ==NSNotFound)
    {

        
        self.personName = to;
        self.uesrID = from;
    }
    else
    {
        self.messageCount++;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendMessageToBadge" object:[NSString stringWithFormat:@"%d",self.messageCount]];
        
        if ([forgroudPushMessage isEqualToString:@"前台推送"])
        {
            //接收客服会话通知栏推送
            [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (chatRoomMessage:) name:@"chatRoomMessagePush" object:nil];
        }
        
        if(hasLogin == YES)
        {
            if ([from rangeOfString:tempUserName].location ==NSNotFound)
            {
                messageg_hasLogin = [[message elementForName:@"body"] stringValue];
                if ([messageg_hasLogin rangeOfString:@"null"].location == NSNotFound || [messageg_hasLogin rangeOfString:@"(null)"].location == NSNotFound)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"messageGetting" object:messageg_hasLogin];
                    
                    //获得本地时间
                    NSDate *dates = [NSDate date];
                    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy:MM:dd:HH:mm:ss"];
                    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
                    [formatter setTimeZone:timeZone];
                    NSString *loctime = [formatter stringFromDate:dates];
                    
                    [self recUserId:@"1" toUserId:@"1" toUserName:tempUserName toTime:loctime toMessage:messageg_hasLogin];
                }
                self.personName = to;
            }
        }
        else
        {
            if ([from rangeOfString:[PhoneHelper getDeviceId]].location ==NSNotFound)
            {
                messageg_noLogin = [[message elementForName:@"body"] stringValue];
                if ([messageg_noLogin rangeOfString:@"null"].location == NSNotFound || [messageg_noLogin rangeOfString:@"(null)"].location == NSNotFound)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"messageGetting" object:messageg_noLogin];
                    
                    //获得本地时间
                    NSDate *dates = [NSDate date];
                    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy:MM:dd:HH:mm:ss"];
                    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
                    [formatter setTimeZone:timeZone];
                    NSString *loctime = [formatter stringFromDate:dates];
                    
                    [self recUserId:@"1" toUserId:@"1" toUserName:[self.appDelegate getUdid] toTime:loctime toMessage:messageg_noLogin];
                }
            }
            self.personName = to;
        }
    }
    
    NSRange range=[from rangeOfString:@"@"];
    if(range.length==0)
    {
        return;
    }
//    NSString *fromSimple=[from substringToIndex:range.location];
}

// 发送消息回调方法
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
}


#pragma mark - 数据库创建
-(void)SQLDataSteup
{
    //创建数据库对象
    sqlite3 * dataBase = NULL;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *filePath = [documents stringByAppendingPathComponent:@"ChatMessageList.sqlite"];
    
    //打开数据库
    int result = sqlite3_open([filePath UTF8String],&dataBase);
    
    if (SQLITE_OK == result)
    {
        //创建一个名称为messageList的表
        char * sqlCreate = "CREATE TABLE MESSAGELIST(id integer primary key AutoIncrement, rec_user_id varchar(30),user_id varchar(30),user_name varchar(2000),time varchar(30),message varchar(2000))";
        char * error = NULL;
        
        //执行sql语句
        sqlite3_exec(dataBase, sqlCreate, nil, nil, &error);
        
        
        //版本更新增加新字段creater
        
        //字段增加
        
        char * sqlAdd = "ALTER TABLE MESSAGELIST ADD creater varchar(30)";
        
        sqlite3_exec(dataBase, sqlAdd, nil, nil, &error);
        
        
        //数据库使用完成后关闭数据库
        sqlite3_close(dataBase);
    }
}

#pragma mark - 数据库存入消息
//数据存入本地数据库
-(void)recUserId:(NSString *)recUserId toUserId:(NSString *)userId toUserName:(NSString *)userName toTime:(NSString *)time toMessage:(NSString *)message
{
    sqlite3 * dataBase = NULL;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *filePath = [documents stringByAppendingPathComponent:@"ChatMessageList.sqlite"];
    //打开数据库
    int result = sqlite3_open([filePath UTF8String],&dataBase);
    
    if (SQLITE_OK == result)
    {
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO MESSAGELIST(rec_user_id, user_id, user_name, time, message,creater) values ('%@','%@','%@','%@','%@','%@')",recUserId,userId,userName,time,message,@"0"];
        
        char * error = NULL;
        
        //obj-c字符串和c字符串需要转换
        sqlite3_exec(dataBase, [insert UTF8String], nil, nil, &error);
        sqlite3_close(dataBase);
    }
}

@end
