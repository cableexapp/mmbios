//
//  HotKindHostViewController.h
//  B2C_MMB_iOS
//
//  Created by cyumen on 14-11-7.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HotKindFirstViewController;


@protocol HotKindHostViewControllerDelegate <NSObject>


	@end

@interface HotKindFirstViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
//选中属性
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
//清空属性
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
//大的Tabview
@property (weak, nonatomic) IBOutlet UITableView *testTableView;
//小的Tabview
@property (weak, nonatomic) IBOutlet UITableView *testSubTableView;
//提交属性
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
//提交按钮
- (IBAction)clickSubmit:(id)sender;
//展开选中
@property (nonatomic, assign,getter = isOpened) BOOL opend;

@property (weak, nonatomic) IBOutlet UIView *selectView;


@property (weak, nonatomic) IBOutlet UIButton *triangleBtn;


- (IBAction)serarchRightBtn:(id)sender;





@end
