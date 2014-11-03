//
//  HotClasscifyViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-27.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "MBProgressHUD.h"

@interface HotClasscifyViewController : UIViewController<UIScrollViewDelegate,ConnectionDelegate,MBProgressHUDDelegate>
{
    DCFConnectionUtil *conn;
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UIButton *serchBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UIButton *addToAskPriceBtn;

@property (weak, nonatomic) IBOutlet UIButton *hotLineBtn;
@property (weak, nonatomic) IBOutlet UIButton *imBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreModelBtn;
@property (weak, nonatomic) IBOutlet UIButton *directBtn;


@end
