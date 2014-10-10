//
//  B2CUpOrderData.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-9.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2CUpOrderData.h"

@implementation B2CUpOrderData

- (id) initWithDataDic:(NSDictionary *) dic
{
    if(self == [super init])
    {
        if([dic.allKeys count] == 0 || dic == nil)
        {
            
        }
        else
        {
            _addressArray = [[NSArray alloc] initWithArray:[dic objectForKey:@"address"]];
            _invoicesArray = [[NSArray alloc] initWithArray:[dic objectForKey:@"invoices"]];
            _summariesArray = [[NSArray alloc] initWithArray:[dic objectForKey:@"summaries"]];
        }
    }
    return self;
}

@end
