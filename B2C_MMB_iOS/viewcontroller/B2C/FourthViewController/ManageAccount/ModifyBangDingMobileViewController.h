//
//  ModifyBangDingMobileViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-16.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface ModifyBangDingMobileViewController : UIViewController<ConnectionDelegate,UITextFieldDelegate>
{
    DCFConnectionUtil *conn;
}

@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UIButton *validateBtn;
@property (weak, nonatomic) IBOutlet UITextField *validateTf;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
