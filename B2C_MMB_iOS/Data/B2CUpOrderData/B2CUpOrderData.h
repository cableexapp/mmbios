//
//  B2CUpOrderData.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-9.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2CUpOrderData : NSObject
@property (strong,nonatomic) NSArray *addressArray;
@property (strong,nonatomic) NSArray *invoicesArray;
@property (strong,nonatomic) NSArray *summariesArray;

- (id) initWithDataDic:(NSDictionary *) dic;
@end
