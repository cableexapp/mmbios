//
//  BaseTask.h
//  TestConnection
//
//  Created by dqf on 4/9/14.
//  Copyright (c) 2014 dqf. All rights reserved.
//

#import "Contact.h"

//task实现
@protocol MyTaskDelegate <NSObject>
@optional
-(void)fail:(int)err;
-(void)finish:(id)data statusMsg:(NSString *)msg;
-(void)progress:(float)progress;
@end

//ui或task实现
@protocol MyHandleDelegate <NSObject>

@optional
- (void)addNetInvaliadView;
- (void)removeNetInvaliadView;
- (void)addWaitingView;
- (void)removeWaitingView;
- (void)addErrorView;
- (void)removeErrorView;
- (void)addNoContentView;

@required
- (void)resultWithData:(id)analyData urlTag:(URLTag)URLTag statusCode:(ResultCode)resultCode statusMsg:(NSString *)resultMsg;

@end

@interface BaseTask : NSOperation

@property(nonatomic,strong) id<MyHandleDelegate>delegate;
@property(nonatomic,assign) BOOL isSuccess;
@property(nonatomic,assign) BOOL isNetWork;

-(id)initWith:(id<MyHandleDelegate>)del;
+(void)addToQueue:(NSOperation*)task;

@end
