//
//  B2BManagBillData.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-14.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2BManagBillData : NSObject

@property (strong,nonatomic) NSDictionary *createDate;

@property (strong,nonatomic) NSString *address;

@property (strong,nonatomic) NSString *bank;

@property (strong,nonatomic) NSString *bankAccount;

@property (strong,nonatomic) NSString *city;

@property (strong,nonatomic) NSString *comTel;

@property (strong,nonatomic) NSString *company;

@property (strong,nonatomic) NSString *content;

@property (strong,nonatomic) NSString *district;

@property (strong,nonatomic) NSString *invoiceId;

@property (strong,nonatomic) NSString *headName;

@property (strong,nonatomic) NSString *province;

@property (strong,nonatomic) NSString *receiveCompany;

@property (strong,nonatomic) NSString *receiveTel;

@property (strong,nonatomic) NSString *recipient;

@property (strong,nonatomic) NSString *regAddr;

@property (strong,nonatomic) NSString *status
;
@property (strong,nonatomic) NSString *taxCode;

@property (strong,nonatomic) NSString *headType;

@property (strong,nonatomic) NSString *tel;

@property (strong,nonatomic) NSString *zip;

@property (strong,nonatomic) NSString *b2bManagBillTime;

@property (strong,nonatomic) NSString *myStatus;

- (id) initWithDic:(NSDictionary *) dic;

+ (NSMutableArray *) getListArray:(NSMutableArray *) array;

@end
