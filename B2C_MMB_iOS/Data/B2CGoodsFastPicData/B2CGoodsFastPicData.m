//
//  B2CGoodsFastPicData.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-24.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2CGoodsFastPicData.h"
#import "MCDefine.h"

@implementation B2CGoodsFastPicData

- (NSString *) dealPic:(NSString *) picString
{
    NSString *pic = picString;
    //.的下标
    int docIndex = pic.length-4;
    if([pic characterAtIndex:docIndex] == '.')
    {
        
        NSString *s1 = [pic substringToIndex:docIndex];
        
        NSString *s2 = [s1 stringByAppendingString:@"_100"];
        
        NSString *pre = [pic substringFromIndex:docIndex];
        
        s2 = [s2 stringByAppendingString:pre];
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_PIC_DEV,s2];
        
        pic = [NSString stringWithFormat:@"%@",has];
        
    }
    else
    {
        docIndex = pic.length - 5;
        
        NSString *s3 = [pic substringToIndex:docIndex];
        
        NSString *s4 = [s3 stringByAppendingString:@"_100"];
        
        NSString *pre = [pic substringFromIndex:docIndex];
        
        s4 = [s4 stringByAppendingString:pre];
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_PIC_DEV,s4];
        
        pic = [NSString stringWithFormat:@"%@",has];
    }
    return pic;
}


- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        _brand = [NSString stringWithFormat:@"%@",[dic objectForKey:@"brand"]];
        
        _color = [NSString stringWithFormat:@"%@",[dic objectForKey:@"color"]];

        _colorId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"colorId"]];

        if([[dic objectForKey:@"createDate"] isKindOfClass:[NSNull class]] || [[[dic objectForKey:@"createDate"] allKeys] count] == 0)
        {
            
        }
        else
        {
            _createDate = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"createDate"]];
        }
        
        _describe = [NSString stringWithFormat:@"%@",[dic objectForKey:@"describe"]];

        _freightPrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"freightPrice"]];

        _model = [NSString stringWithFormat:@"%@",[dic objectForKey:@"model"]];

        _orderNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderNum"]];

        _price = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];

        _productCity = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productCity"]];

        _productId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productId"]];

        _productItemPic = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productItemPic"]];
        _productItemPic = [self dealPic:_productItemPic];

        _productName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productName"]];

        _productProvince = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productProvince"]];

        _range = [NSString stringWithFormat:@"%@",[dic objectForKey:@"range"]];

        _snapId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"snapId"]];
        
        _spec = [NSString stringWithFormat:@"%@",[dic objectForKey:@"spec"]];
        
        _voltage = [NSString stringWithFormat:@"%@",[dic objectForKey:@"voltage"]];

    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2CGoodsFastPicData *amount = [[B2CGoodsFastPicData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}

@end
