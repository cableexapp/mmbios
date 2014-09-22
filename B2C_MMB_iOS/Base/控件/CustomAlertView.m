//
//  CustomAlertView.m
//  SmartCity
//
//  Created by wyfly on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomAlertView.h"
#import <QuartzCore/CAAnimation.h>

@implementation CustomAlertView

@synthesize mMsg;

SYNTHESIZE_SINGLETON_FOR_CLASS(CustomAlertView);

-(void)dismisMsgBox
{
	if(msgBox) [msgBox dismissWithClickedButtonIndex:0 animated:YES];
    msgBox=nil;
    [self release];
}


//alert delegate
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if(alertView.tag==345){
        
        UIView* wiatView;
        int viewW = 20;
        int viewH=50;
        if(mMsg && mMsg.length>0){
            viewH=80;
            viewW = [mMsg sizeWithFont:[UIFont fontWithName:@"Arial" size:16]].width;
        }
        
        wiatView = [[UIView alloc] initWithFrame:CGRectMake((alertView.frame.size.width-viewW-30)/2, (alertView.frame.size.height/2)-40, viewW+30, viewH)];
        [wiatView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [wiatView layer].cornerRadius = 3;
        [wiatView layer].masksToBounds = YES;
        
        if(mMsg && mMsg.length>0){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, viewW, 30)];
            [label setText:mMsg];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            [label setFont:[UIFont fontWithName:@"Arial" size:16]];
            label.textAlignment = NSTextAlignmentCenter;
            [wiatView addSubview:label];
            [label release];
        }
        
        UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //aiv.frame = CGRectMake(14, ([wiatView frame].size.height-aiv.frame.size.height)/2,aiv.frame.size.width, aiv.frame.size.height);
        aiv.center=CGPointMake((viewW+30)/2, 25);
        [aiv startAnimating];
        [wiatView addSubview:aiv];
        [aiv release];

        for (UIView* v in alertView.subviews) {
            if([v isKindOfClass:[UIImageView class]])
                [v setHidden:YES];
        }
        [alertView addSubview:wiatView];
        [wiatView release];
    }
}



- (void)showMsgBoxWithTitle:(NSString*)title message:(NSString*)msg delegate:(id)del 
          cancelButtonTitle:(NSString*)cancelBtnTitle otherButtonTitles:(NSString*)other type:(MSG_BOX_TYPE)type
{
    if(msgBox) [msgBox dismissWithClickedButtonIndex:0 animated:YES];
    msgBox=nil;
    
    switch (type) {
        case MSG_BOX_INFO:
        {
            msgBox = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"\n%@\n",title!=nil?title:@""] message:msg delegate:del cancelButtonTitle:nil otherButtonTitles:nil];  
            [msgBox show];

            [self performSelector:@selector(dismisMsgBox) withObject:nil afterDelay:3.0];
        }    
            break;
        case MSG_BOX_WAIT:
        {            			
            msgBox = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            msgBox.tag=345;
            self.mMsg=msg;
            msgBox.userInteractionEnabled=NO;
            [msgBox show];
            
            
        }    
            break;
        case MSG_BOX_CONFIRM:
        {
            msgBox = [[UIAlertView alloc] initWithTitle:title message:msg delegate:del cancelButtonTitle:cancelBtnTitle otherButtonTitles:other,nil];
            [msgBox show];
            [msgBox release];
            msgBox=nil;
        }    
            break;
        default:
            return;
    }
    
}


@end
