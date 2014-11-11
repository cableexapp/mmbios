//
//  MyFastInquiryOrder.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-10.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyFastInquiryOrder.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "SpeedAskPriceFirstViewController.h"
#import "UIImageView+WebCache.h"
#import "MyNormalInquiryDetailController.h"

@implementation MyFastInquiryOrder

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"我的快速询价单"];
    self.navigationItem.titleView = top;
    
    [self.orderLabel setText:[NSString stringWithFormat:@"询价单号:%@",self.fastData.oemId]];
    [self.statusLabel setText:[NSString stringWithFormat:@"状态:%@",self.fastData.status]];
    
    [self.upTimeLabel setText:[NSString stringWithFormat:@"提交时间:%@",self.fastData.myTime]];
    [self.telLabel setText:[NSString stringWithFormat:@"联系电话:%@",self.fastData.phone]];
    [self.linkManLabel setText:[NSString stringWithFormat:@"联系人:%@",self.fastData.linkman]];
    
    
    UILabel *requestLabel = [[UILabel alloc] init];
    NSString *request = [NSString stringWithFormat:@"%@",self.fastData.remark];
    if(request.length == 0 || [request isKindOfClass:[NSNull class]])
    {
        [requestLabel setFrame:CGRectMake(10, self.requestFirstLabel.frame.origin.y+self.requestFirstLabel.frame.size.height-20, ScreenWidth-20, 0)];
    }
    else
    {
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:request WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
        if(size.height <= 30)
        {
            [requestLabel setFrame:CGRectMake(10, self.requestFirstLabel.frame.origin.y+self.requestFirstLabel.frame.size.height-20, ScreenWidth-20, 30)];
        }
        else
        {
            [requestLabel setFrame:CGRectMake(10, self.requestFirstLabel.frame.origin.y+self.requestFirstLabel.frame.size.height-20, ScreenWidth-20, size.height)];
        }
    }
    [requestLabel setText:request];
    [requestLabel setFont:[UIFont systemFontOfSize:14]];
    [requestLabel setNumberOfLines:0];
    [self.sv addSubview:requestLabel];
    
    UILabel *picTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, requestLabel.frame.origin.y+requestLabel.frame.size.height, ScreenWidth-20, 30)];
    [picTitleLabel setText:@"已传照片:"];
    [self.sv addSubview:picTitleLabel];
    
    UIImageView *iv = [[UIImageView alloc] init];
    NSString *filePath = [NSString stringWithFormat:@"%@",[self.fastData filePath]];
    if(filePath.length == 0 || [filePath isKindOfClass:[NSNull class]])
    {
        [iv setFrame:CGRectMake(10, picTitleLabel.frame.origin.y+picTitleLabel.frame.size.height+10, 60, 0)];
    }
    else
    {
        [iv setFrame:CGRectMake(10, picTitleLabel.frame.origin.y+picTitleLabel.frame.size.height+10, 60, 60)];
        [iv setImageWithURL:[NSURL URLWithString:filePath]];
        [iv setUserInteractionEnabled:YES];
        UITapGestureRecognizer *ivTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ivTap:)];
        [iv addGestureRecognizer:ivTap];
    }
    [self.sv addSubview:iv];

    UILabel *situationLabel = [[UILabel alloc] init];
    NSString *string = [NSString stringWithFormat:@"%@",self.fastData.operatior];
    NSString *situation = [NSString stringWithFormat:@"处理情况: %@",string];
    [situationLabel setText:situation];
    if(string.length == 0 || [string isKindOfClass:[NSNull class]])
    {
        [situationLabel setFrame:CGRectMake(10, iv.frame.origin.y+iv.frame.size.height+10, ScreenWidth-20, 30)];
    }
    else
    {
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:situation WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
        [situationLabel setFrame:CGRectMake(10, iv.frame.origin.y+iv.frame.size.height+10, ScreenWidth-20, size.height)];
    }
    [situationLabel setFont:[UIFont systemFontOfSize:14]];
    [situationLabel setNumberOfLines:0];
    [self.sv addSubview:situationLabel];
    
    [self.sv setContentSize:CGSizeMake(ScreenWidth, situationLabel.frame.origin.y+situationLabel.frame.size.height+20)];
    [self.sv setUserInteractionEnabled:YES];
    
    int inquiryId = [[self.fastData inquiryId] intValue];
    if(inquiryId == 0)
    {
        [self.lookBtn setEnabled:NO];
    }
    else
    {
        [self.lookBtn setEnabled:YES];
    }
}

- (void) ivTap:(UITapGestureRecognizer *) sender
{
    NSLog(@"ivTap");
}

- (IBAction)againAskBtnClick:(id)sender
{
    SpeedAskPriceFirstViewController *speedAskPriceFirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"speedAskPriceFirstViewController"];
    [self.navigationController pushViewController:speedAskPriceFirstViewController animated:YES];
}

- (IBAction)lookBtnClick:(id)sender
{
    NSLog(@"lookBtnClick");
    
    MyNormalInquiryDetailController *myNormalInquiryDetailController = [self.storyboard instantiateViewControllerWithIdentifier:@"myNormalInquiryDetailController"];
    
    NSString *orderNum = [NSString stringWithFormat:@"%@",[self.fastData oemId]];
    myNormalInquiryDetailController.myOrderNum = orderNum;
    
    
    NSString *status = [NSString stringWithFormat:@"%@",[self.fastData status]];
    myNormalInquiryDetailController.myStatus = status;
    
    
    NSString *upTime = [self.fastData myTime];
    myNormalInquiryDetailController.myTime = upTime;
    
    
    NSString *Inquiryid = [self.fastData inquiryId];
    myNormalInquiryDetailController.myInquiryid = Inquiryid;
    
//    NSDictionary *dic = [self.fastData pushDic];
//    myNormalInquiryDetailController.myDic = [NSDictionary dictionaryWithDictionary:dic];
    
    [self.navigationController pushViewController:myNormalInquiryDetailController animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
