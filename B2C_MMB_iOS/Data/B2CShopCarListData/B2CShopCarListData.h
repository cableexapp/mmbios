//
//  B2CShopCarListData.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-28.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2CShopCarListData : NSObject

@property (strong,nonatomic) NSString *colorId;
@property (strong,nonatomic) NSString *colorName;
@property (strong,nonatomic) NSString *colorPrice;
@property (strong,nonatomic) NSString *isSale;
@property (strong,nonatomic) NSString *isUse;
@property (strong,nonatomic) NSDictionary *createDate;
@property (strong,nonatomic) NSString *isAvaliable;
@property (strong,nonatomic) NSString *isDelete;
@property (strong,nonatomic) NSString *itemId;
@property (strong,nonatomic) NSString *memberId;
@property (strong,nonatomic) NSString *num;
@property (strong,nonatomic) NSString *price;
@property (strong,nonatomic) NSString *productId;
@property (strong,nonatomic) NSString *productItemPic;
@property (strong,nonatomic) NSString *productItemSku;
@property (strong,nonatomic) NSString *productItmeTitle;
@property (strong,nonatomic) NSString *recordId;
@property (strong,nonatomic) NSString *sShopName;
@property (strong,nonatomic) NSString *shopId;
@property (strong,nonatomic) NSString *visitorId;
@property (strong,nonatomic) NSString *productNum;
@property (strong,nonatomic) NSString *productName;

- (id) initWithDic:(NSDictionary *) dic;

+ (NSMutableArray *) getListArray:(NSMutableArray *) array;

@end
