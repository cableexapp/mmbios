//
//  MyShoppingListViewController.h
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-1.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

#pragma mark - 购物车列表

@interface MyShoppingListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ConnectionDelegate,UIAlertViewDelegate>
{
    UITableView *tv;
    
    DCFConnectionUtil *conn;
    
    UITableViewCell *noCell;
}

- (id) initWithDataArray:(NSArray *) arr;


@end
