//
//  B2CGetOrderDetailData.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-21.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2CGetOrderDetailData : NSObject
@property (strong,nonatomic) NSArray *myItems;

@property (strong,nonatomic) NSString *invoiceType;
@property (strong,nonatomic) NSString *nvoiceTitle;

@property (strong,nonatomic) NSString *receiveAddr;
@property (strong,nonatomic) NSString *receiveId;
@property (strong,nonatomic) NSString *receivePhone;
@property (strong,nonatomic) NSString *receiveMember;

@property (strong,nonatomic) NSDictionary *subDate;
@property (strong,nonatomic) NSString *myTime;

@property (strong,nonatomic) NSString *shopName;

@property (strong,nonatomic) NSString *logisticsPrice; //运费
@property (strong,nonatomic) NSString *orderTotal;   //订单总额

@property (strong,nonatomic) NSString *status;

@property (strong,nonatomic) NSString *snapId;

@property (strong,nonatomic) NSString *shopId;

@property (strong,nonatomic) NSString *logisticsId;

@property (strong,nonatomic) NSString *orderNum;

@property (strong,nonatomic) NSString *orderId;

@property (strong,nonatomic) NSString *logisticsNum;

@property (strong,nonatomic) NSString *logisticsCompanay;

@property (strong,nonatomic) NSString *juderstatus;

@property (strong,nonatomic) NSString *afterStatus;


- (id) initWithDic:(NSDictionary *) dic;

+ (NSMutableArray *) getListArray:(NSMutableArray *) array;
@end
