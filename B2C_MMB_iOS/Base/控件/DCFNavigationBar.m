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
//    [self setTranslucent:YES];
    //ios7下面更改的是导航条的背景色，ios6下面更改的是返回按钮的背景色
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
//        [self setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor redColor] size:CGSizeMake(1, 1)] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];

        [self setBackgroundImage:[DCFCustomExtra imageWithColor:[DCFColorUtil colorFromHexRGB:@"#1465ba"] size:CGSizeMake(1, 1)] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self setBackgroundImage:[DCFCustomExtra imageWithColor:[DCFColorUtil colorFromHexRGB:@"#1465ba"] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    }
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void) changeBackGroundColor
{

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
