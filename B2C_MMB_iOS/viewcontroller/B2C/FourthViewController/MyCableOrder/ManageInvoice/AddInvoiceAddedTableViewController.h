//
//  AddInvoiceAddedTableViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface AddInvoiceAddedTableViewController : UITableViewController<UITextViewDelegate,ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}
@property (weak, nonatomic) IBOutlet UITextView *headTextView;

@property (weak, nonatomic) IBOutlet UITextView *companyName;

- (void) keyBoardHide;

//- (NSArray *) validate;

- (void) loadRequest;
@end
