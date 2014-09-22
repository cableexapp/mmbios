//
//  Objc+UserInfo.m
//  DCFTeacherEnd
//
//  Created by dqf on 14-5-8.
//  Copyright (c) 2014年 dqf. All rights reserved.
//

#import <objc/runtime.h>

@implementation NSObject (Extension)

-(void)setExtraInfo:(NSDictionary *)newUserInfo
{
    objc_setAssociatedObject(self, @"extraInfo", newUserInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)extraInfo
{
    return objc_getAssociatedObject(self, @"extraInfo");
}
@end