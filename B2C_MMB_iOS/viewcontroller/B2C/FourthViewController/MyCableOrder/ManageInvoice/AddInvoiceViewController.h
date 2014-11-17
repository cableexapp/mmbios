//
//  AddInvoiceViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddInvoiceViewController : UIViewController<UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *normalBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;


@end
