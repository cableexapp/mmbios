//
//  MyCableSureOrderViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "B2BMyCableOrderListData.h"
#import "MyCableSureOrderTableViewController.h"

@interface MyCableSureOrderViewController : UIViewController<PopDelegate>

@property (strong,nonatomic) B2BMyCableOrderListData *b2bMyCableOrderListData;

@property (weak, nonatomic) IBOutlet UILabel *myOrderNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *myOrderTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *myOrderStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *myOrderTotalLabel;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UIView *tableSubView;

@property (assign,nonatomic) int btnIndex;

@end
