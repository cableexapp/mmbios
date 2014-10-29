//
//  LookForCustomViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-14.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "MBProgressHUD.h"

#pragma mark - 查看售后

@interface LookForCustomViewController : UIViewController<ConnectionDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
{
    DCFConnectionUtil *conn;
    MBProgressHUD *HUD;
}
@property (strong,nonatomic) UITableView *tv;
@property (strong,nonatomic) NSString *orderNum;
@end
