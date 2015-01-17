//
//  ConnectionUtil.m
//  midai
//
//  Created by duomai on 13-10-21.
//  Copyright (c) 2013年 tiny. All rights reserved.
//

#import "DCFConnectionUtil.h"
#import "DCFStringUtil.h"
#import "AppDelegate.h"
#import "DCFCustomExtra.h"

//#import "ParentsSendMsgDetailViewController.h"

@implementation DCFConnectionUtil

- (id)initWithURLTag:(URLTag)theUrlTag delegate:(id<ConnectionDelegate>)theDelegate
{
    self = [super init];
    self.delegate = theDelegate;
    
    if(theUrlTag == 13 || theUrlTag == 19)
    {
        _isSpecialCharacter = YES;
    }
    else
    {
        _isSpecialCharacter = NO;
    }
    self.urlTag = theUrlTag;
    self.isShowErrorView = YES;
    return self;
}





//异步请求数据,strUrl表示域名,strPostBody表示上传的参数,theMethod表示请求方式
- (void)getResultFromUrlString:(NSString *)strUrl postBody:(NSString *)strPostBody method:(URLMethod)theMethod
{
#pragma mark - UTF8编码
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //登录
    if(self.LogIn == YES)
    {
        
    }
    //其余情况
    else
    {
        NSString *loginid = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginid"];
        if([DCFCustomExtra validateString:loginid] == NO)
        {
            loginid = @"";
        }
        strPostBody = [strPostBody stringByAppendingString:[NSString stringWithFormat:@"&loginid=%@",loginid]];
    }
    
    //    if(_isSpecialCharacter == YES)
    //    {
    //        strPostBody = [strPostBody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    //
    //        NSString *str = [NSString stringWithFormat:@"%@20%@22%@%@22,%@0A%@20%@20%@22",@"%",@"%",self.specialString,@"%",@"%",@"%",@"%",@"%"];
    //        strPostBody = [strPostBody stringByReplacingOccurrencesOfString:@"%20%22%22,%0A%20%20%22" withString:str];
    //
    //    }
    //    else if (_isSpecialCharacter == NO)
    //    {
    strPostBody = [strPostBody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    }
    
    NSString *urlStr;
    if(strPostBody.length == 0 || [strPostBody isKindOfClass:[NSNull class]] || strPostBody == nil || strPostBody == NULL)
    {
        urlStr = [NSString stringWithFormat:@"%@",strUrl];
        
    }
    else
    {
        urlStr = [NSString stringWithFormat:@"%@%@",strUrl,strPostBody];
        
    }
    NSLog(@"urlStr = %@",urlStr);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:strUrl]];
    request.timeoutInterval = 20;
    //设置传送类型
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
    //给传输类型添加内容
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    if (theMethod == GET) {
        [request setHTTPMethod:@"GET"];
    }else{
        [request setHTTPMethod:@"POST"];
    }
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    self.conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.conn start];
    
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:strUrl]];
    //    request.timeoutInterval = 20;
    //    //设置传送类型
    //    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
    //    //给传输类型添加内容
    //    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    //
    //    [request setHTTPBody:[strPostBody dataUsingEncoding:NSUTF8StringEncoding]];
    //
    //    if (theMethod == GET) {
    //        [request setHTTPMethod:@"GET"];
    //    }else{
    //        [request setHTTPMethod:@"POST"];
    //    }
    //
    //    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    //    self.conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //    [self.conn start];
}


//POST上传图片,strUrl表示服务器地址,dicText表示需要的参数,dicImage表示图片名字,strImageFileName表示上传到服务器的目录
- (void)getResultFromUrlString:(NSString *)strUrl dicText:(NSDictionary *)dicText dicImage:(NSDictionary *)dicImage imageFilename:(NSMutableArray *)strImageFileName
{
    NSString *url = strUrl;
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:20];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    for (NSString *strKey in [dicText allKeys]) {
        NSString *strValue = [dicText objectForKey:strKey];
        [body appendFormat:@"\r\n--%@\r\ncontent-disposition: form-data; name=\"%@\"\r\n\r\n%@",TWITTERFON_FORM_BOUNDARY,strKey,strValue];
    }
    
    //添加分界线，换行
    [body appendString:@"\r\n"];
    NSMutableArray *aryBody = [[NSMutableArray alloc]init];
    
    for(int i=0;i<[[dicImage allKeys] count];i++)
    {
        NSString *strImageKey = [NSString stringWithFormat:@"%@",[[dicImage allKeys] objectAtIndex:i]];
        NSMutableString *strBody = [[NSMutableString alloc]init];
        [strBody appendFormat:@"\r\n%@\r\n",MPboundary];
        
        NSString *S = [NSString stringWithFormat:@"%@",[strImageFileName objectAtIndex:i]];
        
        //声明pic字段，文件名
        [strBody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",S,strImageKey];
        //        [strBody appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",@"pic1",strImageKey];
        //声明上传文件的格式
        //        [strBody appendString:@"Content-Type: image/png\r\n\r\n"];
        [strBody appendString:@"Content-Type: multipart/form-data\r\n\r\n"];
        
        
        [aryBody addObject:strBody];
    }
    //    for (NSString *strImageKey in [dicImage allKeys]) {
    //        NSMutableString *strBody = [[NSMutableString alloc]init];
    //
    //        [strBody appendFormat:@"\r\n%@\r\n",MPboundary];
    //        //声明pic字段，文件名
    //        [strBody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",strImageFileName,strImageKey];
    //        //声明上传文件的格式
    //        [strBody appendString:@"Content-Type: multipart/form-data\r\n\r\n"];
    //
    //
    //        [aryBody addObject:strBody];
    //    }
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (int i = 0 ; i<[dicImage count]; i++) {
        NSString *strBody = [aryBody objectAtIndex:i];
        UIImage *imgUpload = [[dicImage allValues] objectAtIndex:i];
        //上传图片格式为png，可以更改为jpeg，同时需要更改文件名
        NSData *dtImg = UIImagePNGRepresentation(imgUpload);
        //        NSData *dtImg = UIImageJPEGRepresentation(imgUpload, 0.5);
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
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    self.conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.conn start];
    
    //    //建立连接，设置代理
    //    NSURLConnection *conn1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //    //设置接受response的data
    //    if (conn1) {
    //        NSURLResponse *response = 0x00;
    //        NSError *error = 0x00;
    //        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //        MDLog(@">>%@",returnString);
    //        NSDictionary *dicRespon = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:&error];
    //        MDLog(@">>%@",[dicRespon objectForKey:@"msg"]);
    //        return  [dicRespon objectForKey:@"msg"];
    //    }
    //    return @"连接失败";
    
}

//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
//    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
//        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
//    }
//}
//
//- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
//{
//    return NO;
//}

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
    NSString *resultStr = [[NSString alloc] initWithData:_dtReviceData encoding:NSUTF8StringEncoding];
    
    NSDictionary *dicRespon = [NSJSONSerialization JSONObjectWithData:_dtReviceData options:NSJSONReadingMutableLeaves error:&error];
    
    //    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    //    NSError *err;
    //    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
    //                                                        options:NSJSONReadingMutableContainers
    //                                                          error:&err];
    //
    ResultCode theResultCode = RS_Error;
    
    if (dicRespon && [[dicRespon allKeys] containsObject:@"result"]) {
        
        theResultCode = RS_Success;
    }
    int result = [[dicRespon objectForKey:@"result"] intValue];
    
    //    if(self.LogOut == YES)
    //    {
    //
    //    }
    if(result == 1)
    {
        [self.delegate resultWithDic:dicRespon urlTag:self.urlTag isSuccess:theResultCode];
    }
    else if (result == 0)
    {
        [self.delegate resultWithDic:dicRespon urlTag:self.urlTag isSuccess:theResultCode];
    }
#pragma mark - 支付宝校验
    else if(result == 2 || result == 3)
    {
        [self.delegate resultWithDic:dicRespon urlTag:self.urlTag isSuccess:theResultCode];
        
    }
    else if (result == 99)
    {
        if(self.LogOut == YES)
        {
            [self.delegate resultWithDic:dicRespon urlTag:self.urlTag isSuccess:theResultCode];
            return;
        }
        AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDel logOutMethod];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    //    if (self.isShowErrorView == YES) {
    //        [DCFStringUtil showNotice:error.localizedDescription];
    //    }
    ResultCode theResultCode = RS_Error;
    [self.delegate resultWithDic:nil urlTag:self.urlTag isSuccess:theResultCode];
    
}

- (void)stopConnection{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    [self.conn cancel];
}
@end
