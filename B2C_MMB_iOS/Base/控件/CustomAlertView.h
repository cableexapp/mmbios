//
//  CustomAlertView.h
//  SmartCity
//
//  Created by wyfly on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

typedef enum{
    MSG_BOX_INFO,//auto dismis
    MSG_BOX_WAIT,
    MSG_BOX_CONFIRM  //user dismis
}MSG_BOX_TYPE;


@interface CustomAlertView : NSObject<UIAlertViewDelegate>
{
	UIAlertView* msgBox;
}

@property(nonatomic,copy)NSString* mMsg;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(CustomAlertView);

-(void)dismisMsgBox;

- (void)showMsgBoxWithTitle:(NSString*)title message:(NSString*)msg delegate:(id)del 
          cancelButtonTitle:(NSString*)cancelBtnTitle otherButtonTitles:(NSString*)other type:(MSG_BOX_TYPE)type;

@end
