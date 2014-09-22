//
//  BaseExecutor.h
//  TestConnection
//
//  Created by dqf on 4/9/14.
//  Copyright (c) 2014 dqf. All rights reserved.
//

#import "BaseTask.h"

@interface BaseExecutor : NSObject<MyTaskDelegate,NSURLConnectionDelegate>{
       NSMutableData *_dtReviceData; 
}

@property(nonatomic,assign)id<MyTaskDelegate>delegate;
@property (nonatomic,assign) BOOL testMode;
@property(nonatomic,strong) NSString *strUrl;
@property(nonatomic,strong) NSString *postBody;
@property(nonatomic,strong) NSDictionary *imgDic;
@property(nonatomic,strong) NSURLConnection *conn;
@property (nonatomic,assign) URLMethod urlMethod;
@property (nonatomic,assign) URLTag urlTag;

- (id)initWith:(id<MyTaskDelegate>)del urlString:(NSString *)urlStr postBody:(NSString *)strPostBody action:(URLMethod)theMethod tag:(URLTag)aUrlTag;
- (id)initWith:(id<MyTaskDelegate>)del urlString:(NSString *)urlStr dicImage:(NSDictionary *)dicImage action:(URLMethod)theMethod tag:(URLTag)aUrlTag;
//子类覆盖
-(id) analysisData:(id)data;
-(void)start;
- (void)stopConnection;

@end