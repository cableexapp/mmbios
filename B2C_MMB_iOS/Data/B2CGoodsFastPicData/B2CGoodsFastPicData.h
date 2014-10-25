//
//  B2CGoodsFastPicData.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-24.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2CGoodsFastPicData : NSObject

@property (strong,nonatomic) NSString *brand;

@property (strong,nonatomic) NSString *color;

@property (strong,nonatomic) NSString *colorId;

@property (strong,nonatomic) NSDictionary *createDate;

@property (strong,nonatomic) NSString *describe;

@property (strong,nonatomic) NSString *freightPrice;

@property (strong,nonatomic) NSString *model;

@property (strong,nonatomic) NSString *orderNum;

@property (strong,nonatomic) NSString *price;

@property (strong,nonatomic) NSString *productCity;

@property (strong,nonatomic) NSString *productId;

@property (strong,nonatomic) NSString *productItemPic;

@property (strong,nonatomic) NSString *productName;

@property (strong,nonatomic) NSString *productProvince;

@property (strong,nonatomic) NSString *range;

@property (strong,nonatomic) NSString *snapId;

@property (strong,nonatomic) NSString *spec;

@property (strong,nonatomic) NSString *voltage;

- (id) initWithDic:(NSDictionary *) dic;

+ (NSMutableArray *) getListArray:(NSMutableArray *) array;


@end
