//
//  SixHostSearchView.h
//  B2C_MMB_iOS
//
//  Created by App01 on 15-3-31.
//  Copyright (c) 2015年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SixHostSearchView : UIView<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *searchSV;
    
    NSArray *searchDataArray;
    
    UIButton *clearBtn;
}

- (id) initWithCustomFrame:(CGRect)rect;

@end
