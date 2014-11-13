//
//  MyCableHostSubTableViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-12.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "CKRefreshControl.h"
#import "EGORefreshTableHeaderView.h"

@interface MyCableHostSubTableViewController : UITableViewController<ConnectionDelegate,EGORefreshTableHeaderDelegate>
{
    DCFConnectionUtil *conn;
}
@property(nonatomic,strong) EGORefreshTableHeaderView *refreshView;

@property (assign,nonatomic) int tag;
@end
