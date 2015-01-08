//
//  BaseExecutor.m
//  TestConnection
//
//  Created by dqf on 4/9/14.
//  Copyright (c) 2014 dqf. All rights reserved.
//

#import "BaseExecutor.h"
#import "AppDelegate.h"

@interface BaseExecutor ()

@end

@implementation BaseExecutor

@synthesize delegate;
@synthesize testMode;
@synthesize strUrl;
@synthesize postBody;
@synthesize imgDic;
@synthesize conn;
@synthesize urlMethod;
@synthesize urlTag;

//一般请求
- (id)initWith:(id<MyTaskDelegate>)del urlString:(NSString *)urlStr postBody:(NSString *)strPostBody action:(URLMethod)theMethod tag:(URLTag)aUrlTag
{
    self = [super init];
    if (self) {
        self.delegate = del;
        self.strUrl = urlStr;
        self.postBody = strPostBody;
        self.urlMethod = theMethod;
        self.urlTag = aUrlTag;
    }
    
    return self;
}
//上传图片
- (id)initWith:(id<MyTaskDelegate>)del urlString:(NSString *)urlStr dicImage:(NSDictionary *)dicImage action:(URLMethod)theMethod tag:(URLTag)aUrlTag
{
    self = [super init];
    if (self) {
        self.delegate = del;
        self.strUrl = urlStr;
        self.imgDic = dicImage;
        self.urlMethod = theMethod;
        self.urlTag = aUrlTag;
    }
    
    return self;
}

- (id)analysisData:(id)data
{
	return data;
}

- (void)start
{
    if (!imgDic) {
        //一般请求
        [self requestData];
    }else{
        //上传图片
        [self upLoadImage];
    }
    
}
//请求服务器
- (void)requestData
{
    BOOL globalTestMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"testMode"];
    if (globalTestMode) {
        if (self.testMode) {
            
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
//            [self.delegate finish:[self analysisData:[[DataManager sharedInstance] methodInstanceWith:self.urlTag]] statusMsg:nil];
            
        }else {
            
            //UPLOAD
            [self upLoadString];
        }
    }else {
        
        //UPLOAD
        [self upLoadString];
    }
    
}
//上传字符串
- (void)upLoadString
{
    self.strUrl = [self.strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.postBody = [self.postBody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.strUrl]];
    request.timeoutInterval = 20;
    
    //设置传送类型
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
    //给传输类型添加内容
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [request setHTTPBody:[self.postBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (self.urlMethod == GET) {
        [request setHTTPMethod:@"GET"];
    }else{
        [request setHTTPMethod:@"POST"];
    }
    
    self.conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.conn start];
}
//上传图片
- (void)upLoadImage
{
    self.strUrl = [self.strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:20];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    //添加分界线，换行
    [body appendString:@"\r\n"];
    NSMutableArray *aryBody = [[NSMutableArray alloc]init];
    
    for (NSString *strImageKey in [self.imgDic allKeys]) {
        NSMutableString *strBody = [[NSMutableString alloc]init];
        
        [strBody appendFormat:@"\r\n%@\r\n",MPboundary];
        //声明pic字段，文件名
        [strBody appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",@"file",strImageKey];
        //声明上传文件的格式
        [strBody appendString:@"Content-Type: multipart/form-data\r\n\r\n"];
        
        [aryBody addObject:strBody];
    }
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (int i = 0 ; i<[self.imgDic count]; i++) {
        NSString *strBody = [aryBody objectAtIndex:i];
        UIImage *imgUpload = [[self.imgDic allValues] objectAtIndex:i];
        //上传图片格式为png，可以更改为jpeg，同时需要更改文件名
        NSData *dtImg = UIImagePNGRepresentation(imgUpload);
        [myRequestData appendData:[strBody dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData appendData:dtImg];
    }
    
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    self.conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.conn start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_dtReviceData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    _dtReviceData = [[NSMutableData alloc]init];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    NSError *error;
    NSDictionary *dicRespon = [NSJSONSerialization JSONObjectWithData:_dtReviceData options:NSJSONReadingMutableLeaves error:&error];

    if ([self.delegate respondsToSelector:@selector(finish: statusMsg:)]) {

        NSString *status = [dicRespon objectForKey:@"result"];

        if([status intValue] == 1)
        {
            [self.delegate finish:[self analysisData:[dicRespon objectForKey:@"data"]] statusMsg:nil];
            [[NSUserDefaults standardUserDefaults] setObject:[dicRespon objectForKey:@"sessionKey"] forKey:@"sessionKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else if ([status intValue] == 0){
            
            NSString *statusMsg = [dicRespon objectForKey:@"msg"];
            if (!statusMsg || ![statusMsg isKindOfClass:[NSString class]] || [statusMsg isEqualToString:@""]) {
                statusMsg = @"status code error !";
            }
            [self.delegate finish:nil statusMsg:statusMsg];
        }
        else
        {
//            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [appDel logOutMethod];
//            [app logOutMethod];
            
            
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    if ([self.delegate respondsToSelector:@selector(fail:)]) {
        
        [self.delegate fail:RS_Error];
    }
}

- (void)stopConnection{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    [self.conn cancel];
}

@end
