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


@interface RegisterViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate,ConnectionDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    MBProgressHUD *HUD;
}




@property (weak, nonatomic) IBOutlet UIView *subView;

@property (weak, nonatomic) IBOutlet UIScrollView *sv;

@property (weak, nonatomic) IBOutlet UIButton *regesterBtn;

@property (weak, nonatomic) IBOutlet UITextField *userTf;
@property (weak, nonatomic) IBOutlet UITextField *secTf;
@property (weak, nonatomic) IBOutlet UILabel *sureSecLabel;
@property (weak, nonatomic) IBOutlet UITextField *sureSecTf;
@property (weak, nonatomic) IBOutlet UIButton *getValidateBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

- (IBAction)agreeBtn:(id)sender;

@end


