//
//  CustomExtra.m
//  com.up360
//
//  Created by jhq on 14-3-5.
//  Copyright (c) 2014年 jhq. All rights reserved.
//

#import "DCFCustomExtra.h"
#import "MCDefine.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>

@implementation DCFCustomExtra


+ (CGSize) adjustWithFont:(UIFont*) font WithText:(NSString *) text WithSize:(CGSize) size
{
    CGSize actualsize;
    if(text.length == 0)
    {
        
    }
    else
    {
        if(IS_IOS_7)
        {
            //    获取当前文本的属性
            NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
            
            //ios7方法，获取文本需要的size，限制宽度
            actualsize =[text boundingRectWithSize:actualsize options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
            NSAttributedString *attributedText = [[NSAttributedString alloc]
                                                  initWithString:text
                                                  attributes:@{NSFontAttributeName:font}];
            actualsize = [attributedText boundingRectWithSize:size
                                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                      context:nil].size;
        }
        else
        {
            // ios7之前使用方法获取文本需要的size，7.0已弃用下面的方法。此方法要求font，与breakmode与之前设置的完全一致
            actualsize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        }
        return actualsize;
    }
    return CGSizeZero;
}

#pragma mark - 判断字符串是否为空
+ (BOOL) validateString:(NSString *) str
{
    if(str.length ==  0 || [str isKindOfClass:[NSNull class]] || str == nil || str == NULL || [str isEqualToString:@"(null)"] || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 || [str isEqualToString:@"null"])
    {
        return NO;
    }
    return YES;
}

#pragma mark - 四舍五入
+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

#pragma mark - 截取小数点后2位，四舍五入，如果不要，修改NSRoundUp
+ (NSString *)notRounding:(double)price afterPoint:(int)position
{
    return [NSString stringWithFormat:@"%.2f",round(price*100)/100];
}

+ (NSString *)notRounding:(double)price afterPoint:(int)position WithBackIndex:(int) index
{
    return [NSString stringWithFormat:@"%.1f",round(price*100)/100];
}

#pragma mark - 缩放图片
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

#pragma mark - 传入颜色和SIZE返回图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    //Create a context of the appropriate size
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //Build a rect of appropriate size at origin 0,0
    CGRect fillRect = CGRectMake(0, 0, size.width, size.height);
    
    //Set the fill color
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    
    //Fill the color
    CGContextFillRect(currentContext, fillRect);
    
    //Snap the picture and close the context
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}

+ (void) alignLabelWithTop:(UILabel *)label
{
    CGSize maxSize = CGSizeMake(label.frame.size.width, 999);
    //    label.adjustsFontSizeToFitWidth = NO;
    CGSize actualSize = [label.text sizeWithFont:label.font constrainedToSize:maxSize lineBreakMode:label.lineBreakMode];
    CGRect rect = label.frame;
    rect.size.height = actualSize.height;
    label.frame = rect;
}

#pragma mark - 高度自适应
+ (CGFloat) adjustWithFont:(UIFont *) font WithString:(NSString *) string WithSize:(CGSize) size WithlineBreakMode:(NSLineBreakMode) lineBreakMode
{
    CGSize textSize;
    CGFloat rowHeight;
    if (IS_IOS_7)
    {
        NSAttributedString *attributedText = [[NSAttributedString alloc]
                                              initWithString:string
                                              attributes:@{NSFontAttributeName:font}];
        textSize = [attributedText boundingRectWithSize:size
                                                options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                context:nil].size;
        rowHeight = textSize.height;
    }else{
        textSize = [string sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:lineBreakMode];
        rowHeight = textSize.height+20;
    }
    return rowHeight;
}

#pragma mark - 获得当前系统版本号
+ (NSString *) getCurrentVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark - 获得当前的手机型号
+ (NSString *) getCurrentModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *string = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if([string isEqualToString:@"iPhone2,1"])
    {
        string = @"iPhone3GS";
    }
    else if([string isEqualToString:@"iPhone3,1"])
    {
        string = @"iPhone4";
    }else if([string isEqualToString:@"iPhone4,1"])
    {
        string = @"iPhone4S";
    } else if([string isEqualToString:@"iPhone5,1"])
    {
        string = @"iPhone5";
    } else if([string isEqualToString:@"iPhone5,2"])
    {
        string = @"iPhone5";
    } else if([string isEqualToString:@"iPhone5,3"])
    {
        string = @"iPhone5C";
    } else if([string isEqualToString:@"iPhone5,4"])
    {
        string = @"iPhone5C";
    } else if([string isEqualToString:@"iPhone6,1"])
    {
        string = @"iPhone5S";
    } else if([string isEqualToString:@"iPhone6,2"])
    {
        string = @"iPhone5S";
    }
    return string;
    //    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    //    {
    //        CGFloat scale = [UIScreen mainScreen].scale;
    //        if(scale > 1.0)
    //        {
    //            if([UIScreen mainScreen].bounds.size.height == 568)
    //            {
    //                return @"5";
    //            }
    //
    //        }
    //    }
}

#pragma mark - 获取APP信息
+ (NSArray *) getAppInfo
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"app_Name = %@",app_Name);
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"app_Version = %@",app_Version);
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"app_build = %@",app_build);
    NSArray *array = [[NSArray alloc] initWithObjects:app_Name,app_Version,app_build, nil];
    return array;
}

#pragma mark - 获取当前时间
+ (NSString *) getFirstRunTime
{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year = [dateComponent year];
    
    int month = [dateComponent month];
    NSString *monthString_1 = [NSString stringWithFormat:@"%d",month];
    NSString *monthString_2 = nil;
    if(month <= 9)
    {
        monthString_2 = [NSString stringWithFormat:@"%@%@",@"0",monthString_1];
    }
    else
    {
        monthString_2 = [NSString stringWithFormat:@"%@",monthString_1];
    }
    
    int day = [dateComponent day];
    NSString *day_1 = [NSString stringWithFormat:@"%d",day];
    NSString *day_2 = nil;
    if(day <= 9)
    {
        day_2 = [NSString stringWithFormat:@"%@%@",@"0",day_1];
    }
    else
    {
        day_2 = [NSString stringWithFormat:@"%@",day_1];
    }
    
    int hour = [dateComponent hour];
    int minute = [dateComponent minute];
    
    NSString *M = @"";
    if(minute<10)
    {
        M = [NSString stringWithFormat:@"0%d",minute];
    }
    else
    {
        M = [NSString stringWithFormat:@"%d",minute];
    }
    
    NSString *S = @"";
    int second = [dateComponent second];
    if(second < 10)
    {
        S = [NSString stringWithFormat:@"0%d",second];
    }
    else
    {
        S = [NSString stringWithFormat:@"%d",second];
    }
    
    //    NSString *time = [[NSString alloc] initWithFormat:@"%d-%d-%d %d:%@:%@",year,month,day,hour,M,S];
    //    NSLog(@"time = %@",time);
    
    NSString *time = [NSString stringWithFormat:@"%d-%@-%@",year,monthString_2,day_2];
    return time;
}

#pragma mark - 获取当前时间的年，月，日，小时，分，秒
+ (NSMutableArray *) getHourAndMin
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    //    int year = [dateComponent year];
    //    int month = [dateComponent month];
    int day = [dateComponent day];
    int hour = [dateComponent hour];
    int minute = [dateComponent minute];
    //    int second = [dateComponent second];
    
    NSString *HOUR = [[NSString alloc] initWithFormat:@"%d",hour];
    NSString *MIN = [[NSString alloc] initWithFormat:@"%d",minute];
    NSString *DAY = [[NSString alloc] initWithFormat:@"%d",day];
    [array addObject:HOUR];
    [array addObject:MIN];
    [array addObject:DAY];
    return array;
}

+ (NSString *) getRandomNumber:(int) fromNum to:(int) toNum
{
    //    return (int)(fromNum + (arc4random() % (toNum – fromNum + 1)));
    int n = (fromNum + (arc4random() % (toNum - fromNum +1)));
    NSString *s = [NSString stringWithFormat:@"%d",n];
    return s;
}

#pragma mark - 将yyyy-MM-dd HH:mm:ss格式时间转换成时间戳
+ (long) changeTimeToTimeSp:(NSString *)timeStr
{
    long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:timeStr];
    time= (long)[fromdate timeIntervalSince1970];
    return time;
}

#pragma mark - 将时间戳转换成NSDate,加上时区偏移
+ (NSDate*) zoneChange:(NSString*)spString
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString intValue]];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:confromTimesp];
    NSDate *localeDate = [confromTimesp  dateByAddingTimeInterval: interval];
    return localeDate;
}

#pragma mark - 将NSDate按yyyy-MM-dd HH:mm:ss格式时间输出
+ (NSString*) nsdateToString:(NSDate *)date
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}

#pragma mark - 获取当前系统的时间戳
+(long)getTimeSp
{
    long time;
    NSDate *fromdate=[NSDate date];
    time=(long)[fromdate timeIntervalSince1970];
    return time;
}

#pragma mark - 将时间戳转换成NSDate

//将时间戳转换成NSDate
+(NSDate *)changeSpToTime:(NSString*)spString{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString intValue]];
    return confromTimesp;
}

#pragma mark - 比较给定NSDate与当前时间的时间差，返回相差的秒数
+(long)timeDifference:(NSDate *)date{
    NSDate *localeDate = [NSDate date];
    long difference =fabs([localeDate timeIntervalSinceDate:date]);
    return difference;
}


#pragma mark 结束时间与当前时间差
+ (NSString *) timeIntervalFromStartToEnd:(NSString *) endTime
{
    //    NSString *dateStr = [timeArray objectAtIndex:0];//传入开始时间
    //    //将传入时间转化成需要的格式
    //    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    //    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSDate *fromdate=[format dateFromString:dateStr];
    //    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    //    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    //    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    
    NSString *dateStr1 = [NSString stringWithFormat:@"%@",endTime];//传入结束时间
    //将传入时间转化成需要的格式
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate1=[format1 dateFromString:dateStr1];
    NSTimeZone *fromzone1 = [NSTimeZone systemTimeZone];
    NSInteger frominterval1 = [fromzone1 secondsFromGMTForDate: fromdate1];
    NSDate *fromDate1 = [fromdate1  dateByAddingTimeInterval: frominterval1];
    
    //获取当前时间
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    
    double intervalTime = [fromDate1 timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    
    long lTime = (long)intervalTime;
    //    NSInteger iSeconds = lTime % 60;
    NSInteger iMinutes = (lTime / 60) % 60;
    NSInteger iHours = (lTime / 3600);
    //    NSInteger iDays = lTime/60/60/24;
    //    NSInteger iMonth = lTime/60/60/24/12;
    //    NSInteger iYears = lTime/60/60/24/384;
    
    //    NSLog(@"相差%d年%d月%d日%d时%d分%d秒", iYears,iMonth,iDays,iHours,iMinutes,iSeconds);
    
    NSString *timeInterval;
    
    if(iHours <= 0 )
    {
        if(iHours < 0)
        {
            timeInterval = [[NSString alloc] initWithFormat:@"%d分钟",0];
            return timeInterval;
        }
        if(iHours == 0)
        {
            if(iMinutes <= 0)
            {
                timeInterval = [[NSString alloc] initWithFormat:@"%d分钟",0];
                return timeInterval;
            }
            else if(iMinutes > 0)
            {
                timeInterval = [[NSString alloc] initWithFormat:@"%d分钟",iMinutes];
                return timeInterval;
            }
        }
    }
    if(iMinutes == 0)
    {
        timeInterval = [[NSString alloc] initWithFormat:@"%d小时",iHours];
        return timeInterval;
    }
    if(iMinutes != 0)
    {
        timeInterval = [[NSString alloc] initWithFormat:@"%d小时%d分钟",iHours,iMinutes];
        return timeInterval;
    }
    return nil;
}


//#pragma mark - 截取时间
//+ (NSString *) interceptTime:(NSString *) time
//{
//    NSString *finalTime;
//    NSRange testRange = [time rangeOfString:@" "];
//    if(testRange.location != NSNotFound)
//    {
//        NSString *s1 = [time substringToIndex:testRange.location];
//        NSLog(@"s1 = %@",s1);
//
//        NSString *s2 = [s1 substringFromIndex:5];
//        NSLog(@"s2 = %@",s2);
//
//        s2 = [s2 stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
//        NSLog(@"s2   s2 = %@",s2);
//
//        NSString *s3 = [s2 stringByAppendingString:@"日"];
//        NSLog(@"s3 = %@",s3);
//
//        NSString *s4 = [time substringFromIndex:testRange.location + 1];
//        NSLog(@"s4 = %@",s4);
//
//        NSString *s5 = [s4 substringToIndex:5];
//        NSLog(@"s5 = %@",s5);
//
//        finalTime = [NSString stringWithFormat:@"%@ %@",s3,s5];
//        NSLog(@"finalTime = %@",finalTime);
//    }
//    return finalTime;
//}

#pragma mark - 校验邮编
+ (BOOL) validateZip:(NSString *) zip
{
    const char *cvalue = [zip UTF8String];
    int len = strlen(cvalue);
    if (len != 6) {
        return NO;
    }
    for (int i = 0; i < len; i++)
    {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
        {
            return NO;
        }
    }
    return YES;
    
}

#pragma mark - 验证固化小灵通
+ (BOOL) validateTel:(NSString *) tel
{
    //     25         * 大陆地区固话及小灵通
    //     26         * 区号：010,020,021,022,023,024,025,027,028,029
    //     27         * 号码：七位或八位
    //     28         */
    NSString *PHS = @"^([\\+][0-9]{1,3}[ \\.\\-])?([\\(]{1}[0-9]{2,6}[\\)])?([0-9 \\.\\-\\/]{3,20})((x|ext|extension)[ ]?[0-9]{1,4})?$";
    //    ^([\\+][0-9]{1,3}[ \\.\\-])?([\\(]{1}[0-9]{2,6}[\\)])?([0-9 \\.\\-\\/]{3,20})((x|ext|extension)[ ]?[0-9]{1,4})?$
    NSPredicate *regextestTel = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    BOOL isMatch = [regextestTel evaluateWithObject:tel];
    if (isMatch == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

#pragma mark - 验证手机号码
+ (BOOL)validateMobile:(NSString *)mobileNum
{
//    NSString *regex = @"^((13[0-9])|(14[^4,\\D])|(17[^4,\\D])|(15[^4,\\D])|(18[0,1,2,5-9]))\\d{8}$";
    NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:mobileNum];
    
    if (!isMatch)
    {
        
        
        return NO;
        
    }

    
    
    return YES;
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    //    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    //    /**
    //     10         * 中国移动：China Mobile
    //     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    //     12         */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //    /**
    //     15         * 中国联通：China Unicom
    //     16         * 130,131,132,152,155,156,185,186
    //     17         */
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //    /**
    //     20         * 中国电信：China Telecom
    //     21         * 133,1349,153,180,189
    //     22         */
    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    //    /**
    //     25         * 大陆地区固话及小灵通
    //     26         * 区号：010,020,021,022,023,024,025,027,028,029
    //     27         * 号码：七位或八位
    //     28         */
    //     NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    //    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    //
    //    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
    //        || ([regextestcm evaluateWithObject:mobileNum] == YES)
    //        || ([regextestct evaluateWithObject:mobileNum] == YES)
    //        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    //    {
    //        NSLog(@"正确");
    //        return YES;
    //    }
    //    else
    //    {
    //        NSLog(@"错误");
    //        return NO;
    //    }
}

#pragma mark - 验证邮箱
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (NSString *) compareSessionKey:(NSString *) sessionKey
{
    NSString *localSessionKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionKey"];
    if([localSessionKey isEqualToString:sessionKey])
    {
        return localSessionKey;
    }
    else
    {
        if(sessionKey.length != 0 || sessionKey != NULL || sessionKey != nil || ![sessionKey isKindOfClass:[NSNull class]])
        {
            if(![[NSUserDefaults standardUserDefaults] objectForKey:@"sessionKey"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:sessionKey forKey:@"sessionKey"];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sessionKey"];
                [[NSUserDefaults standardUserDefaults] setObject:sessionKey forKey:@"sessionKey"];
            }
            return [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionKey"];
        }
        else
        {
            
        }
    }
    return nil;
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *) compareStatus:(NSString *) status
{
    NSString *myStatus = nil;
    int statusInt = [status intValue];
    switch (statusInt)
    {
        case 1:
            myStatus = @"买家待付款";
            break;
        case 2:
            myStatus = @"买家已付款";
            break;
        case 3:
            myStatus = @"卖家已发货";
            break;
        case 5:
            myStatus = @"申请取消";
            break;
        case 6:
            myStatus = @"交易成功";
            break;
        case 7:
            myStatus = @"订单取消";
            break;
        default:
            break;
    }
    return myStatus;
}

#pragma mark - UTF8转中文
+ (NSString *) UTF8Encoding:(NSString *) str
{
    NSString *userName = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return userName;
}

@end
