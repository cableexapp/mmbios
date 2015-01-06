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

@protocol ChangeDelegate <NSObject>

- (void)popSearchText:(NSString *) str;

@end

@interface GoodsDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,ConnectionDelegate,EScrollerViewDelegate,UIWebViewDelegate>
{
    DCFConnectionUtil *conn;
    MBProgressHUD *HUD;
    
    UITableView *tv;
    EScrollerView *es;
    NSString *GoodsDetailUrl;
    

}
@property (strong,nonatomic) NSString *productid;

@property (nonatomic,strong) NSString *GoodsDetailUrl;

- (id) initWithProductId:(NSString *) productid;

@property(nonatomic,assign) id<ChangeDelegate>_degegate;

@end
