//
//  CableSecondAndThirdStepViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-8.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CableSecondStepTableViewController.h"
#import "CableThirdStepViewController.h"

#pragma mark - 二级三级界面
@interface CableSecondAndThirdStepViewController : UIViewController<Change,PushString>

@property (strong,nonatomic) NSString *typeId;

@property (weak, nonatomic) IBOutlet UIView *secondTypeView;
@property (weak, nonatomic) IBOutlet UIView *thirdTypeView;

@property (strong,nonatomic) NSString *myTitle;

@property (nonatomic,strong) NSString *fromPage;

@end
