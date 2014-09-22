//
//  PhoneHelper.h
//  SmartCity
//
//  Created by wyfly on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "Contact.h"
#import "SynthesizeSingleton.h"
//#import <MessageUI/MessageUI.h>
//#import <MessageUI/MFMailComposeViewController.h>

@interface PhoneHelper : NSObject
{
	Reachability* hostReach;
    
}

@property(nonatomic,readonly)int curNetType;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(PhoneHelper);

-(BOOL)isNetValiad;
//发送短信
//+(void)showSMSPicker:(id)delegate parent:(UIViewController*)parent text:(NSString*)text;
////发送邮件
//+(void)showMailPicker:(id<MFMailComposeViewControllerDelegate>)delegate parent:(UIViewController*)parent text:(NSString*)text ;
+(NSString*)getDeviceId;
+ (NSString*)deviceString;
+(NSString*)getSysTemVer;
@end
