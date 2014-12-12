//
//  B2BAskPriceUpSuccessViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-6.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface B2BAskPriceUpSuccessViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *lookForMyOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *telBtn;
@property (weak, nonatomic) IBOutlet UIButton *backToHomeBtn;
- (IBAction)backToHomeBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *imBTN;
- (IBAction)imBtn:(id)sender;
- (IBAction)telBtnClick:(id)sender;

@end
