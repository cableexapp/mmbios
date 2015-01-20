//
//  FourOrderDetailViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-18.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "MBProgressHUD.h"

@interface FourOrderDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ConnectionDelegate,MBProgressHUDDelegate>
{
    DCFConnectionUtil *conn;
    MBProgressHUD *hud;
    
    BOOL showOrHideDisCussBtn;
    BOOL showOrHideTradeBtn;
}
@property (strong,nonatomic) NSString *myOrderNum;
//@property (strong,nonatomic) NSString *myTime;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *myOederLabel;
@property (weak, nonatomic) IBOutlet UILabel *myTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *tableBackView;
@property (weak, nonatomic) IBOutlet UIView *buttomView;

@end
