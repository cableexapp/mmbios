//
//  GoodsPicFastViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-24.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "MBProgressHUD.h"

@interface GoodsPicFastViewController : UIViewController<ConnectionDelegate,UITableViewDataSource,UITableViewDelegate>
{
    DCFConnectionUtil *conn;
    UITableView *tv;
}
@property (strong,nonatomic) NSString *mySnapId;
@property (strong,nonatomic) NSString *myShopName;

@property (weak, nonatomic) IBOutlet UIView *tableBackView;
@property (weak, nonatomic) IBOutlet UILabel *buttomLabel;

@end
