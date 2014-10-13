//
//  ShopHostTableViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-26.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
//#import "MBProgressHUD.h"
#import "DCFChenMoreCell.h"
#import "CKRefreshControl.h"
#import "EGORefreshTableHeaderView.h"
#import "B2CShoppingSearchViewController.h"
#import "ShopHostPreTableViewController.h"

@interface ShopHostTableViewController : UITableViewController<ConnectionDelegate,EGORefreshTableHeaderDelegate,UIGestureRecognizerDelegate,PushText>
{
    DCFConnectionUtil *conn;
    
    UIView *preView;
    
    UIView *preBackView;
    
    NSString *shopUse;
}
@property (strong,nonatomic) NSString *shopId;
@property (strong,nonatomic) NSString *myTitle;
@property(nonatomic,strong) EGORefreshTableHeaderView *refreshView;

- (id) initWithHeadTitle:(NSString *) title WithShopId:(NSString *) shopId WithUse:(NSString *) use;
@end
