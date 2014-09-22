//
//  DCFMyArrangeHomeWorkList.h
//  DCFTeacherEnd
//
//  Created by jhq on 14-5-6.
//  Copyright (c) 2014年 dqf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCFMyArrangeHomeWorkList : NSObject

@property (assign,nonatomic) long totalOfPage;

@property (assign,nonatomic) long homeworkId;

@property (strong,nonatomic) NSString *userTeaName;

@property (strong,nonatomic) NSString *subjectIconUrl;

@property (assign,nonatomic) long  subjectId;

@property (strong,nonatomic) NSString *finishedFlag;

@property (strong,nonatomic) NSString *homeworkName;

@property (strong,nonatomic) NSString *startTime;

@property (strong,nonatomic) NSString *endTime;

@property (strong,nonatomic) NSString *time;



+ (NSMutableArray *) getListArray:(NSMutableArray *) array;
- (id) initWithDic:(NSDictionary *) dic;
@end
