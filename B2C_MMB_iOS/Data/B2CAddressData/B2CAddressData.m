//
//  B2CAddressData.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-7.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2CAddressData.h"
#import "DCFCustomExtra.h"

@implementation B2CAddressData

- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        _addressId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"addressId"]];
        
        _streetOrTown = [NSString stringWithFormat:@"%@",[dic objectForKey:@"addressName"]];
        if([DCFCustomExtra validateString:_streetOrTown] == NO)
        {
            _streetOrTown = @"";
        }
        
        _area = [NSString stringWithFormat:@"%@",[dic objectForKey:@"area"]];
        
        _city = [NSString stringWithFormat:@"%@",[dic objectForKey:@"city"]];
        
        if([[dic objectForKey:@"createDate"] isKindOfClass:[NSNull class]])
        {
            _myCreateDate = [[NSDictionary alloc] init];
        }
        else
        {
            _myCreateDate = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"createDate"]];
        }
        
        _detailAddress = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fullAddress"]];
        if([DCFCustomExtra validateString:_detailAddress] == NO)
        {
            _detailAddress = @"";
        }
        
        _isDefault = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isDefault"]];
        
        _isDelete = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isDelete"]];
        
        _memberId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
        
        _mobile = [NSString stringWithFormat:@"%@",[dic objectForKey:@"mobile"]];
        
        _modifyDate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"modifyDate"]];
        
        _province = [NSString stringWithFormat:@"%@",[dic objectForKey:@"province"]];
        
        _receiver = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiver"]];
        
        _tel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tel"]];
        
        _zip = [NSString stringWithFormat:@"%@",[dic objectForKey:@"zip"]];
        
        NSLog(@"%@   %@   %@   %@   %@  ",_province,_city,_area,_streetOrTown,_detailAddress);

    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2CAddressData *amount = [[B2CAddressData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}

@end
