//
//  MyCableOrderSearchViewController.m
//  B2C_MMB_iOS
//
//  Created by developer on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyCableOrderSearchViewController.h"
#import "DCFCustomExtra.h"
#import "MCDefine.h"
#import "UIImageView+WebCache.h"
#import "LookForCustomViewController.h"
#import "DiscussViewController.h"
#import "CancelOrderViewController.h"
#import "logisticsTrackingViewController.h"
#import "FourOrderDetailViewController.h"
#import "AliViewController.h"
#import "DCFChenMoreCell.h"
#import "DCFCustomExtra.h"
#import "DCFTopLabel.h"
#define GoodsDetail_URL @"http://mmb.fgame.com:8083"

@interface MyCableOrderSearchViewController ()
{
    UISearchBar *search;
    
    
    NSMutableArray *searchArray;
    
    NSMutableArray *searchResults;
    NSMutableArray *dataArray;
    NSString *sureReceiveNumber; //确认收货
    DCFChenMoreCell *moreCell;
    UIStoryboard *mySB;
    NSMutableArray *tempOrderNum;
    UIImageView *GoodsPic;
    UILabel *GoodsName;
    UILabel *GoodsPrice;
    UILabel *GoodsColor;
    UILabel *GoodsNum;
    
    UILabel *logisticsPriceLabel;
    
    UILabel *statusLabe;
    
    UILabel *statusContent;
    
    UIButton *onLinePayBtn;
    
    UIButton *cancelOrderBtn;
    
    UIButton *discussBtn;
    
    UIButton *lookForCustomBtn;
    
    UIButton *lookForTradeBtn;
    
    UIButton *receiveBtn;
    
    UIView *titleBackView;
    
    UILabel *orderNumLabel;
    
    UILabel *timeLabel;
    
    UILabel *shopNameLabel;

    UIView *noResultView;
}

@end

@implementation MyCableOrderSearchViewController
@synthesize fromFlag;

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
    self.view.backgroundColor = [UIColor whiteColor];
    dataArray = [[NSMutableArray alloc] init];
    searchArray = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc]init];
    
    //导航栏标题
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"搜索家装线订单"];
    self.navigationItem.titleView = top;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;
    
    mySB = [UIStoryboard storyboardWithName:@"FourthSB" bundle:nil];
    
    dataArray = [[NSMutableArray alloc] init];
    
    tempOrderNum = [[NSMutableArray alloc] init];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45,self.view.frame.size.width,self.view.frame.size.height-109) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.scrollEnabled = YES;
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.myTableView];
    
    noResultView = [[UIView alloc] init];
    noResultView.frame = CGRectMake(0, 45, ScreenWidth, ScreenHeight-45);
    noResultView.backgroundColor = [UIColor whiteColor];
    noResultView.hidden = YES;
    [self.view insertSubview:noResultView aboveSubview:self.myTableView];
    UIImageView *noResultImageView = [[UIImageView alloc] init];
    noResultImageView.frame = CGRectMake((ScreenWidth-200)/2, 40,200,115);
    noResultImageView.image = [UIImage imageNamed:@"noResult"];
    [noResultView addSubview:noResultImageView];
    
    search = [[UISearchBar alloc] init];
    search.frame = CGRectMake(0, 0,self.view.frame.size.width, 45);
    search.delegate = self;
    search.backgroundColor = [UIColor clearColor];
    search.autocorrectionType = UITextAutocorrectionTypeNo;
    search.autocapitalizationType = UITextAutocapitalizationTypeNone;
    search.placeholder = @"搜索家装馆订单";
    [self.view addSubview:search];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    if (dataArray.count == 0)
    {
        [self loadRequestB2COrderListAllWithStatus:@""];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
    if(moreCell)
    {
        [moreCell stopAnimation];
    }
}

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];

    return memberid;
}

- (void) loadRequestB2COrderListAllWithStatus:(NSString *)sender
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getOrderListAll",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *status = [NSString stringWithFormat:@"%@",sender];
    
    conn.LogIn = YES;
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&status=%@",token,[self getMemberId],status];
    
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2COrderListAllTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getOrderListAll.html?"];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLB2COrderListAllTag)
    {
        int intTotal = [[dicRespon objectForKey:@"total"] intValue];
        int result = [[dicRespon objectForKey:@"result"] intValue];

            if([[dicRespon allKeys] count] == 0)
            {
//                [moreCell noDataAnimation];
                 noResultView.hidden = NO;
            }
            else
            {
                if(result == 1)
                {
                    if(intTotal == 0)
                    {
                        noResultView.hidden = NO;
//                        [moreCell noDataAnimation];
                    }
                    else
                    {
                        noResultView.hidden = NO;
                        dataArray = [dicRespon objectForKey:@"items"];
                        tempOrderNum = [dicRespon objectForKey:@"items"];
                         [self.myTableView reloadData];
                    }
                }
                else
                {
                    noResultView.hidden = YES;
//                    [moreCell failAcimation];
                }
            }
       }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger row;
    if(!dataArray || dataArray.count == 0)
    {
        row = 0;
    }
    else
    {
        row = 1;
    }

    return row;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row;
    if (dataArray.count == 0)
    {
        row = 0;
    }
    else
    {
        row = dataArray.count;
    }
    return row;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if(!dataArray || dataArray.count == 0)
    {
        height = 0;
    }
    else
    {
        height = 230;
    }
    return height;
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

#pragma mark - 查看售后
- (void) lookForCustomBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    LookForCustomViewController *custom = [mySB instantiateViewControllerWithIdentifier:@"lookForCustomViewController"];
        custom.orderNum = [[dataArray objectAtIndex:sender.tag] objectForKey:@"orderNum"];
    [self.navigationController pushViewController:custom animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - 评价
- (void) discussBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    DiscussViewController *disCuss = [mySB instantiateViewControllerWithIdentifier:@"discussViewController"];
    disCuss.itemArray = [[NSMutableArray alloc] initWithArray:[[dataArray objectAtIndex:sender.tag] objectForKey:@"items"]];
    disCuss.shopId = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:sender.tag] objectForKey:@"shopId"]];
    disCuss.orderNum = [[dataArray objectAtIndex:sender.tag] objectForKey:@"orderNum"];
    disCuss.subDateDic = [[NSDictionary alloc] initWithDictionary:[[dataArray objectAtIndex:sender.tag] objectForKey:@"subDate"]];
    [self.navigationController pushViewController:disCuss animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}


#pragma mark - 物流跟踪
- (void) lookForTradeBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    logisticsTrackingViewController *logisticsTrackingView = [mySB instantiateViewControllerWithIdentifier:@"logisticsTrackingView"];
    logisticsTrackingView.mylogisticsId = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:sender.tag] objectForKey:@"logisticsId"]];
    logisticsTrackingView.mylogisticsNum = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:sender.tag] objectForKey:@"logisticsNum"]];
    [self.navigationController pushViewController:logisticsTrackingView animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - 取消
- (void) cancelOrderBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    CancelOrderViewController *cancelOrderViewController = [mySB instantiateViewControllerWithIdentifier:@"cancelOrderViewController"];
    cancelOrderViewController.myOrderNum = [[dataArray objectAtIndex:sender.tag] objectForKey:@"orderNum"];
    cancelOrderViewController.myStatus = [[dataArray objectAtIndex:sender.tag] objectForKey:@"status"];
    [self.navigationController pushViewController:cancelOrderViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - 在线支付
- (void) onLinePayBtnClick:(UIButton *) sender
{
    NSString *productTitle = @"";
    NSString *total = nil;
    float shopPrice = 0.00;
    
    NSArray *itemsArray = [[dataArray objectAtIndex:sender.tag] objectForKey:@"items"];
    if(itemsArray.count != 0)
    {
        for(NSDictionary *dic in itemsArray)
        {
            NSString *productItmeTitle = [dic objectForKey:@"productItmeTitle"];
            productTitle = [productTitle stringByAppendingString:productItmeTitle];
            
            shopPrice = shopPrice + [[dic objectForKey:@"price"] floatValue];
        }
        total = [NSString stringWithFormat:@"%.2f",shopPrice];
    }

    [self setHidesBottomBarWhenPushed:YES];
    
    AliViewController *ali = [[AliViewController alloc] initWithNibName:@"AliViewController" bundle:nil];
//  ali.shopName = shopName;
    ali.shopName = @"家装馆产品";
    ali.productName = productTitle;
    ali.productPrice = total;
    ali.productOrderNum =  [[dataArray objectAtIndex:sender.tag] objectForKey:@"orderNum"];
    
    [ali testPay];
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

#pragma mark - 确认接收
- (void) receiveBtnClick:(UIButton *) sender
{
    sureReceiveNumber = [[dataArray objectAtIndex:sender.tag] objectForKey:@"orderNum"];
    UIAlertView *sureAlert = [[UIAlertView alloc] initWithTitle:nil message:@"您确认要收货嘛" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [sureAlert show];
}

- (UITableViewCell *) returnMoreCell:(UITableView *)tableView
{
    static NSString *moreCellId = @"moreCell";
    moreCell = (DCFChenMoreCell *)[tableView dequeueReusableCellWithIdentifier:moreCellId];
    if(moreCell == nil)
    {
        moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
        [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    }
    return moreCell;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        GoodsPic = [[UIImageView alloc] init];
        GoodsPic.frame = CGRectMake(20, 71, 60, 60);
        [cell.contentView addSubview:GoodsPic];
        
        GoodsName = [[UILabel alloc] init];
        GoodsName.frame = CGRectMake(90, 61, 122, 89);
        GoodsName.numberOfLines = 5;
        GoodsName.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:GoodsName];
        
        GoodsPrice = [[UILabel alloc] init];
        GoodsPrice.frame = CGRectMake(214, 61, 98, 32);
        GoodsPrice.textColor = [UIColor redColor];
        GoodsPrice.textAlignment = NSTextAlignmentRight;
        GoodsPrice.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:GoodsPrice];
        
        GoodsColor = [[UILabel alloc] init];
        GoodsColor.frame = CGRectMake(214, 93, 98, 28);
        GoodsColor.textAlignment = NSTextAlignmentRight;
        GoodsColor.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:GoodsColor];
        
        GoodsNum = [[UILabel alloc] init];
        GoodsNum.frame = CGRectMake(214,121, 98, 29);
        GoodsNum.textAlignment = NSTextAlignmentRight;
        GoodsNum.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:GoodsNum];
        
        logisticsPriceLabel = [[UILabel alloc] init];
        logisticsPriceLabel.frame = CGRectMake(10,155, 98, 32);
        logisticsPriceLabel.textAlignment = NSTextAlignmentLeft;
        logisticsPriceLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:logisticsPriceLabel];
        
        statusLabe = [[UILabel alloc] init];
        statusLabe.frame = CGRectMake(180,155, 56, 32);
        statusLabe.textAlignment = NSTextAlignmentRight;
        statusLabe.text = @"订单状态:";
        statusLabe.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:statusLabe];
        
        statusContent = [[UILabel alloc] init];
        statusContent.frame = CGRectMake(242,155, 80, 32);
        statusContent.textAlignment = NSTextAlignmentLeft;
        statusContent.font = [UIFont systemFontOfSize:13];
        statusContent.textColor = [UIColor redColor];
        [cell.contentView addSubview:statusContent];
        
        onLinePayBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        onLinePayBtn.frame = CGRectMake(10, 195,(ScreenWidth-30)/2, 30);
        [onLinePayBtn setTitle:@"在线支付" forState:UIControlStateNormal];
        [onLinePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        onLinePayBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
        onLinePayBtn.layer.cornerRadius = 5;
        
        cancelOrderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelOrderBtn.frame = CGRectMake(onLinePayBtn.frame.origin.x + onLinePayBtn.frame.size.width + 10, 195, onLinePayBtn.frame.size.width, 30);
        [cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [cancelOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelOrderBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
        cancelOrderBtn.layer.cornerRadius = 5;
        
        discussBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [discussBtn setTitle:@"评价" forState:UIControlStateNormal];
        [discussBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        discussBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
        discussBtn.layer.cornerRadius = 5;
        
        lookForCustomBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [lookForCustomBtn setTitle:@"查看售后" forState:UIControlStateNormal];
        [lookForCustomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lookForCustomBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
        lookForCustomBtn.layer.cornerRadius = 5;
        
        lookForTradeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [lookForTradeBtn setTitle:@"物流跟踪" forState:UIControlStateNormal];
        [lookForTradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [lookForTradeBtn setFrame:CGRectMake(onLinePayBtn.frame.origin.x + onLinePayBtn.frame.size.width + 10, 195, onLinePayBtn.frame.size.width, 30)];
        lookForTradeBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
        lookForTradeBtn.layer.cornerRadius = 5;
        
        receiveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [receiveBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        receiveBtn.frame = CGRectMake(15, 195,(ScreenWidth-30)/2, 30);
        [receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        receiveBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
        receiveBtn.layer.cornerRadius = 5;
        
        [cell.contentView addSubview:onLinePayBtn];
        [cell.contentView addSubview:cancelOrderBtn];
        [cell.contentView addSubview:discussBtn];
        [cell.contentView addSubview:lookForCustomBtn];
        [cell.contentView addSubview:lookForTradeBtn];
        [cell.contentView addSubview:receiveBtn];
        
        
        titleBackView = [[UIView alloc] init];
        titleBackView.frame = CGRectMake(0, 0, cell.frame.size.width, 56);
        titleBackView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [cell addSubview:titleBackView];
        
        orderNumLabel = [[UILabel alloc] init];
        orderNumLabel.frame = CGRectMake(10, 5, 215, 21);
        orderNumLabel.font = [UIFont systemFontOfSize:12];
        orderNumLabel.textAlignment = NSTextAlignmentLeft;
        
        [titleBackView addSubview:orderNumLabel];
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.frame = CGRectMake(ScreenWidth-115, 5, 110, 21);
        timeLabel.font = [UIFont systemFontOfSize:11];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [titleBackView addSubview:timeLabel];
        
        shopNameLabel = [[UILabel alloc] init];
        shopNameLabel.frame = CGRectMake(10, 26, ScreenWidth-10, 25);
        shopNameLabel.font = [UIFont systemFontOfSize:14];
        shopNameLabel.textAlignment = NSTextAlignmentLeft;
        [titleBackView addSubview:shopNameLabel];
    }
//    else
//    {
//        while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
//        {
//            [(UIView *) CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
//        }
//    }
    if(!dataArray || dataArray.count == 0)
    {
        return [self returnMoreCell:self.myTableView];
    }
    else if(dataArray.count > 0)
    {
        NSString *picString = [[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"productItemPic"];
        NSString *picURL = [NSString stringWithFormat:@"%@%@",GoodsDetail_URL,picString];
      
        NSURL *url = [NSURL URLWithString:picURL];
        [GoodsPic setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cabel.png"]];

        GoodsName.text = [[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"productName"];
        GoodsPrice.text = [NSString stringWithFormat:@"¥ %@",[[[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"price"] stringValue]];
        NSString *stringNum = [NSString stringWithFormat:@"数量:%@",[[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"productNum"]];
        GoodsNum.text = stringNum;
        
        GoodsColor.text = [NSString stringWithFormat:@"颜色:%@",[[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"colorName"]];
  
        orderNumLabel.text = [NSString stringWithFormat:@"订单编号:  %@",[dataArray[indexPath.row] objectForKey:@"orderNum"]];
        
        //时间戳
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[[dataArray[indexPath.row]objectForKey:@"subDate"] objectForKey:@"time"] doubleValue]/1000];
        
        timeLabel.text = [DCFCustomExtra nsdateToString:confromTimesp];

        logisticsPriceLabel.text = [NSString stringWithFormat:@"运费: ￥%@",[dataArray[indexPath.row] objectForKey:@"logisticsPrice"]];
        
        statusContent.text = [NSString stringWithFormat:@"%@",[DCFCustomExtra compareStatus:[dataArray[indexPath.row] objectForKey:@"status"]]];

        shopNameLabel.text = [dataArray[indexPath.row] objectForKey:@"shopName"];
        
        int status = [[dataArray[indexPath.row] objectForKey:@"status"] intValue];
        if(status == 1)
        {
            [onLinePayBtn setHidden:NO];
            [cancelOrderBtn setHidden:NO];
            [discussBtn setHidden:YES];
            [lookForCustomBtn setHidden:YES];
            [lookForTradeBtn setHidden:YES];
            [receiveBtn setHidden:YES];
        }
        if(status == 2)
        {
            [cancelOrderBtn setFrame:CGRectMake(10, 195, cell.contentView.frame.size.width-20, 30)];
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
        if(status == 5 || status == 7)
        {
            [receiveBtn setHidden:YES];
            [lookForTradeBtn setHidden:YES];
            [discussBtn setHidden:YES];
            [lookForCustomBtn setHidden:YES];
            [onLinePayBtn setHidden:YES];
            [cancelOrderBtn setHidden:YES];
        }
        
        if(status == 6)
        {
            int judgeStatus = [[[dataArray objectAtIndex:indexPath.row]  objectForKey:@"juderstatus"] intValue];
            int afterStatus = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"afterStatus"] intValue];
            if(judgeStatus == 1)
            {
                if(afterStatus == 2 || afterStatus == 3)
                {
                    [discussBtn setFrame:CGRectMake(10,195, (cell.contentView.frame.size.width-40)/3, 30)];
                    
                    [lookForCustomBtn setFrame:CGRectMake(discussBtn.frame.origin.x + discussBtn.frame.size.width + 10, 195, discussBtn.frame.size.width, 30)];
                    [lookForTradeBtn setFrame:CGRectMake(lookForCustomBtn.frame.origin.x + lookForCustomBtn.frame.size.width + 10,195, lookForCustomBtn.frame.size.width, 30)];
                   
                    [lookForCustomBtn setHidden:NO];
                    [lookForTradeBtn setHidden:NO];
                    [discussBtn setHidden:NO];
                    [onLinePayBtn setHidden:YES];
                    [cancelOrderBtn setHidden:YES];
                    [receiveBtn setHidden:YES];
                }
                else
                {
                    [discussBtn setFrame:CGRectMake(10, 195, (cell.contentView.frame.size.width-30)/2, 30)];
                    [lookForTradeBtn setFrame:CGRectMake(discussBtn.frame.origin.x + discussBtn.frame.size.width + 10, 195, discussBtn.frame.size.width, 30)];
                    
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
                    [lookForCustomBtn setFrame:CGRectMake(10, 195, (cell.contentView.frame.size.width-25)/2, 30)];
                    [lookForTradeBtn setFrame:CGRectMake(lookForCustomBtn.frame.origin.x + lookForCustomBtn.frame.size.width + 10, 195, lookForCustomBtn.frame.size.width, 30)];
                    
                    [lookForCustomBtn setHidden:NO];
                    [lookForTradeBtn setHidden:NO];
                    [discussBtn setHidden:YES];
                    [onLinePayBtn setHidden:YES];
                    [cancelOrderBtn setHidden:YES];
                    [receiveBtn setHidden:YES];
                }
                else
                {
                    [lookForTradeBtn setFrame:CGRectMake(10, 195, cell.contentView.frame.size.width-20, 30)];
                    
                    [lookForTradeBtn setHidden:NO];
                    [discussBtn setHidden:YES];
                    [lookForCustomBtn setHidden:YES];
                    [cancelOrderBtn setHidden:YES];
                    [receiveBtn setHidden:YES];
                    [onLinePayBtn setHidden:YES];
                }
            }
        }
        [lookForCustomBtn setTag:indexPath.row];
        [lookForCustomBtn addTarget:self action:@selector(lookForCustomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [discussBtn setTag:indexPath.row];
        [discussBtn addTarget:self action:@selector(discussBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [lookForTradeBtn setTag:indexPath.row];
        [lookForTradeBtn addTarget:self action:@selector(lookForTradeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cancelOrderBtn setTag:indexPath.row];
        [cancelOrderBtn addTarget:self action:@selector(cancelOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [onLinePayBtn setTag:indexPath.row];
        [onLinePayBtn addTarget:self action:@selector(onLinePayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [receiveBtn setTag:indexPath.row];
        [receiveBtn addTarget:self action:@selector(receiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.frame = CGRectMake(0, 154, cell.frame.size.width, 1);
        lineView1.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        [cell addSubview:lineView1];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 187, cell.frame.size.width, 1);
        lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        [cell addSubview:lineView];
    }
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(!dataArray || dataArray.count == 0)
    {
        return;
    }
    
    [self setHidesBottomBarWhenPushed:YES];
    FourOrderDetailViewController *fourOrderDetailViewController = [mySB instantiateViewControllerWithIdentifier:@"fourOrderDetailViewController"];

    fourOrderDetailViewController.myOrderNum = [dataArray[indexPath.row] objectForKey:@"orderNum"];
    
    [self.navigationController pushViewController:fourOrderDetailViewController animated:YES];
}

-(void)searchGoods
{
    [searchResults removeAllObjects];
    for (int i=0; i<dataArray.count; i++)
    {
        if([[dataArray[i] objectForKey:@"orderNum"] rangeOfString:search.text].location !=NSNotFound || [[[[dataArray[i] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"productName"] rangeOfString:search.text].location !=NSNotFound || [[dataArray[i] objectForKey:@"shopName"] rangeOfString:search.text].location !=NSNotFound)
        {
            [searchResults addObject:dataArray[i]];
        }
    }
    
    dataArray = searchResults;

    [search resignFirstResponder];
    if (searchResults.count == 0)
    {
        noResultView.hidden = NO;
    }
    else
    {
        noResultView.hidden = YES;
        [self refreshTableView];
    }
}

-(void)refreshTableView
{
    [self.myTableView removeFromSuperview];
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45,self.view.frame.size.width,self.view.frame.size.height-45) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.scrollEnabled = YES;
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.myTableView];
    [self.myTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchGoods];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{

}


- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0)
    {
        [self loadRequestB2COrderListAllWithStatus:@""];
        noResultView.hidden = NO;
        [self.view bringSubviewToFront:noResultView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
