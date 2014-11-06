//
//  B2BAddressData.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-6.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2BAddressData : NSObject

@property (strong,nonatomic) NSString *addressId;
@property (strong,nonatomic) NSString *addressName;
@property (strong,nonatomic) NSString *addressType;
@property (strong,nonatomic) NSString *area;
@property (strong,nonatomic) NSString *city;
@property (strong,nonatomic) NSString *isDefault;
@property (strong,nonatomic) NSString *isDelete;
@property (strong,nonatomic) NSString *memberId;
@property (strong,nonatomic) NSString *mobile;
@property (strong,nonatomic) NSString *province;
@property (strong,nonatomic) NSString *receiver;
@property (strong,nonatomic) NSString *tel;
@property (strong,nonatomic) NSString *zip;
@property (strong,nonatomic) NSString *fullAddress;


- (id) initWithDic:(NSDictionary *) dic;

+ (NSMutableArray *) getListArray:(NSMutableArray *) array;
@end
