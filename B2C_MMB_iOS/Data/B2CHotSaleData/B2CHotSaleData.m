//
//  B2CHotSaleData.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-30.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2CHotSaleData.h"
#import "DCFCustomExtra.h"
#import "MCDefine.h"

@implementation B2CHotSaleData

- (id) initWithDic:(NSDictionary *)dic
{
    if(self = [super init])
    {
        NSString *pic = [NSString stringWithFormat:@"%@",[dic objectForKey:@"p1Path"]];
        //.的下标
        int docIndex = pic.length-4;
        if([pic characterAtIndex:docIndex] == '.')
        {
            
            NSString *s1 = [pic substringToIndex:docIndex];
            
            NSString *s2 = [s1 stringByAppendingString:@"_310"];
            
            NSString *pre = [pic substringFromIndex:docIndex];
            
            s2 = [s2 stringByAppendingString:pre];
            
            NSString *has = [NSString stringWithFormat:@"%@%@",URL_PIC_DEV,s2];
            
            pic = [NSString stringWithFormat:@"%@",has];
            
        }
        else
        {
            docIndex = pic.length - 5;
            
            NSString *s3 = [pic substringToIndex:docIndex];
            
            NSString *s4 = [s3 stringByAppendingString:@"_310"];
            
            NSString *pre = [pic substringFromIndex:docIndex];
            
            s4 = [s4 stringByAppendingString:pre];
            
            NSString *has = [NSString stringWithFormat:@"%@%@",URL_PIC_DEV,s4];
            
            pic = [NSString stringWithFormat:@"%@",has];
        }
        _p1Path = [NSString stringWithFormat:@"%@",pic];
        
        _myProductId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productId"]];
        _productTitle = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productTitle"]];
        _productPrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productPrice"]];
        _productName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productName"]];
    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2CHotSaleData *amount = [[B2CHotSaleData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}

@end
