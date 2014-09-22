//
//  LoginViewController.h
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-8-29.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import "DCFConnectionUtil.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}
@property (weak, nonatomic) IBOutlet UITextField *tf_Account;
@property (weak, nonatomic) IBOutlet UITextField *tf_Secrect;
@property (weak, nonatomic) IBOutlet UIView *tf_BackView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@end
