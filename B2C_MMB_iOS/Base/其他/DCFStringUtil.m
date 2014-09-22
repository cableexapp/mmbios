//
//  StringUtil.m
//  midai
//
//  Created by duomai on 13-10-21.
//  Copyright (c) 2013年 tiny. All rights reserved.
//

#import "DCFStringUtil.h"
#import "MBProgressHUD.h"

@implementation DCFStringUtil

+ (id) getInstance
{
    static DCFStringUtil *stringUtil;
    if(!stringUtil)
    {
        stringUtil = [[DCFStringUtil alloc] init];
    }
    return stringUtil;
}

+ (void)showNotice:(NSString *)strNotice
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = strNotice;
    HUD.margin = 10.f;
    HUD.yOffset = 150.f;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:1.0];
    HUD = nil;
}

+(NSString *)getFinanceInvestRecodeStatus:(NSString *)status{
    if ([status isEqualToString:@"DENIED"]) {
        return @"已被拒绝";
    }else if([status isEqualToString:@"SUCCESS"]){
        return @"投资成功";
    }else if([status isEqualToString:@"WAIT_REPAYMENT"]){
        return @"等待还款";
    }else if([status isEqualToString:@"REPAYMENT_ENDED"]){
        return @"还款结束";
    }else if([status isEqualToString:@"OVERDUE"]){
        return @"已逾期";
    }else if([status isEqualToString:@"OVERDUE_SECURITY"]){
        return @"已逾期，平台垫付";
    }else{
        return status;
    }
}
+(NSString *)getFinanceBorrowOutListStatus:(NSString *)status{
    if ([status isEqualToString:@"SUCCESS"]) {
        return @"投资成功";
    }else if ([status isEqualToString:@"WAIT_REPAYMENT"]){
        return @"等待还款";
    }else if ([status isEqualToString:@"REPAYMENT_ENDED"]){
        return @"还款结束";
    }else {
        return status;
    }
}
+(NSString *)getFinanceLoanPayRecordStatus:(NSString *)status{
    if ([status isEqualToString:@"FINISH"]){
        return @"已还完";
    }else if ([status isEqualToString:@"REPAYMENT"]){
        return @"等待还款";
    }else {
        return status;
    }
}
+(NSString *)getFinanceLoanDetailStatus:(NSString *)status{
    if ([status isEqualToString:@"WAIT_LOAN"]) {
        return @"正在投标";
    }else if ([status isEqualToString:@"OVERDUE"]){
        return @"已逾期";
    }else{
        return status;
    }
}
@end
