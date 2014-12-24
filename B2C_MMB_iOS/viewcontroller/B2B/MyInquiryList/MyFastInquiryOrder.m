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
    UILabel *situationLabel;
    
    NSString *oemNo;
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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.sv setBackgroundColor:[UIColor whiteColor]];
    
    self.againAskBtn.layer.cornerRadius = 5;
    self.againAskBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
    
    self.lookBtn.layer.cornerRadius = 5;
    self.lookBtn.backgroundColor = [UIColor colorWithRed:19/255.0 green:90/255.0 blue:168/255.0 alpha:1.0];
   
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"快速询价单详情"];
    self.navigationItem.titleView = top;
    
    [self.orderLabel setFrame:CGRectMake(self.orderLabel.frame.origin.x, self.orderLabel.frame.origin.y, ScreenWidth-100, self.orderLabel.frame.size.height)];
    if([DCFCustomExtra validateString:self.fastData.oemNo] == NO)
    {
        oemNo = @"";
    }
    else
    {
        oemNo = self.fastData.oemNo;
    }
    [self.orderLabel setText:[NSString stringWithFormat:@"询价单号:%@",oemNo]];
    
    [self.statusLabel setText:[NSString stringWithFormat:@"状态:%@",self.fastData.status]];
    [self.statusLabel setTextAlignment:NSTextAlignmentRight];
    
    NSString *mytime = [NSString stringWithFormat:@"提交时间: %@",self.fastData.myTime];
    if([DCFCustomExtra validateString:self.fastData.myTime] == NO)
    {
        [self.upTimeLabel setFrame:CGRectMake(10, 0, ScreenWidth-20, 0)];
    }
    else
    {
        [self.upTimeLabel setFrame:CGRectMake(10, 0, ScreenWidth-20, self.upTimeLabel.frame.size.height)];
        NSMutableAttributedString *myTime = [[NSMutableAttributedString alloc] initWithString:mytime];
        [myTime addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
        [myTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, mytime.length-5)];
        [self.upTimeLabel setAttributedText:myTime];
    }

    NSString *myphone = [NSString stringWithFormat:@"联系电话: %@",self.fastData.phone];
    if([DCFCustomExtra validateString:self.fastData.phone] == NO)
    {
        [self.telLabel setFrame:CGRectMake(10, self.upTimeLabel.frame.origin.y+self.upTimeLabel.frame.size.height, ScreenWidth-20, 0)];
    }
    else
    {
        [self.telLabel setFrame:CGRectMake(10, self.upTimeLabel.frame.origin.y+self.upTimeLabel.frame.size.height, ScreenWidth-20, self.telLabel.frame.size.height)];
        NSMutableAttributedString *myPhone = [[NSMutableAttributedString alloc] initWithString:myphone];
        [myPhone addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
        [myPhone addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, myphone.length-5)];
        [self.telLabel setAttributedText:myPhone];
    }
    
    NSString *myman = [NSString stringWithFormat:@"联系人: %@",self.fastData.linkman];
    if([DCFCustomExtra validateString:self.fastData.linkman] == NO)
    {
        [self.linkManLabel setFrame:CGRectMake(10, self.telLabel.frame.origin.y+self.telLabel.frame.size.height, ScreenWidth-20, 0)];
    }
    else
    {
        [self.linkManLabel setFrame:CGRectMake(10, self.telLabel.frame.origin.y+self.telLabel.frame.size.height, ScreenWidth-20, self.linkManLabel.frame.size.height)];
        NSMutableAttributedString *myMan = [[NSMutableAttributedString alloc] initWithString:myman];
        [myMan addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
        [myMan addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(4, myman.length-4)];
        [self.linkManLabel setAttributedText:myMan];
    }
    
    
    
    UILabel *requestLabel = [[UILabel alloc] init];
    NSString *request = [NSString stringWithFormat:@"%@",self.fastData.content];
    if([DCFCustomExtra validateString:request] == NO)
    {
        [self.requestFirstLabel setFrame:CGRectMake(10, self.linkManLabel.frame.origin.y, self.linkManLabel.frame.size.width, 0)];
        [requestLabel setFrame:CGRectMake(10, self.requestFirstLabel.frame.origin.y+self.requestFirstLabel.frame.size.height, ScreenWidth-20, 0)];
    }
    else
    {
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:request WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
        [self.requestFirstLabel setFrame:CGRectMake(10, self.linkManLabel.frame.origin.y, self.linkManLabel.frame.size.width, self.requestFirstLabel.frame.size.height)];
        if(size.height <= 30)
        {
            [requestLabel setFrame:CGRectMake(10, self.requestFirstLabel.frame.origin.y+self.requestFirstLabel.frame.size.height, ScreenWidth-20, 30)];
        }
        else
        {
            [requestLabel setFrame:CGRectMake(10, self.requestFirstLabel.frame.origin.y+self.requestFirstLabel.frame.size.height, ScreenWidth-20, size.height)];
        }
    }
    [requestLabel setText:request];
    [requestLabel setFont:[UIFont systemFontOfSize:14]];
    [requestLabel setNumberOfLines:0];
    [requestLabel setTextColor:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0]];
    [self.sv addSubview:requestLabel];
    

    
//    UIImageView *iv = [[UIImageView alloc] init];
//    NSString *filePath = [NSString stringWithFormat:@"%@",[self.fastData filePath]];
//    if(filePath.length == 0 || [filePath isKindOfClass:[NSNull class]])
//    {
//        [iv setFrame:CGRectMake(10, picTitleLabel.frame.origin.y+picTitleLabel.frame.size.height+10, 60, 0)];
//    }
//    else
//    {
//        [iv setFrame:CGRectMake(10, picTitleLabel.frame.origin.y+picTitleLabel.frame.size.height+10, 60, 60)];
//        [iv setImageWithURL:[NSURL URLWithString:filePath]];
//        [iv setUserInteractionEnabled:YES];
//        UITapGestureRecognizer *ivTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ivTap:)];
//        [iv addGestureRecognizer:ivTap];
//    }
//    [self.sv addSubview:iv];

    situationLabel = [[UILabel alloc] init];
    NSString *string = [NSString stringWithFormat:@"%@",self.fastData.treatment];
    NSString *situation = [NSString stringWithFormat:@"处理情况: %@",string];
    if([DCFCustomExtra validateString:string] == NO)
    {
        [situationLabel setFrame:CGRectMake(10, requestLabel.frame.origin.y+requestLabel.frame.size.height+10, ScreenWidth-20, 0)];
    }
    else
    {
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:situation WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
        [situationLabel setFrame:CGRectMake(10, requestLabel.frame.origin.y+requestLabel.frame.size.height+10, ScreenWidth-20, size.height)];
    }
    [situationLabel setText:situation];
    [situationLabel setTextColor:[UIColor whiteColor]];
    [situationLabel setFont:[UIFont boldSystemFontOfSize:14]];
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
    NSString *s = [NSString stringWithFormat:@"%@%@",@"OemDetail",time];
    NSString *token = [DCFCustomExtra md5:s];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&oemid=%@",token,self.fastData.oemId];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetInquiryInfoTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/OemDetail.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
//    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSLog(@"%@",dicRespon);
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
//                    fullAddress = [NSString stringWithFormat:@"%@%@%@%@",[dic objectForKey:@"province"],[dic objectForKey:@"city"],[dic objectForKey:@"district"],[dic objectForKey:@"address"]];
//                    NSLog(@"fullAddress = %@",fullAddress);
//                    
//                    NSString *tel = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"联系电话:%@",self.fastData.phone]];
//                    NSString *name = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"联系人:%@",self.fastData.linkman]];
//                    myDic = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",tel,@"tel",fullAddress,@"fullAddress", nil];
//                    
//                    inquiryserial = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquiryserial"]];
//                    
//                    inquiryid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquiryid"]];
//                    
//                    [self.orderLabel setText:[NSString stringWithFormat:@"询价单号:%@",inquiryserial]];

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
