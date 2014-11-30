//
//  B2CHotSaleData.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-30.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2CHotSaleData : NSObject

@property (strong,nonatomic) NSString *p1Path;

@property (strong,nonatomic) NSString *myProductId;

@property (strong,nonatomic) NSString *productTitle;

@property (strong,nonatomic) NSString *productPrice;


- (id) initWithDic:(NSDictionary *) dic;

+ (NSMutableArray *) getListArray:(NSMutableArray *) array;
@end
