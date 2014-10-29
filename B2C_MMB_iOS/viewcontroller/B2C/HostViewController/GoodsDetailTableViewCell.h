//
//  GoodsDetailTableViewCell.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-22.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *barndLabel;
@property (weak, nonatomic) IBOutlet UILabel *kindLabel;
@property (weak, nonatomic) IBOutlet UILabel *voltageLabel;  //电压
@property (weak, nonatomic) IBOutlet UILabel *surfaceLabel;   //横截面
@property (weak, nonatomic) IBOutlet UILabel *useLabel;
@property (weak, nonatomic) IBOutlet UILabel *threadLabel;  //芯线
@property (weak, nonatomic) IBOutlet UILabel *standLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel; //单位
@property (weak, nonatomic) IBOutlet UILabel *thicknessLabel;  //厚度
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@end
