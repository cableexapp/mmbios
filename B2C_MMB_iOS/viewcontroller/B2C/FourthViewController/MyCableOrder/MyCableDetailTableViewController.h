//
//  MyCableDetailTableViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "B2BMyCableDetailData.h"

@protocol RequestHasFinished <NSObject>

- (void) requestHasFinished:(B2BMyCableDetailData *) b2bMyCableDetailData;

@end

@interface MyCableDetailTableViewController : UITableViewController<ConnectionDelegate>
{
    DCFConnectionUtil *conn;
    NSString *status;
}

@property (strong,nonatomic) NSString *myOrderid;

@property (assign,nonatomic) id<RequestHasFinished> delegate;

//@property (assign,nonatomic) BOOL isWaitForReceive;
@end

