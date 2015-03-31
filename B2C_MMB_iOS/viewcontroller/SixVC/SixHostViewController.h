//
//  SixHostViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 15-3-25.
//  Copyright (c) 2015年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlyRecognizerViewDelegate.h"

@interface SixHostViewController : UIViewController<IFlyRecognizerViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *firstView;

@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet UIView *backView;

@end
