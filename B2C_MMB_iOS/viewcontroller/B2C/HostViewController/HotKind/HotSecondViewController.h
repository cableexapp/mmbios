//
//  HotSecondViewController.h
//  B2C_MMB_iOS
//
//  Created by cyumen on 14-11-12.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "MBProgressHUD.h"


@interface HotSecondViewController : UIViewController<UIActionSheetDelegate,ConnectionDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    DCFConnectionUtil *conn;
    MBProgressHUD *HUD;

}

//传过来的数组属性
@property (strong, nonatomic) NSArray *upArray;
//手机号码文本输入框属性
@property (weak, nonatomic) IBOutlet UITextField *PhoneNumber;
//接收数据的文本框属性
@property (weak, nonatomic) IBOutlet UITextView *markView;
//提交属性
@property (weak, nonatomic) IBOutlet UIButton *submit;

//提交信息
- (IBAction)submitNews:(UIButton *)sender;

// 字数计数
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@property (weak, nonatomic) IBOutlet UILabel *labelText;

@property (weak, nonatomic) IBOutlet UITextView *secondTextView;








@end
