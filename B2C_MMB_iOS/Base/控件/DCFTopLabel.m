//
//  TopLabel.m
//  com.up360
//
//  Created by jhq on 14-3-10.
//  Copyright (c) 2014年 jhq. All rights reserved.
//

#import "DCFTopLabel.h"

@implementation DCFTopLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id) initWithTitle:(NSString *) string
{
    if(self = [super init])
    {
        //        [self sizeToFit];
        self.frame = CGRectMake(110, 0, 100, 44);
        [self setBackgroundColor:[UIColor clearColor]];
        [self setText:string];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setTextColor:[UIColor colorWithRed:18.0/255.0 green:104.0/255.0 blue:253.0/255.0 alpha:1.0]];
        [self setFont:[UIFont systemFontOfSize:20]];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
    