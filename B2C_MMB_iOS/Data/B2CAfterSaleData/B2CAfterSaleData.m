//
//  B2CAfterSaleData.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-23.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2CAfterSaleData.h"

@implementation B2CAfterSaleData

- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        _afterOrderNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"afterOrderNum"]];
        
        _operateDate = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"operateDate"]];
        
        _operateUsername = [NSString stringWithFormat:@"%@",[dic objectForKey:@"operateUsername"]];
        
        _remark = [NSString stringWithFormat:@"%@",[dic objectForKey:@"remark"]];
    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2CAfterSaleData *amount = [[B2CAfterSaleData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}

@end
