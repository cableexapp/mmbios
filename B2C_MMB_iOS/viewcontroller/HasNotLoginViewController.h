//
//  HasNotLoginViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-24.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface HasNotLoginViewController : UIViewController<ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;


@end
