//
//  SettingViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-10.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UIActionSheetDelegate>
{
    UIActionSheet *as;
}
@property (weak, nonatomic) IBOutlet UIImageView *setIv;
@property (weak, nonatomic) IBOutlet UIImageView *cleanIv;
@property (weak, nonatomic) IBOutlet UISwitch *swith;
@property (weak, nonatomic) IBOutlet UIView *cleanBackView;

@end
