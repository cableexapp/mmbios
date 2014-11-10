//
//  HotScreenSecondViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-10.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface HotScreenSecondViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@property (weak, nonatomic) IBOutlet UITextField *myTextField;

@property (weak, nonatomic) IBOutlet UIButton *upBtn;

@property (weak, nonatomic) IBOutlet UILabel *textViewLabel;


@property (strong,nonatomic) NSString *screen;

@end
