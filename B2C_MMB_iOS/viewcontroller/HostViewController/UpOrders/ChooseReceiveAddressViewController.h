//
//  ChooseReceiveAddressViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-24.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"

@interface ChooseReceiveAddressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tv;
}
@property (weak, nonatomic) IBOutlet UIView *tvBackView;
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (weak, nonatomic) IBOutlet UIButton *buttomBtn;

@end
