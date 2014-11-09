//
//  B2BGetModelByIdData.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-9.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2BGetModelByIdData : NSObject

@property (strong,nonatomic) NSString *byname;

@property (strong,nonatomic) NSString *featureName;

@property (strong,nonatomic) NSString *featureType;

@property (strong,nonatomic) NSString *firstType;

@property (strong,nonatomic) NSString *theModel;

@property (strong,nonatomic) NSString *modelDescrible;

@property (strong,nonatomic) NSString *modeltitle;

@property (strong,nonatomic) NSString *propertyId;

@property (strong,nonatomic) NSString *secondType;

@property (strong,nonatomic) NSString *sequence;

@property (strong,nonatomic) NSString *status;

@property (strong,nonatomic) NSString *thirdType;


- (id) initWithDic:(NSDictionary *) dic;

+ (NSMutableArray *) getListArray:(NSMutableArray *) array;
@end
