//
//  OneStepCell.h
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-18.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OneStepDelegate <NSObject>

- (void) askDelegate;

- (void) onLineDelegate;

- (void) upDelegate;

@end

@interface OneStepCell : UITableViewCell
@property (assign,nonatomic) id<OneStepDelegate> delegate;
@end
