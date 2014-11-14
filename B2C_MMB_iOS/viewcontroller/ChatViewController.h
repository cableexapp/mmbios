//
//  ChatViewController.h
//  B2C_MMB_iOS
//
//  Created by 丁瑞 on 14-10-19.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceBoard.h"
#import "EGORefreshTableHeaderView.h"
#import <sqlite3.h>
#import "XMPPFramework.h"
#import <AVFoundation/AVFoundation.h>
#import "DCFColorUtil.h"

@interface ChatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,FaceBoardDelegate,EGORefreshTableHeaderDelegate,UIAlertViewDelegate,XMPPRoomDelegate,XMPPMUCDelegate>
{
    FaceBoard *faceBoard;
    
    BOOL isFirstShowKeyboard;
    
    BOOL isButtonClicked;
    
    BOOL isKeyboardShowing;
    
    BOOL isSystemBoardShow;
    
    CGFloat keyboardHeight;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;//主要是记录是否在刷新中
    
    NSMutableArray *tempNameArray;
    
#pragma mark - 时间标记
@private
    NSMutableArray * ArrTimeCheck;
    NSString * StrTimeCheck;
    
    NSMutableArray * TimeArray;
    NSString * TimeString;
    
    //用于控制翻页查询
    //初始值为1
    int pageIndex;
    XMPPRoom * xmppRoom;
    
    AVAudioPlayer * messageSound;
    
    //标记客服咨询入口
    NSString *fromStringFlag;
}

@property (nonatomic,strong) NSMutableArray *chatArray;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *tempNameArray;

@property (nonatomic,strong) NSMutableArray *timeFlagArray;

@property (nonatomic,strong) XMPPRoom *xmppRoom;

@property (nonatomic,strong) NSString *fromStringFlag;

//时间中间量
@property NSDate *tempDate;

- (void)reloadTableViewDataSource;

- (void)doneLoadingTableViewData;

@end
