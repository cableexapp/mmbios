//
//  FindBackSec_SecondViewController.h
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-9.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFPickerView.h"

@interface FindBackSec_SecondViewController : UIViewController<PickerView,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIButton *getValidateBtn;
@property (weak, nonatomic) IBOutlet UITextField *tf_getValidate;

@end
