//
//  MyFastInquiryOrder.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-10.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "B2BMyInquiryListFastData.h"
#import "DCFConnectionUtil.h"

@interface MyFastInquiryOrder : UIViewController<ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}
@property (strong,nonatomic) B2BMyInquiryListFastData *fastData;

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *sv;

@property (weak, nonatomic) IBOutlet UILabel *upTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UILabel *linkManLabel;

@property (weak, nonatomic) IBOutlet UILabel *requestFirstLabel;

@property (weak, nonatomic) IBOutlet UIButton *againAskBtn;

@property (weak, nonatomic) IBOutlet UIButton *lookBtn;


@end
