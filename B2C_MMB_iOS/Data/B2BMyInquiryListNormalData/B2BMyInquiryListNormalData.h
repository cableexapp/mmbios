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

- (id) initWithDic:(NSDictionary *) dic;

+ (NSMutableArray *) getListArray:(NSMutableArray *) array;


@end
