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

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define yCompensation (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)?88.0:0.0)

@interface AppDelegate : UIResponder <UIApplicationDelegate,ConnectionDelegate,XMPPRosterDelegate>
{
    DCFConnectionUtil *conn;
    
    //XMPP
    NSString * passWord;
    BOOL * isOpen;//是否开着
    XMPPStream * xmppStream;
    XMPPReconnect *xmppReconnect;
    XMPPRosterCoreDataStorage * xmppRosterStorage;
    NSString *personName;
    NSString *sendMessageInfo;
    NSString *userID;
    NSMutableArray *roster;
    
    NSString *chatRequestJID;
    NSString *roomJID;
    
    BOOL isXmppConnected;
    BOOL isRegister;
    
    NSString *password;
    XMPPRoster *xmppRoster;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    XMPPCapabilities *xmppCapabilities;
    NSString *strPassword;
}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NSOperationQueue *mainQueue;


@property (strong,nonatomic) FMDatabase *db;

//@property (strong,nonatomic) NSString *udid;

- (void) openDatabase;

-(NSString*) getUdid;

//XMPP
@property (nonatomic,strong) NSString *sendMessageInfo;
@property (nonatomic,strong) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic,strong) XMPPStream *xmppStream;
@property (nonatomic,strong) XMPPRoom *xmppRoom;

@property (nonatomic,strong) NSString *chatRequestJID;
@property (nonatomic,strong) NSString *roomJID;
@property (nonatomic,strong) NSString *personName;
@property (nonatomic,strong) NSString *uesrID;
@property (nonatomic,strong) NSMutableArray *roster;

#pragma mark - XMPP方法
-(BOOL)connect;

-(void)disconnect;

-(void)stetupStrem;

-(void)goOnline;

-(void)goOffline;

- (BOOL)reConnect;

-(void)registerInSide;

@end
