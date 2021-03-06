//
//  B2CMyOrderData.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-16.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2CMyOrderData : NSObject

@property (strong,nonatomic) NSArray *myItems;   //商铺下面的商品数组
@property (strong,nonatomic) NSString *afterStatus;  //售后状态
@property (strong,nonatomic) NSString *juderstatus;  //评价状态
@property (strong,nonatomic) NSDictionary *subDate; //商铺信息数组
@property (strong,nonatomic) NSString *myOderDataTime;
@property (strong,nonatomic) NSString *orderId;
@property (strong,nonatomic) NSString *orderMergeId;
@property (strong,nonatomic) NSString *orderNum;
@property (strong,nonatomic) NSString *orderTotal;
@property (strong,nonatomic) NSString *receiveAddr;
@property (strong,nonatomic) NSString *receiveDate;
@property (strong,nonatomic) NSString *receiveEmail;
@property (strong,nonatomic) NSString *receiveId;
@property (strong,nonatomic) NSString *receiveMember;
@property (strong,nonatomic) NSString *receivePhone;
@property (strong,nonatomic) NSString *receiveTel;
@property (strong,nonatomic) NSString *sellMemberId;
@property (strong,nonatomic) NSString *sellName;
@property (strong,nonatomic) NSString *shopId;
@property (strong,nonatomic) NSString *shopName;
@property (strong,nonatomic) NSString *B2CMyOrderDataStatus;

@property (strong,nonatomic) NSString *logisticsNum;
@property (strong,nonatomic) NSString *logisticsCompanay;
@property (strong,nonatomic) NSString *logisticsId;

- (id) initWithDic:(NSDictionary *) dic;

+ (NSMutableArray *) getListArray:(NSMutableArray *) array;
@end
