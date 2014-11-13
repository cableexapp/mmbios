//
//  B2BMyCableOrderListData.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2BMyCableOrderListData : NSObject

@property (strong,nonatomic) NSDictionary *createDate;

@property (strong,nonatomic) NSArray *myItems;

@property (strong,nonatomic) NSString *myTime;

@property (strong,nonatomic) NSString *orderid;

@property (strong,nonatomic) NSString *orderserial;

@property (strong,nonatomic) NSString *ordertotal;

@property (strong,nonatomic) NSString *receiveaddress;

@property (strong,nonatomic) NSString *receivecity;

@property (strong,nonatomic) NSString *receivecompany;

@property (strong,nonatomic) NSString *receivedistrict;

@property (strong,nonatomic) NSString *receivename;

@property (strong,nonatomic) NSString *receiveprovince;

@property (strong,nonatomic) NSString *status;

@property (strong,nonatomic) NSString *tel;

- (id) initWithDic:(NSDictionary *) dic;

+ (NSMutableArray *) getListArray:(NSMutableArray *) array;

@end
