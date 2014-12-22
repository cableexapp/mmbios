//
//  B2BAskPriceInquirySheetViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-6.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "MBProgressHUD.h"
#import "ChooseReceiveAddressViewController.h"

@interface B2BAskPriceInquirySheetViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ConnectionDelegate,MBProgressHUDDelegate,B2BReceveAddress>
{
    UITableView *tv;
    DCFConnectionUtil *conn;
    MBProgressHUD *HUD;
}

@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) NSMutableArray *heightArray;

@end
