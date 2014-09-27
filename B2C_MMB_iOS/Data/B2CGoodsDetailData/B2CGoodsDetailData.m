//
//  B2CGoodsDetailData.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-27.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2CGoodsDetailData.h"
#import "MCDefine.h"

@implementation B2CGoodsDetailData
- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        
    }
    return self;
}

- (void) dealData:(NSDictionary *) dictionary
{
    _coloritems = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"coloritems"]];
    NSLog(@"coloritems = %@",_coloritems);
    
    _ctems = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"ctems"]];
    NSLog(@"ctems = %@",_ctems);
    
    _items = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"items"]];
    NSLog(@"items = %@",_items);
    
    NSDictionary *dic = [_items objectAtIndex:0];
    
    _p1Path = [dic objectForKey:@"p1Path"];
    
    
    //.的下标
    int docIndex = _p1Path.length-4;
    if([_p1Path characterAtIndex:docIndex] == '.')
    {
        
        NSString *s1 = [_p1Path substringToIndex:docIndex];
        
        NSString *s2 = [s1 stringByAppendingString:@"_100"];
        
        NSString *pre = [_p1Path substringFromIndex:docIndex];
        
        s2 = [s2 stringByAppendingString:pre];
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,s2];
        
        _p1Path = [NSString stringWithFormat:@"%@",has];
        
    }
    else
    {
        docIndex = _p1Path.length - 5;
        
        NSString *s3 = [_p1Path substringToIndex:docIndex];
        
        NSString *s4 = [s3 stringByAppendingString:@"_100"];
        
        NSString *pre = [_p1Path substringFromIndex:docIndex];
        
        s4 = [s4 stringByAppendingString:pre];
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,s4];
        
        _p1Path = [NSString stringWithFormat:@"%@",has];
    }
    
    _goodsName = [dic objectForKey:@"productName"];
    
    _goodsTitle = [dic objectForKey:@"productTitle"];
    
    _goodsBrand = [dic objectForKey:@"brand"];
    
    _goodsModel = [dic objectForKey:@"model"];
    
    _goodsVoltage = [NSString stringWithFormat:@"%@",[dic objectForKey:@"voltage"]];
    
    _spec = [NSString stringWithFormat:@"%@",[dic objectForKey:@"spec"]];
    
    _use = [dic objectForKey:@"use"];
    
    _coreNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"coreNum"]];
    
    _standard = [NSString stringWithFormat:@"%@",[dic objectForKey:@"standard"]];
    
    _unit = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unit"]];
    
    _insulationThickness = [NSString stringWithFormat:@"%@",[dic objectForKey:@"insulationThickness"]];
    
    _avgLength = [NSString stringWithFormat:@"%@",[dic objectForKey:@"length"]];
    
    _avgDiameter = [NSString stringWithFormat:@"%@",[dic objectForKey:@"avgDiameter"]];
    
    _weight = [NSString stringWithFormat:@"%@",[dic objectForKey:@"weight"]];
    
    _shopName = [dic objectForKey:@"shopName"];
    
    _shopShortname = [dic objectForKey:@"shopShortname"];
    
    _shopId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shopId"]];
}

@end
