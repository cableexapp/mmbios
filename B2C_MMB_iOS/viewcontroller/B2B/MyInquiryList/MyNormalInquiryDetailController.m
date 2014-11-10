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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"询价单详情"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    MyInquiryDetailTableViewController *tv = [self.storyboard instantiateViewControllerWithIdentifier:@"myInquiryDetailTableViewController"];
    tv.myInquiryid = self.myInquiryid;
    tv.addressDic = [[NSDictionary alloc] initWithDictionary:self.myDic];
    tv.view.frame = self.tableBackView.bounds;
    [self addChildViewController:tv];
    [self.tableBackView addSubview:tv.view];
    
    CGSize size_order;
    if(self.myOrderNum.length == 0 || [self.myOrderNum isKindOfClass:[NSNull class]])
    {
        size_order = CGSizeMake(20, 20);
    }
    else
    {
        size_order = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:self.myOrderNum WithSize:CGSizeMake(MAXFLOAT, 20)];
    }
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size_order.width+40, 20)];
    [orderLabel setFont:[UIFont systemFontOfSize:12]];
    [orderLabel setText:[NSString stringWithFormat:@"编号:%@",self.myOrderNum]];
    [self.topView addSubview:orderLabel];
    
    CGSize size_time;
    if(self.myTime.length == 0 || [self.myTime isKindOfClass:[NSNull class]])
    {
        size_time = CGSizeMake(20, 20);
    }
    else
    {
        size_time = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:self.myTime WithSize:CGSizeMake(MAXFLOAT, 20)];
    }
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-size_time.width-40, 5, size_time.width+40, 20)];
    [timeLabel setText:self.myTime];
    [timeLabel setFont:[UIFont systemFontOfSize:12]];
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    [timeLabel setTextColor:[UIColor lightGrayColor]];
    [self.topView addSubview:timeLabel];
    
    NSString *s = [NSString stringWithFormat:@"状态: %@",self.myStatus];
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, ScreenWidth-20, 20)];
    [statusLabel setFont:[UIFont systemFontOfSize:12]];
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
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end