//
//  ManagReceiveAddressViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-12-11.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "DCFConnectionUtil.h"

@interface ManagReceiveAddressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ConnectionDelegate>
{
    UITableView *tv;
    DCFConnectionUtil *conn;
    NSMutableArray *dataArray;
}

@property (assign,nonatomic) BOOL B2COrB2B;

@property (strong,nonatomic) UIView *tvBackView;
@property (strong,nonatomic) UIView *buttomView;
@property (strong,nonatomic) UIButton *buttomBtn;

@end
