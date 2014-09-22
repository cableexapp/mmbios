//
//  TestTask.m
//  TestConnection
//
//  Created by dqf on 4/9/14.
//  Copyright (c) 2014 dqf. All rights reserved.
//

#import "TestTask.h"
#import "PhoneHelper.h"
#import "NSDictionary+exp.h"

@implementation TestTask

@synthesize exe;
@synthesize urlTag;

@synthesize showPromptView;

@synthesize objcs;
@synthesize keys;

-(void)fail:(int)err
{
    
    if ([self showPromptView]) {
        
        //REMOVE WAITING VIEW
        if ([[self delegate] respondsToSelector:@selector(removeWaitingView)]) {
            
            [[self delegate] removeWaitingView];
        }
        //ADD ERROE VIEW
        if ([[self delegate] respondsToSelector:@selector(addErrorView)]) {
            
            [[self delegate] addErrorView];
        }
    }
    
    //EXE DELEGATE METHOD
    if ([[self delegate] respondsToSelector:@selector(resultWithData:urlTag:statusCode:statusMsg:)]) {
      
        [[self delegate] resultWithData:nil urlTag:self.urlTag statusCode:RS_Error statusMsg:nil];
    }
    
}

-(void)finish:(id)data statusMsg:(NSString *)msg
{
    if ([self showPromptView]) {
        
        //REMOVE WAITING VIEW
        if ([[self delegate] respondsToSelector:@selector(removeWaitingView)]) {
            
            [[self delegate] removeWaitingView];
        }
        //REMOVE ERROR VIEW
        if ([[self delegate] respondsToSelector:@selector(removeErrorView)]) {
            
            [[self delegate] removeErrorView];//此处需要先判断ErrorView是否存在
        }
    }
    
    //EXE DELEGATE METHOD
    if ([[self delegate] respondsToSelector:@selector(resultWithData:urlTag:statusCode:statusMsg:)]) {
        
        [[self delegate] resultWithData:data urlTag:self.urlTag statusCode:RS_Success statusMsg:msg];
    }

}

//判断是否有网络
- (void)checkNetworkStatus
{
    if(![PhoneHelper sharedInstance].isNetValiad ){
        
        self.isNetWork = NO;
        
        if ([[self delegate] respondsToSelector:@selector(addNetInvaliadView)]) {
            
            [[self delegate] addNetInvaliadView];
        }
    }else {
        
        self.isNetWork = YES;
        
        if ([[self delegate] respondsToSelector:@selector(removeNetInvaliadView)]) {
            
            [[self delegate] removeNetInvaliadView];
        }
    }
}

- (id)initWith:(id<MyHandleDelegate>)del objcs:(NSArray *)objcArr keys:(NSArray *)keyArr
{
    self = [super initWith:del];
    
    [self setObjcs:objcArr];
    [self setKeys:keyArr];
    
    //以视图方式提醒,如果想以视图方式提醒就设置YES,反之为NO
    [self setShowPromptView:YES];
    [self setUrlTag:URLLoginTag];
    
    //判断是否有网络
    [self checkNetworkStatus];
    
    return self;
}

-(void)main
{
    @autoreleasepool {
        
        if ([self showPromptView]) {
            
            //REMOVE ERROR VIEW
            if ([[self delegate] respondsToSelector:@selector(removeErrorView)]) {
                
                [[self delegate] removeErrorView];//此处需要先判断ErrorView是否存在
            }
            //ADD WAITING VIEW
            if ([[self delegate] respondsToSelector:@selector(addWaitingView)]) {
                
                [[self delegate] addWaitingView];
            }
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:objcs forKeys:keys];
        
        [self startExeUrlString:URL_LOGIN postBody:[dic toUrlString] method:POST tag:self.urlTag];
    }
}

- (void)startExeUrlString:(NSString *)urlStr postBody:(NSString *)strPostBody method:(URLMethod)theMethod tag:(URLTag)aTag
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    exe = [[BaseExecutor alloc] initWith:self urlString:urlStr postBody:strPostBody action:theMethod tag:aTag];
    
    //本地模拟测试的时候设置YES
//    [exe setTestMode:YES];
    
    //实际连调服务器的时候设置NO
    [exe setTestMode:NO];

    [exe start];
    
}

@end
