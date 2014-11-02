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
    self.lookForCustomBtn.layer.borderColor = [UIColor colorWithRed:65.0/255.0 green:99.0/255.0 blue:114.0/255.0 alpha:1.0].CGColor;
    self.lookForCustomBtn.layer.borderWidth = 1.0f;
    self.lookForCustomBtn.layer.cornerRadius = 5;
    
    self.discussBtn.layer.borderColor = [UIColor colorWithRed:65.0/255.0 green:99.0/255.0 blue:114.0/255.0 alpha:1.0].CGColor;
    self.discussBtn.layer.borderWidth = 1.0f;
    self.discussBtn.layer.cornerRadius = 5;

    self.lookForTradeBtn.layer.borderColor = [UIColor colorWithRed:65.0/255.0 green:99.0/255.0 blue:114.0/255.0 alpha:1.0].CGColor;
    self.lookForTradeBtn.layer.borderWidth = 1.0f;
    self.lookForTradeBtn.layer.cornerRadius = 5;

    self.cancelOrderBtn.layer.borderColor = [UIColor colorWithRed:65.0/255.0 green:99.0/255.0 blue:114.0/255.0 alpha:1.0].CGColor;
    self.cancelOrderBtn.layer.borderWidth = 1.0f;
    self.cancelOrderBtn.layer.cornerRadius = 5;

    
    self.onLinePayBtn.layer.borderColor = [UIColor colorWithRed:65.0/255.0 green:99.0/255.0 blue:114.0/255.0 alpha:1.0].CGColor;
    self.onLinePayBtn.layer.borderWidth = 1.0f;
    self.onLinePayBtn.layer.cornerRadius = 5;
    
    
    self.receiveBtn.layer.borderColor = [UIColor colorWithRed:65.0/255.0 green:99.0/255.0 blue:114.0/255.0 alpha:1.0].CGColor;
    self.receiveBtn.layer.borderWidth = 1.0f;
    self.receiveBtn.layer.cornerRadius = 5;

    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
