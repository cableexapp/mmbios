//
//  B2CGoodsDetailData.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-27.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2CGoodsDetailData : NSObject

@property (strong,nonatomic) NSArray *coloritems;

@property (strong,nonatomic) NSArray *ctems;

@property (strong,nonatomic) NSArray *items;

@property (strong,nonatomic) NSString *p1Path;

@property (strong,nonatomic) NSString *p2Path;

@property (strong,nonatomic) NSString *p3Path;

@property (strong,nonatomic) NSString *p4Path;

@property (strong,nonatomic) NSString *p5Path;

@property (strong,nonatomic) NSMutableArray *picArray;

@property (strong,nonatomic) NSString *goodsName;

@property (strong,nonatomic) NSString *goodsTitle;

@property (strong,nonatomic) NSString *productPrice;

@property (strong,nonatomic) NSString *goodsVoltage;  //额定电压

@property (strong,nonatomic) NSString *goodsBrand;   //商品品牌

@property (strong,nonatomic) NSString *goodsModel;   //商品型号

@property (strong,nonatomic) NSString *spec;    //横截面

@property (strong,nonatomic) NSString *use;    //用途

@property (strong,nonatomic) NSString *coreNum;   //芯数

@property (strong,nonatomic) NSString *standard;  //执行标准

@property (strong,nonatomic) NSString *unit;  //计价单位

@property (strong,nonatomic) NSString *insulationThickness;  //绝缘厚度

@property (strong,nonatomic) NSString *avgLength;  //每卷长度

@property (strong,nonatomic) NSString *avgDiameter;  //外径上限

@property (strong,nonatomic) NSString  *weight;

@property (strong,nonatomic) NSString  *shopName;

@property (strong,nonatomic) NSString  *shopShortname;

@property (strong,nonatomic) NSString  *shopId;

@property (strong,nonatomic) NSString *score;

- (void) dealData:(NSDictionary *) dictionary;

@end
