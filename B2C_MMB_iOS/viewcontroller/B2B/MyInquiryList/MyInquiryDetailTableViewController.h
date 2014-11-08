//
//  MyInquiryDetailTableViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-7.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface MyInquiryDetailTableViewController : UITableViewController<ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}


@property (strong,nonatomic) NSString *myInquiryid;
@property (strong,nonatomic) NSDictionary *addressDic;

@end
