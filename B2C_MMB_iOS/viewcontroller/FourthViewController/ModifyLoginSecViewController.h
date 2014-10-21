//
//  ModifyLoginSecViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-17.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface ModifyLoginSecViewController : UIViewController<UITextFieldDelegate,ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}
@property (weak, nonatomic) IBOutlet UITextField *tf_first;
@property (weak, nonatomic) IBOutlet UITextField *tf_second;

@end
