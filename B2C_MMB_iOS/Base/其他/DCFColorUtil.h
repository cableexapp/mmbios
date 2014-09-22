//
//  ColorUtil.h
//  coin
//
//  Created by duomai on 13-12-25.
//  Copyright (c) 2013年 tiny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCFColorUtil : NSObject
+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;
+ (UIColor *)colorFromR:(float)R G:(float)G B:(float)B;
+ (UIColor *)colorWithblue;
+ (UIColor *)colorWithred;
+ (UIColor *)colorWithgreen;
+ (UIColor *)colorWithblueH;
+ (UIColor *)colorWithredH;
+ (UIColor *)colorWithgreenH;

+ (UIColor *)colorWithEqua;
+ (UIColor *)colorWithCellHeight;
@end
