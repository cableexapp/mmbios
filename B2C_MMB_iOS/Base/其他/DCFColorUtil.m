//
//  ColorUtil.m
//  coin
//
//  Created by duomai on 13-12-25.
//  Copyright (c) 2013年 tiny. All rights reserved.
//

#import "DCFColorUtil.h"
#define DEFAULT_VOID_COLOR [UIColor blackColor]
@implementation DCFColorUtil

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    NSString *cString = [[inColorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)colorFromR:(float)R G:(float)G B:(float)B{
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
}

+ (UIColor *)colorWithblue{
    return [self colorFromHexRGB:@"31adda"];
}

+ (UIColor *)colorWithred{
    return [self colorFromHexRGB:@"de3e3e"];
}

+ (UIColor *)colorWithgreen{
    return [self colorFromHexRGB:@"9ad000"];
}

+ (UIColor *)colorWithblueH{
    return [self colorFromHexRGB:@"0a8bb5"];
}

+ (UIColor *)colorWithredH{
    return [self colorFromHexRGB:@"eb4b4b"];
}

+ (UIColor *)colorWithgreenH{
    return [self colorFromHexRGB:@"8eb816"];
}

+ (UIColor *)colorWithEqua{
    return [self colorFromHexRGB:@"a6a5a7"];
}

+ (UIColor *)colorWithCellHeight{
    return [UIColor colorWithWhite:0 alpha:0.6];
}

@end
