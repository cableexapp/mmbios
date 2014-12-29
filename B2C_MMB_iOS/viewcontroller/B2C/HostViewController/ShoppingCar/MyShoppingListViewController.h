//
//  MyShoppingListViewController.h
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-1.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "CKRefreshControl.h"
#import "EGORefreshTableHeaderView.h"

#pragma mark - 购物车列表

@interface MyShoppingListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ConnectionDelegate,UIAlertViewDelegate,EGORefreshTableHeaderDelegate>
{
    UITableView *tv;
    
    DCFConnectionUtil *conn;
    
    UITableViewCell *noCell;
    
    BOOL _reloading;
}
@property(nonatomic,strong) EGORefreshTableHeaderView *refreshView;

- (id) initWithDataArray:(NSArray *) arr;


@end
