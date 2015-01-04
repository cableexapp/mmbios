//
//  B2CSearchViewController.h
//  B2C_MMB_iOS
//
//  Created by developer on 15-1-4.
//  Copyright (c) 2015年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import <sqlite3.h>
#import <AVFoundation/AVFoundation.h>
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "DCFChenMoreCell.h"

@interface B2CSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ConnectionDelegate,IFlyRecognizerViewDelegate,MBProgressHUDDelegate,EGORefreshTableHeaderDelegate>
{
    DCFConnectionUtil *conn;
    
    IFlyRecognizerView *_iflyRecognizerView;
    
    NSString *tempSearchText;
    
    UITableView *tv;
    
    UIView *selectBtnView;
    
    MBProgressHUD *HUD;
    
}

@property(nonatomic,strong) NSString *tempSearchText;

@property(nonatomic,strong) EGORefreshTableHeaderView *refreshView;

@property (strong,nonatomic) UIView *lineView;
@property (strong,nonatomic) UIView *lineView_1;

@end
