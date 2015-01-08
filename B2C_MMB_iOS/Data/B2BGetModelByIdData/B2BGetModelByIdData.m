//
//  B2BGetModelByIdData.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-9.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2BGetModelByIdData.h"

@implementation B2BGetModelByIdData

- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        _byname = [NSString stringWithFormat:@"%@",[dic objectForKey:@"byname"]];
        
        _featureName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"featureName"]];
        
        _featureType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"featureType"]];
        
        _firstType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"firstType"]];
        
        _theModel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"model"]];
        
        _modelDescrible = [NSString stringWithFormat:@"%@",[dic objectForKey:@"modelDescrible"]];
        
        _modeltitle = [NSString stringWithFormat:@"%@",[dic objectForKey:@"modeltitle"]];
        
        _propertyId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"propertyId"]];
        
        _secondType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"secondType"]];
        
        _sequence = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sequence"]];
        
        _status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        
        _thirdType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"thirdType"]];
    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2BGetModelByIdData *amount = [[B2BGetModelByIdData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}

@end
