//
//  B2BAskPriceDetailData.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-4.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2BAskPriceDetailData.h"
#import "DCFCustomExtra.h"

@implementation B2BAskPriceDetailData

- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        _addrId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"addrId"]];
        
        _cartId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cartId"]];
        
        _cartModel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cartModel"]];
        
        _cartSpec = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cartSpec"]];
        
        _cartVoltage = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cartVoltage"]];
        
        _cartColor = [NSString stringWithFormat:@"%@",[dic objectForKey:@"color"]];
        
        _createDate = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"createDate"]];
        
        _deliver = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deliver"]];
        
        _feature = [NSString stringWithFormat:@"%@",[dic objectForKey:@"feature"]];
        
        _featureone = [NSString stringWithFormat:@"%@",[dic objectForKey:@"featureone"]];
        
        _featuretwo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"featuretwo"]];
        
        _fileId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fileId"]];
        
        _filePath = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filePath"]];
        
        _firstType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"firstType"]];
        
        _fuleName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fuleName"]];
        
        _memberId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
        
        NSString *NumBer = [NSString stringWithFormat:@"%@",[dic objectForKey:@"num"]];
        NSString *testNum = [DCFCustomExtra notRounding:NumBer];
//        NSString *testNum = nil;
//        for(int i=0;i<NumBer.length;i++)
//        {
//            char c = [NumBer characterAtIndex:i];
//            if(c == '.')
//            {
//                testNum = [DCFCustomExtra notRounding:[NumBer doubleValue]];
//                break;
//            }
//            else if(i == NumBer.length-1)
//            {
//                testNum = NumBer;
//            }
//        }
        
        _num = [NSString stringWithFormat:@"%@",testNum];
        
        _price = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];
        
        _require = [NSString stringWithFormat:@"%@",[dic objectForKey:@"require"]];
        
        _secondType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"secondType"]];
        
        _thridType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"thridType"]];
        
        _total = [NSString stringWithFormat:@"%@",[dic objectForKey:@"total"]];
        
        _unit = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unit"]];
        
        _visitorId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"visitorId"]];
        
        _chooseKind = [NSString stringWithFormat:@"%@%@%@",_firstType,_secondType,_thridType];
    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        B2BAskPriceDetailData *amount = [[B2BAskPriceDetailData alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}

@end
