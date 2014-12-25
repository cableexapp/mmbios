//
//  B2BMyInquiryListNormalData.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-7.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2BMyInquiryListNormalData : NSObject

@property (strong,nonatomic) NSDictionary *createdate;

@property (strong,nonatomic) NSString *inquiryid;

@property (strong,nonatomic) NSString *inquiryserial;

@property (strong,nonatomic) NSString *inquirytotal;

@property (strong,nonatomic) NSArray *myItems;

@property (strong,nonatomic) NSString *status;

@property (strong,nonatomic) NSString *time;

@property (strong,nonatomic) NSString *address;

@property (strong,nonatomic) NSString *city;

@property (strong,nonatomic) NSString *district;

@property (strong,nonatomic) NSString *province;

@property (strong,nonatomic) NSString *recipint;

@property (strong,nonatomic) NSString *fullAddress;

@property (strong,nonatomic) NSString *tel;


@property (strong,nonatomic) NSDictionary *pushDic;

- (id) initWithDic:(NSDictionary *) dic;

+ (NSMutableArray *) getListArray:(NSMutableArray *) array;


@end
