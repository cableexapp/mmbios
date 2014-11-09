//
//  CableSecondStepTableViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-8.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@protocol Change <NSObject>

- (void) changeWithTypeId:(NSString *) typeId WithTypeName:(NSString *) typeName;

@end

@interface CableSecondStepTableViewController : UITableViewController<ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}
@property (assign,nonatomic) id<Change> delegate;
@property (strong,nonatomic) NSString *myTypeId;
@property (assign,nonatomic) float width;
@property (assign,nonatomic) float height;

@property (strong,nonatomic) NSString *title;

@end

