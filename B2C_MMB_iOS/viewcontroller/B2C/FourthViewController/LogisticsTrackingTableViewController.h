//
//  LogisticsTrackingTableViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-27.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LogisticsTrackingTableViewController : UITableViewController
@property (strong,nonatomic) NSMutableArray *myArray;

@property (assign,nonatomic) BOOL isRequest;  //判断是否正在请求数据

- (void) reloadData:(BOOL) status;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

