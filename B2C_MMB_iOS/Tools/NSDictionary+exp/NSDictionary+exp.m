//
//  NSDictionary+exp.m
//  DCFTeacherEnd
//
//  Created by dqf on 14-5-8.
//  Copyright (c) 2014年 dqf. All rights reserved.
//

#import <objc/runtime.h>

@implementation NSDictionary (Extension)

- (NSString *)toUrlString
{
    NSString *urlStr = @"";
    NSArray *keys = [self allKeys];
    NSUInteger count = [keys count];
    for (int i=0; i<count; i++) {
        NSString *key = [keys objectAtIndex:i];
        if (i == 0) {
            
            urlStr = [NSString stringWithFormat:@"%@=%@",key,[self objectForKey:key]];
        }else {
            
            urlStr = [NSString stringWithFormat:@"%@&%@=%@",urlStr,key,[self objectForKey:key]];
        }
    }

    return urlStr;
}

- (NSString *)toJSONString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}

@end