//
//  MyCableOrderB2BViewController.h
//  B2C_MMB_iOS
//
//  Created by developer on 14-11-29.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "B2BMyCableOrderListData.h"

@interface MyCableOrderB2BViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,ConnectionDelegate,UIAlertViewDelegate>
{
    DCFConnectionUtil *conn;
    NSString *fromFlag;
}

@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,strong)  NSString *fromFlag;

@end
