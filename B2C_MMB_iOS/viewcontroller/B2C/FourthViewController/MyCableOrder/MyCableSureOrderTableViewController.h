//
//  MyCableSureOrderTableViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "B2BMyCableOrderListData.h"
#import "ManageInvoiceViewController.h"
#import "ChooseReceiveAddressViewController.h"

@interface MyCableSureOrderTableViewController : UITableViewController<ConnectionDelegate,B2BReceveAddress>
{
    DCFConnectionUtil *conn;
    
    ManageInvoiceViewController *manageInvoiceViewController;
}
@property (strong,nonatomic) B2BMyCableOrderListData *b2bMyCableOrderListData;

@property (strong,nonatomic) NSString *myOrderid;
@property (strong,nonatomic) NSDictionary *addressDic;

- (void) loadRequest;

@end
