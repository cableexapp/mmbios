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
{
    NSDictionary *myDic;
    NSString *fullAddress;
    NSString *inquiryserial;
    NSString *inquiryid;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
//    [self.navigationController.tabBarController.tabBar setHidden:YES];
    
    [self pushAndPopStyle];
    
    self.againAskBtn.layer.cornerRadius = 5;
    self.againAskBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
    
    self.lookBtn.layer.cornerRadius = 5;
    self.lookBtn.backgroundColor = [UIColor colorWithRed:19/255.0 green:90/255.0 blue:168/255.0 alpha:1.0];
   
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"我的快速询价单"];
    self.navigationItem.titleView = top;
    
    [self.orderLabel setText:[NSString stringWithFormat:@"询价单号:%@",self.fastData.oemId]];
    
    [self.statusLabel setText:[NSString stringWithFormat:@"状态:%@",self.fastData.status]];
    [self.statusLabel setTextAlignment:NSTextAlignmentRight];
    
    [self.upTimeLabel setText:[NSString stringWithFormat:@"%@",self.fastData.myTime]];
    [self.telLabel setText:[NSString stringWithFormat:@"%@",self.fastData.phone]];
    [self.linkManLabel setText:[NSString stringWithFormat:@"%@",self.fastData.linkman]];
    
    
    UILabel *requestLabel = [[UILabel alloc] init];
    NSString *request = [NSString stringWithFormat:@"%@",self.fastData.remark];
    if(request.length == 0 || [request isKindOfClass:[NSNull class]])
    {
        [self.requestFirstLabel setFrame:CGRectMake(self.requestFirstLabel.frame.origin.x, self.requestFirstLabel.frame.origin.y, self.requestFirstLabel.frame.size.width, 0)];
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
    
    UILabel *picTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, requestLabel.frame.origin.y+requestLabel.frame.size.height+5, ScreenWidth-20, 30)];
    [picTitleLabel setText:@"已传照片:"];
    [self.sv addSubview:picTitleLabel];
    
    UIImageView *iv = [[UIImageView alloc] init];
    NSString *filePath = [NSString stringWithFormat:@"%@",[self.fastData filePath]];
    if(filePath.length == 0 || [filePath isKindOfClass:[NSNull class]])
    {
        [picTitleLabel setFrame:CGRectMake(picTitleLabel.frame.origin.x, picTitleLabel.frame.origin.y, picTitleLabel.frame.size.width, 0)];
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
        [situationLabel setText:@"处理情况: 暂无处理情况哦~"];
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
        self.againAskBtn.frame = CGRectMake(15, 9, ScreenWidth-30, 40);
        [self.lookBtn setHidden:YES];
        
    }
    else
    {
        [self.lookBtn setHidden:NO];
    }
    
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *s = [NSString stringWithFormat:@"%@%@",@"getInquiryInfo",time];
    NSString *token = [DCFCustomExtra md5:s];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&inquiryid=%@",token,[self.fastData inquiryId]];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetInquiryInfoTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/getInquiryInfo.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
//    int result = [[dicRespon objectForKey:@"result"] intValue];
    if(URLTag == URLGetInquiryInfoTag)
    {
        if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            myDic = [[NSDictionary alloc] init];
        }
        else
        {
            NSArray *ctems = [NSArray arrayWithArray:[dicRespon objectForKey:@"ctems"]];
            if(ctems.count == 0 || [ctems isKindOfClass:[NSNull class]])
            {
                myDic = [[NSDictionary alloc] init];
            }
            else
            {
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[ctems lastObject]];
                if([[dic allKeys] count] == 0 || [dic isKindOfClass:[NSNull class]])
                {
                    myDic = [[NSDictionary alloc] init];
                }
                else
                {
                    fullAddress = [NSString stringWithFormat:@"%@%@%@%@",[dic objectForKey:@"province"],[dic objectForKey:@"city"],[dic objectForKey:@"district"],[dic objectForKey:@"address"]];
                    NSLog(@"fullAddress = %@",fullAddress);
                    NSString *tel = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"联系电话:%@",self.fastData.phone]];
                    NSString *name = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"联系人:%@",self.fastData.linkman]];
                    myDic = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",tel,@"tel",fullAddress,@"fullAddress", nil];
                    
                    inquiryserial = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquiryserial"]];
                    
                    inquiryid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquiryid"]];
                    
                    [self.orderLabel setText:[NSString stringWithFormat:@"询价单号:%@",inquiryserial]];

                }
            }
        }
    }
}

- (void) ivTap:(UITapGestureRecognizer *) sender
{
    NSLog(@"ivTap");
}

- (IBAction)againAskBtnClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    SpeedAskPriceFirstViewController *speedAskPriceFirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"speedAskPriceFirstViewController"];
    [self.navigationController pushViewController:speedAskPriceFirstViewController animated:YES];
}

- (IBAction)lookBtnClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    MyNormalInquiryDetailController *myNormalInquiryDetailController = [self.storyboard instantiateViewControllerWithIdentifier:@"myNormalInquiryDetailController"];
    
#pragma mark - 这里暂时用oemid替换inquirId
    myNormalInquiryDetailController.myOrderNum = inquiryserial;
    
    
    NSString *status = [NSString stringWithFormat:@"%@",[self.fastData status]];
    myNormalInquiryDetailController.myStatus = status;
    
    
    NSString *upTime = [self.fastData myTime];
    myNormalInquiryDetailController.myTime = upTime;
    
    
    myNormalInquiryDetailController.myInquiryid = inquiryid;
    
    myNormalInquiryDetailController.myDic = [NSDictionary dictionaryWithDictionary:myDic];
    
    [self.navigationController pushViewController:myNormalInquiryDetailController animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
