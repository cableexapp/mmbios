//
//  B2CGoodsListData.m
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-16.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import "B2CGoodsListData.h"
#import "MCDefine.h"

@implementation B2CGoodsListData

- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        _productName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productName"]];
        
        _productPrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productPrice"]];
        
        _saleNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"saleNum"]];
        
        _shopId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shopId"]];
        
        _p1Path = [NSString stringWithFormat:@"%@",[dic objectForKey:@"p1Path"]];
        
        _productId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productId"]];
        
        _shopName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shopName"]];
        //.的下标
        int docIndex = _p1Path.length-4;
        if([_p1Path characterAtIndex:docIndex] == '.')
        {
  
            NSString *s1 = [_p1Path substringToIndex:docIndex];
            
            NSString *s2 = [s1 stringByAppendingString:@"_100"];
            
            NSString *pre = [_p1Path substringFromIndex:docIndex];
            
            s2 = [s2 stringByAppendingString:pre];
            
            NSString *has = [NSString stringWithFormat:@"%@%@",URL_PIC_DEV,s2];
            
            _p1Path = [NSString stringWithFormat:@"%@",has];
            
        }
        else
        {
            docIndex = _p1Path.length - 5;

            NSString *s3 = [_p1Path substringToIndex:docIndex];
            
            NSString *s4 = [s3 stringByAppendingString:@"_300"];
            
            NSString *pre = [_p1Path substringFromIndex:docIndex];
            
            s4 = [s4 stringByAppendingString:pre];
            
            NSString *has = [NSString stringWithFormat:@"%@%@",URL_PIC_DEV,s4];
            
            _p1Path = [NSString stringWithFormat:@"%@",has];
        }
    
    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2CGoodsListData *amount = [[B2CGoodsListData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}
@end
