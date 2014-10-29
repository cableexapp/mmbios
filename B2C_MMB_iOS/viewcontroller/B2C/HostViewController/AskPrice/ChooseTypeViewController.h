//
//  ChooseTypeViewController.h
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-19.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"

@interface ChooseTypeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView *tv;
    UISearchBar *searchBar;
}
@property (strong,nonatomic) NSString *headTitle;

- (id) initWithHeadTitle:(NSString *) title;

@end
