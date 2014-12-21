//
//  MyInquiryListFirstViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-6.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalInquiryListTableViewController.h"
#import "SpeedInquiryListTableViewController.h"
#import "MyNormalInquiryDetailController.h"

@interface MyInquiryListFirstViewController : UIViewController<PushToNextVC,PushViewController>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (nonatomic,strong) NSString *orderBtnClick;

@end
