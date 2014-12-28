//
//  AddReceiveAddressViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-24.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "FMDatabase.h"

@interface AddReceiveAddressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tv;
}
@property (assign,nonatomic) BOOL edit;
@property (strong,nonatomic) FMDatabase *db;

@property (strong,nonatomic) NSDictionary *pushDic;

@end
