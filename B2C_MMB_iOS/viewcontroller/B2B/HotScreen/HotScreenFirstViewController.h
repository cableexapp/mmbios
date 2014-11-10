//
//  HotScreenFirstViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-10.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotScreenFirstViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end
