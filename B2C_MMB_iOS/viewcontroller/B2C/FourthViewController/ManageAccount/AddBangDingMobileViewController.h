//
//  AddBangDingMobileViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-16.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface AddBangDingMobileViewController : UIViewController<ConnectionDelegate,UITextFieldDelegate>
{
    DCFConnectionUtil *conn;
}

@property (weak, nonatomic) IBOutlet UITextField *teltf;
@property (weak, nonatomic) IBOutlet UIButton *validateBtn;
@property (weak, nonatomic) IBOutlet UITextField *validateTf;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;

@end
