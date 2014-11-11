//
//  WaitViewController.h
//  B2C_MMB_iOS
//
//  Created by developer on 14-11-4.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PICircularProgressView.h"
#import "XMPPFramework.h"

@interface WaitViewController : UIViewController<UIAlertViewDelegate>
{
    NSString *tempGroup;
    XMPPRoom * xmppRoom;
    NSString *tempFrom;
}

@property (nonatomic,strong) PICircularProgressView *progressView;

@property (nonatomic,strong) NSString *tempGroup;

@property (nonatomic,strong) XMPPRoom *xmppRoom;

@property (nonatomic,strong) NSString *tempFrom;

@end
