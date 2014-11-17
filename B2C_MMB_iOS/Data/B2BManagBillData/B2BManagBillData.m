//
//  B2BManagBillData.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-14.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2BManagBillData.h"
#import "DCFCustomExtra.h"

@implementation B2BManagBillData


- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        
        if([[[dic objectForKey:@"createdate"] allKeys] count] == 0 || [[dic objectForKey:@"createdate"] isKindOfClass:[NSNull class]])
        {
            _createDate = [[NSDictionary alloc] init];
            _b2bManagBillTime = @"";
        }
        else
        {
            _createDate = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"createdate"]];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[_createDate objectForKey:@"time"] doubleValue]/1000];
            
            _b2bManagBillTime = [DCFCustomExtra nsdateToString:confromTimesp];
        }
        
  
        
        _address = [NSString stringWithFormat:@"%@",[dic objectForKey:@"address"]];
        
        _bank = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bank"]];
        
        _bankAccount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankAccount"]];
        
        _city = [NSString stringWithFormat:@"%@",[dic objectForKey:@"city"]];
        
        _comTel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"comTel"]];
        
        _company = [NSString stringWithFormat:@"%@",[dic objectForKey:@"company"]];
        
        _content = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
        
        _district = [NSString stringWithFormat:@"%@",[dic objectForKey:@"district"]];
        
        _invoiceId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"invoiceId"]];
        
        _headName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];

        _province = [NSString stringWithFormat:@"%@",[dic objectForKey:@"province"]];

        _receiveCompany = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveCompany"]];

        _receiveTel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveTel"]];

        _recipient = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recipient"]];

        _regAddr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"regAddr"]];

        _taxCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"taxCode"]];

        _tel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tel"]];

        _headType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
        if([_headType isEqualToString:@"1"])
        {
            _headType = @"普通发票";
        }
        else if ([_headType isEqualToString:@"2"])
        {
            _headType = @"增值税发票";
        }
        
        _zip = [NSString stringWithFormat:@"%@",[dic objectForKey:@"zip"]];

        _status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        
        if([_status isEqualToString:@"0"])
        {
            _myStatus = @"待确认";
        }
        if([_status isEqualToString:@"2"])
        {
            _myStatus = @"待付款";
        }
        if([_status isEqualToString:@"3"])
        {
            _myStatus = @"已付款";
        }
        if([_status isEqualToString:@"4"])
        {
            _myStatus = @"待发货";
        }
        if([_status isEqualToString:@"5"])
        {
            _myStatus = @"待收货";
        }
        if([_status isEqualToString:@"6"])
        {
            _myStatus = @"已收货";
        }
        if([_status isEqualToString:@"7"])
        {
            _myStatus = @"已关闭";
        }
        
    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2BManagBillData *amount = [[B2BManagBillData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}


@end
