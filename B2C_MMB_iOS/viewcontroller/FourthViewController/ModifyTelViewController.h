//
//  ModifyTelViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-18.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface ModifyTelViewController : UIViewController<UITextFieldDelegate,ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UIButton *identifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;

@end
