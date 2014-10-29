//
//  HostSection1TableViewCell.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-21.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "HostSection1TableViewCell.h"

@implementation HostSection1TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
    btnArray = [[NSArray alloc] initWithObjects:self.askBtn,self.chooseCabelBtn,self.B2CEntranceBtn,self.hotBtn,self.hotKindBtn,self.choosePlaceBtn,self.onLineBtn,self.telServiceBtn, nil];
    for(int i=0;i<btnArray.count;i++)
    {
        UIButton *btn = [btnArray objectAtIndex:i];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.frame.size.height, 0, 0, 0)];
        [btn setTag:i];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake((btn.frame.size.width-50)/2, 5, 50, 50)];
        NSLog(@"%f %f %f",btn.frame.origin.y,btn.frame.size.height,btn.frame.size.width);
        switch (i) {
            case 0:
                [iv setImage:[UIImage imageNamed:@"快速查询.png"]];
                break;
            case 1:
                [iv setImage:[UIImage imageNamed:@"电缆选购.png"]];
                break;
            case 2:
                [iv setImage:[UIImage imageNamed:@"家装线专卖.png"]];
                break;
            case 3:
                [iv setImage:[UIImage imageNamed:@"热门型号.png"]];
                break;
            case 4:
                [iv setImage:[UIImage imageNamed:@"热门分类.png"]];
                break;
            case 5:
                [iv setImage:[UIImage imageNamed:@"场合选择.png"]];
                break;
            case 6:
                [iv setImage:[UIImage imageNamed:@"在线客服.png"]];
                break;
            case 7:
                [iv setImage:[UIImage imageNamed:@"电话服务.png"]];
                break;

            default:
                break;
        }
        [btn addSubview:iv];
    }
}

- (void) btnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    [self.delegate HostSection1BtnClick:btn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
