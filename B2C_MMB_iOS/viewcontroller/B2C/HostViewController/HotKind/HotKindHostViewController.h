//
//  HotKindHostViewController.h
//  B2C_MMB_iOS
//
//  Created by cyumen on 14-11-7.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotKindHostViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *myTV;

@end
