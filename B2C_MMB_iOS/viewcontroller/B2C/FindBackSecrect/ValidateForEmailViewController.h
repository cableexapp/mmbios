//
//  ValidateForEmailViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-20.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface ValidateForEmailViewController : UIViewController<ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}

@property (weak, nonatomic) IBOutlet UIImageView *topIv;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *validateBtn;
@property (weak, nonatomic) IBOutlet UILabel *buttomLabel;



@end
