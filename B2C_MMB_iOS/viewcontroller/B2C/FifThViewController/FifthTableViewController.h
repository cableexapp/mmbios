//
//  FifthTableViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-25.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "MBProgressHUD.h"
#import "XMPPFramework.h"

@interface FifthTableViewController : UITableViewController<ConnectionDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,XMPPRoomDelegate>
{
    MBProgressHUD *HUD;
    DCFConnectionUtil *conn;
    XMPPRoom *xmppRoom;
}
@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (nonatomic,strong) XMPPRoom *xmppRoom;

@end
