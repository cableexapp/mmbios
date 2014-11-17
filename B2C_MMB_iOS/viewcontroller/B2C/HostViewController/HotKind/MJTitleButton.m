 //
//  MJTitleButton.m
//  00-ItcastLottery
//
//  Created by apple on 14-4-16.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJTitleButton.h"

#import <Availability.h>

// 判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

@interface MJTitleButton()
@property (nonatomic, strong) UIFont *titleFont;
@end

// initWithCoder  --->  awakeFromNib
@implementation MJTitleButton

/**
 *  当一个对象从xib或者storyboard中加载完毕后,就会调用一次
 */
//- (void)awakeFromNib
//{
//    NSLog(@"awakeFromNib");
////    self.titleFont = [UIFont systemFontOfSize:14];
//}

/**
 *  从文件中解析一个对象的时候就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

/**
 *  通过代码创建控件的时候就会调用
 */
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

/**
 *  初始化
 */
- (void)setup
{
    self.titleFont = [UIFont systemFontOfSize:14];
    self.titleLabel.font = self.titleFont;
    
    // 图标居中
    self.imageView.contentMode = UIViewContentModeCenter;
}


/**
 *  控制器内部label的frame
 *  contentRect : 按钮自己的边框
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    NSDictionary *attrs = @{NSFontAttributeName : self.titleFont};
    CGFloat titleW;
    
    if ( iOS7 ) {
        // 只有Xcode5才会编译这段代码
#ifdef __IPHONE_7_0
        titleW = [self.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
#else
        titleW = [self.currentTitle sizeWithFont:self.titleFont].width;
#endif
    } else {
        titleW = [self.currentTitle sizeWithFont:self.titleFont].width;
    }
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

/**
 *  控制器内部imageView的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 30;
    CGFloat imageX = contentRect.size.width - imageW;
    CGFloat imageY = 0;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
