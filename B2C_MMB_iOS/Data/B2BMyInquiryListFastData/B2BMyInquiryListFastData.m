//
//  B2BMyInquiryListFastData.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-10.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2BMyInquiryListFastData.h"
#import "DCFCustomExtra.h"

@implementation B2BMyInquiryListFastData

- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        _content = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
        
        if([[[dic objectForKey:@"createDate"] allKeys] count] == 0 || [[dic objectForKey:@"createDate"] isKindOfClass:[NSNull class]])
        {
            _createDate = [[NSDictionary alloc] init];
            _myTime = @"";
        }
        else
        {
            _createDate = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"createDate"]];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[_createDate objectForKey:@"time"] doubleValue]/1000];
            
            _myTime = [DCFCustomExtra nsdateToString:confromTimesp];
        }
        
        _fileId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fileId"]];
        
        _filePath = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filePath"]];
        
        _fuleName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fuleName"]];
        
        _inquiryId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquiryId"]];
        
        _isDelete = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isDelete"]];
        
        _linkman = [NSString stringWithFormat:@"%@",[dic objectForKey:@"linkman"]];
        
        _oemId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"oemId"]];
        
        _operatior = [NSString stringWithFormat:@"%@",[dic objectForKey:@"operatior"]];
        
        _phone = [NSString stringWithFormat:@"%@",[dic objectForKey:@"phone"]];
        
        _qq = [NSString stringWithFormat:@"%@",[dic objectForKey:@"qq"]];
        
        _remark = [NSString stringWithFormat:@"%@",[dic objectForKey:@"remark"]];
        
        _status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        if([_status intValue] == 0)
        {
            _speedStatus = @"";
        }
        if([_status isEqualToString:@"1"])
        {
            _status = @"待审核";
            _speedStatus = @"待审核";
        }
        if([_status isEqualToString:@"2"])
        {
            _status = @"询价中";
            _speedStatus = @"已审核";
        }
        if([_status isEqualToString:@"3"])
        {
            _status = @"待接受";
            _speedStatus = @"已关闭";
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

        _treatment = [NSString stringWithFormat:@"%@",[dic objectForKey:@"treatment"]];
        
        _oemNo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"oemNo"]];

    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2BMyInquiryListFastData *amount = [[B2BMyInquiryListFastData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}


@end
