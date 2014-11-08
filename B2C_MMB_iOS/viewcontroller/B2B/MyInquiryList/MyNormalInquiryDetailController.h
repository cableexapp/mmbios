//
//  MyNormalInquiryDetailController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-7.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNormalInquiryDetailController : UIViewController

@property (strong,nonatomic) NSString *myOrderNum;
@property (strong,nonatomic) NSString *myTime;
@property (strong,nonatomic) NSString *myStatus;
@property (strong,nonatomic) NSString *myInquiryid;
@property (strong,nonatomic) NSDictionary *myDic;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *tableBackView;


@end
