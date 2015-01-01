//
//  ValidateForPhoneViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-20.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface ValidateForPhoneViewController : UIViewController<ConnectionDelegate,UITextFieldDelegate>
{
    DCFConnectionUtil *conn;
}

@property (weak, nonatomic) IBOutlet UIImageView *topiV;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *validateBtn;
@property (weak, nonatomic) IBOutlet UITextField *telTf;
@property (weak, nonatomic) IBOutlet UIButton *buttomBtn;
@property (strong, nonatomic) IBOutlet UIView *backView;

@end
