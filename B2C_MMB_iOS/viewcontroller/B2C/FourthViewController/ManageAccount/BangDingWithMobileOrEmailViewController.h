//
//  BangDingWithMobileOrEmailViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "DCFPickerView.h"

@interface BangDingWithMobileOrEmailViewController : UIViewController<PickerView,UITextFieldDelegate,ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}

@property (strong,nonatomic) NSString *myPhone;
@property (strong,nonatomic) NSString *myEmail;

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIButton *getValidateBtn;
@property (weak, nonatomic) IBOutlet UITextField *tf_getValidate;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *secondLine;
@property (weak, nonatomic) IBOutlet UIView *firstView;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UILabel *buttomLabel;


@property (assign,nonatomic) BOOL isMobileOrEmail;
@end
