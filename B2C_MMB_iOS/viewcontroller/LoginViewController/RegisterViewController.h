//
//  RegisterViewController.h
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-9.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DCFConnectionUtil.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate,ConnectionDelegate>
{
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITextField *tf_account;
@property (weak, nonatomic) IBOutlet UITextField *tf_sec;
@property (weak, nonatomic) IBOutlet UITextField *tf_confirm;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end
