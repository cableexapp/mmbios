//
//  MyCableOrderSearchViewController.h
//  B2C_MMB_iOS
//
//  Created by developer on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "MBProgressHUD.h"

@interface MyCableOrderSearchViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,ConnectionDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
{
    NSString *fromFlag;
    DCFConnectionUtil *conn;
    MBProgressHUD *HUD;
}

@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,strong)  NSString *fromFlag;

@end
