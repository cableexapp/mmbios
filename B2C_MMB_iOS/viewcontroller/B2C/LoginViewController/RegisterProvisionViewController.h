//
//  RegisterProvisionViewController.h
//  B2C_MMB_iOS
//
//  Created by developer on 15-1-1.
//  Copyright (c) 2015年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface RegisterProvisionViewController : UIViewController<UIWebViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@end
