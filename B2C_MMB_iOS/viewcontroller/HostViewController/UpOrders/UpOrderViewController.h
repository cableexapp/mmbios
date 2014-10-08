//
//  UpOrderViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-9-23.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFPickerView.h"
#import "DCFConnectionUtil.h"

@interface UpOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PickerView,ConnectionDelegate>
{
    DCFConnectionUtil *conn;
    UITableView *tv;
    
    NSMutableArray *goodsListArray;
    
    float goodsMoney;
}

- (id) initWithDataArray:(NSMutableArray *) dataArray WithMoney:(float) money;
@end
