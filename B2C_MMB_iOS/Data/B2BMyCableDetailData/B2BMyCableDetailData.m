//
//  B2BMyCableDetailData.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-12-29.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2BMyCableDetailData.h"
#import "DCFCustomExtra.h"

@implementation B2BMyCableDetailData

- (void) dealData:(NSDictionary *) dic
{
    if([[[dic objectForKey:@"createDate"] allKeys] count] == 0 || [[dic objectForKey:@"createDate"] isKindOfClass:[NSNull class]])
    {
        _createDate = [[NSDictionary alloc] init];
        _cableOrderTime = @"";
    }
    else
    {
        _createDate = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"createDate"]];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[_createDate objectForKey:@"time"] doubleValue]/1000];
        
        _cableOrderTime = [DCFCustomExtra nsdateToString:confromTimesp];
    }
    
    if([[dic objectForKey:@"items_logistics"] count] == 0 || [[dic objectForKey:@"items_logistics"] isKindOfClass:[NSNull class]])
    {
        _myItems = [[NSMutableArray alloc] init];
    }
    else
    {
        _myItems = [[NSArray alloc] initWithArray:[dic objectForKey:@"items_logistics"]];
    }
    
    _ordernum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ordernum"]];
    
    _ordertotal = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ordertotal"]];
    
    _reciver = [NSString stringWithFormat:@"%@",[dic objectForKey:@"reciver"]];
    
    _province = [NSString stringWithFormat:@"%@",[dic objectForKey:@"province"]];
    
    _city = [NSString stringWithFormat:@"%@",[dic objectForKey:@"city"]];
    
    _district = [NSString stringWithFormat:@"%@",[dic objectForKey:@"district"]];
    
    _address = [NSString stringWithFormat:@"%@",[dic objectForKey:@"address"]];
    
    _fullAddress = [NSString stringWithFormat:@"%@%@%@%@",_province,_city,_district,_address];
    
    if([_fullAddress rangeOfString:@"(null)"].location != NSNotFound)
    {
        [_fullAddress stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    }
    _fullAddress = [_fullAddress stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"(null)"]];

    _fullAddress = [_fullAddress stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"null"]];

    
    _theTel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"phone"]];

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
    
    if([[dic objectForKey:@"invoice"] isKindOfClass:[NSNull class]])
    {
        _invoiceDic = [[NSDictionary alloc] init];
    }
    else
    {
        _invoiceDic = [NSDictionary dictionaryWithDictionary:[dic objectForKey:@"invoice"]];
    }
}

- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
    }
            return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2BMyCableDetailData *amount = [[B2BMyCableDetailData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}

@end
