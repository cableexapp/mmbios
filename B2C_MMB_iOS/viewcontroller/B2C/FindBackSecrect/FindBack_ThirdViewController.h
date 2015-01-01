//
//  FindBack_ThirdViewController.h
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-9.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "MBProgressHUD.h"

@interface FindBack_ThirdViewController : UIViewController<UITextFieldDelegate,ConnectionDelegate,MBProgressHUDDelegate>
{
    DCFConnectionUtil *conn;
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UITextField *tf_newSec;
@property (weak, nonatomic) IBOutlet UITextField *tf_sureSec;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
