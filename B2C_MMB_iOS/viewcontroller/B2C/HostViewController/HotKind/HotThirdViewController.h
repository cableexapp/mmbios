//
//  HotThirdViewController.h
//  B2C_MMB_iOS
//
//  Created by cyumen on 14-11-12.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotThirdViewController : UIViewController<UIAlertViewDelegate>

//返回首页属性
- (IBAction)backHome:(id)sender;
//返回第二页
- (IBAction)backSecond:(id)sender;
//咨询电话
- (IBAction)taPhone:(id)sender;

- (IBAction)clickAsk:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneMoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *imBtn;

@end
