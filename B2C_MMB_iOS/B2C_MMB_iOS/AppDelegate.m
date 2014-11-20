
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

#define SUPPORT_IOS8 0

//XMPP
#import <AudioToolbox/AudioToolbox.h>
#import "XMPPStream.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "NSXMLElement+XMPP.h"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

NSString *strUserId = @"";
@implementation AppDelegate
{
    //李深望修改
    UIStoryboard *sb;
}
@synthesize mainQueue;
@synthesize db;

//XMPP
@synthesize personName;
@synthesize sendMessageInfo;
@synthesize roster;
@synthesize xmppRosterStorage;
@synthesize xmppStream;
@synthesize xmppRoom;
@synthesize uesrID;
@synthesize chatRequestJID;
@synthesize roomJID;

- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability *curReach = [note object];
    if (![curReach isKindOfClass:[Reachability class]])
        return;
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:  //无网络
        {
            [DCFStringUtil showNotice:@"似乎断开了互联网连接"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"netErrorMessage" object:nil];
            
            //            curNetType=NETWORK_NO;
            //            NSLog(@"%@:NotReachable",NSStringFromSelector(_cmd));
        }
            break;
        case ReachableViaWWAN:  //使用3g/gprs网络
        {
            //            curNetType=NETWORK_3G;
            //            NSLog(@"%@:ReachableViaWWAN 3g",NSStringFromSelector(_cmd));
            [self reConnect];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NetisConnect" object:nil];
        }
            break;
        case ReachableViaWiFi:  //使用wifi网络
        {
            //            curNetType=NETWORK_WIFI;
            //            NSLog(@"%@:ReachableViaWiFi",NSStringFromSelector(_cmd));
            [self reConnect];
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
    NSLog(@"%@",udid);
    return udid;
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLShopListTag)
    {
        
        
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"token = %@",deviceToken);
    NSString *token = [[deviceToken description]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",token);
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
        NSLog(@"%@  %@   %@",self.appId,self.baiduPushUserId,self.channelId);
        
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        
        //        BPushRequestResponseParamsKey
    }
    else if ([BPushRequestMethod_Unbind isEqualToString:method])
    {
        
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSLog(@"%@",userInfo);
    
    NSString *pushTitle = [userInfo objectForKey:@"title"];
    NSString *description = [userInfo objectForKey:@"description"];
    
    if (application.applicationState == UIApplicationStateActive) {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:pushTitle
                                                            message:description
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    [application setApplicationIconBadgeNumber:0];
    
    [BPush handleNotification:userInfo];
    
}


#if SUPPORT_IOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
#endif


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //百度云推送
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    
    [application setApplicationIconBadgeNumber:0];
#if SUPPORT_IOS8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else
#endif
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    
    //XMPP
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID])
    {
        NSString *tempUUID = [PhoneHelper getDeviceId];
        tempUUID = [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyPassword])
    {
        NSString *tempPassWord = @"123456";
        tempPassWord = [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyPassword];
    }
    self.roster  = [[NSMutableArray alloc] init];
    
    //xmpp初始化
    [self setupStream];
    //连接
    [self connect];
    
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
    
    //    DCFTabBarCtrl *tabbar = [sb instantiateViewControllerWithIdentifier:@"dcfTabBarCtrl"];
    //    self.window.rootViewController = tabbar;
    WelComeViewController *welcome = [sb instantiateViewControllerWithIdentifier:@"welComeViewController"];
    self.window.rootViewController = welcome;
    
    [PhoneHelper sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    
    mainQueue = [[NSOperationQueue alloc] init] ;
    [self.mainQueue setMaxConcurrentOperationCount:30];
    
    [self loadFMDB];
    
    //注册
    [self registerInSide];
    // Override point for customization after application launch.
    return YES;
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
    
    
    //    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDB.db"];
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"t_prov_city_area_street" ofType:@"db"];
    
    //    self.db = [[FMDatabase alloc] initWithPath:dbPath];
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

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //程序进入后台时将xmpp下线
    [self goOffline];
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if([self.db open] == YES)
    {
        [self.db close];
    }
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    
    // 初始化roster
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    // 初始化 vCard support
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    
    // 初始化 capabilities
    xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    // 激活xmpp的模块
    [xmppReconnect         activate:xmppStream];
    [xmppRoster            activate:xmppStream];
    [xmppvCardTempModule   activate:xmppStream];
    [xmppvCardAvatarModule activate:xmppStream];
    [xmppCapabilities      activate:xmppStream];
    
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 域名和端口
    [xmppStream setHostName:@"117.79.154.178"];
    [xmppStream setHostPort:5222];
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//注册
- (void)registerInSide
{
    isRegister = YES;
    NSError *error;
    NSString *UUID = [PhoneHelper getDeviceId];
    NSString *hostName = @"117.79.154.178";
    NSString *tjid = [[NSString alloc] initWithFormat:@"%@@%@/smack",UUID,hostName];
    if ([xmppStream isConnected])
    {
        if (![xmppStream registerWithPassword:@"123456" error:&error])
        {
            //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建帐号失败"
            //                                                                message:[error localizedDescription]
            //                                                               delegate:nil
            //                                                      cancelButtonTitle:@"Ok"
            //                                                      otherButtonTitles:nil];
            //            [alertView show];
        }
    }
    else
    {
        [xmppStream setMyJID:[XMPPJID jidWithString:tjid]];
    }
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    //    registerSuccess = YES;
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建帐号成功"
    //                                                        message:@""
    //                                                       delegate:self
    //                                              cancelButtonTitle:@"Ok"
    //                                              otherButtonTitles:nil];
    //    [alertView show];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    [self disconnect];
    [self reConnect];
}

//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	isXmppConnected = YES;
	NSError *error = nil;
	if (![[self xmppStream] authenticateWithPassword:@"123456" error:&error])
	{
        if (error != nil)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"errorMessage" object:nil];
        }
	}
}

//验证通过 上线、
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    [self goonline];
}

-(void)goonline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [xmppStream sendElement:presence];
    if (self.roster.count == 0)
    {
        [self queryRoster];
    }
}

- (BOOL)connect
{
	NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    
	myJID = [NSString stringWithFormat:@"%@@%@",[PhoneHelper getDeviceId],@"fgame.com"];
    myPassword = @"123456";
	if (myJID == nil || myPassword == nil)
    {
		return NO;
	}
    XMPPJID *jid = [XMPPJID jidWithString:myJID resource:@"XMPP"];
	[xmppStream setMyJID:jid];
	password = myPassword;
    
	NSError *error = nil;
    if (![xmppStream connect:&error])
    {
        return NO;
    }
	return YES;
}

//重新连接
- (BOOL)reConnect
{
    //    NSLog(@"reConnect");
    if (![xmppStream isDisconnected])
    {
        [self goonline];
        return YES;
    }
    NSString *myJID =[NSString stringWithFormat:@"%@@fgame.com",[PhoneHelper getDeviceId]];
    NSString *myPassword = @"123456";
    if (myJID == nil || myPassword == nil)
    {
        return NO;
    }
    [xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    strPassword = @"123456";
    NSError *error = nil;
    if (![xmppStream connect:&error])
    {
        return NO;
    }
    return YES;
}

//查询群组列表
- (void)queryRoster
{
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"from" stringValue:self.personName];
    [iq addAttributeWithName:@"id" stringValue:@"disco2"];
    [iq addAttributeWithName:@"to"stringValue:@"workgroup.fgame.com"];
    [iq addAttributeWithName:@"type"stringValue:@"get"];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
    [query addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/disco#items"];
    [iq addChild:query];
    [[self xmppStream] sendElement:iq];
    //NSLog(@"iq = %@",iq);
    //NSLog(@"查询列表");
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    DDLogVerbose(@"%@", [iq description]);
    //    NSLog(@"[IQ description] = %@\n\n",[iq description]);
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
    }
    return NO;
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    //      NSLog(@"接收++++message = %@\n\n",message);
    //消息内容
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    //    NSString *type= [[message attributeForName:@"type"] stringValue];
    NSString *to= [[message attributeForName:@"to"] stringValue];
    
    //    NSLog(@"接收++++from = %@\n\n",from);
    //    NSLog(@"接收++++to = %@\n\n",to);
    if([from rangeOfString:@"workgroup"].location !=NSNotFound)
    {
        self.personName = to;
        self.chatRequestJID = [PhoneHelper getDeviceId];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"joinRoomMessage" object:msg];
    }
    else if([from rangeOfString:@"conference"].location !=NSNotFound && [from rangeOfString:@"/"].location ==NSNotFound)
    {
        self.personName = to;
        self.uesrID = from;
    }
    else if ([from rangeOfString:[PhoneHelper getDeviceId]].location ==NSNotFound)
    {
        //        self.messageInfo = msg;
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"messageGetting" object:msg];
    }
    
    NSRange range=[from rangeOfString:@"@"];
    if(range.length==0)
    {
        return;
    }
    //    NSString *fromSimple=[from substringToIndex:range.location];
    //    NSLog(@"接受%@的消息：%@ (消息类型:%@)",fromSimple,msg,type);
}

// 发送消息回调方法
- (void)sendMessage:(NSString *)message toUser:(NSString *)user
{
    
}

- (void)XMPPAddFriendSubscribe:(NSString *)name
{
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",name,@""]];
    [xmppRoster subscribePresenceToUser:jid];
}

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //取得好友状态
    //    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]];
    //    NSLog(@"好友状态 = %@",presenceType);
    //请求的用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
    //    NSLog(@"请求的用户 = %@",presenceFromUser);
    //请求的用户jid
    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
    //    NSLog(@"jid = %@",jid);
    [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
}

//下线
-(void)goOffline
{
    //    NSLog(@"goOffline");
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [xmppStream sendElement:presence];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    //    NSLog(@"presence = %@",presence);
    //    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //        //当前用户
    //        NSString *userId = [[sender myJID] user];
    //        NSLog(@"请求的用户userId = %@",userId);
    //        //在线用户
    //        NSString *presenceFromUser = [[presence from] user];
    //        NSLog(@"presenceFromUser = %@",presenceFromUser);
    //在线状态
    if ([presenceType isEqualToString:@"unavailable"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noFriendOnLine" object:nil];
    }
}

- (void)disconnect
{
    //    NSLog(@"disconnect");
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
    [self.xmppStream disconnect];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    //    NSLog(@"didNotAuthenticate");
}

#pragma mark - 数据库创建
-(void)SQLDataSteup
{
    //创建数据库对象
    sqlite3 * dataBase = NULL;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *filePath = [documents stringByAppendingPathComponent:@"ChatMessageList.sqlite"];
    //    NSLog(@"进入数据库创建方法");
    
    //打开数据库
    int result = sqlite3_open([filePath UTF8String],&dataBase);
    //    NSLog(@"result = %d",result);
    
    if (SQLITE_OK == result)
    {
        //创建一个名称为messageList的表
        char * sqlCreate = "CREATE TABLE MESSAGELIST(id integer primary key AutoIncrement, rec_user_id varchar(30),user_id varchar(30),time varchar(30),message varchar(2000))";
        char * error = NULL;
        //执行sql语句
        sqlite3_exec(dataBase, sqlCreate, nil, nil, &error);
        
        //        NSLog(@"创建数据库 错误信息---%s",error);
        //2014-5-16 版本更新增加新字段creater
        //字段增加
        //        NSLog(@"进入数据库增加字段方法");
        char * sqlAdd = "ALTER TABLE MESSAGELIST ADD creater varchar(30)";
        sqlite3_exec(dataBase, sqlAdd, nil, nil, &error);
        //        NSLog(@"增加字段错误信息----%s",error);
        //数据库使用完成后关闭数据库
        sqlite3_close(dataBase);
    }
}

#pragma mark - 数据库 - 收到消息存储
-(void)recUserId:(NSString *)recUserId toUserId:(NSString *)userId toTime:(NSString *)time toMessage:(NSString *)message
{
    sqlite3 * dataBase = NULL;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *filePath = [documents stringByAppendingPathComponent:@"ChatMessageList.sqlite"];
    //打开数据库
    int result = sqlite3_open([filePath UTF8String],&dataBase);
    if (SQLITE_OK == result)
    {
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO MESSAGELIST(rec_user_id, user_id, time, message, creater) values ('%@','%@','%@','%@','%@')",recUserId,userId,time,message,strUserId];
        char * error = NULL;
        sqlite3_exec(dataBase, [insert UTF8String], nil, nil, &error);
        sqlite3_close(dataBase);
        //printf(error);
    }
}


@end
