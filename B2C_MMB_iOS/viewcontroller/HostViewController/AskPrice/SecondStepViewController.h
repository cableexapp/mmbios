//
//  SecondStepViewController.h
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-19.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"

@interface SecondStepViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tv;
}
@property (strong,nonatomic) NSString *headTitle;

- (id) initWithHeadTitle:(NSString *) title;
@end
