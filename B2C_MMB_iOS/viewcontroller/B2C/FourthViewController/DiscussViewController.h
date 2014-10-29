//
//  DiscussViewController.h
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-14.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface DiscussViewController : UIViewController<ConnectionDelegate,UITextViewDelegate>
{
    DCFConnectionUtil *conn;
}
@property (strong,nonatomic) NSMutableArray *itemArray;
@property (strong,nonatomic) NSString *shopId;

@property (strong,nonatomic) NSString *orderNum;
@property (strong,nonatomic) NSDictionary *subDateDic;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;

@property (weak, nonatomic) IBOutlet UIButton *descriptionBtn_1;
@property (weak, nonatomic) IBOutlet UIButton *descriptionBtn_2;
@property (weak, nonatomic) IBOutlet UIButton *descriptionBtn_3;
@property (weak, nonatomic) IBOutlet UIButton *descriptionBtn_4;
@property (weak, nonatomic) IBOutlet UIButton *descriptionBtn_5;
@property (weak, nonatomic) IBOutlet UILabel *descriptionBtn_label;

@property (weak, nonatomic) IBOutlet UIButton *attibuteBtn_1;
@property (weak, nonatomic) IBOutlet UIButton *attibuteBtn_2;
@property (weak, nonatomic) IBOutlet UIButton *attibuteBtn_3;
@property (weak, nonatomic) IBOutlet UIButton *attibuteBtn_4;
@property (weak, nonatomic) IBOutlet UIButton *attibuteBtn_5;
@property (weak, nonatomic) IBOutlet UILabel *attibuteBtn_label;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn_1;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn_2;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn_3;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn_4;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn_5;
@property (weak, nonatomic) IBOutlet UILabel *sendBtn_label;

@property (weak, nonatomic) IBOutlet UIButton *tradeBtn_1;
@property (weak, nonatomic) IBOutlet UIButton *tradeBtn_2;
@property (weak, nonatomic) IBOutlet UIButton *tradeBtn_3;
@property (weak, nonatomic) IBOutlet UIButton *tradeBtn_4;
@property (weak, nonatomic) IBOutlet UIButton *tradeBtn_5;
@property (weak, nonatomic) IBOutlet UILabel *tradeBtn_label;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *showOrHideBtn;

@end
