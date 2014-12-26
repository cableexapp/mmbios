//
//  MyInquiryDetailTableViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-7.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@protocol ChangeStatusDelegate <NSObject>

- (void) ChangeStatusDelegate:(NSArray *) array;

@end

@interface MyInquiryDetailTableViewController : UITableViewController<ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}


@property (strong,nonatomic) NSString *myInquiryid;
@property (strong,nonatomic) NSDictionary *addressDic;

@property (assign,nonatomic) id<ChangeStatusDelegate> delegate;

@end

