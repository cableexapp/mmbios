//
//  AddReceiveFinalViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-25.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "DCFMyTextField.h"

@interface AddReceiveFinalViewController : UIViewController<UITextFieldDelegate>
{
}
//@property (strong,nonatomic) NSDictionary *myDic;
@property (strong,nonatomic) NSString *provinceAndCityAndStreet;

- (id) initWithAddress:(NSString *) address;

@end