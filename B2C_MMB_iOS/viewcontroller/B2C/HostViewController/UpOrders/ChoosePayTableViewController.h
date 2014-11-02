//
//  ChoosePayTableViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-26.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface ChoosePayTableViewController : UITableViewController<ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}
- (id) initWithTotal:(NSString *) total WithValue:(NSString *) value WithShopName:(NSString *) shopName WithProductTitle:(NSString *) productTitle;
@end
