//
//  SpeedInquiryListTableViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-6.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "CKRefreshControl.h"
#import "EGORefreshTableHeaderView.h"

@interface SpeedInquiryListTableViewController : UITableViewController<ConnectionDelegate,EGORefreshTableHeaderDelegate>
{
    DCFConnectionUtil *conn;
}
@property(nonatomic,strong) EGORefreshTableHeaderView *refreshView;

@end
