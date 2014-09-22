//
//  B2CGoodsListData.h
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-16.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B2CGoodsListData : NSObject
{

}
@property (strong,nonatomic) NSString *productName;
@property (strong,nonatomic) NSString *productPrice;
@property (strong,nonatomic) NSString *saleNum;
@property (strong,nonatomic) NSString *p1Path;


+ (NSMutableArray *) getListArray:(NSMutableArray *) array;
- (id) initWithDic:(NSDictionary *) dic;

@end
