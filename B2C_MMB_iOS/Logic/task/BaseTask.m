//
//  BaseTask.m
//  TestConnection
//
//  Created by dqf on 4/9/14.
//  Copyright (c) 2014 dqf. All rights reserved.
//

#import "BaseTask.h"
#import "AppDelegate.h"
#import "PhoneHelper.h"

@implementation BaseTask

@synthesize delegate;
@synthesize isSuccess;
@synthesize isNetWork;

-(id)initWith:(id<MyHandleDelegate>)del
{
	self = [super init];
    if(self!=nil){
    	self.delegate=del;
    }
    
	return self;
}


+(void)addToQueue:(NSOperation*)task
{
    //判断是否有网络
//    if([PhoneHelper sharedInstance].isNetValiad ){
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app.mainQueue addOperation:task];
//    }
}

@end