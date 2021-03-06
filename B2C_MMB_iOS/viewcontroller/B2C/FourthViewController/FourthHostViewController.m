//
//  FourthHostViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "FourthHostViewController.h"
#import "MyOrderHostTableViewCell.h"
#import "DCFTopLabel.h"
#import "DCFStringUtil.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "DCFChenMoreCell.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "MyOrderHostBtnTableViewCell.h"
#import "LookForCustomViewController.h"
#import "DiscussViewController.h"
#import "LoginNaviViewController.h"
#import "B2CMyOrderData.h"
#import "UIImageView+WebCache.h"
#import "FourOrderDetailViewController.h"
#import "CancelOrderViewController.h"
#import "logisticsTrackingViewController.h"
#import "AliViewController.h"
#import "MyCableOrderSearchViewController.h"
#import "AppDelegate.h"

@interface FourthHostViewController ()
{
    UIStoryboard *sb;
    
    NSMutableArray *dataArray;
    
    NSString *logisticsPriceString;
    
    NSMutableArray *btnArray;
    
    DCFChenMoreCell *moreCell;
    
    int intPage; //页数
    int intTotal; //总数
    int pageSize; //每页条数
    
    BOOL _reloading;
    
    NSString *sureReceiveNumber; //确认收货
    
    AppDelegate *app;
}
@end

@implementation FourthHostViewController

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
    if(moreCell)
    {
        [moreCell stopAnimation];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0,22,22)];
    [btn setBackgroundImage:[UIImage imageNamed:@"orderSearch"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(app.isB2CPush == YES)
    {
        [self setHidesBottomBarWhenPushed:YES];
        FourOrderDetailViewController *fourOrderDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fourOrderDetailViewController"];
        fourOrderDetailViewController.myOrderNum = [NSString stringWithFormat:@"%@",app.key3];
        [self.navigationController pushViewController:fourOrderDetailViewController animated:NO];
        app.isB2CPush = NO;
    }
    
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    
    if(!btnArray)
    {
        [self.allBtn setTag:0];
        [self.waitForPayBtn setTag:1];
        [self.waitForSend setTag:2];
        [self.waitForSureBtn setTag:3];
        [self.waitForDiscussBtn setTag:4];
        
        btnArray = [[NSMutableArray alloc] initWithObjects:self.allBtn,self.waitForPayBtn,self.waitForSend,self.waitForSureBtn,self.waitForDiscussBtn, nil];
    }
    
    int tag = [self.myStatus intValue];
    for(UIButton *btn in btnArray)
    {
        if(btn.tag == tag)
        {
            [btn setSelected:YES];
        }
        else
        {
            [btn setSelected:NO];
        }
    }

    for(int i=0;i<btnArray.count;i++)
    {
        UIButton *btn = (UIButton *)[btnArray objectAtIndex:i];
        [btn setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:240.0/255.0 green:241.0/255.0 blue:223.0/255.0 alpha:1.0] forState:UIControlStateSelected];
        
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:37.0/255.0 green:118.0/255.0 blue:254.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        
        [btn setTag:i];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    intPage = 1;
    [self loadRequest:self.myStatus];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    app.aliPayHasFinished = NO;
    
    [self.tv setDataSource:self];
    [self.tv setDelegate:self];
    [self.tv setFrame:CGRectMake(0, 64, ScreenWidth, MainScreenHeight-64)];
    
    [self pushAndPopStyle];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"我的家装线订单"];
    self.navigationItem.titleView = top;
    
    intPage = 1;
    
    dataArray = [[NSMutableArray alloc] init];
    
    //ADD REFRESH VIEW
    _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -300, ScreenWidth, 300)];
    [self.refreshView setDelegate:self];
    [self.tv addSubview:self.refreshView];
    [self.refreshView refreshLastUpdatedDate];
}

-(void)searchOrderBtnClick
{
    [self setHidesBottomBarWhenPushed:YES];
    MyCableOrderSearchViewController *searchVC = [[MyCableOrderSearchViewController alloc] init];
    searchVC.fromFlag = @"我的家装馆订单";
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if(memberid.length == 0)
    {
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
    }
    return memberid;
}

- (void) loadRequest:(NSString *) sender
{
    pageSize = 1000000;
    //    intPage = 1;
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getOrderList",time];
    
    NSString *token = [DCFCustomExtra md5:string];
    
    if([DCFCustomExtra validateString:_myStatus] == NO)
    {
        _myStatus = @"";
    }
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&pagesize=%d&pageindex=%d&status=%@",token,[self getMemberId],pageSize,intPage,_myStatus];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getOrderList.html?"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:ULRGetOrderListTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if(URLTag == ULRGetOrderListTag)
    {
        if(_reloading == YES)
        {
            [self doneLoadingViewData];
        }
        else if(_reloading == NO)
        {
            
        }
        if([[dicRespon allKeys] count] == 0)
        {
            [moreCell noDataAnimation];
        }
        else
        {
            if(result == 1)
            {
                if(intPage == 1)
                {
                    [dataArray removeAllObjects];
                }
                if ([[dicRespon objectForKey:@"items"] count] > 0)
                {
                    logisticsPriceString = [[[dicRespon objectForKey:@"items"] objectAtIndex:0] objectForKey:@"logisticsPrice"];
                }
                [dataArray addObjectsFromArray:[B2CMyOrderData getListArray:[dicRespon objectForKey:@"items"]]];
                intTotal = [[dicRespon objectForKey:@"items"] count];
                if(intTotal == 0)
                {
                    [moreCell HomeImprovementGalleryOrders];
                }
                else
                {
                    [moreCell stopAnimation];
                }
                intPage++;
            }
            else
            {
                [moreCell failAcimation];
            }
        }
        
        [self.tv reloadData];
        
    }
    if(URLTag == URLSureReceiveTag)
    {
        
        [DCFStringUtil showNotice:msg];
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            [self reloadViewDataSource];
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

- (NSString *) validateStatus:(NSString *) str
{
    if([str isEqualToString:@"全部订单"])
    {
        _myStatus = @"";
    }
    if([str isEqualToString:@"待付款"])
    {
        _myStatus = @"1";
    }
    if([str isEqualToString:@"待发货"])
    {
        _myStatus = @"2";
    }
    if([str isEqualToString:@"待确认收货"])
    {
        _myStatus = @"3";
    }
    if([str isEqualToString:@"待评价"])
    {
        _myStatus = @"4";
    }
    return _myStatus;
}

- (void) btnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    
    int tag = btn.tag;
    
    for(UIButton *b in btnArray)
    {
        if(b.tag == tag)
        {
            [b setSelected:YES];
        }
        else
        {
            [b setSelected:NO];
        }
    }
    
    NSString *title = [btn.titleLabel text];
    _myStatus = [self validateStatus:title];
    
    if(dataArray && dataArray.count != 0)
    {
        [dataArray removeAllObjects];
    }
    intPage = 1;
    [self.tv reloadData];
    [self loadRequest:_myStatus];
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
        if ((intPage-1)*pageSize < intTotal )
        {
            if(section == dataArray.count-1)
            {
                if([[[dataArray objectAtIndex:section] B2CMyOrderDataStatus] intValue] == 7 || [[[dataArray objectAtIndex:section] B2CMyOrderDataStatus] intValue] == 5 ||[[[dataArray objectAtIndex:section] B2CMyOrderDataStatus] intValue] == 8)
                {
                    return row+1;
                }
                return row+2;
            }
            else
            {
                if([[[dataArray objectAtIndex:section] B2CMyOrderDataStatus] intValue] == 7 || [[[dataArray objectAtIndex:section] B2CMyOrderDataStatus] intValue] == 5 ||[[[dataArray objectAtIndex:section] B2CMyOrderDataStatus] intValue] == 8)
                {
                    return row;
                }
                return row + 1;
            }
        }
        if([[[dataArray objectAtIndex:section] B2CMyOrderDataStatus] intValue] == 7 || [[[dataArray objectAtIndex:section] B2CMyOrderDataStatus] intValue] == 5 ||[[[dataArray objectAtIndex:section] B2CMyOrderDataStatus] intValue] == 8)
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
            return 122;
        }
        if(indexPath.row == [[[dataArray objectAtIndex:indexPath.section] myItems] count])
        {
            if([[[dataArray objectAtIndex:indexPath.section] B2CMyOrderDataStatus] intValue] == 7 || [[[dataArray objectAtIndex:indexPath.section] B2CMyOrderDataStatus] intValue] == 5 ||[[[dataArray objectAtIndex:indexPath.section] B2CMyOrderDataStatus] intValue] == 8)
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
            return 122;
        }
        if(indexPath.row == [[[dataArray objectAtIndex:indexPath.section] myItems] count])
        {
            if([[[dataArray objectAtIndex:indexPath.section] B2CMyOrderDataStatus] intValue] == 7 || [[[dataArray objectAtIndex:indexPath.section] B2CMyOrderDataStatus] intValue] == 5 ||[[[dataArray objectAtIndex:indexPath.section] B2CMyOrderDataStatus] intValue] == 8)
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
        for(int i=0;i<5;i++)
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
                [label setText:[[dataArray objectAtIndex:section] myOderDataTime]];
            }
            if(i == 3)
            {
                NSString *shopName = [[dataArray objectAtIndex:section] shopName];
                CGSize size_1;
                if([DCFCustomExtra validateString:shopName] == NO)
                {
                    size_1 = CGSizeMake(100, 25);
                }
                else
                {
                    size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:shopName WithSize:CGSizeMake(MAXFLOAT, 25)];
                }
                [label setFrame:CGRectMake(10, 26, size_1.width, 25)];
                [label setFont:[UIFont systemFontOfSize:14]];
                [label setTextAlignment:NSTextAlignmentLeft];
                [label setText:shopName];
            }
            if(i == 4)
            {
                NSString *theStatus = [DCFCustomExtra compareStatus:[[dataArray objectAtIndex:section] B2CMyOrderDataStatus]];
                NSString *str = [NSString stringWithFormat:@"订单状态: %@",theStatus];
                CGSize size_2;
                if([DCFCustomExtra validateString:theStatus] == NO)
                {
                    size_2 = CGSizeMake(300, 25);
                }
                else
                {
                    size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(MAXFLOAT, 25)];
                    [label setFrame:CGRectMake(ScreenWidth-10-size_2.width, 26, size_2.width, 25)];
                    [label setFont:[UIFont systemFontOfSize:12]];
                    [label setTextAlignment:NSTextAlignmentLeft];
                    
                    NSMutableAttributedString *shopStatus = [[NSMutableAttributedString alloc] initWithString:str];
                    [shopStatus addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
                    [shopStatus addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, str.length-5)];
                    [label setAttributedText:shopStatus];
                }

            }
            [headView addSubview:label];
        }

    }
    return headView;
}

- (UITableViewCell *) returnMoreCell:(UITableView *) tv
{
    static NSString *moreCellId = @"moreCell";
    moreCell = (DCFChenMoreCell *)[tv dequeueReusableCellWithIdentifier:moreCellId];
    if(moreCell == nil)
    {
        moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
        [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
    }
    return moreCell;
}

- (UITableViewCell *) returnNormalCell:(UITableView *) tv WithPath:(NSIndexPath *) path
{
    static NSString *cellId = @"myOrderHostTableViewCell";
    MyOrderHostTableViewCell *cell = (MyOrderHostTableViewCell *)[tv dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[MyOrderHostTableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
    }
    NSArray *itemsArray = [[dataArray objectAtIndex:path.section] myItems];
    NSDictionary *itemDic = [itemsArray objectAtIndex:path.row];
    
    NSString *picString = [self dealPic:[itemDic objectForKey:@"productItemPic"]];
    NSURL *url = [NSURL URLWithString:picString];
    [cell.cellIv setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cabel.png"]];
    [cell.contentLabel setText:[itemDic objectForKey:@"productName"]];
    
    [cell.colorLabel setText:[NSString stringWithFormat:@"颜色:%@",[itemDic objectForKey:@"colorName"]]];
    
    [cell.priceLabel setText:[NSString stringWithFormat:@"¥%@",[itemDic objectForKey:@"price"]]];
    
    [cell.numberLabel setText:[NSString stringWithFormat:@"数量:%@",[itemDic objectForKey:@"productNum"]]];
    
    [cell.logisticsPriceLabel setText:[NSString stringWithFormat:@"运费: ￥%@",logisticsPriceString]];
    
    NSString *orderTotal = [NSString stringWithFormat:@"¥%@",[[dataArray objectAtIndex:path.section] orderTotal]];
    
    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:orderTotal WithSize:CGSizeMake(MAXFLOAT, cell.totalLabel.frame.size.height)];
    
    [cell.totalLabel setFrame:CGRectMake(ScreenWidth-20-size.width, cell.totalLabel.frame.origin.y, size.width+10, cell.totalLabel.frame.size.height)];
//    cell.totalLabel.backgroundColor = [UIColor yellowColor];
    cell.totalLabel.font = [UIFont systemFontOfSize:13];
    [cell.totalLabel setText:orderTotal];
    
    [cell.anotherTotalLabel setFrame:CGRectMake(ScreenWidth-10-cell.totalLabel.frame.size.width-cell.anotherTotalLabel.frame.size.width, cell.totalLabel.frame.origin.y, cell.anotherTotalLabel.frame.size.width, cell.anotherTotalLabel.frame.size.height)];
//    cell.anotherTotalLabel.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (UITableViewCell *) returnBtnCell:(UITableView *) tv WithPath:(NSIndexPath *) path
{
    static NSString *cellId = @"myOrderHostBtnTableViewCell";
    MyOrderHostBtnTableViewCell *cell = (MyOrderHostBtnTableViewCell *)[tv dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[MyOrderHostBtnTableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
    }
    int statuss = [[[dataArray objectAtIndex:path.section] B2CMyOrderDataStatus] intValue];
    if(statuss == 1)
    {
        [cell.onLinePayBtn setHidden:NO];
        [cell.cancelOrderBtn setHidden:NO];
        
        [cell.onLinePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.onLinePayBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
        
        [cell.cancelOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.cancelOrderBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
        
        [cell.onLinePayBtn setFrame:CGRectMake(10, 5,(cell.contentView.frame.size.width-30)/2, 30)];
        [cell.cancelOrderBtn setFrame:CGRectMake(cell.onLinePayBtn.frame.origin.x + cell.onLinePayBtn.frame.size.width + 10, 5, cell.onLinePayBtn.frame.size.width, 30)];
        
        [cell.discussBtn setHidden:YES];
        [cell.lookForCustomBtn setHidden:YES];
        [cell.lookForTradeBtn setHidden:YES];
        [cell.receiveBtn setHidden:YES];
    }
    if(statuss == 2)
    {
        [cell.cancelOrderBtn setHidden:NO];
        
        [cell.cancelOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.cancelOrderBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
        
        [cell.cancelOrderBtn setFrame:CGRectMake(10, 5, cell.contentView.frame.size.width-20, 30)];
        
        [cell.discussBtn setHidden:YES];
        [cell.lookForCustomBtn setHidden:YES];
        [cell.lookForTradeBtn setHidden:YES];
        [cell.receiveBtn setHidden:YES];
        [cell.onLinePayBtn setHidden:YES];
    }
    
    if(statuss == 3)
    {
        [cell.receiveBtn setHidden:NO];
        
        [cell.receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.receiveBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
        
        [cell.lookForTradeBtn setHidden:NO];
        
        [cell.lookForTradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.lookForTradeBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
        
        [cell.receiveBtn setFrame:CGRectMake(10, 5, (cell.contentView.frame.size.width-30)/2, 30)];
        [cell.lookForTradeBtn setFrame:CGRectMake(cell.receiveBtn.frame.origin.x + cell.receiveBtn.frame.size.width + 10, 5, cell.receiveBtn.frame.size.width, 30)];
        
        [cell.discussBtn setHidden:YES];
        [cell.lookForCustomBtn setHidden:YES];
        [cell.onLinePayBtn setHidden:YES];
        [cell.cancelOrderBtn setHidden:YES];
    }
    
    if(statuss == 6)
    {
        int judgeStatus = [[[dataArray objectAtIndex:path.section] juderstatus] intValue];
        int afterStatus = [[[dataArray objectAtIndex:path.section] afterStatus] intValue];
        if(judgeStatus == 1)
        {
            if(afterStatus == 2 || afterStatus == 3)
            {
                [cell.discussBtn setHidden:NO];
                
                [cell.discussBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.discussBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
                
                [cell.lookForCustomBtn setHidden:NO];
                
                [cell.lookForCustomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.lookForCustomBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
                
                [cell.lookForTradeBtn setHidden:NO];
                
                [cell.lookForTradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.lookForTradeBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
                
                [cell.onLinePayBtn setHidden:YES];
                [cell.cancelOrderBtn setHidden:YES];
                [cell.receiveBtn setHidden:YES];
                
                [cell.discussBtn setFrame:CGRectMake(10, 5, (cell.contentView.frame.size.width-40)/3, 30)];
                
                [cell.lookForCustomBtn setFrame:CGRectMake(cell.discussBtn.frame.origin.x + cell.discussBtn.frame.size.width + 10, 5, cell.discussBtn.frame.size.width, 30)];
                [cell.lookForTradeBtn setFrame:CGRectMake(cell.lookForCustomBtn.frame.origin.x + cell.lookForCustomBtn.frame.size.width + 10, 5, cell.lookForCustomBtn.frame.size.width, 30)];
            }
            else
            {
                [cell.discussBtn setHidden:NO];
                
                [cell.discussBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.discussBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
                
                [cell.lookForTradeBtn setHidden:NO];
                
                [cell.lookForTradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.lookForTradeBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
                
                [cell.discussBtn setFrame:CGRectMake(10, 5, (cell.contentView.frame.size.width-30)/2, 30)];
                [cell.lookForTradeBtn setFrame:CGRectMake(cell.discussBtn.frame.origin.x + cell.discussBtn.frame.size.width + 10, 5, cell.discussBtn.frame.size.width, 30)];
                
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
                
                [cell.lookForCustomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.lookForCustomBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
                
                [cell.lookForTradeBtn setHidden:NO];
                
                [cell.lookForTradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.lookForTradeBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
                
                [cell.lookForCustomBtn setFrame:CGRectMake(10, 5, (cell.contentView.frame.size.width-30)/2, 30)];
                [cell.lookForTradeBtn setFrame:CGRectMake(cell.lookForCustomBtn.frame.origin.x + cell.lookForCustomBtn.frame.size.width + 10, 5, cell.lookForCustomBtn.frame.size.width, 30)];
                
                [cell.discussBtn setHidden:YES];
                [cell.onLinePayBtn setHidden:YES];
                [cell.cancelOrderBtn setHidden:YES];
                [cell.receiveBtn setHidden:YES];
            }
            else
            {
                [cell.lookForTradeBtn setHidden:NO];
                
                [cell.lookForTradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.lookForTradeBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:4/255.0 alpha:1.0];
                
                [cell.lookForTradeBtn setFrame:CGRectMake(15, 5, cell.contentView.frame.size.width-30, 30)];
                
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
        return [self returnMoreCell:tableView];
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
            return [self returnMoreCell:tableView];
        }
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        return;
    }
    
    [self setHidesBottomBarWhenPushed:YES];
    FourOrderDetailViewController *fourOrderDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fourOrderDetailViewController"];
    fourOrderDetailViewController.myOrderNum = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.section] orderNum]];
    
    [self.navigationController pushViewController:fourOrderDetailViewController animated:YES];
    //    [self setHidesBottomBarWhenPushed:NO];
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
    LookForCustomViewController *custom = [self.storyboard instantiateViewControllerWithIdentifier:@"lookForCustomViewController"];
        custom.orderNum = [[dataArray objectAtIndex:sender.tag/10] orderNum];
    [self.navigationController pushViewController:custom animated:YES];
}

#pragma mark - 评价
- (void) discussBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    DiscussViewController *disCuss = [self.storyboard instantiateViewControllerWithIdentifier:@"discussViewController"];
    disCuss.itemArray = [[NSMutableArray alloc] initWithArray:[[dataArray objectAtIndex:sender.tag/10] myItems]];
    disCuss.shopId = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:sender.tag/10] shopId]];
    disCuss.orderNum = [[dataArray objectAtIndex:sender.tag/10] orderNum];
    disCuss.subDateDic = [[NSDictionary alloc] initWithDictionary:[[dataArray objectAtIndex:sender.tag/10] subDate]];
    
    [self.navigationController pushViewController:disCuss animated:YES];
    //    [self setHidesBottomBarWhenPushed:NO];
}


#pragma mark - 物流跟踪
- (void) lookForTradeBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    logisticsTrackingViewController *logisticsTrackingView = [self.storyboard instantiateViewControllerWithIdentifier:@"logisticsTrackingView"];
    logisticsTrackingView.mylogisticsId = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:sender.tag/10] logisticsId]];
    logisticsTrackingView.mylogisticsNum = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:sender.tag/10] logisticsNum]];
    logisticsTrackingView.mylogisticsName = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:sender.tag/10] logisticsCompanay]];
    [self.navigationController pushViewController:logisticsTrackingView animated:YES];
    //    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - 取消
- (void) cancelOrderBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    CancelOrderViewController *cancelOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cancelOrderViewController"];
    cancelOrderViewController.myOrderNum = [[dataArray objectAtIndex:sender.tag/10] orderNum];
    cancelOrderViewController.myStatus = [[dataArray objectAtIndex:sender.tag/10] B2CMyOrderDataStatus];
    [self.navigationController pushViewController:cancelOrderViewController animated:YES];
    //    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - 在线支付
- (void) onLinePayBtnClick:(UIButton *) sender
{
    NSString *productTitle = @"";
    
    
    NSArray *itemsArray = [[dataArray objectAtIndex:sender.tag/10] myItems];
    if(itemsArray.count != 0)
    {
        for(NSDictionary *dic in itemsArray)
        {
            NSString *productItmeTitle = [dic objectForKey:@"productItmeTitle"];
            productTitle = [productTitle stringByAppendingString:productItmeTitle];
        }
    }
    
    
    
    AliViewController *ali = [[AliViewController alloc] initWithNibName:@"AliViewController" bundle:nil];
    //
    //    ali.shopName = shopName;
    ali.shopName = @"家装馆产品";
    ali.productName = productTitle;
    ali.productPrice = [[dataArray objectAtIndex:sender.tag/10] orderTotal];
    ali.productOrderNum =  [[dataArray objectAtIndex:sender.tag/10] orderNum];
    
    [self setHidesBottomBarWhenPushed:YES];
    [ali testPay];
    [self setHidesBottomBarWhenPushed:NO];
    //    [self.navigationController pushViewController:ali animated:YES];
}


#pragma mark - 确认接收
- (void) receiveBtnClick:(UIButton *) sender
{
    sureReceiveNumber = [[dataArray objectAtIndex:sender.tag/10] orderNum];
    
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    if (self.tv == (UITableView *)scrollView)
    {
        if (scrollView.contentSize.height > 0 && (scrollView.contentSize.height-scrollView.frame.size.height)>0)
        {
            if (scrollView.contentOffset.y >= scrollView.contentSize.height-scrollView.frame.size.height)
            {
                if ((intPage-1) * pageSize < intTotal )
                {
                    [self loadRequest:_myStatus];
                }
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.refreshView egoRefreshScrollViewDidScroll:self.tv];
}
//
#pragma mark -
#pragma mark DATA SOURCE LOADING / RELOADING METHODS
- (void)reloadViewDataSource
{
    
    _reloading = YES;
    intPage = 1;
    [self loadRequest:_myStatus];
}
//
- (void)doneLoadingViewData
{
    
    _reloading = NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tv];
}
//
//#pragma mark -
//#pragma mark REFRESH HEADER DELEGATE METHODS
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    
    [self reloadViewDataSource];
}
//
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    
    return _reloading;
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    
    return [NSDate date];
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
//- (IBAction)allBtnClick:(id)sender
//{
//
//}
//
//- (IBAction)waitForBtnClick:(id)sender
//{
//
//}
//
//- (IBAction)waitForSureBtnClick:(id)sender
//{
//
//}
//
//- (IBAction)waitForDiscussBtnClick:(id)sender
//{
//
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
