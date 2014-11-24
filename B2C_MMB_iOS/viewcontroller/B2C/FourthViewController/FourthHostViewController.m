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

@interface FourthHostViewController ()
{
    UIStoryboard *sb;
    
    NSMutableArray *dataArray;
    
    NSMutableArray *btnArray;
    
    DCFChenMoreCell *moreCell;
    
    int intPage; //页数
    int intTotal; //总数
    int pageSize; //每页条数
    
    BOOL _reloading;
    
    
    NSString *sureReceiveNumber; //确认收货
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if(!btnArray)
    {
        btnArray = [[NSMutableArray alloc] initWithObjects:self.allBtn,self.waitForPayBtn,self.waitForSend,self.waitForSureBtn,self.waitForDiscussBtn, nil];
    }
    
    [self.allBtn setSelected:YES];
    [self.waitForPayBtn setSelected:NO];
    [self.waitForSend setSelected:NO];
    [self.waitForSureBtn setSelected:NO];
    [self.waitForDiscussBtn setSelected:NO];

    for(int i=0;i<btnArray.count;i++)
    {
        UIButton *btn = (UIButton *)[btnArray objectAtIndex:i];
        [btn setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:240.0/255.0 green:241.0/255.0 blue:223.0/255.0 alpha:1.0] forState:UIControlStateSelected];
        
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        
        [btn setTag:i];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        if([btn.titleLabel.text isEqualToString:_myStatus])
//        {
//            [btn setSelected:YES];
//        }
//        else
//        {
//            [btn setSelected:NO];
//        }
    }
//    [self loadRequest:_myStatus];
    [self loadRequest:@""];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"我的家装馆订单"];
    self.navigationItem.titleView = top;
    
    intPage = 1;
    
    dataArray = [[NSMutableArray alloc] init];
    
    //ADD REFRESH VIEW
    _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -300, 320, 300)];
    [self.refreshView setDelegate:self];
    [self.tv addSubview:self.refreshView];
    [self.refreshView refreshLastUpdatedDate];
    
    
    
    
    [self.tv setDataSource:self];
    [self.tv setDelegate:self];
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
                [dataArray addObjectsFromArray:[B2CMyOrderData getListArray:[dicRespon objectForKey:@"items"]]];
                
                intTotal = [[dicRespon objectForKey:@"total"] intValue];
                
                if(intTotal == 0)
                {
                    [moreCell noDataAnimation];
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
            
        }
        else
        {
            
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
                [label setText:@"订单编号:"];
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
                [label setFrame:CGRectMake(201, 5, 119, 21)];
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
    
    [cell.contentLabel setText:[itemDic objectForKey:@"productItmeTitle"]];
    
    [cell.priceLabel setText:[NSString stringWithFormat:@"¥%@",[itemDic objectForKey:@"price"]]];
    
    [cell.numberLabel setText:[NSString stringWithFormat:@"*%@",[itemDic objectForKey:@"productNum"]]];
    
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
    
    
    
    int status = [[[dataArray objectAtIndex:path.section] status] intValue];
    if(status == 1)
    {
        [cell.onLinePayBtn setHidden:NO];
        [cell.cancelOrderBtn setHidden:NO];
        
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
    //    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    //    {
    //        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    //    }
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        return;
    }


    
    NSString *s1 = [[[dataArray objectAtIndex:indexPath.section] subDate] objectForKey:@"month"];
    NSString *month = [NSString stringWithFormat:@"%d",[s1 intValue]+1];
    
    NSString *date = [[[dataArray objectAtIndex:indexPath.section] subDate] objectForKey:@"date"];
    
    NSString *hours = [[[dataArray objectAtIndex:indexPath.section] subDate] objectForKey:@"hours"];
    
    NSString *minutes = [[[dataArray objectAtIndex:indexPath.section] subDate] objectForKey:@"minutes"];
    
    NSString *time = [NSString stringWithFormat:@"%@-%@ %@:%@",month,date,hours,minutes];
    
    [self setHidesBottomBarWhenPushed:YES];
    FourOrderDetailViewController *fourOrderDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fourOrderDetailViewController"];

    fourOrderDetailViewController.theLogiId = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.section] logisticsId]];
    fourOrderDetailViewController.theLogiNum = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.section] logisticsNum]];

    
    fourOrderDetailViewController.theLogiArray = [[NSMutableArray alloc] initWithArray:[[dataArray objectAtIndex:indexPath.section] myItems]];
    fourOrderDetailViewController.theShopId = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] shopId]];
    fourOrderDetailViewController.theOrderNum = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.section] orderNum]];
    fourOrderDetailViewController.theDic = [[NSDictionary alloc] initWithDictionary:[[dataArray objectAtIndex:indexPath.section] subDate]];

    int status = [[[dataArray objectAtIndex:indexPath.section] status] intValue];
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
        int judgeStatus = [[[dataArray objectAtIndex:indexPath.section] juderstatus] intValue];
        int afterStatus = [[[dataArray objectAtIndex:indexPath.section] afterStatus] intValue];
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
    fourOrderDetailViewController.myOrderNum = [[dataArray objectAtIndex:indexPath.section] orderNum];
    fourOrderDetailViewController.myTime = time;
    [self.navigationController pushViewController:fourOrderDetailViewController animated:YES];
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
    DiscussViewController *disCuss = [self.storyboard instantiateViewControllerWithIdentifier:@"discussViewController"];
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
    logisticsTrackingViewController *logisticsTrackingView = [self.storyboard instantiateViewControllerWithIdentifier:@"logisticsTrackingView"];
    logisticsTrackingView.mylogisticsId = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:sender.tag/10] logisticsId]];
    logisticsTrackingView.mylogisticsNum = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:sender.tag/10] logisticsNum]];
    [self.navigationController pushViewController:logisticsTrackingView animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - 取消
- (void) cancelOrderBtnClick:(UIButton *) sender
{
    
    [self setHidesBottomBarWhenPushed:YES];
    CancelOrderViewController *cancelOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cancelOrderViewController"];
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

//
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
