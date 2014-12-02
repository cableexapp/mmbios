//
//  B2BMyInquiryListFastData.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-10.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2BMyInquiryListFastData : NSObject

@property (strong,nonatomic) NSString *content;

@property (strong,nonatomic) NSDictionary *createDate;

@property (strong,nonatomic) NSString *fileId;

@property (strong,nonatomic) NSString *filePath;

@property (strong,nonatomic) NSString *fuleName;

@property (strong,nonatomic) NSString *inquiryId;

@property (strong,nonatomic) NSString *isDelete;

@property (strong,nonatomic) NSString *linkman;

@property (strong,nonatomic) NSString *oemId;

@property (strong,nonatomic) NSString *operatior;

@property (strong,nonatomic) NSString *phone;

@property (strong,nonatomic) NSString *qq;

@property (strong,nonatomic) NSString *remark;

@property (strong,nonatomic) NSString *status;

@property (strong,nonatomic) NSString *treatment;

@property (strong,nonatomic) NSString *myTime;

@property (strong,nonatomic) NSString *oemNo;

- (id) initWithDic:(NSDictionary *) dic;

+ (NSMutableArray *) getListArray:(NSMutableArray *) array;

@end
