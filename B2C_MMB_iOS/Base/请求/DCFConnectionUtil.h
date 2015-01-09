//
//  ConnectionUtil.h
//  midai
//
//  Created by duomai on 13-10-21.
//  Copyright (c) 2013年 tiny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"
//enum {
//    POST = 1,
//    GET = 2,
//};
//typedef NSUInteger URLMethod;

#pragma mark - TAG定义，班级空间以CS开头，个人中心以PC开头，家长学堂以PS开头
enum {
    
    
    //退出
    URLLoginOutTag,         //退出


};
typedef NSUInteger URLTag;


//enum {
//    RS_Success = 1,
//    RS_Error,
//};
//typedef NSUInteger ResultCode;


@protocol ConnectionDelegate
@optional
//- (void)pushToLoginViewControllerWithTag:(URLTag)theUrlTag;
@required
- (void)resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode;
@optional
- (void) resultWithString:(NSString *) str;
@end

@interface DCFConnectionUtil : NSObject<NSURLConnectionDelegate>{
    NSMutableData *_dtReviceData;
}

@property (nonatomic,assign) id<ConnectionDelegate> delegate;
@property (nonatomic,assign) URLTag urlTag;
@property (nonatomic,strong) NSURLConnection *conn;
@property (nonatomic,assign) BOOL isShowErrorView;
@property (assign,nonatomic) BOOL isSpecialCharacter;   //是否是特殊字符
@property (strong,nonatomic) NSString *specialString;    //特殊字符

@property (assign,nonatomic) BOOL LogOut;
@property (assign,nonatomic) BOOL LogIn;

- (id)initWithURLTag:(URLTag)theUrlTag delegate:(id<ConnectionDelegate>)theDelegate;
- (void)getResultFromUrlString:(NSString *)strUrl postBody:(NSString *)strPostBody method:(URLMethod)theMethod;
- (void)getResultFromUrlString:(NSString *)strUrl dicText:(NSDictionary *)dicText dicImage:(NSDictionary *)dicImage imageFilename:(NSMutableArray *)strImageFileName;
- (void)stopConnection;

@end
    