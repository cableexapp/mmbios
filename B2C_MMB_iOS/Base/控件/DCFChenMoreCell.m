//
//  MCMoreCell.m
//  coin
//
//  Created by duomai on 13-12-24.
//  Copyright (c) 2013年 tiny. All rights reserved.
//

#import "DCFChenMoreCell.h"
#import "MCDefine.h"

@implementation DCFChenMoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)noSearchResult
{
    [self setUserInteractionEnabled:NO];
    self.lblContent.text = @"对不起，暂无搜索结果";
    [self.avState stopAnimating];
    self.avState.hidden = YES;
}

- (void)startAnimation{
    self.avState.hidden = NO;
    self.lblContent.text = @"加载中...";
    [self.avState startAnimating];
}

- (void)stopAnimation{
    //    self.avState.frame = CGRectMake(99, 12, 20, 20);
    //    self.lblContent.frame = CGRectMake(94, 11, 132, 21);
    [self setUserInteractionEnabled:NO];
    self.lblContent.text = @"上拉加载更多";
    [self.avState stopAnimating];
    self.avState.hidden = YES;
}

- (void)awakeFromNib{
    self.avState.frame = CGRectMake(99, 12, 20, 20);
    self.lblContent.frame = CGRectMake(0, 11,320, 21);
    self.lblContent.textAlignment = NSTextAlignmentCenter;
}

- (void)failAcimation{
    self.tag = 50;
    self.lblContent.text = @"加载失败";
    [self.avState stopAnimating];
    self.avState.hidden = YES;
}

- (void) noClasses
{
    [self.lblContent setFrame:CGRectMake(self.lblContent.frame.origin.x-50, self.lblContent.frame.origin.y, self.lblContent.frame.size.width+100, self.lblContent.frame.size.height)];
    self.lblContent.text = @"没有相关数据";
    [self.avState stopAnimating];
    self.avState.hidden = YES;
}

- (void)noDataAnimation{
    self.lblContent.text = @"没有相关数据";
    [self.avState stopAnimating];
    self.avState.hidden = YES;
}

- (void) HomeImprovementGalleryOrders
{
    [self.avState stopAnimating];
    self.avState.hidden = YES;
    self.lblContent.text = @"您还没有家装馆订单哦~赶紧去选购一下吧~";
    [self.lblContent setFont:[UIFont systemFontOfSize:12]];
    [self.lblContent setFrame:CGRectMake(0, 5, self.frame.size.width, self.frame.size.height-10)];
}

- (void) noB2BInvoice
{
    self.lblContent.text = @"暂无发票信息";
    [self.avState stopAnimating];
    self.avState.hidden = YES;
}
@end
