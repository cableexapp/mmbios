//
//  B2CShopCarListData.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-28.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2CShopCarListData.h"
#import "MCDefine.h"

@implementation B2CShopCarListData

- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        _colorId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"colorId"]];
        
        _colorName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"colorName"]];
        
        _createDate = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"createDate"]];
        
        _isAvaliable = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isAvaliable"]];
        
        _isDelete = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isDelete"]];
        
        _itemId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"itemId"]];
        
        _memberId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
        
        _num = [NSString stringWithFormat:@"%@",[dic objectForKey:@"num"]];
        
        _price = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];
        
        _productId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productId"]];
        
        _productItemSku = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productItemSku"]];
        
        _productItmeTitle = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productItmeTitle"]];
        
        _recordId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recordId"]];
        
        _sShopName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sShopName"]];
        
        _shopId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shopId"]];
        
        _visitorId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"visitorId"]];

        _productItemPic = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productItemPic"]];

        //.的下标
        int docIndex = _productItemPic.length-4;
        if([_productItemPic characterAtIndex:docIndex] == '.')
        {
            
            NSString *s1 = [_productItemPic substringToIndex:docIndex];
            
            NSString *s2 = [s1 stringByAppendingString:@"_100"];
            
            NSString *pre = [_productItemPic substringFromIndex:docIndex];
            
            s2 = [s2 stringByAppendingString:pre];
            
            NSString *has = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,s2];
            
            _productItemPic = [NSString stringWithFormat:@"%@",has];
            
        }
        else
        {
            docIndex = _productItemPic.length - 5;
            
            NSString *s3 = [_productItemPic substringToIndex:docIndex];
            
            NSString *s4 = [s3 stringByAppendingString:@"_100"];
            
            NSString *pre = [_productItemPic substringFromIndex:docIndex];
            
            s4 = [s4 stringByAppendingString:pre];
            
            NSString *has = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,s4];
            
            _productItemPic = [NSString stringWithFormat:@"%@",has];
        }
        
    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2CShopCarListData *amount = [[B2CShopCarListData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}

@end
