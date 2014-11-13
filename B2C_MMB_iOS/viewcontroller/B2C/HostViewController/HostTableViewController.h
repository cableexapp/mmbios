//
//  HostTableViewController.h
//  tttt
//
//  Created by xiaochen on 14-8-29.
//  Copyright (c) 2014年 MySelfDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EScrollerView.h"
#import "HostSection1TableViewCell.h"
#import "DCFConnectionUtil.h"
#import "DCFColorUtil.h"

@interface HostTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,EScrollerViewDelegate,HostSection1BtnClick,ConnectionDelegate>
{
    DCFConnectionUtil *conn;
    EScrollerView *es;
}

@end
