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
@optional
- (void) headerviewDidClickeNameview: (HotKindFirstViewController *)headerView;


@end

@interface HotKindFirstViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *typeBtn;

@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@property (weak, nonatomic) IBOutlet UITableView *testTableView;

@property (weak, nonatomic) IBOutlet UITableView *testSubTableView;

@property (weak, nonatomic) IBOutlet UIButton *upBtn;

@property (nonatomic, assign,getter = isOpened) BOOL opend;


@property (nonatomic, weak) id <HotKindHostViewControllerDelegate> delegate;



@end
