//
//  B2BAskPriceCarViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-3.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "B2BAskPriceCarEditViewController.h"

@interface B2BAskPriceCarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ConnectionDelegate,RemoveSubView,UIAlertViewDelegate>
{
    UITableView *tv;
    DCFConnectionUtil *conn;
    UITableViewCell *noCell;
}
@end
