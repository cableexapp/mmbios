//
//  BillMsgManagerViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-26.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFMyTextField.h"
#import "DCFConnectionUtil.h"


@interface BillMsgManagerViewController : UIViewController<UITextFieldDelegate,ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}
@property (assign,nonatomic) BOOL editOrAddBill;

@property (strong,nonatomic) NSString *naviTitle;

@property (assign,nonatomic)  int billHeadTag;

@property (strong,nonatomic) NSString *tfContent;

@property (strong,nonatomic) NSString *invoiceid;
@end

