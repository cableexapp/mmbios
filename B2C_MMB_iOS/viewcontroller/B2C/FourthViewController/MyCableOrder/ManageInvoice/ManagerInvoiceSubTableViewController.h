//
//  ManagerInvoiceSubTableViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-14.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface ManagerInvoiceSubTableViewController : UITableViewController<ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}

@property (assign,nonatomic) BOOL status;

- (void) changeColor;

- (NSMutableArray *) changeChooseArray;
@end
