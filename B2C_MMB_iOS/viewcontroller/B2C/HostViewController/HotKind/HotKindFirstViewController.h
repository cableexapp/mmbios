//
//  HotKindFirstViewController.h
//  B2C_MMB_iOS
//
//  Created by cyumen on 14-11-5.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface HotKindFirstViewController : UIViewController<ConnectionDelegate>
{
    DCFConnectionUtil *conn;
}
@end
