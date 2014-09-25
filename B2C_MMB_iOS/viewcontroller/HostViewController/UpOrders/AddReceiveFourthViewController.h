//
//  AddReceiveFourthViewController.h
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

@interface AddReceiveFourthViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tv;
}
@property (strong,nonatomic) NSDictionary *myDic;
@property (strong,nonatomic) NSString *town;
@property (strong,nonatomic) NSString *provinceAndCityAndTown;

- (id) initWithData:(NSDictionary *) dic WithCity:(NSString *) city;
@property (strong,nonatomic) FMDatabase *db;

@end
