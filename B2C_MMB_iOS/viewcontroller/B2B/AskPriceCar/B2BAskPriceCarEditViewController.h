//
//  B2BAskPriceCarEditViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-5.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFPickerView.h"
#import "DCFConnectionUtil.h"

@protocol RemoveSubView <NSObject>

- (void) removeSubView;
- (void) reloadData;

@end

@interface B2BAskPriceCarEditViewController : UIViewController<PickerView,UITextFieldDelegate,ConnectionDelegate,UITextViewDelegate>
{
    DCFConnectionUtil *conn;
}
@property (strong,nonatomic) NSString *myModel;
@property (strong,nonatomic) NSString *myCartId;

@property (assign,nonatomic) float width;
@property (assign,nonatomic) float height;

@property (weak, nonatomic) IBOutlet UILabel *modelLabel;

@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;
@property (weak, nonatomic) IBOutlet UILabel *requestLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIButton *unitBtn;
@property (weak, nonatomic) IBOutlet UIButton *specBtn;
@property (weak, nonatomic) IBOutlet UIButton *volBtn;
@property (weak, nonatomic) IBOutlet UIButton *colorBtn;
@property (weak, nonatomic) IBOutlet UIButton *featherBtn;


@property (weak, nonatomic) IBOutlet UITextView *requestTF;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@property (assign,nonatomic) id<RemoveSubView> delegate;
@end



