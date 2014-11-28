//
//  SpeedAskPriceFirstViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-21.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"
#import "ELCImagePickerDemoViewController.h"
#import "DCFConnectionUtil.h"
#import "MBProgressHUD.h"
#import "LookForBigPicViewController.h"

@interface SpeedAskPriceFirstViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,QBImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate,ConnectionDelegate,DeletePic,UITextViewDelegate>
{
    ELCImagePickerDemoViewController *elcImagePickerDemoViewController;
    MBProgressHUD *HUD;
    DCFConnectionUtil *conn;
}
@property (weak, nonatomic) IBOutlet UITextField *tel_Tf;
@property (weak, nonatomic) IBOutlet UITextView *content_Tv;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UIButton *lastUpPicBtn;
@property (weak, nonatomic) IBOutlet UILabel *upLabel;
@property (weak, nonatomic) IBOutlet UILabel *showlabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
