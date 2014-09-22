//
//  ChooseListTableViewController.h
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-8-30.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFPickerView.h"

@interface ChooseListTableViewController : UITableViewController<PickerView,UISearchBarDelegate>
{
    UISearchBar *mySearchBar;
    
}
@end
