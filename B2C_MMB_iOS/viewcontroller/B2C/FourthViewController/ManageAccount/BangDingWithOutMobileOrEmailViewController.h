//
//  BangDingWithOutMobileOrEmailViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface BangDingWithOutMobileOrEmailViewController : UIViewController<UITextFieldDelegate,ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}

@property (weak, nonatomic) IBOutlet UITextField *oldSecTf;
@property (weak, nonatomic) IBOutlet UITextField *setNewSecTf;
@property (weak, nonatomic) IBOutlet UITextField *sureSecTf;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end
