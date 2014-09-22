//
//  HostTableViewController.h
//  tttt
//
//  Created by xiaochen on 14-8-29.
//  Copyright (c) 2014年 MySelfDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EScrollerView.h"



@interface HostTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,EScrollerViewDelegate>
{
    EScrollerView *es;
}
@end
