//
//  WelComeViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-16.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelComeViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *starView;    //最后一页（开启页）
@property (strong, nonatomic) IBOutlet UIButton *startBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *iv_Fir;
@property (weak, nonatomic) IBOutlet UIImageView *iv_Sec;
@property (weak, nonatomic) IBOutlet UIImageView *iv_Third;
@property (weak, nonatomic) IBOutlet UIView *jumpView;     //跳过背景
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;      //跳过按钮
@end
