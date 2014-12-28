//
//  AddReceiveAddressSecondViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-25.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "FMDatabase.h"

@interface AddReceiveAddressSecondViewController :UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tv;
}
@property (strong,nonatomic) NSDictionary *myDic;
@property (strong,nonatomic) NSString *province;
@property (strong,nonatomic) NSDictionary *pushDic;

- (id) initWithData:(NSDictionary *) dic;
@property (strong,nonatomic) FMDatabase *db;

@property (assign,nonatomic) BOOL edit;

@end
