//
//  UIViewController+AddPushAndPopStyle.m
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-8-29.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import "UIViewController+AddPushAndPopStyle.h"

@implementation UIViewController (AddPushAndPopStyle)

- (void) pushAndPopStyle
{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:0 target:self action:@selector(back:)];
    [back setTitle:@"返回"];
    
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];

    
    if(systemVersion >= 7.0)
    {
//        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:18.0/255.0 green:104.0/255.0 blue:253.0/255.0 alpha:1.0]];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    else
    {
        [back setTintColor:[UIColor whiteColor]];
    }
    self.navigationItem.backBarButtonItem = back;
}

- (void) back:(UIBarButtonItem *) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
