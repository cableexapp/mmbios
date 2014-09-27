//
//  GoodsDetailViewController.h
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-9.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "MBProgressHUD.h"
#import "EScrollerView.h"

@interface GoodsDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,ConnectionDelegate,EScrollerViewDelegate>
{
    DCFConnectionUtil *conn;
    MBProgressHUD *HUD;
    UITableView *tv;
    EScrollerView *es;
}
@property (strong,nonatomic) NSString *productid;

- (id) initWithProductId:(NSString *) productid;
@end
