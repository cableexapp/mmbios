//
//  B2CShoppingListViewController.h
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-16.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "MBProgressHUD.h"
#import "DCFChenMoreCell.h"
#import "CKRefreshControl.h"
#import "EGORefreshTableHeaderView.h"
#import "B2CShoppingSearchViewController.h"

@interface B2CShoppingListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ConnectionDelegate,MBProgressHUDDelegate,EGORefreshTableHeaderDelegate,RequestString>
{
    DCFConnectionUtil *conn;
    UITextField  *searchTextField;
    UITableView *tv;
    
    UIView *selectBtnView;
   

    MBProgressHUD *HUD;
    
    NSString *delegateMyUse;
    NSString *delegateMyBrand;
    NSString *delegateMySpec;
    NSString *delegateMyModel;
    
    BOOL flag;
}

@property (strong,nonatomic) UIView *lineView;
@property (strong,nonatomic) UIView *lineView_1;
@property (strong,nonatomic) NSString *use;
@property (strong,nonatomic) NSString *seq;
@property(nonatomic,strong) EGORefreshTableHeaderView *refreshView;

- (id) initWithUse:(NSString *) string;
@end
