//
//  OneStepCell.m
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-18.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import "OneStepCell.h"

@implementation OneStepCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)ask:(id)sender
{
    if([self.delegate respondsToSelector:@selector(askDelegate)])
    {
        [self.delegate askDelegate];
    }
}

- (IBAction)online:(id)sender
{
    if([self.delegate respondsToSelector:@selector(onLineDelegate)])
    {
        [self.delegate onLineDelegate];
    }
}

- (IBAction)up:(id)sender
{
    if([self.delegate respondsToSelector:@selector(upDelegate)])
    {
        [self.delegate upDelegate];
    }
}

@end
