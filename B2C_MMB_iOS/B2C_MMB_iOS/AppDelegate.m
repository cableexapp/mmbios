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


@implementation AppDelegate
{
    UIStoryboard *sb;
}
@synthesize mainQueue;
@synthesize db;

- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability *curReach = [note object];
    if (![curReach isKindOfClass:[Reachability class]])
        return;
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:  //无网络
        {
            [DCFStringUtil showNotice:@"似乎断开了物联网连接"];
            
            //            curNetType=NETWORK_NO;
            //            NSLog(@"%@:NotReachable",NSStringFromSelector(_cmd));
        }
            break;
        case ReachableViaWWAN:  //使用3g/gprs网络
        {
            //            curNetType=NETWORK_3G;
            //            NSLog(@"%@:ReachableViaWWAN 3g",NSStringFromSelector(_cmd));
        }
            break;
        case ReachableViaWiFi:  //使用wifi网络
        {
            //            curNetType=NETWORK_WIFI;
            //            NSLog(@"%@:ReachableViaWiFi",NSStringFromSelector(_cmd));
        }
            break;
        default:
            break;
    }
    
}

-(NSString*) getUdid
{
    NSString *udid = [PhoneHelper getDeviceId];
    
    return udid;
}



- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLShopListTag)
    {
        

    }
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
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
    
    DCFTabBarCtrl *tabbar = [sb instantiateViewControllerWithIdentifier:@"dcfTabBarCtrl"];
    self.window.rootViewController = tabbar;
//    [tabbar.view.window setBackgroundColor:[UIColor blackColor]];
//    [tabbar.view.window setOpaque:NO];
    
    [PhoneHelper sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    
    mainQueue = [[NSOperationQueue alloc] init] ;
    [self.mainQueue setMaxConcurrentOperationCount:30];
    
    [self loadFMDB];
    
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
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if([self.db open] == YES)
    {
        [self.db close];
    }
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
