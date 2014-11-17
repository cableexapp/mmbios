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

@interface BangDingWithMobileOrEmailViewController : UIViewController<UITextFieldDelegate,ConnectionDelegate,PickerView>
{
    DCFConnectionUtil *conn;
    DCFPickerView *pickerView;
}

@property (strong,nonatomic) NSString *myPhone;
@property (strong,nonatomic) NSString *myEmail;

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;
@property (weak, nonatomic) IBOutlet UIButton *validateBtn;
@property (weak, nonatomic) IBOutlet UITextField *validateTf;

@end
