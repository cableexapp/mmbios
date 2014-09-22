//
//  PhoneHelper.m
//  SmartCity
//
//  Created by wyfly on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhoneHelper.h"
#import "OpenUDID.h"
#import <sys/utsname.h>


@implementation PhoneHelper

@synthesize curNetType;

SYNTHESIZE_SINGLETON_FOR_CLASS(PhoneHelper);

-(id)init
{
	self=[super init];
    if(self){
    	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        hostReach = [[Reachability reachabilityWithHostName:@"www.baidu.com"] retain];
        [hostReach startNotifier];
        curNetType=NETWORK_3G;
    }
    
    return self;
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability *curReach = [note object];
    if (![curReach isKindOfClass:[Reachability class]]) 
        return;
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];     
    switch (netStatus) {
        case NotReachable:  //无网络
        {
            curNetType=NETWORK_NO;
            NSLog(@"%@:NotReachable",NSStringFromSelector(_cmd));
        }
            break;
        case ReachableViaWWAN:  //使用3g/gprs网络
        {
            curNetType=NETWORK_3G;
            NSLog(@"%@:ReachableViaWWAN 3g",NSStringFromSelector(_cmd));
        }
            break;
        case ReachableViaWiFi:  //使用wifi网络
        {
            curNetType=NETWORK_WIFI;
            NSLog(@"%@:ReachableViaWiFi",NSStringFromSelector(_cmd)); 
        }
            break;
        default:
            break;
    }

}

-(BOOL)isNetValiad
{
	return [hostReach isReachable];
}

///////////.....SMS.MAIL.
//+(void)showMailPicker:(id<MFMailComposeViewControllerDelegate>)delegate parent:(UIViewController*)parent text:(NSString*)text 
//{
//    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
//    
//    if (mailClass !=nil) {
//        if ([mailClass canSendMail]) {
//            [self displayMailComposerSheet:delegate parent:parent text:text];
//        }else{
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""message:@"设备不支持邮件功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//            [alert release];
//        }
//    }else{
//        
//    }
//    
//}
//
//
//+(void)displayMailComposerSheet: (id<MFMailComposeViewControllerDelegate>)delegate parent:(UIViewController*)parent text:(NSString*)text
//{
//    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//    
//    picker.mailComposeDelegate =delegate;
//    
//    [picker setSubject:@"文件分享"];
//    
//    
////    // Set up 收件人
////    NSArray *toRecipients = [NSArray arrayWithObject:@"first@qq.com"]; 
////    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@qq.com",@"third@qq.com", nil]; 
////    NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@qq.com"]; 
////    
////    
////    [picker setToRecipients:toRecipients];
////    [picker setCcRecipients:ccRecipients];
////    [picker setBccRecipients:bccRecipients];
////    
//    //发送图片附件
//    //NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
//    //NSData *myData = [NSData dataWithContentsOfFile:path];
//    //[picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy.jpg"];
//    
//    //发送txt文本附件
//    //NSString *path = [[NSBundle mainBundle] pathForResource:@"MyText" ofType:@"txt"];
//    //NSData *myData = [NSData dataWithContentsOfFile:path];
//    //[picker addAttachmentData:myData mimeType:@"text/txt" fileName:@"MyText.txt"];
//    
//    //发送doc文本附件 
//    //NSString *path = [[NSBundle mainBundle] pathForResource:@"MyText" ofType:@"doc"];
//    //NSData *myData = [NSData dataWithContentsOfFile:path];
//    //[picker addAttachmentData:myData mimeType:@"text/doc" fileName:@"MyText.doc"];
//    
//    //发送pdf文档附件
//    /*
//     NSString *path = [[NSBundlemainBundle] pathForResource:@"CodeSigningGuide"ofType:@"pdf"];
//     NSData *myData = [NSDatadataWithContentsOfFile:path];
//     [pickeraddAttachmentData:myData mimeType:@"file/pdf"fileName:@"rainy.pdf"];
//     */
//    
//    
//    // Fill out the email body text
//    [picker setMessageBody:text isHTML:NO];
//    
//    [(UIViewController*)parent presentModalViewController:picker animated:YES];
//    [picker release];
//}




////短信
//+(void)showSMSPicker:(id)delegate parent:(UIViewController*)parent text:(NSString*)text
//{
//    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
//    
//    if (messageClass != nil) { 
//        // Check whether the current device is configured for sending SMS messages
//        if ([messageClass canSendText]) {
//            [self displaySMSComposerSheet:delegate parent:parent text:text];
//        }
//        else {
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""message:@"设备不支持短信功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//            [alert release];
//            
//        }
//    }
//    else {
//    }
//}
//
//
//+(void)displaySMSComposerSheet:(id)delegate parent:(UIViewController*)parent text:(NSString*)text
//{
//    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
//    picker.messageComposeDelegate =delegate;
//    picker.body=text;
//    [(UIViewController*)parent presentModalViewController:picker animated:YES];
//    [picker release];
//}

+(NSString*)getDeviceId
{
	return [OpenUDID value];
}

/*
 *  获取版本型号
 *  "i386"          simulator
 *  "iPod1,1"       iPod Touch
 *  "iPhone1,1"     iPhone
 *  "iPhone1,2"     iPhone 3G
 *  "iPhone2,1"     iPhone 3GS
 *  "iPad1,1"       iPad
 *  "iPhone3,1"     iPhone 4
 *  "iPhone4,1"     iPhone 4s
 *  "iPhone5,2"     iPhone 5
 */
+ (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}


+(NSString*)getSysTemVer
{
	NSString* ver;
    ver=[NSString stringWithFormat:@"ios%@",[UIDevice currentDevice].systemVersion];
    return ver;
}

@end
