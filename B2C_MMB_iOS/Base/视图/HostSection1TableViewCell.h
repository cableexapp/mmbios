//
//  HostSection1TableViewCell.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-21.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HostSection1BtnClick <NSObject>

- (void) HostSection1BtnClick:(UIButton *) btn;

@end

@interface HostSection1TableViewCell : UITableViewCell
{
    NSArray *btnArray;
}
@property (assign,nonatomic) id<HostSection1BtnClick> delegate;

@property (weak, nonatomic) IBOutlet UIButton *askBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseCabelBtn;
@property (weak, nonatomic) IBOutlet UIButton *B2CEntranceBtn;
@property (weak, nonatomic) IBOutlet UIButton *hotBtn;
@property (weak, nonatomic) IBOutlet UIButton *hotKindBtn;
@property (weak, nonatomic) IBOutlet UIButton *choosePlaceBtn;
@property (weak, nonatomic) IBOutlet UIButton *onLineBtn;
@property (weak, nonatomic) IBOutlet UIButton *telServiceBtn;


@end

