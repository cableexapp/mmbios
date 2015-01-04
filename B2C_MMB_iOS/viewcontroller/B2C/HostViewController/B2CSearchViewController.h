//
//  B2CSearchViewController.h
//  B2C_MMB_iOS
//
//  Created by developer on 15-1-4.
//  Copyright (c) 2015年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import <sqlite3.h>
#import <AVFoundation/AVFoundation.h>

@interface B2CSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ConnectionDelegate,IFlyRecognizerViewDelegate>
{
    DCFConnectionUtil *conn;
    
    IFlyRecognizerView *_iflyRecognizerView;
    
    NSString *tempSearchText;
}

@property(nonatomic,strong) NSString *tempSearchText;

@end
