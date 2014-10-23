//
//  B2CAfterSaleData.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-23.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2CAfterSaleData : NSObject

@property (strong,nonatomic) NSString *afterOrderNum;

@property (strong,nonatomic) NSDictionary *operateDate;

@property (strong,nonatomic) NSString *operateUsername;

@property (strong,nonatomic) NSString *remark;

- (id) initWithDic:(NSDictionary *) dic;

+ (NSMutableArray *) getListArray:(NSMutableArray *) array;

@end
