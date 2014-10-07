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
#import "DCFConnectionUtil.h"

@interface AddReceiveFinalViewController : UIViewController<UITextFieldDelegate,ConnectionDelegate>
{
    NSString *chooseProvince;   //省
    NSString *chooseCity;             //市
    NSString *chooseAddress;     //区和街道
    NSString *chooseAddressName;  //具体地址
    
    NSString *chooseCode;
    
    DCFConnectionUtil *conn;
    
    BOOL isEditOrAdd;   //判断是编辑还是新增地址,为0表示编辑，为1表示新增
}
//@property (strong,nonatomic) NSDictionary *myDic;
@property (strong,nonatomic) NSString *provinceAndCityAndStreet;

@property (strong,nonatomic) NSDictionary *msgDic;

//用于新增地址
- (id) initWithAddress:(NSString *) address WithCode:(NSString *) code WithSwithStatus:(BOOL) status;

//用于编辑地址
- (id) initWithMsgDic:(NSDictionary *) dic;

@end
