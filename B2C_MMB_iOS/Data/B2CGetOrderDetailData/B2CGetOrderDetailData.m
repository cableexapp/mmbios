//
//  B2CGetOrderDetailData.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-21.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2CGetOrderDetailData.h"

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
        
        _subDate = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"subDate"]];
        
        _shopName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shopName"]];
        
        _logisticsPrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"logisticsPrice"]];
        
        _orderTotal = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderTotal"]];
        
        _status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        
        _snapId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"snapId"]];
        
        _shopId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shopId"]];
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
