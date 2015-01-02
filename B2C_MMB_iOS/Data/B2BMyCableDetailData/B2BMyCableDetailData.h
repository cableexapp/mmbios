//
//  B2BMyCableDetailData.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-12-29.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2BMyCableDetailData : NSObject

@property (strong,nonatomic) NSDictionary *createDate;

@property (strong,nonatomic) NSDictionary *invoiceDic;

@property (strong,nonatomic) NSString *cableOrderTime;

@property (strong,nonatomic) NSArray *myItems;

@property (strong,nonatomic) NSString *address;

@property (strong,nonatomic) NSString *city;

@property (strong,nonatomic) NSString *district;

@property (strong,nonatomic) NSString *province;

@property (strong,nonatomic) NSString *fullAddress;

@property (strong,nonatomic) NSString *ordernum;

@property (strong,nonatomic) NSString *ordertotal;

@property (strong,nonatomic) NSString *reciver;

@property (strong,nonatomic) NSString *status;

@property (strong,nonatomic) NSString *theTel;

@property (strong,nonatomic) NSString *zip;

@property (strong,nonatomic) NSString *myStatus;



- (id) initWithDic:(NSDictionary *) dic;

- (void) dealData:(NSDictionary *) dic;

@end
