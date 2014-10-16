//
//  FourthHostViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface FourthHostViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitForPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitForSureBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitForDiscussBtn;
@property (weak, nonatomic) IBOutlet UITableView *tv;

@end
