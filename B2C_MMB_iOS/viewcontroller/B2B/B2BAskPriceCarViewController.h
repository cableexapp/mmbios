//
//  B2BAskPriceCarViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-3.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface B2BAskPriceCarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ConnectionDelegate>
{
    UITableView *tv;
    DCFConnectionUtil *conn;
}
@end
