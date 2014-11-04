//
//  B2BAskPriceDetailData.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-4.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2BAskPriceDetailData : NSObject

@property (strong,nonatomic) NSString *addrId;
@property (strong,nonatomic) NSString *cartId;
@property (strong,nonatomic) NSString *cartModel;
@property (strong,nonatomic) NSString *cartSpec;
@property (strong,nonatomic) NSString *cartVoltage;  //5

@property (strong,nonatomic) NSString *color;
@property (strong,nonatomic) NSDictionary *createDate;
@property (strong,nonatomic) NSString *deliver;
@property (strong,nonatomic) NSString *feature;
@property (strong,nonatomic) NSString *featureone;  //阻燃特性  10

@property (strong,nonatomic) NSString *featuretwo;
@property (strong,nonatomic) NSString *fileId;
@property (strong,nonatomic) NSString *filePath;
@property (strong,nonatomic) NSString *firstType;
@property (strong,nonatomic) NSString *fuleName;    //15

@property (strong,nonatomic) NSString *memberId;
@property (strong,nonatomic) NSString *num;
@property (strong,nonatomic) NSString *price;
@property (strong,nonatomic) NSString *require;
@property (strong,nonatomic) NSString *secondType;  //20

@property (strong,nonatomic) NSString *thridType;
@property (strong,nonatomic) NSString *total;
@property (strong,nonatomic) NSString *unit;
@property (strong,nonatomic) NSString *visitorId;


- (id) initWithDic:(NSDictionary *) dic;

+ (NSMutableArray *) getListArray:(NSMutableArray *) array;

@end
