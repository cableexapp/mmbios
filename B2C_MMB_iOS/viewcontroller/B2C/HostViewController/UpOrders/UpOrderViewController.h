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
#import "B2CUpOrderData.h"
#import "ChooseReceiveAddressViewController.h"
#import "BillMsgManagerViewController.h"

@interface UpOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PickerView,ConnectionDelegate,UITextFieldDelegate,ReceveAddress,UIAlertViewDelegate>
{
    DCFConnectionUtil *conn;
    UITableView *tv;
    
    NSMutableArray *goodsListArray;  //有几组商品
    
    double goodsMoney;
    
    B2CUpOrderData *b2cOrderData;
}

- (id) initWithDataArray:(NSMutableArray *) dataArray WithMoney:(double) money WithOrderData:(B2CUpOrderData *) orderData WithTag:(int) tag;
@end
