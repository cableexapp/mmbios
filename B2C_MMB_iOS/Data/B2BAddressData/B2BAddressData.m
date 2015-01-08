//
//  B2BAddressData.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-6.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2BAddressData.h"

@implementation B2BAddressData

- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        
        _addressId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"addressId"]];
        
        _addressName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"addressName"]];
        
        _addressType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"addressType"]];
        
        _area = [NSString stringWithFormat:@"%@",[dic objectForKey:@"area"]];
        
        _city = [NSString stringWithFormat:@"%@",[dic objectForKey:@"city"]];
        
        _isDefault = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isDefault"]];
        
        _isDelete = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isDelete"]];
        
        _memberId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
        
        _mobile = [NSString stringWithFormat:@"%@",[dic objectForKey:@"mobile"]];
        
        _province = [NSString stringWithFormat:@"%@",[dic objectForKey:@"province"]];
        
        _receiver = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiver"]];
        
        _tel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tel"]];
        
        _zip = [NSString stringWithFormat:@"%@",[dic objectForKey:@"zip"]];
        
        _fullAddress = [NSString stringWithFormat:@"%@%@%@%@",self.province,self.city,self.area,self.addressName];
    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2BAddressData *amount = [[B2BAddressData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}

@end
