//
//  CustomExtra.h
//  com.up360
//
//  Created by jhq on 14-3-5.
//  Copyright (c) 2014年 jhq. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 自定义的宏,方法存放在这里

@interface DCFCustomExtra : NSObject
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (void) alignLabelWithTop:(UILabel *)label;
+ (CGFloat) adjustWithFont:(UIFont *) font WithString:(NSString *) string WithSize:(CGSize) size WithlineBreakMode:(NSLineBreakMode) lineBreakMode;
+ (NSString *) getCurrentVersion;
+ (NSString *) getCurrentModel;
+ (NSArray *) getAppInfo;
+ (NSString *) getFirstRunTime;
+ (NSString *) getRandomNumber:(int) fromNum to:(int) toNum;
+ (NSMutableArray *) getHourAndMin;

+ (long) changeTimeToTimeSp:(NSString *)timeStr;
+ (NSDate*) zoneChange:(NSString*)spString;
+ (NSString*) nsdateToString:(NSDate *)date;

+ (NSString *) timeIntervalFromStartToEnd:(NSString *) endTime;

+ (BOOL)validateMobile:(NSString *)mobileNum;

+ (BOOL)isValidateEmail:(NSString *)email;

+ (NSString *) compareSessionKey:(NSString *) sessionKey;

+ (NSString *)notRounding:(NSString *)price;

+ (NSString *)notRounding:(double)price afterOnePoint:(int)position ;

+ (CGSize) adjustWithFont:(UIFont*) font WithText:(NSString *) text WithSize:(CGSize) size;

+ (NSString *)md5:(NSString *)str;

+(NSDate *)changeSpToTime:(NSString*)spString;

+ (NSString *) compareStatus:(NSString *) status;

+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV;

+ (BOOL) validateString:(NSString *) str;

+ (BOOL) validateTel:(NSString *) tel;

+ (BOOL) validateZip:(NSString *) email;

+ (NSString *) UTF8Encoding:(NSString *) str;

+ (void) cleanData;

+ (NSString *)testRound:(NSString *)price;

@end
