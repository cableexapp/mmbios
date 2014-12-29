//
//  MyNormalInquiryDetailController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-7.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyNormalInquiryDetailController.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFCustomExtra.h"

@interface MyNormalInquiryDetailController ()
{
    UILabel *orderLabel;
    UILabel *statusLabel;
    NSString *theStatus;
    MyInquiryDetailTableViewController *tv;
    NSString *notistr;
}
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

- (void) ChangeStatusDelegate:(NSArray *)array
{
    NSString *orderNum = [array objectAtIndex:0];
    theStatus = [array objectAtIndex:1];
    
    [orderLabel setText:[NSString stringWithFormat:@"编号: %@",orderNum]];

    NSString *s = [NSString stringWithFormat:@"状态: %@",theStatus];
    if(s.length > 4)
    {
        NSMutableAttributedString *status = [[NSMutableAttributedString alloc] initWithString:s];
        [status addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
        [status addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:134.0/255.0 green:0 blue:0 alpha:1.0] range:NSMakeRange(3, s.length-3)];
        [statusLabel setAttributedText:status];
    }
    else
    {
        [statusLabel setText:s];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"询价单详情"];
    self.navigationItem.titleView = top;
    [self pushAndPopStyle];
    
    
    tv = [self.storyboard instantiateViewControllerWithIdentifier:@"myInquiryDetailTableViewController"];
    tv.delegate = self;
    tv.myInquiryid = [NSString stringWithFormat:@"%@",self.myInquiryid];
    tv.addressDic = [[NSDictionary alloc] initWithDictionary:self.myDic];
    tv.view.frame = self.tableBackView.bounds;
    [self addChildViewController:tv];
    self.tableBackView.backgroundColor = [UIColor whiteColor];
    [self.tableBackView addSubview:tv.view];
    
    CGFloat height = (self.topView.frame.size.height-10)/2;
    CGSize size_order;
    NSString *tempMyOrderNum = [NSString stringWithFormat:@"%@",self.myOrderNum];
    if([DCFCustomExtra validateString:tempMyOrderNum] == NO)
    {
        size_order = CGSizeMake(20, height);
    }
    else
    {
        size_order = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:self.myOrderNum WithSize:CGSizeMake(MAXFLOAT, height)];
    }
    orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size_order.width+40, 20)];
    [orderLabel setFont:[UIFont systemFontOfSize:12]];
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
    
    statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderLabel.frame.origin.x+orderLabel.frame.size.width, orderLabel.frame.origin.y, ScreenWidth-20-orderLabel.frame.size.width, height)];
    [statusLabel setFont:[UIFont systemFontOfSize:12]];
    [statusLabel setTextAlignment:NSTextAlignmentRight];

    [self.topView addSubview:statusLabel];


    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doOrderNumber:) name:@"doOrdernum" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"doOrdernum" object:ordernum];
}

- (void) doOrderNumber:(NSNotification *) noti
{
    notistr = (NSString *)[noti object];
    if([DCFCustomExtra validateString:notistr] == NO)
    {
        [self.buttomView setFrame:CGRectMake(self.buttomView.frame.origin.x, self.buttomView.frame.origin.y, ScreenWidth, 0)];
        [self.tableBackView setFrame:CGRectMake(0, self.tableBackView.frame.origin.y, ScreenWidth, MainScreenHeight-64-self.topView.frame.size.height)];
    }
    else
    {
        [self.buttomView setFrame:CGRectMake(self.buttomView.frame.origin.x, self.buttomView.frame.origin.y, ScreenWidth, self.buttomView.frame.size.height)];
        [self.tableBackView setFrame:CGRectMake(0, self.tableBackView.frame.origin.y, ScreenWidth, MainScreenHeight-64-self.topView.frame.size.height-self.buttomView.frame.size.height)];
        
        UIButton *buttomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buttomBtn.layer.cornerRadius = 5.0f;
        buttomBtn.layer.borderWidth = 1.0f;
        buttomBtn.layer.borderColor = [UIColor colorWithRed:235.0/255.0 green:141.0/255.0 blue:6.0/255.0 alpha:1.0].CGColor;
        [buttomBtn setTitle:@"查看对应订单" forState:UIControlStateNormal];
        [buttomBtn setFrame:CGRectMake(20, 5, self.buttomView.frame.size.width-40, self.buttomView.frame.size.height-10)];
        [buttomBtn addTarget:self action:@selector(buttomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttomView addSubview:buttomBtn];
    }
    tv.view.frame = self.tableBackView.bounds;
}

- (void) buttomBtnClick:(UIButton *) sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
