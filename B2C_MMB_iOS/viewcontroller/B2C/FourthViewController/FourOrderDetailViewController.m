//
//  FourOrderDetailViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-18.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "FourOrderDetailViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "LoginNaviViewController.h"
#import "DCFCustomExtra.h"
#import "B2CGetOrderDetailData.h"
#import "UIImageView+WebCache.h"
#import "GoodsPicFastViewController.h"
#import "logisticsTrackingViewController.h"
#import "DiscussViewController.h"
#import "ShopHostTableViewController.h"
#import "DCFColorUtil.h"
#import "CancelOrderViewController.h"
#import "AliViewController.h"
#import "LookForCustomViewController.h"
#import "DCFStringUtil.h"

@interface FourOrderDetailViewController ()
{
    NSMutableArray *dataArray;
    UITableView *tv;
    UIButton *nameBtn;
    UILabel *cancelLabel;
    NSString *sureReceiveNumber; //确认收货
    
    UIButton *discussBtn;
    UIButton *onLinePayBtn;
    UIButton *lookForCustomBtn;
    UIButton *lookForTradeBtn;
    UIButton *cancelOrderBtn;
    UIButton *receiveBtn;
}
@end

@implementation FourOrderDetailViewController

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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if(memberid.length == 0)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装线订单详情"];
    self.navigationItem.titleView = top;
    
    self.buttomView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];

    onLinePayBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    onLinePayBtn.frame = CGRectMake(10, 9,(ScreenWidth-30)/2, 35);
    [onLinePayBtn setTitle:@"在线支付" forState:UIControlStateNormal];
    [onLinePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    onLinePayBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
    [onLinePayBtn addTarget:self action:@selector(onLinePayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    onLinePayBtn.layer.cornerRadius = 5;
    [self.buttomView addSubview:onLinePayBtn];
    
    cancelOrderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelOrderBtn.frame = CGRectMake(onLinePayBtn.frame.origin.x + onLinePayBtn.frame.size.width + 10,9, onLinePayBtn.frame.size.width, 35);
    [cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [cancelOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelOrderBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
    [cancelOrderBtn addTarget:self action:@selector(cancelOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelOrderBtn.layer.cornerRadius = 5;
    [self.buttomView addSubview:cancelOrderBtn];
    
    discussBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [discussBtn setTitle:@"评价" forState:UIControlStateNormal];
    [discussBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    discussBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
    discussBtn.layer.cornerRadius = 5;
    [discussBtn addTarget:self action:@selector(discussBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttomView addSubview:discussBtn];
    
    lookForCustomBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lookForCustomBtn setTitle:@"查看售后" forState:UIControlStateNormal];
    [lookForCustomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    lookForCustomBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
    [lookForCustomBtn addTarget:self action:@selector(lookForCustomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    lookForCustomBtn.layer.cornerRadius = 5;
    [self.buttomView addSubview:lookForCustomBtn];
    
    lookForTradeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lookForTradeBtn setTitle:@"物流跟踪" forState:UIControlStateNormal];
    [lookForTradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lookForTradeBtn setFrame:CGRectMake(onLinePayBtn.frame.origin.x + onLinePayBtn.frame.size.width + 10, 9, onLinePayBtn.frame.size.width, 35)];
    lookForTradeBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
    lookForTradeBtn.layer.cornerRadius = 5;
    [lookForTradeBtn addTarget:self action:@selector(tradeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttomView addSubview:lookForTradeBtn];
    
    receiveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [receiveBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    receiveBtn.frame = CGRectMake(15, 9,(ScreenWidth-30)/2, 35);
    [receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    receiveBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
    [receiveBtn addTarget:self action:@selector(receiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    receiveBtn.layer.cornerRadius = 5;
    [self.buttomView addSubview:receiveBtn];
    
    [self getOrderDetail];
    
    tv = [[UITableView alloc] init];
}

-(void)getOrderDetail
{
    NSString *memberid = [self getMemberId];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getOrderDetail",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&ordernum=%@",memberid,token,self.myOrderNum];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetOrderDetailTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getOrderDetail.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

#pragma mark - 评价
- (void)discussBtnClick:(UIButton *)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    DiscussViewController *disCuss = [self.storyboard instantiateViewControllerWithIdentifier:@"discussViewController"];
    disCuss.itemArray = [[NSMutableArray alloc] initWithArray:[[dataArray lastObject] myItems]];
    disCuss.shopId = [NSString stringWithFormat:@"%@",[[dataArray lastObject] shopId]];
    disCuss.orderNum = [NSString stringWithFormat:@"%@",[[dataArray lastObject] orderNum]];
    disCuss.subDateDic = [[NSDictionary alloc] initWithDictionary:[[dataArray lastObject] subDate]];
    [self.navigationController pushViewController:disCuss animated:YES];
}

#pragma mark - 物流跟踪
- (void)tradeBtnClick:(UIButton *)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    logisticsTrackingViewController *logisticsTrackingView = [self.storyboard instantiateViewControllerWithIdentifier:@"logisticsTrackingView"];
    logisticsTrackingView.mylogisticsId = [NSString stringWithFormat:@"%@",[[dataArray lastObject] logisticsId]];
    logisticsTrackingView.mylogisticsNum = [NSString stringWithFormat:@"%@",[[dataArray lastObject] logisticsNum]];
    logisticsTrackingView.mylogisticsName = [NSString stringWithFormat:@"%@",[[dataArray lastObject] logisticsCompanay]];
    [self.navigationController pushViewController:logisticsTrackingView animated:YES];
}

#pragma mark - 查看售后
- (void) lookForCustomBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    LookForCustomViewController *custom = [self.storyboard instantiateViewControllerWithIdentifier:@"lookForCustomViewController"];
    custom.orderNum = [[dataArray lastObject] orderNum];
    [self.navigationController pushViewController:custom animated:YES];
}

#pragma mark - 取消
- (void) cancelOrderBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    CancelOrderViewController *cancelOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cancelOrderViewController"];
    cancelOrderViewController.myOrderNum = [[dataArray lastObject] orderNum];
    cancelOrderViewController.myStatus = [[dataArray lastObject] status];
    [self.navigationController pushViewController:cancelOrderViewController animated:YES];
    //    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - 在线支付
- (void) onLinePayBtnClick:(UIButton *) sender
{
    NSString *productTitle = @"";
    
    NSArray *itemsArray = [[dataArray lastObject] myItems];
    if(itemsArray.count != 0)
    {
        for(NSDictionary *dic in itemsArray)
        {
            NSString *productItmeTitle = [dic objectForKey:@"productItmeTitle"];
            productTitle = [productTitle stringByAppendingString:productItmeTitle];
        }
    }
    AliViewController *ali = [[AliViewController alloc] initWithNibName:@"AliViewController" bundle:nil];
  //ali.shopName = shopName;
    ali.shopName = @"家装馆产品";
    ali.productName = productTitle;
    ali.productPrice = [[dataArray lastObject] orderTotal];
    ali.productOrderNum =  [[dataArray lastObject] orderNum];
    
    [self setHidesBottomBarWhenPushed:YES];
    [ali testPay];
    [self setHidesBottomBarWhenPushed:NO];
}


#pragma mark - 确认收货
- (void) receiveBtnClick:(UIButton *) sender
{
    sureReceiveNumber = [[dataArray lastObject] orderNum];
    
    UIAlertView *sureAlert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您确认要收货嘛"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确认", nil];
    [sureAlert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
        {
            NSString *time = [DCFCustomExtra getFirstRunTime];
            
            NSString *string = [NSString stringWithFormat:@"%@%@",@"ReceiveProduct",time];
            
            NSString *token = [DCFCustomExtra md5:string];
            
            NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&ordernum=%@",token,[self getMemberId],sureReceiveNumber];
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/ReceiveProduct.html?"];
            conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSureReceiveTag delegate:self];
            
            [conn getResultFromUrlString:urlString postBody:pushString method:POST];
            
            break;
        }
        default:
            break;
    }
}


- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
     NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLGetOrderDetailTag)
    {
        if(result == 1)
        {
            dataArray = [[NSMutableArray alloc] initWithArray:[B2CGetOrderDetailData getListArray:[dicRespon objectForKey:@"items"]]];
            
            NSString *shopName = [[dataArray lastObject] shopName];
            
            nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [nameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [nameBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            if([DCFCustomExtra validateString:shopName] == NO)
            {
                [nameBtn setFrame:CGRectMake(10, 0, 100, 30)];
            }
            else
            {
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:shopName WithSize:CGSizeMake(MAXFLOAT, 30)];
                [nameBtn setFrame:CGRectMake(10, 0, size.width, 30)];
            }
            [nameBtn setTitle:[[dataArray lastObject] shopName] forState:UIControlStateNormal];
            [nameBtn addTarget:self action:@selector(nameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
            [self.myOederLabel setText:[NSString stringWithFormat:@"%@",[[dataArray lastObject] orderNum]]];
            [self.myTimeLabel setText:[NSString stringWithFormat:@"%@",[[dataArray lastObject] myTime]]];
            
            int status = [[[dataArray lastObject] status] intValue];
    
            if(status == 1)
            {
                [onLinePayBtn setHidden:NO];
                [cancelOrderBtn setHidden:NO];
                [discussBtn setHidden:YES];
                [lookForCustomBtn setHidden:YES];
                [lookForTradeBtn setHidden:YES];
                [receiveBtn setHidden:YES];
            }
            if (status == 2)
            {
                [cancelOrderBtn setFrame:CGRectMake(10, 9, self.buttomView.frame.size.width-20, 35)];
                [cancelOrderBtn setHidden:NO];
                [discussBtn setHidden:YES];
                [lookForCustomBtn setHidden:YES];
                [lookForTradeBtn setHidden:YES];
                [receiveBtn setHidden:YES];
                [onLinePayBtn setHidden:YES];
            }
            if(status == 3)
            {
                [receiveBtn setHidden:NO];
                [lookForTradeBtn setHidden:NO];
                [discussBtn setHidden:YES];
                [lookForCustomBtn setHidden:YES];
                [onLinePayBtn setHidden:YES];
                [cancelOrderBtn setHidden:YES];
            }
            if(status == 6)
            {
                int judgeStatus = [[[dataArray lastObject] juderstatus] intValue];
                int afterStatus = [[[dataArray lastObject] afterStatus] intValue];
                if(judgeStatus == 1)
                {
                    if(afterStatus == 2 || afterStatus == 3)
                    {
                        [discussBtn setFrame:CGRectMake(10,9, (self.buttomView.frame.size.width-40)/3, 35)];
                        
                        [lookForCustomBtn setFrame:CGRectMake(discussBtn.frame.origin.x + discussBtn.frame.size.width + 10, 9, discussBtn.frame.size.width, 35)];
                        [lookForTradeBtn setFrame:CGRectMake(lookForCustomBtn.frame.origin.x + lookForCustomBtn.frame.size.width + 10,9, lookForCustomBtn.frame.size.width, 35)];
                        
                        [lookForCustomBtn setHidden:NO];
                        [lookForTradeBtn setHidden:NO];
                        [discussBtn setHidden:NO];
                        [onLinePayBtn setHidden:YES];
                        [cancelOrderBtn setHidden:YES];
                        [receiveBtn setHidden:YES];
                    }
                    else
                    {
                        [discussBtn setFrame:CGRectMake(10, 9, (discussBtn.frame.size.width-30)/2, 35)];
                        [lookForTradeBtn setFrame:CGRectMake(discussBtn.frame.origin.x + discussBtn.frame.size.width + 10,9, discussBtn.frame.size.width, 35)];
                        
                        [discussBtn setHidden:NO];
                        [lookForTradeBtn setHidden:NO];
                        [lookForCustomBtn setHidden:YES];
                        [onLinePayBtn setHidden:YES];
                        [cancelOrderBtn setHidden:YES];
                        [receiveBtn setHidden:YES];
                    }
                }
                else if (judgeStatus == 2)
                {
                    if(afterStatus == 2 || afterStatus == 3)
                    {
                        [lookForCustomBtn setFrame:CGRectMake(10, 9, (self.buttomView.frame.size.width-25)/2, 35)];
                        [lookForTradeBtn setFrame:CGRectMake(lookForCustomBtn.frame.origin.x + lookForCustomBtn.frame.size.width + 10, 9,lookForCustomBtn.frame.size.width, 35)];
                        
                        [lookForCustomBtn setHidden:NO];
                        [lookForTradeBtn setHidden:NO];
                        [discussBtn setHidden:YES];
                        [onLinePayBtn setHidden:YES];
                        [cancelOrderBtn setHidden:YES];
                        [receiveBtn setHidden:YES];
                    }
                    else
                    {
                        [lookForTradeBtn setFrame:CGRectMake(10, 9, self.buttomView.frame.size.width-20, 35)];
                        [lookForTradeBtn setHidden:NO];
                        [discussBtn setHidden:YES];
                        [lookForCustomBtn setHidden:YES];
                        [cancelOrderBtn setHidden:YES];
                        [receiveBtn setHidden:YES];
                        [onLinePayBtn setHidden:YES];
                    }
                }
            }
            
            if(showOrHideDisCussBtn == YES || showOrHideTradeBtn == YES)
            {
                [self.buttomView setHidden:NO];
                
                [discussBtn setHidden:!showOrHideDisCussBtn];
                
                [lookForTradeBtn setHidden:!showOrHideTradeBtn];
                
                [self.tableBackView setFrame:CGRectMake(0, self.tableBackView.frame.origin.y, ScreenWidth,  MainScreenHeight-self.buttomView.frame.size.height-self.topView.frame.size.height-64)];
            }
            else
            {
                if(status == 5 || status == 7)
                {
                    [self.buttomView setHidden:NO];
                    [discussBtn setHidden:YES];
                    [lookForTradeBtn setHidden:YES];
                    [self.tableBackView setFrame:CGRectMake(0, self.tableBackView.frame.origin.y, ScreenWidth,  MainScreenHeight-self.buttomView.frame.size.height-self.topView.frame.size.height-64)];
                    
                    cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.buttomView.frame.size.width, self.buttomView.frame.size.height)];
                    if(status == 5)
                    {
                        [cancelLabel setText:@"已申请取消,客服会第一时间进行处理,请耐心等待"];
                    }
                    else
                    {
                        [cancelLabel setText:@"订单已取消"];
                    }
                    [cancelLabel setTextAlignment:NSTextAlignmentCenter];
                    [cancelLabel setTextColor:[UIColor whiteColor]];
                    [cancelLabel setFont:[UIFont boldSystemFontOfSize:13]];
                    [cancelLabel setBackgroundColor:[DCFColorUtil colorFromHexRGB:@"#AFABAB"]];
                    [self.buttomView addSubview:cancelLabel];
                }
                else
                {
//                    [self.buttomView setHidden:YES];
//                    [self.buttomView setFrame:CGRectMake(0, ScreenHeight, MainScreenHeight, 0)];
//                    for(UIView *view in self.buttomView.subviews)
//                    {
//                        if([view isKindOfClass:[UIButton class]])
//                        {
//                            [view setHidden:YES];
//                            [view setFrame:CGRectMake(view.frame.origin.x, MainScreenHeight, view.frame.size.width, 0)];
//                        }
//                        
//                    }
//                    [self.tableBackView setFrame:CGRectMake(0, self.tableBackView.frame.origin.y, ScreenWidth, MainScreenHeight-self.topView.frame.size.height-64)];
                }
                
            }
            [tv setFrame:CGRectMake(0, 0, self.tableBackView.frame.size.width, self.tableBackView.frame.size.height)];
            [tv setDataSource:self];
            [tv setDelegate:self];
            tv.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
            [self.tableBackView addSubview:tv];
            
            [tv reloadData];
        }
    }
    if(URLTag == URLSureReceiveTag)
    {
        [DCFStringUtil showNotice:msg];
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            [self getOrderDetail];
            [tv reloadData];
        }
        else
        {
            if([DCFCustomExtra validateString:msg] == NO)
            {
                [DCFStringUtil showNotice:@"确认收货失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }

}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 0;
    }
    if(section == 0)
    {
        return [[[dataArray lastObject] myItems] count] + 2;
    }
    else if(section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        NSString *invoiceType = [NSString stringWithFormat:@"%@",[[dataArray lastObject] invoiceType]];
        NSString *nvoiceTitle = [[dataArray lastObject] nvoiceTitle];
        if([DCFCustomExtra validateString:invoiceType] == NO || [DCFCustomExtra validateString:nvoiceTitle] == NO)
        {
            return 0;
        }
        else
        {
            
        }
    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 0;
    }
    if(section == 2)
    {
        NSString *invoiceType = [NSString stringWithFormat:@"%@",[[dataArray lastObject] invoiceType]];
        NSString *nvoiceTitle = [[dataArray lastObject] nvoiceTitle];
        if([DCFCustomExtra validateString:invoiceType] == NO || [DCFCustomExtra validateString:nvoiceTitle] == NO)
        {
            return 0;
        }
        else
        {
            
        }
    }
    return 30;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        return 0;
    }
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0 || indexPath.row == [[[dataArray lastObject] myItems] count]+1)
        {
            return 30;
        }
        else
        {
            NSString *s = [[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"productItmeTitle"];
            CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:s WithSize:CGSizeMake(ScreenWidth-70-5, MAXFLOAT)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, ScreenWidth-70-5, size.height)];
            [label setText:s];
            [label setFont:[UIFont systemFontOfSize:13]];
            [label setNumberOfLines:0];
            return label.frame.size.height + 60;
        }
    }
    if(indexPath.section == 1)
    {
        NSString *add = [[dataArray lastObject] receiveAddr];
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:add WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, ScreenWidth-20, size.height)];
        [label setText:add];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:13]];
        return label.frame.size.height+70;
    }
    else
    {
        NSString *invoiceType = [NSString stringWithFormat:@"%@",[[dataArray lastObject] invoiceType]];
        NSString *nvoiceTitle = [[dataArray lastObject] nvoiceTitle];
        if([DCFCustomExtra validateString:invoiceType] == NO || [DCFCustomExtra validateString:nvoiceTitle] == NO)
        {
            return 0;
        }
        else
        {
            
        }
        return 30;
    }
    return 30;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth+2, 28)];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:[UIColor blackColor]];
    label.font = [UIFont systemFontOfSize:15];
    [label setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
    if(section == 0)
    {
        [label setText:@"  商品信息"];
    }
    if(section == 1)
    {
        [label setText:@"  收货地址"];
    }
    if(section == 2)
    {
        [label setText:@"  发票信息"];
    }
    return label;
}


- (NSString *) dealPic:(NSString *) picString
{
    NSString *pic = picString;
    //.的下标
    int docIndex = pic.length-4;
    if([pic characterAtIndex:docIndex] == '.')
    {
        
        NSString *s1 = [pic substringToIndex:docIndex];
        
        NSString *s2 = [s1 stringByAppendingString:@"_100"];
        
        NSString *pre = [pic substringFromIndex:docIndex];
        
        s2 = [s2 stringByAppendingString:pre];
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_PIC_DEV,s2];
        
        pic = [NSString stringWithFormat:@"%@",has];
        
    }
    else
    {
        docIndex = pic.length - 5;
        
        NSString *s3 = [pic substringToIndex:docIndex];
        
        NSString *s4 = [s3 stringByAppendingString:@"_100"];
        
        NSString *pre = [pic substringFromIndex:docIndex];
        
        s4 = [s4 stringByAppendingString:pre];
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_PIC_DEV,s4];
        
        pic = [NSString stringWithFormat:@"%@",has];
    }
    return pic;
}

- (void) nameBtnClick:(UIButton *) sender
{
    ShopHostTableViewController *shopHost = [[ShopHostTableViewController alloc] initWithHeadTitle:[[dataArray lastObject] shopName] WithShopId:[[dataArray lastObject] shopId] WithUse:@""];
    [self.navigationController pushViewController:shopHost animated:YES];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:0];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    if(!dataArray || dataArray.count == 0)
    {
        
    }
    else
    {
        if(indexPath.section == 0)
        {
            UILabel *statusLabel;
            if(indexPath.row == 0)
            {
                [cell.contentView addSubview:nameBtn];
                
                NSString *status = [DCFCustomExtra compareStatus:[[dataArray lastObject] status]];
                CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:status WithSize:CGSizeMake(MAXFLOAT, 26)];
                
                UILabel *tempStatusLabel = [[UILabel alloc] init];
                tempStatusLabel.frame = CGRectMake(ScreenWidth-10-size_1.width-35, 0, 40, 26);
                tempStatusLabel.text = @"状态:";
                tempStatusLabel.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:tempStatusLabel];
                statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-size_1.width, 0, size_1.width, 26)];
                [statusLabel setText:status];
                [statusLabel setFont:[UIFont systemFontOfSize:13]];
                statusLabel.textColor = [UIColor redColor];
                [statusLabel setTextAlignment:NSTextAlignmentRight];
                [cell.contentView addSubview:statusLabel];
            }
            if(indexPath.row == [[[dataArray lastObject] myItems] count]+1)
            {
                
                
                NSString *tradeMoney = [NSString stringWithFormat:@"运费: ¥%@",[[dataArray lastObject] logisticsPrice]];
                CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:tradeMoney WithSize:CGSizeMake(MAXFLOAT, 26)];
                UILabel *tradeMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(statusLabel.frame.origin.x + statusLabel.frame.size.width + 20, 2, size_2.width, 26)];
                [tradeMoneyLabel setTextAlignment:NSTextAlignmentCenter];
                [tradeMoneyLabel setText:tradeMoney];
                tradeMoneyLabel.textColor = [UIColor lightGrayColor];
                [tradeMoneyLabel setFont:[UIFont systemFontOfSize:13]];
                [cell.contentView addSubview:tradeMoneyLabel];
                
                NSString *orderTotal = [NSString stringWithFormat:@" ¥%@",[[dataArray lastObject] orderTotal]];
                CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:orderTotal WithSize:CGSizeMake(MAXFLOAT, 26)];
                
                UILabel *tempOrderTotal = [[UILabel alloc] init];
                tempOrderTotal.frame = CGRectMake(ScreenWidth-10-size_3.width-60, 2, 60, 26);
                tempOrderTotal.text = @"订单总额:";
                tempOrderTotal.font = [UIFont systemFontOfSize:13];
                [cell.contentView addSubview:tempOrderTotal];
                
                UILabel *orderTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-size_3.width, 2, size_3.width, 26)];
                [orderTotalLabel setTextAlignment:NSTextAlignmentRight];
                [orderTotalLabel setText:orderTotal];
                orderTotalLabel.textColor = [UIColor redColor];
                [orderTotalLabel setFont:[UIFont systemFontOfSize:13]];
                [cell.contentView addSubview:orderTotalLabel];
            }
            else if(indexPath.row > 0 && indexPath.row <= [[[dataArray lastObject] myItems] count])
            {
                NSString *s = [[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"productItmeTitle"];
                //                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:s WithSize:CGSizeMake(ScreenWidth-70-5, MAXFLOAT)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 8, ScreenWidth-190, 60)];
                [label setText:s];
                [label setFont:[UIFont systemFontOfSize:13]];
                label.backgroundColor = [UIColor whiteColor];
                [label setNumberOfLines:0];
                [cell.contentView addSubview:label];
                
                NSString *color = [[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"colorName"];
                UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-110, 31, 100, 20)];
                [colorLabel setTextAlignment:NSTextAlignmentRight];
                colorLabel.backgroundColor = [UIColor whiteColor];
                [colorLabel setText:[NSString stringWithFormat:@"颜色: %@",color]];
                colorLabel.textColor = [UIColor lightGrayColor];
                [colorLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:colorLabel];
                
                NSString *money = [NSString stringWithFormat:@"¥%@",[[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"price"]];
                CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:money WithSize:CGSizeMake(MAXFLOAT, 20)];
                UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-(size_1.width+10), 8, size_1.width, 20)];
                [moneyLabel setText:money];
                [moneyLabel setFont:[UIFont systemFontOfSize:12]];
                moneyLabel.textColor = [UIColor redColor];
                [cell.contentView addSubview:moneyLabel];
                
                NSString *count = [NSString stringWithFormat:@"数量:%@",[[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"productNum"]];
                CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:count WithSize:CGSizeMake(MAXFLOAT, 20)];
                UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-size_2.width, colorLabel.frame.origin.y + colorLabel.frame.size.height + 5, size_2.width, 20)];
                [countLabel setText:count];
                [countLabel setTextAlignment:NSTextAlignmentRight];
                [countLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:countLabel];
                
                UIImageView *cellIv = [[UIImageView alloc] initWithFrame:CGRectMake(10,8, 60, 60)];
                NSString *picStr = [[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"productItemPic"];
                picStr = [self dealPic:picStr];
                NSURL *picUrl = [NSURL URLWithString:picStr];
                [cellIv setImageWithURL:picUrl placeholderImage:[UIImage imageNamed:@"cabel.png"]];
                [cell.contentView addSubview:cellIv];
                
            }
        }
        if(indexPath.section == 1)
        {
            NSString *name = [NSString stringWithFormat:@"收货人: %@",[[dataArray lastObject] receiveMember]];
            CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:name WithSize:CGSizeMake(MAXFLOAT, 30)];
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size_1.width, 30)];
            [nameLabel setFont:[UIFont systemFontOfSize:13]];
            [nameLabel setText:name];
            [cell.contentView addSubview:nameLabel];
            
            UILabel *tel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 20, 5, 200, 30)];
            [tel setText:[[dataArray lastObject] receivePhone]];
            [tel setFont:[UIFont systemFontOfSize:13]];
            [tel setTextAlignment:NSTextAlignmentCenter];
            [cell.contentView addSubview:tel];
            
            NSString *add = [NSString stringWithFormat:@"收货地址: %@",[[dataArray lastObject] receiveAddr]];
            
            if([add rangeOfString:@"(null)"].location != NSNotFound)
            {
                [add stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            }
            if ([add rangeOfString:@"null"].location != NSNotFound)
            {
                [add stringByReplacingOccurrencesOfString:@"null" withString:@""];
            }
            
            add = [add stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"(null)"]];
            
            add = [add stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"null"]];
            
            add = [add stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:add WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, ScreenWidth-20, size.height)];
            [label setText:add];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:13]];
            [cell.contentView addSubview:label];
        }
        if(indexPath.section == 2)
        {
            if(indexPath.row == 0)
            {
                NSString *invoiceType = [NSString stringWithFormat:@"%@",[[dataArray lastObject] invoiceType]];
                NSString *nvoiceTitle = [[dataArray lastObject] nvoiceTitle];
                if([DCFCustomExtra validateString:invoiceType] == NO || [DCFCustomExtra validateString:nvoiceTitle] == NO)
                {
                    
                }
                else
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, cell.contentView.frame.size.width-20, 26)];
                    NSString *str = [NSString stringWithFormat:@"%@:%@",invoiceType,nvoiceTitle];
                    [label setTextAlignment:NSTextAlignmentLeft];
                    [label setFont:[UIFont systemFontOfSize:12]];
                    [label setText:str];
                    [cell.contentView addSubview:label];
                }
            }
            
            
        }
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row > 0 && indexPath.row <= [[[dataArray lastObject] myItems] count])
        {
            GoodsPicFastViewController *goodsPicFastViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"goodsPicFastViewController"];
            
            NSString *snapId = [[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"snapId"];
            NSString *productId = [[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"productId"];
            goodsPicFastViewController.mySnapId = snapId;
            goodsPicFastViewController.myProductId = productId;
            goodsPicFastViewController.myShopName = [[dataArray lastObject] shopName];
            goodsPicFastViewController.myShopId = [[dataArray lastObject] shopId];
            [self.navigationController pushViewController:goodsPicFastViewController animated:YES];
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
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
