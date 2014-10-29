//
//  OneStepViewController.h
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-18.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDefine.h"
#import "OneStepCell.h"

@interface OneStepViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,OneStepDelegate>
{
    UITableView *tv;
}
@end
