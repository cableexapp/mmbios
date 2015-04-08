//
//  NetDownPayViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 15-4-3.
//  Copyright (c) 2015年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"
#import "ELCImagePickerDemoViewController.h"
#import "LookForBigPicViewController.h"

@interface NetDownPayViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,QBImagePickerControllerDelegate,UINavigationControllerDelegate,DeletePic>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UILabel *bankLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *uplabel;



@end
