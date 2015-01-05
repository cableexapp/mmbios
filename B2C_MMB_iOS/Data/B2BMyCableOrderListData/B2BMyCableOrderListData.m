//
//  B2BMyCableOrderListData.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2BMyCableOrderListData.h"
#import "DCFCustomExtra.h"

@implementation B2BMyCableOrderListData

- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        
        if([[[dic objectForKey:@"createdate"] allKeys] count] == 0 || [[dic objectForKey:@"createdate"] isKindOfClass:[NSNull class]])
        {
            _createDate = [[NSDictionary alloc] init];
            _cableOrderTime = @"";
        }
        else
        {
            _createDate = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"createdate"]];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[_createDate objectForKey:@"time"] doubleValue]/1000];
            
            _cableOrderTime = [DCFCustomExtra nsdateToString:confromTimesp];
        }
        
        if([[dic objectForKey:@"items"] count] == 0 || [[dic objectForKey:@"items"] isKindOfClass:[NSNull class]])
        {
            _myItems = [[NSMutableArray alloc] init];
        }
        else
        {
            _myItems = [[NSArray alloc] initWithArray:[dic objectForKey:@"items"]];
        }
        
        _orderid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderid"]];
        
        _orderserial = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderserial"]];

        _ordertotal = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ordertotal"]];

        _receiveaddress = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveaddress"]];

        _receivecity = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receivecity"]];

        _receivecompany = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receivecompany"]];

        _receivedistrict = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receivedistrict"]];

        _receivename = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receivename"]];

        _receiveprovince = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveprovince"]];

        _status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        
        if([_status isEqualToString:@"0"])
        {
            _myStatus = @"待确认";
        }
        if([_status isEqualToString:@"1"])
        {
            _myStatus = @"";
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
            _myStatus = @"已发货";
        }
        if([_status isEqualToString:@"6"])
        {
            _myStatus = @"已完成";
        }
        if([_status isEqualToString:@"7"])
        {
            _myStatus = @"已关闭";
        }
        _tel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tel"]];
    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2BMyCableOrderListData *amount = [[B2BMyCableOrderListData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}

@end
