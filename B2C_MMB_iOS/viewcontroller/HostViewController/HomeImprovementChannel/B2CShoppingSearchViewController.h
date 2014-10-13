//
//  B2CShoppingSearchTableViewController.h
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-16.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface B2CShoppingSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
//    NSDictionary *myDic;
	BOOL *flag;
	
	UIView *view1;
	UIView *view2;

    UITableView *tv;
    
    CGRect myRect;
}

- (id) initWithFrame:(CGRect) rect;

- (void) addHeadView;

@property (nonatomic,retain) NSDictionary *myDic;

@property (strong,nonatomic) UIButton *clearBtn;
@property (strong,nonatomic) UIView *lineView;
@property (strong,nonatomic) UIButton *sureBtn;

@end

