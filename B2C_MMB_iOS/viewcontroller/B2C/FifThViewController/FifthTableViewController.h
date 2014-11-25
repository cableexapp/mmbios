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

@interface FifthTableViewController : UITableViewController<ConnectionDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    DCFConnectionUtil *conn;
}
@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;

@end
