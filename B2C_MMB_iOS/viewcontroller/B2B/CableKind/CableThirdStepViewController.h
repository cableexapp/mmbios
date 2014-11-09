//
//  CableThirdStepViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-8.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"


@protocol PushString <NSObject>

- (void) pushString:(NSString *) string WithTypeId:(NSString *) typeId;

@end

@interface CableThirdStepViewController : UIViewController<ConnectionDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tv;
    DCFConnectionUtil *conn;

}
@property (assign,nonatomic) id<PushString> delegate;

@property (assign,nonatomic) float width;
@property (assign,nonatomic) float height;

@property (strong,nonatomic) NSString *myTypeId;
@property (strong,nonatomic) NSString *myTitle;

- (void) changeClassify:(NSString *) typeId WithTitle:(NSString *) title;

//- (id) initWithFrame:(CGRect) rect;
@end
