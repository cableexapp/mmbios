//
//  MyFastInquiryOrderLookPicViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-12-24.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFastInquiryOrderLookPicViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *sv;
    NSMutableArray *myPicArray;
    int myTag;
}
- (id) initWithArray:(NSMutableArray *) picArray WithTag:(int) tag;
@end
