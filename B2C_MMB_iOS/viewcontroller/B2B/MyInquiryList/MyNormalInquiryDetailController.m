//
//  MyNormalInquiryDetailController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-7.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyNormalInquiryDetailController.h"
#import "MyInquiryDetailTableViewController.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFCustomExtra.h"

@interface MyNormalInquiryDetailController ()

@end

@implementation MyNormalInquiryDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"询价单详情"];
    self.navigationItem.titleView = top;
    [self pushAndPopStyle];
    MyInquiryDetailTableViewController *tv = [self.storyboard instantiateViewControllerWithIdentifier:@"myInquiryDetailTableViewController"];
    tv.myInquiryid = [NSString stringWithFormat:@"%@",self.myInquiryid];
    tv.addressDic = [[NSDictionary alloc] initWithDictionary:self.myDic];
    tv.view.frame = self.tableBackView.bounds;
    [self addChildViewController:tv];
    self.tableBackView.backgroundColor = [UIColor whiteColor];
    [self.tableBackView addSubview:tv.view];
    
    CGFloat height = (self.topView.frame.size.height-10)/2;
    CGSize size_order;
    NSString *tempMyOrderNum = [NSString stringWithFormat:@"%@",self.myOrderNum];
    if(tempMyOrderNum.length == 0 || [tempMyOrderNum isKindOfClass:[NSNull class]])
    {
        size_order = CGSizeMake(20, height);
    }
    else
    {
        size_order = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:self.myOrderNum WithSize:CGSizeMake(MAXFLOAT, height)];
    }
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size_order.width+40, 20)];
    [orderLabel setFont:[UIFont systemFontOfSize:12]];
    [orderLabel setText:[NSString stringWithFormat:@"编号: %@",self.myOrderNum]];
    [self.topView addSubview:orderLabel];
    
    CGSize size_time;
    NSString *tempMyTime = [NSString stringWithFormat:@"%@",self.myTime];

    if([DCFCustomExtra validateString:tempMyTime] == NO)
    {
        size_time = CGSizeMake(20, height);
    }
    else
    {
        size_time = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:self.myTime WithSize:CGSizeMake(MAXFLOAT, height)];
    }
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, orderLabel.frame.origin.y+orderLabel.frame.size.height, ScreenWidth-20, 20)];
    [timeLabel setText:[NSString stringWithFormat:@"提交时间: %@",tempMyTime]];
    [timeLabel setFont:[UIFont systemFontOfSize:12]];
    [timeLabel setTextAlignment:NSTextAlignmentLeft];
    [timeLabel setTextColor:[UIColor lightGrayColor]];
    [self.topView setBackgroundColor:[UIColor whiteColor]];
    [self.topView addSubview:timeLabel];
    
    NSString *s = [NSString stringWithFormat:@"状态: %@",self.myStatus];
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderLabel.frame.origin.x+orderLabel.frame.size.width, orderLabel.frame.origin.y, ScreenWidth-20-orderLabel.frame.size.width, height)];
    [statusLabel setFont:[UIFont systemFontOfSize:12]];
    [statusLabel setTextAlignment:NSTextAlignmentRight];
    if(s.length > 4)
    {
        NSMutableAttributedString *status = [[NSMutableAttributedString alloc] initWithString:s];
        [status addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
        [status addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:134.0/255.0 green:0 blue:0 alpha:1.0] range:NSMakeRange(4, s.length-4)];
        [statusLabel setAttributedText:status];
    }
    else
    {
        [statusLabel setText:s];
    }
    [self.topView addSubview:statusLabel];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
