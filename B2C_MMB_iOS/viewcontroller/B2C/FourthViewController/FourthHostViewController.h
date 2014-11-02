//
//  FourthHostViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "CKRefreshControl.h"
#import "EGORefreshTableHeaderView.h"

@interface FourthHostViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ConnectionDelegate,EGORefreshTableHeaderDelegate,UIAlertViewDelegate>
{
    DCFConnectionUtil *conn;
}
@property (strong,nonatomic) NSString *myStatus;
@property(nonatomic,strong) EGORefreshTableHeaderView *refreshView;

@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitForPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitForSend;

@property (weak, nonatomic) IBOutlet UIButton *waitForSureBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitForDiscussBtn;
@property (weak, nonatomic) IBOutlet UITableView *tv;

@end
