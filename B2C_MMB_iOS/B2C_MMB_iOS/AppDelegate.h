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

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define yCompensation (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)?88.0:0.0)

@interface AppDelegate : UIResponder <UIApplicationDelegate,ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NSOperationQueue *mainQueue;


@property (strong,nonatomic) FMDatabase *db;

@property (strong,nonatomic) NSString *udid;

- (void) openDatabase;

-(NSString*) uuid;

@end
