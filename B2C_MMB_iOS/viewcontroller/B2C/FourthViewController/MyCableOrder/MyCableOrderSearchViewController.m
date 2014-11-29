//
//  MyCableOrderSearchViewController.m
//  B2C_MMB_iOS
//
//  Created by developer on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyCableOrderSearchViewController.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "DCFCustomExtra.h"
#import "MCDefine.h"
#import "B2CMyOrderData.h"
#import "MyOrderHostTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MyOrderHostBtnTableViewCell.h"
#import "LookForCustomViewController.h"
#import "DiscussViewController.h"
#import "CancelOrderViewController.h"
#import "logisticsTrackingViewController.h"
#import "AliViewController.h"
#import "DCFChenMoreCell.h"

@interface MyCableOrderSearchViewController ()
{
    UISearchBar *search;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *searchResults;
    NSMutableArray *dataArray;
    int isSearch;
    UIStoryboard *sb;
    NSString *sureReceiveNumber; //确认收货
    DCFChenMoreCell *moreCell;
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
    //导航栏标题
    UILabel *naviTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100, 44)];
    naviTitle.textColor = [UIColor whiteColor];
    naviTitle.backgroundColor = [UIColor clearColor];
    naviTitle.font = [UIFont systemFontOfSize:19];
    naviTitle.textAlignment = NSTextAlignmentCenter;
    naviTitle.text = @"订单搜索";
    self.navigationItem.titleView = naviTitle;
    
    dataArray = [[NSMutableArray alloc] init];
    
//    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45,self.view.frame.size.width,self.view.frame.size.height-109) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.scrollEnabled = YES;
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.myTableView];
    
    search = [[UISearchBar alloc] init];
    search.frame = CGRectMake(0, 0,self.view.frame.size.width, 45);
    search.delegate = self;
    search.backgroundColor = [UIColor clearColor];
    search.autocorrectionType = UITextAutocorrectionTypeNo;
    search.autocapitalizationType = UITextAutocapitalizationTypeNone;
    search.placeholder = @"输入搜索内容";
    [self.view addSubview:search];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:search contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.delegate = self;

    NSLog(@"fromFlag = %@",self.fromFlag);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    if ([self.fromFlag isEqualToString:@"我的电缆订单"])
    {
        [self loadRequestB2BOrderListAllWithStatus:@"0"];
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

- (void) loadRequestB2BOrderListAllWithStatus:(NSString *) sender
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"OrderListAll",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *status = [NSString stringWithFormat:@"%@",sender];
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&status=%@",token,[self getMemberId],status];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2BOrderListAllTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/OrderListAll.html?"];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];    
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
    NSString *msg = [dicRespon objectForKey:@"msg"];
    NSLog(@"msg = %@",msg);
    if(URLTag == URLB2BOrderListAllTag)
    {
       NSLog(@"B2B全部订单 = %@",dicRespon);
    }
    else
    {
        NSLog(@"B2C全部订单 = %@",dicRespon);
        [dataArray addObjectsFromArray:[B2CMyOrderData getListArray:[dicRespon objectForKey:@"items"]]];
        [self.myTableView reloadData];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!dataArray || dataArray.count == 0)
    {
        return 1;
    }
    else
    {
        return dataArray.count;
    }
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray.count == 0)
    {
        return 1;
    }
    else
    {
        int row = [[[dataArray objectAtIndex:section] myItems] count];
            if(section == dataArray.count-1)
            {
                if([[[dataArray objectAtIndex:section] status] intValue] == 7 || [[[dataArray objectAtIndex:section] status] intValue] == 5 ||[[[dataArray objectAtIndex:section] status] intValue] == 8)
                {
                    return row+1;
                }
                return row+2;
            }
            else
            {
                if([[[dataArray objectAtIndex:section] status] intValue] == 7 || [[[dataArray objectAtIndex:section] status] intValue] == 5 ||[[[dataArray objectAtIndex:section] status] intValue] == 8)
                {
                    return row;
                }
                return row + 1;
            }
    
        if([[[dataArray objectAtIndex:section] status] intValue] == 7 || [[[dataArray objectAtIndex:section] status] intValue] == 5 ||[[[dataArray objectAtIndex:section] status] intValue] == 8)
        {
            return row;
        }
        return row+1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        return 44;
    }
    if(indexPath.section < dataArray.count-1)
    {
        if(indexPath.row < [[[dataArray objectAtIndex:indexPath.section] myItems] count])
        {
            return 90;
        }
        if(indexPath.row == [[[dataArray objectAtIndex:indexPath.section] myItems] count])
        {
            if([[[dataArray objectAtIndex:indexPath.section] status] intValue] == 7 || [[[dataArray objectAtIndex:indexPath.section] status] intValue] == 5 ||[[[dataArray objectAtIndex:indexPath.section] status] intValue] == 8)
            {
                return 0;
            }
            return 42;
        }
    }
    if(indexPath.section == dataArray.count-1)
    {
        if(indexPath.row < [[[dataArray objectAtIndex:indexPath.section] myItems] count])
        {
            return 90;
        }
        if(indexPath.row == [[[dataArray objectAtIndex:indexPath.section] myItems] count])
        {
            if([[[dataArray objectAtIndex:indexPath.section] status] intValue] == 7 || [[[dataArray objectAtIndex:indexPath.section] status] intValue] == 5 ||[[[dataArray objectAtIndex:indexPath.section] status] intValue] == 8)
            {
                return 0;
            }
            return 42;
        }
        else if(indexPath.row == [[[dataArray objectAtIndex:indexPath.section] myItems] count] + 1)
        {
            return 44;
        }
    }
    return 42;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 0;
    }
    return 56;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    [headView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
    
    if(!dataArray || dataArray.count == 0)
    {
        
    }
    else
    {
        for(int i=0;i<4;i++)
        {
            UILabel *label = [[UILabel alloc] init];
            if(i == 0)
            {
                [label setFrame:CGRectMake(0, 5, 65, 21)];
                [label setFont:[UIFont systemFontOfSize:13]];
                [label setTextAlignment:NSTextAlignmentRight];
                [label setText:@"订单编号:  "];
            }
            if(i == 1)
            {
                [label setFrame:CGRectMake(65, 5, 136, 21)];
                [label setFont:[UIFont systemFontOfSize:13]];
                [label setTextAlignment:NSTextAlignmentLeft];
                [label setText:[[dataArray objectAtIndex:section] orderNum]];
            }
            if(i == 2)
            {
                [label setFrame:CGRectMake(195, 5, 119, 21)];
                [label setFont:[UIFont systemFontOfSize:11]];
                [label setTextAlignment:NSTextAlignmentRight];
                NSString *s1 = [[[dataArray objectAtIndex:section] subDate] objectForKey:@"month"];
                NSString *month = [NSString stringWithFormat:@"%d",[s1 intValue]+1];
                
                NSString *date = [[[dataArray objectAtIndex:section] subDate] objectForKey:@"date"];
                
                NSString *hours = [[[dataArray objectAtIndex:section] subDate] objectForKey:@"hours"];
                
                NSString *minutes = [[[dataArray objectAtIndex:section] subDate] objectForKey:@"minutes"];
                
                NSString *time = [NSString stringWithFormat:@"%@-%@ %@:%@",month,date,hours,minutes];
                
                [label setText:time];
            }
            if(i == 3)
            {
                [label setFrame:CGRectMake(10, 26, ScreenWidth-10, 25)];
                [label setFont:[UIFont systemFontOfSize:14]];
                [label setTextAlignment:NSTextAlignmentLeft];
                [label setText:[[dataArray objectAtIndex:section] shopName]];
            }
            [headView addSubview:label];
        }
    }
    return headView;
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
    LookForCustomViewController *custom = [sb instantiateViewControllerWithIdentifier:@"lookForCustomViewController"];
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
    DiscussViewController *disCuss = [sb instantiateViewControllerWithIdentifier:@"discussViewController"];
    disCuss.itemArray = [[NSMutableArray alloc] initWithArray:[[dataArray objectAtIndex:sender.tag/10] myItems]];
    disCuss.shopId = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:sender.tag/10] shopId]];
    disCuss.orderNum = [[dataArray objectAtIndex:sender.tag/10] orderNum];
    disCuss.subDateDic = [[NSDictionary alloc] initWithDictionary:[[dataArray objectAtIndex:sender.tag/10] subDate]];
    
    [self.navigationController pushViewController:disCuss animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}


#pragma mark - 物流跟踪
- (void) lookForTradeBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    logisticsTrackingViewController *logisticsTrackingView = [sb instantiateViewControllerWithIdentifier:@"logisticsTrackingView"];
    logisticsTrackingView.mylogisticsId = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:sender.tag/10] logisticsId]];
    logisticsTrackingView.mylogisticsNum = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:sender.tag/10] logisticsNum]];
    [self.navigationController pushViewController:logisticsTrackingView animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - 取消
- (void) cancelOrderBtnClick:(UIButton *) sender
{
    
    [self setHidesBottomBarWhenPushed:YES];
    CancelOrderViewController *cancelOrderViewController = [sb instantiateViewControllerWithIdentifier:@"cancelOrderViewController"];
    cancelOrderViewController.myOrderNum = [[dataArray objectAtIndex:sender.tag/10] orderNum];
    cancelOrderViewController.myStatus = [[dataArray objectAtIndex:sender.tag/10] status];
    [self.navigationController pushViewController:cancelOrderViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - 在线支付
- (void) onLinePayBtnClick:(UIButton *) sender
{
    
    NSString *shopName = [[dataArray objectAtIndex:sender.tag/10] shopName];
    
    NSString *productTitle = @"";
    NSString *total = nil;
    float shopPrice = 0.00;
    
    NSArray *itemsArray = [[dataArray objectAtIndex:sender.tag/10] myItems];
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
    ali.productOrderNum =  [[dataArray objectAtIndex:sender.tag/10] orderNum];
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
    
    sureReceiveNumber = [[dataArray objectAtIndex:sender.tag/10] orderNum];
    
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
    }
    return moreCell;
}

- (UITableViewCell *) returnNormalCell:(UITableView *)tableView WithPath:(NSIndexPath *) path
{
    static NSString *cellId = @"myOrderHostTableViewCell";
    MyOrderHostTableViewCell *cell = (MyOrderHostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[MyOrderHostTableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
    }
//    NSLog(@"cell = %@",cell);
    NSLog(@"%@",[[cell.subviews objectAtIndex:0] subviews]);
//    NSLog(@"%@",cell.contentView.subviews);
//    NSArray *itemsArray = [[dataArray objectAtIndex:path.section] myItems];
//    NSDictionary *itemDic = [itemsArray objectAtIndex:path.row];
//    
//    NSString *picString = [self dealPic:[itemDic objectForKey:@"productItemPic"]];
//    NSURL *url = [NSURL URLWithString:picString];
//    [cell.cellIv setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cabel.png"]];
//    cell.cellIv.backgroundColor = [UIColor redColor];
//    
//    [cell.contentLabel setText:[itemDic objectForKey:@"productItmeTitle"]];
//    NSLog(@"contentLabel = %@",[itemDic objectForKey:@"productItmeTitle"]);
//    
//    cell.contentLabel.backgroundColor = [UIColor redColor];
//    
//    [cell.priceLabel setText:[NSString stringWithFormat:@"¥%@",[itemDic objectForKey:@"price"]]];
//    NSLog(@"contentLabel = %@",[NSString stringWithFormat:@"¥%@",[itemDic objectForKey:@"price"]]);
//    
//    [cell.numberLabel setText:[NSString stringWithFormat:@"*%@",[itemDic objectForKey:@"productNum"]]];
//    NSLog(@"contentLabel = %@",[NSString stringWithFormat:@"*%@",[itemDic objectForKey:@"productNum"]]);
    return cell;
}

- (UITableViewCell *) returnBtnCell:(UITableView *)tableView WithPath:(NSIndexPath *)path
{
    static NSString *cellId = @"myOrderHostBtnTableViewCell";
    MyOrderHostBtnTableViewCell *cell = (MyOrderHostBtnTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[MyOrderHostBtnTableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
    }
    int status = [[[dataArray objectAtIndex:path.section] status] intValue];
    if(status == 1)
    {
        [cell.onLinePayBtn setHidden:NO];
        [cell.cancelOrderBtn setHidden:NO];
        cell.onLinePayBtn.layer.borderColor = [[UIColor clearColor] CGColor];
        [cell.onLinePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.onLinePayBtn.backgroundColor = [UIColor colorWithRed:227/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
        cell.cancelOrderBtn.layer.borderColor = [[UIColor clearColor] CGColor];
        [cell.cancelOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.cancelOrderBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
        [cell.onLinePayBtn setFrame:CGRectMake(10, 5, (cell.contentView.frame.size.width-25)/2, 30)];
        [cell.cancelOrderBtn setFrame:CGRectMake(cell.onLinePayBtn.frame.origin.x + cell.onLinePayBtn.frame.size.width + 5, 5, cell.onLinePayBtn.frame.size.width, 30)];
        
        [cell.discussBtn setHidden:YES];
        [cell.lookForCustomBtn setHidden:YES];
        [cell.lookForTradeBtn setHidden:YES];
        [cell.receiveBtn setHidden:YES];
    }
    if(status == 2)
    {
        [cell.cancelOrderBtn setHidden:NO];
        
        [cell.cancelOrderBtn setFrame:CGRectMake(10, 5, cell.contentView.frame.size.width-20, 30)];
        
        [cell.discussBtn setHidden:YES];
        [cell.lookForCustomBtn setHidden:YES];
        [cell.lookForTradeBtn setHidden:YES];
        [cell.receiveBtn setHidden:YES];
        [cell.onLinePayBtn setHidden:YES];
    }
    if(status == 3)
    {
        [cell.receiveBtn setHidden:NO];
        [cell.lookForTradeBtn setHidden:NO];
        
        [cell.receiveBtn setFrame:CGRectMake(10, 5, (cell.contentView.frame.size.width-25)/2, 30)];
        [cell.lookForTradeBtn setFrame:CGRectMake(cell.receiveBtn.frame.origin.x + cell.receiveBtn.frame.size.width + 5, 5, cell.receiveBtn.frame.size.width, 30)];
        
        [cell.discussBtn setHidden:YES];
        [cell.lookForCustomBtn setHidden:YES];
        [cell.onLinePayBtn setHidden:YES];
        [cell.cancelOrderBtn setHidden:YES];
    }
    if(status == 6)
    {
        int judgeStatus = [[[dataArray objectAtIndex:path.section] juderstatus] intValue];
        int afterStatus = [[[dataArray objectAtIndex:path.section] afterStatus] intValue];
        if(judgeStatus == 1)
        {
            if(afterStatus == 2 || afterStatus == 3)
            {
                [cell.discussBtn setHidden:NO];
                [cell.lookForCustomBtn setHidden:NO];
                [cell.lookForTradeBtn setHidden:NO];
                
                [cell.onLinePayBtn setHidden:YES];
                [cell.cancelOrderBtn setHidden:YES];
                [cell.receiveBtn setHidden:YES];
                
                [cell.discussBtn setFrame:CGRectMake(10, 5, (cell.contentView.frame.size.width-30)/3, 30)];
                
                //                [cell.lookForCustomBtn setFrame:CGRectMake(200, 5, 100, 30)];
                [cell.lookForCustomBtn setFrame:CGRectMake(cell.discussBtn.frame.origin.x + cell.discussBtn.frame.size.width + 5, 5, cell.discussBtn.frame.size.width, 30)];
                [cell.lookForTradeBtn setFrame:CGRectMake(cell.lookForCustomBtn.frame.origin.x + cell.lookForCustomBtn.frame.size.width + 5, 5, cell.lookForCustomBtn.frame.size.width, 30)];
            }
            else
            {
                [cell.discussBtn setHidden:NO];
                [cell.lookForTradeBtn setHidden:NO];
                
                [cell.discussBtn setFrame:CGRectMake(10, 5, (cell.contentView.frame.size.width-25)/2, 30)];
                [cell.lookForTradeBtn setFrame:CGRectMake(cell.discussBtn.frame.origin.x + cell.discussBtn.frame.size.width + 5, 5, cell.discussBtn.frame.size.width, 30)];
                
                [cell.lookForCustomBtn setHidden:YES];
                [cell.onLinePayBtn setHidden:YES];
                [cell.cancelOrderBtn setHidden:YES];
                [cell.receiveBtn setHidden:YES];
            }
        }
        else if (judgeStatus == 2)
        {
            if(afterStatus == 2 || afterStatus == 3)
            {
                [cell.lookForCustomBtn setHidden:NO];
                [cell.lookForTradeBtn setHidden:NO];
                
                [cell.lookForCustomBtn setFrame:CGRectMake(10, 5, (cell.contentView.frame.size.width-25)/2, 30)];
                [cell.lookForTradeBtn setFrame:CGRectMake(cell.lookForCustomBtn.frame.origin.x + cell.lookForCustomBtn.frame.size.width + 5, 5, cell.lookForCustomBtn.frame.size.width, 30)];
                
                [cell.discussBtn setHidden:YES];
                [cell.onLinePayBtn setHidden:YES];
                [cell.cancelOrderBtn setHidden:YES];
                [cell.receiveBtn setHidden:YES];
            }
            else
            {
                [cell.lookForTradeBtn setHidden:NO];
                
                [cell.lookForTradeBtn setFrame:CGRectMake(10, 5, cell.contentView.frame.size.width-20, 30)];
                
                [cell.discussBtn setHidden:YES];
                [cell.lookForCustomBtn setHidden:YES];
                [cell.cancelOrderBtn setHidden:YES];
                [cell.receiveBtn setHidden:YES];
                [cell.onLinePayBtn setHidden:YES];
            }
        }
    }
    [cell.lookForCustomBtn setTag:path.section*10];
    [cell.lookForCustomBtn addTarget:self action:@selector(lookForCustomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.discussBtn setTag:path.section*10+1];
    [cell.discussBtn addTarget:self action:@selector(discussBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.lookForTradeBtn setTag:path.section*10+2];
    [cell.lookForTradeBtn addTarget:self action:@selector(lookForTradeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.cancelOrderBtn setTag:path.section*10+3];
    [cell.cancelOrderBtn addTarget:self action:@selector(cancelOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.onLinePayBtn setTag:path.section*10+4];
    [cell.onLinePayBtn addTarget:self action:@selector(onLinePayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.receiveBtn setTag:path.section*10+5];
    [cell.receiveBtn addTarget:self action:@selector(receiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
//       return [self returnMoreCell:tableView];
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    }
    
    if(indexPath.section < dataArray.count-1)
    {
        if(indexPath.row < [[[dataArray objectAtIndex:indexPath.section] myItems] count])
        {
            return [self returnNormalCell:tableView WithPath:indexPath];
        }
        else if(indexPath.row == [[[dataArray objectAtIndex:indexPath.section] myItems] count])
        {
            return [self returnBtnCell:tableView WithPath:indexPath];
        }
    }
    if(indexPath.section == dataArray.count-1)
    {
        if(indexPath.row < [[[dataArray objectAtIndex:indexPath.section] myItems] count])
        {
            return [self returnNormalCell:tableView WithPath:indexPath];
        }
        else if(indexPath.row == [[[dataArray objectAtIndex:indexPath.section] myItems] count])
        {
            return [self returnBtnCell:tableView WithPath:indexPath];
        }
        if(indexPath.row == [[[dataArray objectAtIndex:indexPath.section] myItems] count]+1)
        {
//            return [self returnMoreCell:tableView];
            NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            return cell;
        }
    }
    return nil;
}


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	return 100;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        return searchResults.count;
//    }
//    else
//    {
//        return dataArray.count;
//    }
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.textLabel.textColor = [UIColor blackColor];
//    }
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        cell.textLabel.text = searchResults[indexPath.row];
//    }
//    else
//    {
//        cell.textLabel.text = dataArray[indexPath.row];
//    }
//    return cell;
//}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"didSelectRowAtIndexPath");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"键盘搜索.....");
    [search resignFirstResponder];
    search.frame = CGRectMake(0, 20,self.view.frame.size.width, 45);
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    search.frame = CGRectMake(0, 20,self.view.frame.size.width, 45);
    self.searchDisplayController.searchResultsTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (search.text.length > 0)
    {
        search.frame = CGRectMake(0, 20,self.view.frame.size.width, 45);
    }
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    NSLog(@"searchDisplayControllerWillBeginSearch");
}
- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
     NSLog(@"searchDisplayControllerDidBeginSearch");
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    NSLog(@"searchDisplayControllerWillEndSearch");
    search.frame = CGRectMake(0, 0,self.view.frame.size.width, 45);
}
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    NSLog(@"searchDisplayControllerDidEndSearch");
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    NSLog(@"willHideSearchResultsTableView");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    NSLog(@"didHideSearchResultsTableView");
}

- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
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
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",searchText];
    NSLog(@"searchArray = %@",[NSArray arrayWithArray:[dataArray filteredArrayUsingPredicate:pred]]);
    searchResults = [[NSMutableArray alloc]init];
    if (search.text.length>0&&![ChineseInclude isIncludeChineseInString:search.text])
    {
        for (int i=0; i<dataArray.count; i++)
        {
            if ([ChineseInclude isIncludeChineseInString:dataArray[i]])
            {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:dataArray[i]];
                NSRange titleResult=[tempPinYinStr rangeOfString:search.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0)
                {
                    [searchResults addObject:dataArray[i]];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:dataArray[i]];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:search.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0)
                {
                    [searchResults addObject:dataArray[i]];
                }
            }
            else
            {
                NSRange titleResult=[dataArray[i] rangeOfString:search.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0)
                {
                    [searchResults addObject:dataArray[i]];
                }
            }
        }
    }
    else if (search.text.length>0&&[ChineseInclude isIncludeChineseInString:search.text])
    {
        for (NSString *tempStr in dataArray)
        {
            NSRange titleResult=[tempStr rangeOfString:search.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0)
            {
                [searchResults addObject:tempStr];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
