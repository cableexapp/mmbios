//
//  DCFMyArrangeHomeWorkList.m
//  DCFTeacherEnd
//
//  Created by jhq on 14-5-6.
//  Copyright (c) 2014年 dqf. All rights reserved.
//

#import "DCFMyArrangeHomeWorkList.h"

@implementation DCFMyArrangeHomeWorkList

- (id) initWithDic:(NSDictionary *) dic
{
    if(self = [super init])
    {
        _totalOfPage = [[dic objectForKey:@"totalOfPage"] longValue];
        _homeworkId = [[dic objectForKey:@"homeworkId"] longValue];
        _userTeaName = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"userTeaName"]];
        _subjectIconUrl = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"subjectIconUrl"]];
        _subjectId = [[dic objectForKey:@"subjectId"] longValue];
        _homeworkName = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"homeworkName"]];
        _startTime = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"startTime"]];
        _endTime = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"endTime"]];
        _time = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"time"]];
        _finishedFlag = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"finishedFlag"]];
    }
    return self;
}

+ (NSMutableArray *) getListArray:(NSMutableArray *) array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        DCFMyArrangeHomeWorkList *amount = [[DCFMyArrangeHomeWorkList alloc] initWithDic:dic];
        [dataArray addObject:amount];
    }
    return dataArray;
}

@end
