//
//  CableChoosemodelViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-9.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFChenMoreCell.h"
#import "DCFConnectionUtil.h"

@interface CableChoosemodelViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ConnectionDelegate>
{
    DCFConnectionUtil *conn;
    UILabel *topLabel;
    UISearchBar *mySearch;
    UITableView *myTv;
    DCFChenMoreCell *moreCell;
}
@property (strong,nonatomic) NSString *myTitle;
@property (strong,nonatomic) NSString *myTypeId;

@end
