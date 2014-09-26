//
//  UpOrderViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-9-23.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFPickerView.h"

@interface UpOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PickerView>
{
    UITableView *tv;
}
@end
