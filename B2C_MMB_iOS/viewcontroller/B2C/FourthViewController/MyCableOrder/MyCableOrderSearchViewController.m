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
#import "B2CMyOrderData.h"
//#import "MyOrderHostTableViewCell.h"
#import "UIImageView+WebCache.h"
//#import "MyOrderHostBtnTableViewCell.h"
#import "LookForCustomViewController.h"
#import "DiscussViewController.h"
#import "CancelOrderViewController.h"
#import "logisticsTrackingViewController.h"
#import "FourOrderDetailViewController.h"
#import "AliViewController.h"
#import "DCFChenMoreCell.h"
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
    UILabel *GoodsNum;
    
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
    
    //导航栏标题
    UILabel *naviTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100, 44)];
    naviTitle.textColor = [UIColor whiteColor];
    naviTitle.backgroundColor = [UIColor clearColor];
    naviTitle.font = [UIFont systemFontOfSize:19];
    naviTitle.textAlignment = NSTextAlignmentCenter;
    naviTitle.text = @"订单搜索";
    self.navigationItem.titleView = naviTitle;
    
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
    noResultImageView.frame = CGRectMake((ScreenWidth-130)/2, 40, 130, 75);
    noResultImageView.image = [UIImage imageNamed:@"noResult"];
    [noResultView addSubview:noResultImageView];
    
    search = [[UISearchBar alloc] init];
    search.frame = CGRectMake(0, 0,self.view.frame.size.width, 45);
    search.delegate = self;
    search.backgroundColor = [UIColor clearColor];
    search.autocorrectionType = UITextAutocorrectionTypeNo;
    search.autocapitalizationType = UITextAutocapitalizationTypeNone;
    search.placeholder = @"输入搜索内容";
    [self.view addSubview:search];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    if ([self.fromFlag isEqualToString:@"我的电缆订单"])
    {
    }
    else
    {
        [self loadRequestB2COrderListAllWithStatus:@"1"];
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

- (void) loadRequestB2COrderListAllWithStatus:(NSString *) sender
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getOrderListAll",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *status = [NSString stringWithFormat:@"%@",sender];
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&status=%@",token,[self getMemberId],status];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2COrderListAllTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getOrderListAll.html?"];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{

    if(URLTag == URLB2COrderListAllTag)
    {
        NSLog(@"dicRespon = %@",dicRespon);
        int intTotal = [[dicRespon objectForKey:@"total"] intValue];
        int result = [[dicRespon objectForKey:@"result"] intValue];

            if([[dicRespon allKeys] count] == 0)
            {
                [moreCell noDataAnimation];
            }
            else
            {
                if(result == 1)
                {
                    if(intTotal == 0)
                    {
                        [moreCell noDataAnimation];
                    }
                    else
                    {
                        noResultView.hidden = YES;
                        dataArray = [dicRespon objectForKey:@"items"];
                        tempOrderNum = [dicRespon objectForKey:@"items"];
                        intTotal = [[dicRespon objectForKey:@"total"] intValue];
                    }
                }
                else
                {
                    [moreCell failAcimation];
                }
            }
        [self.myTableView reloadData];
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
        row = 1;
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
        height =  44;
    }
    else
    {
        height = 188;
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
    //    custom.orderNum = [[dataArray objectAtIndex:sender.tag/10] orderNum];
    
    //这部分暂时写死了
    custom.orderNum = @"201404234998770799";
    [self.navigationController pushViewController:custom animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - 评价
- (void) discussBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    DiscussViewController *disCuss = [mySB instantiateViewControllerWithIdentifier:@"discussViewController"];
//    disCuss.itemArray = [[NSMutableArray alloc] initWithArray:[[dataArray objectAtIndex:sender.tag/10] myItems]];
//    disCuss.shopId = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:sender.tag/10] shopId]];
//    disCuss.orderNum = [[dataArray objectAtIndex:sender.tag/10] orderNum];
//    disCuss.subDateDic = [[NSDictionary alloc] initWithDictionary:[[dataArray objectAtIndex:sender.tag/10] subDate]];
    
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
    
    NSString *shopName = [[dataArray objectAtIndex:sender.tag] objectForKey:@"shopName"];
    
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
    //
    ali.shopName = shopName;
    ali.productName = productTitle;
    ali.productPrice = total;
    ali.productOrderNum =  [[dataArray objectAtIndex:sender.tag] objectForKey:@"orderNum"];
    NSLog(@"%@  %@  %@  %@",ali.shopName,ali.productName,ali.productPrice,ali.productOrderNum);
    
    [self.navigationController pushViewController:ali animated:YES];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"取消");
            break;
        case 1:
        {
            NSString *time = [DCFCustomExtra getFirstRunTime];
            
            NSString *string = [NSString stringWithFormat:@"%@%@",@"ReceiveProduct",time];
            
            NSString *token = [DCFCustomExtra md5:string];
            
            NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&ordernum=%@",token,[self getMemberId],sureReceiveNumber];
            
            NSLog(@"push%@",pushString);
            
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
    NSLog(@"receiveBtnClick");
    
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
        [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        [moreCell noDataAnimation];
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
        GoodsPic = [[UIImageView alloc] init];
        GoodsPic.frame = CGRectMake(20, 71, 60, 60);
        [cell addSubview:GoodsPic];
        
        GoodsName = [[UILabel alloc] init];
        GoodsName.frame = CGRectMake(90, 71, cell.frame.size.width-100, 30);
        GoodsName.numberOfLines = 2;
        GoodsName.font = [UIFont systemFontOfSize:15];
        [cell addSubview:GoodsName];
        
        GoodsPrice = [[UILabel alloc] init];
        GoodsPrice.frame = CGRectMake(90, 111, 100, 20);
        GoodsPrice.textColor = [UIColor redColor];
        GoodsPrice.font = [UIFont systemFontOfSize:15];
        [cell addSubview:GoodsPrice];
        
        GoodsNum = [[UILabel alloc] init];
        GoodsNum.frame = CGRectMake(cell.frame.size.width-65, 111, 50, 20);
        GoodsNum.textAlignment = NSTextAlignmentRight;
        GoodsNum.font = [UIFont systemFontOfSize:15];
        [cell addSubview:GoodsNum];
        
        onLinePayBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        onLinePayBtn.frame = CGRectMake(15, 5, 51, 30);
        [onLinePayBtn setTitle:@"在线支付" forState:UIControlStateNormal];
        onLinePayBtn.layer.cornerRadius = 5;
        
        cancelOrderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        cancelOrderBtn.layer.cornerRadius = 5;
        
        discussBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [discussBtn setTitle:@"评价" forState:UIControlStateNormal];
        discussBtn.layer.cornerRadius = 5;
        
        lookForCustomBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [lookForCustomBtn setTitle:@"查看售后" forState:UIControlStateNormal];
        lookForCustomBtn.layer.cornerRadius = 5;
        
        lookForTradeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [lookForTradeBtn setTitle:@"物流跟踪" forState:UIControlStateNormal];
        lookForTradeBtn.layer.cornerRadius = 5;
        
        receiveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [receiveBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        receiveBtn.layer.cornerRadius = 5;
        
        [cell addSubview:onLinePayBtn];
        [cell addSubview:cancelOrderBtn];
        [cell addSubview:discussBtn];
        [cell addSubview:lookForCustomBtn];
        [cell addSubview:lookForTradeBtn];
        [cell addSubview:receiveBtn];
        
        
        titleBackView = [[UIView alloc] init];
        titleBackView.frame = CGRectMake(0, 0, cell.frame.size.width, 56);
        titleBackView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [cell addSubview:titleBackView];
        
        orderNumLabel = [[UILabel alloc] init];
        orderNumLabel.frame = CGRectMake(10, 5, 215, 21);
        orderNumLabel.font = [UIFont systemFontOfSize:13];
        orderNumLabel.textAlignment = NSTextAlignmentLeft;
        
        [titleBackView addSubview:orderNumLabel];
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.frame = CGRectMake(ScreenWidth-105, 5, 100, 21);
        timeLabel.font = [UIFont systemFontOfSize:11];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [titleBackView addSubview:timeLabel];
        
        shopNameLabel = [[UILabel alloc] init];
        shopNameLabel.frame = CGRectMake(10, 26, ScreenWidth-10, 25);
        shopNameLabel.font = [UIFont systemFontOfSize:14];
        shopNameLabel.textAlignment = NSTextAlignmentLeft;
        [titleBackView addSubview:shopNameLabel];
    }
    if(!dataArray || dataArray.count == 0)
    {
//        return [self returnMoreCell:tableView];
    }
    else if(dataArray.count > 0)
    {
        NSString *picString = [[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"productItemPic"];
        NSString *picURL = [NSString stringWithFormat:@"%@%@",GoodsDetail_URL,picString];
        NSLog(@"picString = %@",picString);
        NSURL *url = [NSURL URLWithString:picURL];
        [GoodsPic setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cabel.png"]];

        GoodsName.text = [[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"productItmeTitle"];
        GoodsPrice.text = [[[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"price"] stringValue];
        NSString *stringNum = [NSString stringWithFormat:@"×%@",[[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"productNum"]];
        GoodsNum.text = stringNum;
  
        orderNumLabel.text = [NSString stringWithFormat:@"订单编号:  %@",[dataArray[indexPath.row] objectForKey:@"orderNum"]];
        
        NSString *s1 = [[[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"createDate"] objectForKey:@"month"];
        NSString *month = [NSString stringWithFormat:@"%d",[s1 intValue]+1];
        NSString *date = [[[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"createDate"] objectForKey:@"date"];
        NSString *hours = [[[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"createDate"] objectForKey:@"hours"];
        NSString *minutes = [[[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"createDate"] objectForKey:@"minutes"];
        NSString *time = [NSString stringWithFormat:@"%@-%@ %@:%@",month,date,hours,minutes];
        timeLabel.text = time;
        
        shopNameLabel.text = [dataArray[indexPath.row] objectForKey:@"shopName"];
        int status = [[dataArray[indexPath.row] objectForKey:@"status"] intValue];
        if(status == 1)
        {
            onLinePayBtn.layer.borderColor = [[UIColor clearColor] CGColor];
            [onLinePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            onLinePayBtn.backgroundColor = [UIColor colorWithRed:227/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
            
            cancelOrderBtn.layer.borderColor = [[UIColor clearColor] CGColor];
            [cancelOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cancelOrderBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
            
            [onLinePayBtn setFrame:CGRectMake(10, 151, (cell.contentView.frame.size.width-30)/2, 30)];
            [cancelOrderBtn setFrame:CGRectMake(onLinePayBtn.frame.origin.x + onLinePayBtn.frame.size.width + 10, 151, onLinePayBtn.frame.size.width, 30)];
            [onLinePayBtn setHidden:NO];
            [cancelOrderBtn setHidden:NO];
            [discussBtn setHidden:YES];
            [lookForCustomBtn setHidden:YES];
            [lookForTradeBtn setHidden:YES];
            [receiveBtn setHidden:YES];
        }
        if(status == 2)
        {
            [cancelOrderBtn setHidden:NO];
            cancelOrderBtn.layer.borderColor = [[UIColor clearColor] CGColor];
            [cancelOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cancelOrderBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
            
            [cancelOrderBtn setFrame:CGRectMake(10, 151, cell.contentView.frame.size.width-20, 30)];
            
            [discussBtn setHidden:YES];
            [lookForCustomBtn setHidden:YES];
            [lookForTradeBtn setHidden:YES];
            [receiveBtn setHidden:YES];
            [onLinePayBtn setHidden:YES];
        }
        
        if(status == 3)
        {
            [receiveBtn setHidden:NO];
            receiveBtn.layer.borderColor = [[UIColor clearColor] CGColor];
            [receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            receiveBtn.backgroundColor = [UIColor colorWithRed:227/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
            
            [lookForTradeBtn setHidden:NO];
            lookForTradeBtn.layer.borderColor = [[UIColor clearColor] CGColor];
            [lookForTradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            lookForTradeBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
            
            [receiveBtn setFrame:CGRectMake(10, 151, (cell.contentView.frame.size.width-30)/2, 30)];
            [lookForTradeBtn setFrame:CGRectMake(receiveBtn.frame.origin.x + receiveBtn.frame.size.width + 10, 151,receiveBtn.frame.size.width, 30)];
            
            [discussBtn setHidden:YES];
            [lookForCustomBtn setHidden:YES];
            [onLinePayBtn setHidden:YES];
            [cancelOrderBtn setHidden:YES];
        }
        
        if(status == 6)
        {
            int judgeStatus = [[[dataArray objectAtIndex:indexPath.section] juderstatus] intValue];
            int afterStatus = [[[dataArray objectAtIndex:indexPath.section] afterStatus] intValue];
            if(judgeStatus == 1)
            {
                if(afterStatus == 2 || afterStatus == 3)
                {
                    [discussBtn setHidden:NO];
                    discussBtn.layer.borderColor = [[UIColor clearColor] CGColor];
                    [discussBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    discussBtn.backgroundColor = [UIColor colorWithRed:227/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
                    
                    [lookForCustomBtn setHidden:NO];
                    lookForCustomBtn.layer.borderColor = [[UIColor clearColor] CGColor];
                    [lookForCustomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    lookForCustomBtn.backgroundColor = [UIColor colorWithRed:227/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
                    
                    [lookForTradeBtn setHidden:NO];
                    lookForTradeBtn.layer.borderColor = [[UIColor clearColor] CGColor];
                    [lookForTradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    lookForTradeBtn.backgroundColor = [UIColor colorWithRed:227/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
                    
                    
                    [onLinePayBtn setHidden:YES];
                    [cancelOrderBtn setHidden:YES];
                    [receiveBtn setHidden:YES];
                    
                    [discussBtn setFrame:CGRectMake(10, 151, (cell.contentView.frame.size.width-40)/3, 30)];
                    
                    [lookForCustomBtn setFrame:CGRectMake(discussBtn.frame.origin.x + discussBtn.frame.size.width + 10, 151, discussBtn.frame.size.width, 30)];
                    [lookForTradeBtn setFrame:CGRectMake(lookForCustomBtn.frame.origin.x + lookForCustomBtn.frame.size.width + 10, 151, lookForCustomBtn.frame.size.width, 30)];
                }
                else
                {
                    [discussBtn setHidden:NO];
                    discussBtn.layer.borderColor = [[UIColor clearColor] CGColor];
                    [discussBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    discussBtn.backgroundColor = [UIColor colorWithRed:227/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
                    
                    [lookForTradeBtn setHidden:NO];
                    lookForTradeBtn.layer.borderColor = [[UIColor clearColor] CGColor];
                    [lookForTradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    lookForTradeBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
                    
                    [discussBtn setFrame:CGRectMake(10, 151, (cell.contentView.frame.size.width-30)/2, 30)];
                    [lookForTradeBtn setFrame:CGRectMake(discussBtn.frame.origin.x + discussBtn.frame.size.width + 10, 151, discussBtn.frame.size.width, 30)];
                    
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
                    [lookForCustomBtn setHidden:NO];
                    lookForCustomBtn.layer.borderColor = [[UIColor clearColor] CGColor];
                    [lookForCustomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    lookForCustomBtn.backgroundColor = [UIColor colorWithRed:227/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
                    
                    [lookForTradeBtn setHidden:NO];
                    lookForTradeBtn.layer.borderColor = [[UIColor clearColor] CGColor];
                    [lookForTradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    lookForTradeBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
                    
                    [lookForCustomBtn setFrame:CGRectMake(10, 151, (cell.contentView.frame.size.width-25)/2, 30)];
                    [lookForTradeBtn setFrame:CGRectMake(lookForCustomBtn.frame.origin.x + lookForCustomBtn.frame.size.width + 5, 151, lookForCustomBtn.frame.size.width, 30)];
                    
                    [discussBtn setHidden:YES];
                    [onLinePayBtn setHidden:YES];
                    [cancelOrderBtn setHidden:YES];
                    [receiveBtn setHidden:YES];
                }
                else
                {
                    [lookForTradeBtn setHidden:NO];
                    lookForTradeBtn.layer.borderColor = [[UIColor clearColor] CGColor];
                    [lookForTradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    lookForTradeBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
                    
                    [lookForTradeBtn setFrame:CGRectMake(10, 151, cell.contentView.frame.size.width-20, 30)];
                    
                    [discussBtn setHidden:YES];
                    [lookForCustomBtn setHidden:YES];
                    [cancelOrderBtn setHidden:YES];
                    [receiveBtn setHidden:YES];
                    [onLinePayBtn setHidden:YES];
                }
            }
        }
//        [lookForCustomBtn setTag:indexPath.section*10];
//        [lookForCustomBtn addTarget:self action:@selector(lookForCustomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [discussBtn setTag:indexPath.section*10+1];
//        [discussBtn addTarget:self action:@selector(discussBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [lookForTradeBtn setTag:indexPath.section*10+2];
//        [lookForTradeBtn addTarget:self action:@selector(lookForTradeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [cancelOrderBtn setTag:indexPath.section*10+3];
//        [cancelOrderBtn addTarget:self action:@selector(cancelOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [onLinePayBtn setTag:indexPath.section*10+4];
//        [onLinePayBtn addTarget:self action:@selector(onLinePayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [receiveBtn setTag:indexPath.section*10+5];
//        [receiveBtn addTarget:self action:@selector(receiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
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
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 187, cell.frame.size.width, 1);
        lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        [cell addSubview:lineView];
    }
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        return;
    }
    
    NSString *s1 = [[[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"createDate"] objectForKey:@"month"];
    NSString *month = [NSString stringWithFormat:@"%d",[s1 intValue]+1];
    NSString *date = [[[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"createDate"] objectForKey:@"date"];
    NSString *hours = [[[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"createDate"] objectForKey:@"hours"];
    NSString *minutes = [[[[dataArray[indexPath.row] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"createDate"] objectForKey:@"minutes"];
    NSString *time = [NSString stringWithFormat:@"%@-%@ %@:%@",month,date,hours,minutes];
    
    [self setHidesBottomBarWhenPushed:YES];
    FourOrderDetailViewController *fourOrderDetailViewController = [mySB instantiateViewControllerWithIdentifier:@"fourOrderDetailViewController"];
    
    fourOrderDetailViewController.theLogiId = [NSString stringWithFormat:@"%@",[dataArray[indexPath.row] objectForKey:@"logisticsId"]];
    fourOrderDetailViewController.theLogiNum = [NSString stringWithFormat:@"%@",[dataArray[indexPath.row] objectForKey:@"logisticsNum"]];
    
    
    fourOrderDetailViewController.theLogiArray = [[NSMutableArray alloc] initWithArray:[dataArray[indexPath.row] objectForKey:@"items"]];
    fourOrderDetailViewController.theShopId = [NSString stringWithFormat:@"%@",[dataArray[indexPath.row] objectForKey:@"shopId"]];
    fourOrderDetailViewController.theOrderNum = [NSString stringWithFormat:@"%@",[dataArray[indexPath.row] objectForKey:@"orderNum"]];
    fourOrderDetailViewController.theDic = [[NSDictionary alloc] initWithDictionary:[dataArray[indexPath.row] objectForKey:@"subDate"]];
    
    int status = [[dataArray[indexPath.row] objectForKey:@"status"] intValue];
    if(status == 1)
    {
        fourOrderDetailViewController.showOrHideDisCussBtn = NO;
        fourOrderDetailViewController.showOrHideTradeBtn = NO;
    }
    
    if(status == 2)
    {
        fourOrderDetailViewController.showOrHideDisCussBtn = NO;
        fourOrderDetailViewController.showOrHideTradeBtn = NO;
    }
    
    if(status == 3)
    {
        fourOrderDetailViewController.showOrHideDisCussBtn = NO;
        fourOrderDetailViewController.showOrHideTradeBtn = YES;
    }
    
    if(status == 6)
    {
        int judgeStatus = [[dataArray[indexPath.row] objectForKey:@"juderstatus"] intValue];
        int afterStatus = [[dataArray[indexPath.row] objectForKey:@"afterStatus"]  intValue];
        if(judgeStatus == 1)
        {
            if(afterStatus == 2 || afterStatus == 3)
            {
                fourOrderDetailViewController.showOrHideDisCussBtn = YES;
                fourOrderDetailViewController.showOrHideTradeBtn = YES;
            }
            else
            {
                fourOrderDetailViewController.showOrHideDisCussBtn = YES;
                fourOrderDetailViewController.showOrHideTradeBtn = YES;
            }
        }
        else if (judgeStatus == 2)
        {
            if(afterStatus == 2 || afterStatus == 3)
            {
                fourOrderDetailViewController.showOrHideDisCussBtn = NO;
                fourOrderDetailViewController.showOrHideTradeBtn = YES;
            }
            else
            {
                fourOrderDetailViewController.showOrHideDisCussBtn = NO;
                fourOrderDetailViewController.showOrHideTradeBtn = YES;
            }
        }
    }
    fourOrderDetailViewController.myOrderNum = [dataArray[indexPath.row] objectForKey:@"orderNum"];
    fourOrderDetailViewController.myTime = time;
    [self.navigationController pushViewController:fourOrderDetailViewController animated:YES];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
   
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
    searchResults = [[NSMutableArray alloc]init];
    for (int i=0; i<dataArray.count; i++)
    {
        if([[dataArray[i] objectForKey:@"orderNum"] rangeOfString:search.text].location !=NSNotFound || [[[[dataArray[i] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"productName"] rangeOfString:search.text].location !=NSNotFound || [[dataArray[i] objectForKey:@"shopName"] rangeOfString:search.text].location !=NSNotFound)
        {
            [searchResults addObject:dataArray[i]];
        }
    }
    if (searchResults.count == 0)
    {
        dataArray = searchResults;
        noResultView.hidden = NO;
    }
    else
    {
        noResultView.hidden = YES;
        [self.myTableView removeFromSuperview];
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45,self.view.frame.size.width,self.view.frame.size.height-45) style:UITableViewStylePlain];
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        self.myTableView.scrollEnabled = YES;
        self.myTableView.backgroundColor = [UIColor clearColor];
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.myTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        [self.view addSubview:self.myTableView];
        dataArray = searchResults;
    }
    if ([searchBar.text isEqualToString:@""])
    {
        [dataArray removeAllObjects];
        noResultView.hidden = YES;
        dataArray = tempOrderNum;
//        [self loadRequestB2COrderListAllWithStatus:@"1"];
    }
    NSLog(@"dataArray = %@",dataArray);
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
