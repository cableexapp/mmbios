//
//  ShopHostPreTableViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-11.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PushText <NSObject>

- (void) pushText:(NSString *) text;

@end

@interface ShopHostPreTableViewController : UITableViewController<UIGestureRecognizerDelegate>
{
    NSMutableArray *discussArray;
    NSArray *ListArray;
    NSString *headTitle;
}

@property (nonatomic,retain) NSDictionary *myDic;
@property (assign,nonatomic) id<PushText> delegate;

- (id) initWithScoreArray:(NSArray *) scoreArray WithListArray:(NSArray *) listArray WithTitle:(NSString *) title;
@end
