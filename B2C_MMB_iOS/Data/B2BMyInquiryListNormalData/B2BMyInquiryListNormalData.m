//
//  B2BMyInquiryListNormalData.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-7.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2BMyInquiryListNormalData.h"
#import "DCFCustomExtra.h"

@implementation B2BMyInquiryListNormalData

- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        _createdate = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"createdate"]];
        
        if([[_createdate allKeys] count] == 0 || [_createdate isKindOfClass:[NSNull class]])
        {
            _time = @"";
        }
        else
        {
            //时间戳
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[_createdate objectForKey:@"time"] doubleValue]/1000];
            
            _time = [DCFCustomExtra nsdateToString:confromTimesp];
        }

        _inquiryid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquiryid"]];

        _inquiryserial = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquiryserial"]];

        _inquirytotal = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquirytotal"]];

        NSArray *ctems = [[NSArray alloc] initWithArray:[dic objectForKey:@"ctems"]];
//        NSArray *items = [[NSArray alloc] initWithArray:[dic objectForKey:@"items"]];
//        if(ctems.count == 0 || [ctems isKindOfClass:[NSNull class]])
//        {
//            _myItems = [[NSArray alloc] initWithArray:items];
//        }
//        else if(items.count == 0 || [items isKindOfClass:[NSNull class]])
//        {
            _myItems = [[NSArray alloc] initWithArray:ctems];
//        }
//        else
//        {
//            _myItems = [[NSArray alloc] init];
//        }
        
        _status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        if([_status isEqualToString:@"1"])
        {
            _status = @"待审核";
        }
        if([_status isEqualToString:@"2"])
        {
            _status = @"询价中";
        }
        if([_status isEqualToString:@"3"])
        {
            _status = @"待接受";
        }
        if([_status isEqualToString:@"4"])
        {
            _status = @"完成询价";
        }
        if([_status isEqualToString:@"5"])
        {
            _status = @"已关闭";
        }
        if([_status isEqualToString:@"6"])
        {
            _status = @"部分完成";
        }
        
        _address = [NSString stringWithFormat:@"%@",[dic objectForKey:@"address"]];
        
        _city = [NSString stringWithFormat:@"%@",[dic objectForKey:@"city"]];

        _district = [NSString stringWithFormat:@"%@",[dic objectForKey:@"district"]];

        _province = [NSString stringWithFormat:@"%@",[dic objectForKey:@"province"]];

        _fullAddress = [NSString stringWithFormat:@"%@%@%@%@",_province,_city,_district,_address];
        
        _recipint = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recipint"]];

        _tel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tel"]];

        _pushDic = [[NSDictionary alloc] initWithObjectsAndKeys:_fullAddress,@"fullAddress",_tel,@"tel",_recipint,@"name", nil];

    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2BMyInquiryListNormalData *amount = [[B2BMyInquiryListNormalData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}


@end
