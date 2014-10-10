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
    
    _ctems = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"ctems"]];
    
    _items = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"items"]];
    
    NSDictionary *dic = nil;
    if([_items isKindOfClass:[NSNull class]] || _items.count == 0)
    {
        dic = [[NSDictionary alloc] init];
    }
    else
    {
        dic = [_items objectAtIndex:0];
        
    }
    
    _p1Path = [dic objectForKey:@"p1Path"];
    _p2Path = [dic objectForKey:@"p2Path"];
    _p3Path = [dic objectForKey:@"p3Path"];
    _p4Path = [dic objectForKey:@"p3Path"];
    _p5Path = [dic objectForKey:@"p5Path"];
    
    _picArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    if(_p1Path.length != 0)
    {
        [_picArray addObject:_p1Path];
    }
    if(_p2Path.length != 0)
    {
        [_picArray addObject:_p2Path];
    }
    if(_p3Path.length != 0)
    {
        [_picArray addObject:_p3Path];
    }
    if(_p4Path.length != 0)
    {
        [_picArray addObject:_p4Path];
    }
    if(_p5Path.length != 0)
    {
        [_picArray addObject:_p5Path];
    }
    
    for(int i=0;i<_picArray.count;i++)
    {
        NSString *pic = [_picArray objectAtIndex:i];
        //.的下标
        int docIndex = pic.length-4;
        if([pic characterAtIndex:docIndex] == '.')
        {
            
            NSString *s1 = [pic substringToIndex:docIndex];
            
            NSString *s2 = [s1 stringByAppendingString:@"_100"];
            
            NSString *pre = [pic substringFromIndex:docIndex];
            
            s2 = [s2 stringByAppendingString:pre];
            
            NSString *has = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,s2];
            
            pic = [NSString stringWithFormat:@"%@",has];
            
        }
        else
        {
            docIndex = pic.length - 5;
            
            NSString *s3 = [pic substringToIndex:docIndex];
            
            NSString *s4 = [s3 stringByAppendingString:@"_100"];
            
            NSString *pre = [pic substringFromIndex:docIndex];
            
            s4 = [s4 stringByAppendingString:pre];
            
            NSString *has = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,s4];
            
            pic = [NSString stringWithFormat:@"%@",has];
        }
        [_picArray replaceObjectAtIndex:i withObject:pic];
    }
    
  
    
    _productPrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productPrice"]];
    
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
    
//    _score = [NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"score"] objectAtIndex:0]];
    
    NSArray *scoreArray = [dictionary objectForKey:@"score"];
    if([scoreArray isKindOfClass:[NSNull class]] || scoreArray.count == 0)
    {
        _score = @"";
    }
    else
    {
        _score = [NSString stringWithFormat:@"%@",[scoreArray objectAtIndex:0]];
    }
    
    _productId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productId"]];
}

@end