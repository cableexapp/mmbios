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
#import "B2BMyCableOrderListData.h"

@protocol PushToDetailVC <NSObject>

- (void) pushToDetailVCWithData:(B2BMyCableOrderListData *) data;

@end

@interface MyCableHostSubTableViewController : UITableViewController<ConnectionDelegate,EGORefreshTableHeaderDelegate,UIAlertViewDelegate>
{
    DCFConnectionUtil *conn;
}
@property(nonatomic,strong) EGORefreshTableHeaderView *refreshView;

@property (assign,nonatomic) int tag;
@property (strong,nonatomic) NSString *statusIndex;
@property (assign,nonatomic) id<PushToDetailVC> delegate;
@property (assign,nonatomic) int intPage;

- (void) loadRequestWithStatus:(NSString *) sender;
@end


