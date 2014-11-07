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

        _myItems = [[NSArray alloc] initWithArray:[dic objectForKey:@"items"]];
        
        _status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
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
