//
//  MyCableOrderHostViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-12.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCableHostSubTableViewController.h"

@interface MyCableOrderHostViewController : UIViewController<UIScrollViewDelegate>
{
    MyCableHostSubTableViewController *subTV_1;
    MyCableHostSubTableViewController *subTV_2;
    MyCableHostSubTableViewController *subTV_3;
    MyCableHostSubTableViewController *subTV_4;
}
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *firstView;

@property (assign,nonatomic) int btnIndex;

@end
