//
//  ShoppingHostViewController.h
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-1.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingHostViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *sv;
    
    UITableView *tv;
}
@end
