//
//  AppDelegate.h
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-8-29.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "DCFConnectionUtil.h"

//XMPP
#import <CoreData/CoreData.h>
#import <sqlite3.h>
#import "XMPPFramework.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#define UMENG_APPKEY @"546d533bfd98c55662004041"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define yCompensation (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)?88.0:0.0)

@interface AppDelegate : UIResponder <UIApplicationDelegate,ConnectionDelegate,XMPPRosterDelegate,XMPPStreamDelegate>
{
    DCFConnectionUtil *conn;
    
    //XMPP
    NSString * passWord;
    BOOL * isOpen;//是否开着
    XMPPStream * xmppStream;
    XMPPReconnect *xmppReconnect;

    NSString *personName;
    NSString *sendMessageInfo;
    NSString *userID;
    NSMutableArray *roster;
    
    NSString *chatRequestJID;
    NSString *roomJID;
    
    NSString *tempID;
    NSString *errorMessage;
    NSString *isConnect;
    
    BOOL isXmppConnected;

    XMPPRoster *xmppRoster;

    NSString *isOnLine;
    NSString *pushChatView;
    
    int messageCount;
    
    NSString *forgroudPushMessage;
}

//修改登录密码之后不需要显示弹出框
@property (assign,nonatomic) BOOL hideNotice;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NSOperationQueue *mainQueue;


@property (strong,nonatomic) FMDatabase *db;

@property (assign,nonatomic) BOOL speedRegister;
@property (assign,nonatomic) BOOL isB2BPush;
@property (assign,nonatomic) BOOL isB2CPush;

@property (assign,nonatomic) BOOL lookForTradeMsg;

@property (strong,nonatomic) NSString *key1;
@property (strong,nonatomic) NSString *key2;
@property (strong,nonatomic) NSString *key3;

@property (strong, nonatomic) NSString *appId;
@property (strong, nonatomic) NSString *channelId;
@property (strong, nonatomic) NSString *baiduPushUserId;
@property (nonatomic,strong) NSString *pushChatView;
@property (nonatomic,strong) NSString *isOnLine;

@property (assign,nonatomic) BOOL aliPayHasFinished;

//@property (strong,nonatomic) NSString *udid;

- (void) openDatabase;

-(NSString*) getUdid;

- (void)queryRoster;


//XMPP
@property (nonatomic,strong) NSString *sendMessageInfo;

@property (nonatomic,strong) XMPPStream *xmppStream;
@property (nonatomic,strong) XMPPRoom *xmppRoom;

@property (nonatomic,strong) NSString *chatRequestJID;
@property (nonatomic,strong) NSString *roomJID;
@property (nonatomic,strong) NSString *personName;
@property (nonatomic,strong) NSString *uesrID;
@property (nonatomic,strong) NSMutableArray *roster;
@property (nonatomic,strong) NSString *tempID;
@property (nonatomic,strong) NSString *errorMessage;
@property (nonatomic,strong) NSString *isConnect;
@property (nonatomic,assign) int messageCount;

@property (nonatomic,strong) NSString *forgroudPushMessage;

#pragma mark - XMPP方法
-(BOOL)connect;

-(void)disconnect;

-(void)setupStream;

-(void)goonline;

-(void)goOffline;

-(BOOL)reConnect;

-(void)registerInSide;

-(void)aliPayChange;

-(void)logOutMethod;

- (void)logout;

@end
