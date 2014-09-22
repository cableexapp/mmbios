//
//  StringUtil.h
//  midai
//
//  Created by duomai on 13-10-21.
//  Copyright (c) 2013年 tiny. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 自定义的提示框等存放在这里

@interface DCFStringUtil : NSObject
@property (strong,nonatomic) NSString *naviTitle;
@property (assign,nonatomic) BOOL showNavi;
@property (strong,nonatomic)  NSString *sysVersion;  //系统版本
@property (strong,nonatomic) NSString *mblTag;    //机型
@property (strong,nonatomic) NSString *appVersion;  //app版本
@property (strong,nonatomic) NSString *appFirstRunTime;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *userPwd;
@property (strong,nonatomic) NSString *deviceToken;

@property (strong,nonatomic) NSString *userId;


+ (void)showNotice:(NSString *)strNotice;
+(NSString *)getFinanceInvestRecodeStatus:(NSString *)status;
+(NSString *)getFinanceBorrowOutListStatus:(NSString *)status;
+(NSString *)getFinanceLoanPayRecordStatus:(NSString *)status;
+(NSString *)getFinanceLoanDetailStatus:(NSString *)status;
+ (id) getInstance;

@end
