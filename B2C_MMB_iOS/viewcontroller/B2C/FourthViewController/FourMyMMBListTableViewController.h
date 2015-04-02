//
//  FourMyMMBListTableViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-17.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "HasNotLoginViewController.h"
#import "CKRefreshControl.h"
#import "EGORefreshTableHeaderView.h"

@interface FourMyMMBListTableViewController : UITableViewController<ConnectionDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITabBarControllerDelegate,UITabBarDelegate,EGORefreshTableHeaderDelegate>
{
    HasNotLoginViewController *hasNotLoginViewController;
    DCFConnectionUtil *conn;
    BOOL _reloading;
}

@property(nonatomic,strong) UIImageView *photoBtn;
@property (nonatomic,strong) UIImage *userImage;

@property (weak, nonatomic) IBOutlet UIButton *btn_2;
@property (weak, nonatomic) IBOutlet UIButton *btn_3;

@property (weak, nonatomic) IBOutlet UIButton *btn_8;
@property (weak, nonatomic) IBOutlet UIButton *btn_9;
@property (weak, nonatomic) IBOutlet UIButton *btn_10;
@property (weak, nonatomic) IBOutlet UIButton *btn_11;

@property (weak, nonatomic) IBOutlet UIButton *customOrderBtn;

@property(nonatomic,strong) EGORefreshTableHeaderView *refreshView;

@end
