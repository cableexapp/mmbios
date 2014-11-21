//
//  FindBackSec_SecondViewController.h
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-9.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFPickerView.h"
#import "DCFConnectionUtil.h"
@interface FindBackSec_SecondViewController : UIViewController<PickerView,UITextFieldDelegate,ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIButton *getValidateBtn;
@property (weak, nonatomic) IBOutlet UITextField *tf_getValidate;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *secondLine;
@property (weak, nonatomic) IBOutlet UIView *firstView;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (assign,nonatomic) BOOL isMobileOrEmail;

@end
