//
//  MyCableDetailTableViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface MyCableDetailTableViewController : UITableViewController<ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}

@property (strong,nonatomic) NSString *myOrderid;
@property (strong,nonatomic) NSDictionary *addressDic;

@end
