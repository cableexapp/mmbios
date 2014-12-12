//
//  ChooseReceiveAddressViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-24.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "DCFConnectionUtil.h"

@protocol ReceveAddress <NSObject>

- (void) receveAddress:(NSDictionary *) dic;

@end

@interface ChooseReceiveAddressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ConnectionDelegate>
{
    UITableView *tv;
    DCFConnectionUtil *conn;
    NSMutableArray *dataArray;
}


@property (strong,nonatomic) UIView *tvBackView;
@property (strong,nonatomic) UIView *buttomView;
@property (strong,nonatomic) UIButton *buttomBtn;

@property (assign,nonatomic) id<ReceveAddress> delegate;

- (id) initWithDataArray:(NSMutableArray *) arr;

- (void) loadRequest;

- (void) cancelRequest;

@end

