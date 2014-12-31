//
//  B2CShoppingSearchTableViewController.h
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-16.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "MBProgressHUD.h"

@protocol RequestString <NSObject>

- (void) requestStringWithUse:(NSString *) myUse WithBrand:(NSString *) myBrand WithSpec:(NSString *) mySpec WithModel:(NSString *) myModel WithSeq:(NSString *) mySeq;

@end

@interface B2CShoppingSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ConnectionDelegate,MBProgressHUDDelegate>
{
//    NSDictionary *myDic;
	BOOL *flag;

	UIView *headClickView;

    UITableView *tv;
    
    CGRect myRect;
    
    DCFConnectionUtil *conn;
    
    MBProgressHUD *HUD;
}

- (id) initWithFrame:(CGRect) rect;
- (void)brandBtnClick:(UIButton *)button;

@property (strong,nonatomic) NSMutableArray *ScreeningCondition;

- (void) addHeadView;

@property (nonatomic,retain) NSDictionary *myDic;
@property (strong,nonatomic) UIButton *clearBtn;
@property (strong,nonatomic) UIView *lineView;
@property (strong,nonatomic) UIButton *sureBtn;
@property (strong,nonatomic) id<RequestString> delegate;

@end
