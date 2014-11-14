//
//  SearchViewController.h
//  B2C_MMB_iOS
//
//  Created by developer on 14-11-11.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong) UITableView *serchResultView;

@end
