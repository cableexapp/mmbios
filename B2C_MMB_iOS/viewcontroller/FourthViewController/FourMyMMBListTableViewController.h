//
//  FourMyMMBListTableViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-17.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface FourMyMMBListTableViewController : UITableViewController<ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}

@property (weak, nonatomic) IBOutlet UIButton *btn_1;
@property (weak, nonatomic) IBOutlet UIButton *btn_2;
@property (weak, nonatomic) IBOutlet UIButton *btn_3;
@property (weak, nonatomic) IBOutlet UIButton *btn_4;

@property (weak, nonatomic) IBOutlet UIButton *btn_5;
@property (weak, nonatomic) IBOutlet UIButton *btn_6;
@property (weak, nonatomic) IBOutlet UIButton *btn_7;

@property (weak, nonatomic) IBOutlet UIButton *btn_8;
@property (weak, nonatomic) IBOutlet UIButton *btn_9;
@property (weak, nonatomic) IBOutlet UIButton *btn_10;
@property (weak, nonatomic) IBOutlet UIButton *btn_11;


@end
