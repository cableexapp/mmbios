//
//  B2CGetOrderDetailData.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-21.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2CGetOrderDetailData.h"
#import "DCFCustomExtra.h"

@implementation B2CGetOrderDetailData

- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        _myItems = [[NSArray alloc] initWithArray:[dic objectForKey:@"items"]];
        
        _invoiceType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"invoiceType"]];
        
        _nvoiceTitle = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nvoiceTitle"]];
        
        _receiveAddr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveAddr"]];
        
        _receiveId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveId"]];
        
        _receivePhone = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receivePhone"]];
        
        _receiveMember = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveMember"]];
        
        if([[[dic objectForKey:@"subDate"] allKeys] count] == 0 || [[dic objectForKey:@"subDate"] isKindOfClass:[NSNull class]])
        {
            _subDate = [[NSDictionary alloc] init];
            _myTime = @"";
        }
        else
        {
            _subDate = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"subDate"]];
            //时间戳
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[_subDate objectForKey:@"time"] doubleValue]/1000];
            
            _myTime = [DCFCustomExtra nsdateToString:confromTimesp];
        }
        
        _shopName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shopName"]];
        
        _logisticsPrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"logisticsPrice"]];
        
        _orderTotal = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderTotal"]];
        
        _status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        
        _snapId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"snapId"]];
        
        _shopId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shopId"]];
        
        _logisticsId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"logisticsId"]];
        
        _logisticsNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"logisticsNum"]];

        _logisticsCompanay = [NSString stringWithFormat:@"%@",[dic objectForKey:@"logisticsCompanay"]];

        _orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];

        _orderNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderNum"]];

        _juderstatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"juderstatus"]];

        _afterStatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"afterStatus"]];

    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2CGetOrderDetailData *amount = [[B2CGetOrderDetailData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}

@end
