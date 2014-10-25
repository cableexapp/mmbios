//
//  CancelOrderViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-23.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "MBProgressHUD.h"

@interface CancelOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,ConnectionDelegate,MBProgressHUDDelegate>
{
    DCFConnectionUtil *conn;
    MBProgressHUD *HUD;
}

@property (strong,nonatomic) NSString *myStatus;

@property (strong,nonatomic) NSString *myOrderNum;

@property (weak, nonatomic) IBOutlet UITableView *tv;

@end
