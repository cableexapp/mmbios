//
//  DCFNavigationBar.m
//  DCFTeacherEnd
//
//  Created by jhq on 14-4-9.
//  Copyright (c) 2014年 dqf. All rights reserved.
//

#import "DCFNavigationBar.h"
#import "DCFCustomExtra.h"
#import "DCFColorUtil.h"

@implementation DCFNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) awakeFromNib
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [self setBackgroundImage:[DCFCustomExtra imageWithColor:[DCFColorUtil colorFromHexRGB:@"#1465ba"] size:CGSizeMake(1, 1)] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self setBackgroundImage:[DCFCustomExtra imageWithColor:[DCFColorUtil colorFromHexRGB:@"#1465ba"] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    }
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
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
