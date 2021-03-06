//
//  LoginViewController.h
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-8-29.
//  Copyright (c) 2014年 App01. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "MBProgressHUD.h"
#import "RegisterViewController.h"
#import "XMPPFramework.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,ConnectionDelegate,MBProgressHUDDelegate>
{
    DCFConnectionUtil *conn;
    
    MBProgressHUD *HUD;
    
    XMPPStream * xmppStream;
}
@property (weak, nonatomic) IBOutlet UITextField *tf_Account;
@property (weak, nonatomic) IBOutlet UITextField *tf_Secrect;
@property (weak, nonatomic) IBOutlet UIView *tf_BackView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic,strong) XMPPStream *xmppStream;

@property (assign,nonatomic) BOOL flag;

@end
