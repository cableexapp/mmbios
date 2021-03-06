//
//  B2CMyOrderData.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-16.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2CMyOrderData.h"
#import "DCFCustomExtra.h"

@implementation B2CMyOrderData

- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        _myItems = [[NSArray alloc] initWithArray:[dic objectForKey:@"items"]];
        
        _subDate = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"subDate"]];
        
        if([[_subDate allKeys] count] == 0 || [_subDate isKindOfClass:[NSNull class]])
        {
            _myOderDataTime = @"";
        }
        else
        {
            //时间戳
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[_subDate objectForKey:@"time"] doubleValue]/1000];
            
            _myOderDataTime = [DCFCustomExtra nsdateToString:confromTimesp];
        }
        
        _orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
        
        _orderMergeId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderMergeId"]];
        
        _orderNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderNum"]];
        
        _orderTotal = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderTotal"]];
        
        _receiveAddr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveAddr"]];
        
        _receiveDate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveDate"]];
        
        _receiveEmail = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveEmail"]];
        
        _receiveId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveId"]];
        
        _receiveMember = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveMember"]];
        
        _receivePhone = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receivePhone"]];
        
        _receiveTel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveTel"]];
        
        _sellMemberId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sellMemberId"]];
        
        _sellName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sellName"]];
        
        _shopId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shopId"]];
        
        _shopName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shopName"]];
        
        _B2CMyOrderDataStatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        
        _afterStatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"afterStatus"]];
        
        _juderstatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"juderstatus"]];
        
        _logisticsId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"logisticsId"]];
        
        _logisticsNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"logisticsNum"]];
        
        _logisticsCompanay = [NSString stringWithFormat:@"%@",[dic objectForKey:@"logisticsCompanay"]];
    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2CMyOrderData *amount = [[B2CMyOrderData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}
@end
