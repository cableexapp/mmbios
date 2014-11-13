//
//  ChatListViewController.h
//  B2C_MMB_iOS
//
//  Created by developer on 14-11-4.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFColorUtil.h"

@interface ChatListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate>
{
    NSString *fromString;
}

@property (nonatomic,strong) UITableView *memberTableView;

@property (nonatomic,strong) NSMutableArray *tempArray;

@property (nonatomic,strong) NSString *fromString;

@end
