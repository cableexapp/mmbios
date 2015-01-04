//
//  SearchViewController.h
//  B2C_MMB_iOS
//
//  Created by developer on 14-11-11.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import <sqlite3.h>
#import <AVFoundation/AVFoundation.h>

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ConnectionDelegate,IFlyRecognizerViewDelegate>
{
    DCFConnectionUtil *conn;
    
    IFlyRecognizerView *_iflyRecognizerView;
    
    sqlite3 *contactDBB2C;

    NSString *databasePathB2C;

    NSString *searchFlag;
}

@property (nonatomic,strong) UITableView *serchResultView;

@property (nonatomic,strong) NSString *searchFlag;

@end
