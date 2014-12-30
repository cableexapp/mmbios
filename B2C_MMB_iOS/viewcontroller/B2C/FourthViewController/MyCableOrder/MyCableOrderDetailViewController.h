//
//  MyCableOrderDetailViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "B2BMyCableOrderListData.h"
#import "MyCableDetailTableViewController.h"

@interface MyCableOrderDetailViewController : UIViewController<RequestHasFinished>
{
    MyCableDetailTableViewController *myCableDetailTableViewController;
}
@property (weak, nonatomic) IBOutlet UILabel *myOrderNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *myOrderTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *myOrderStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *myOrderTotalLabel;

@property (weak, nonatomic) IBOutlet UIView *buttomView;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UILabel *buttomLabel;


@property (weak, nonatomic) IBOutlet UIView *tableSubView;

@property (weak, nonatomic) IBOutlet UIView *topView;

//@property (strong,nonatomic) B2BMyCableOrderListData *b2bMyCableOrderListData;

@property (strong,nonatomic) NSString *myOrderNumber;

@property (assign,nonatomic) int btnIndex;





@end
