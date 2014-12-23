//
//  AddInvoiceNormalTableViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@protocol PopDelegate <NSObject>

- (void) popDelegate;

- (void) isRequestNormal:(NSString *) str;

@end

@interface AddInvoiceNormalTableViewController : UITableViewController<UITextViewDelegate,ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}
@property (assign,nonatomic) id<PopDelegate> delegate;

- (void) keyBoardHide;

- (NSArray *) validate;

- (void) loadRequest;

@end

