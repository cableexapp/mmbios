//
//  NormalInquiryListTableViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-6.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"
#import "CKRefreshControl.h"
#import "EGORefreshTableHeaderView.h"
#import "MyNormalInquiryDetailController.h"
#import "B2BMyInquiryListNormalData.h"

@protocol PushToNextVC <NSObject>

- (void) pushToNextVC:(MyNormalInquiryDetailController *) myNormalInquiryDetailController WithData:(B2BMyInquiryListNormalData *) data;

@end

@interface NormalInquiryListTableViewController : UITableViewController<ConnectionDelegate,EGORefreshTableHeaderDelegate>
{
    DCFConnectionUtil *conn;
}
@property(nonatomic,strong) EGORefreshTableHeaderView *refreshView;
@property (assign,nonatomic) id<PushToNextVC> delegate;

- (void) loadRequest;


@end

