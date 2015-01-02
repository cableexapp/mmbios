//
//  MyOrderHostBtnTableViewCell.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyOrderHostBtnTableViewCell.h"

@implementation MyOrderHostBtnTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{

    self.lookForCustomBtn.layer.cornerRadius = 5;

    self.discussBtn.layer.cornerRadius = 5;

    self.lookForTradeBtn.layer.cornerRadius = 5;

    self.cancelOrderBtn.layer.cornerRadius = 5;

    self.onLinePayBtn.layer.cornerRadius = 5;

    self.receiveBtn.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
