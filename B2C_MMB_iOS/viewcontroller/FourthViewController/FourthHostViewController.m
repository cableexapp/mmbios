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
    
    [self loadRequest:_myStatus];
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
    
    btnArray = [[NSMutableArray alloc] initWithObjects:self.allBtn,self.waitForPayBtn,self.waitForSureBtn,self.waitForDiscussBtn, nil];
    for(int i=0;i<btnArray.count;i++)
    {
        UIButton *btn = (UIButton *)[btnArray objectAtIndex:i];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithRed:97.0/255.0 green:93.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:238.0/255.0 green:234.0/255.0 blue:241.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        
        [btn setTag:i];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
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
    pageSize = 2;
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
    if(URLTag == ULRGetOrderListTag)
    {
        NSLog(@"%@",dicRespon);
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
            NSString *result = [dicRespon objectForKey:@"result"];
            if([result isEqualToString:@"1"])
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
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView");
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
    NSLog(@"numberOfRowsInSection");
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
                return row+2;
            }
            else
            {
                return row + 1;
            }
        }
        return row+1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndexPath");
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
    [cell.lookForCustomBtn setTag:0];
    [cell.lookForCustomBtn addTarget:self action:@selector(lookForCustomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.discussBtn setTag:1];
    [cell.discussBtn addTarget:self action:@selector(discussBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.lookForTradeBtn setTag:2];
    [cell.lookForTradeBtn addTarget:self action:@selector(lookForTradeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.cancelOrderBtn setTag:3];
    [cell.cancelOrderBtn addTarget:self action:@selector(cancelOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,s2];
        
        pic = [NSString stringWithFormat:@"%@",has];
        
    }
    else
    {
        docIndex = pic.length - 5;
        
        NSString *s3 = [pic substringToIndex:docIndex];
        
        NSString *s4 = [s3 stringByAppendingString:@"_100"];
        
        NSString *pre = [pic substringFromIndex:docIndex];
        
        s4 = [s4 stringByAppendingString:pre];
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,s4];
        
        pic = [NSString stringWithFormat:@"%@",has];
    }
    return pic;
}

- (void) lookForCustomBtnClick:(UIButton *) sender
{
    NSLog(@"%d",sender.tag);
    
    [self setHidesBottomBarWhenPushed:YES];
    LookForCustomViewController *custom = [self.storyboard instantiateViewControllerWithIdentifier:@"lookForCustomViewController"];
    [self.navigationController pushViewController:custom animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}


- (void) discussBtnClick:(UIButton *) sender
{
    NSLog(@"%d",sender.tag);
    
    [self setHidesBottomBarWhenPushed:YES];
    DiscussViewController *disCuss = [self.storyboard instantiateViewControllerWithIdentifier:@"discussViewController"];
    [self.navigationController pushViewController:disCuss animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void) lookForTradeBtnClick:(UIButton *) sender
{
    NSLog(@"%d",sender.tag);
}

- (void) cancelOrderBtnClick:(UIButton *) sender
{
    NSLog(@"%d",sender.tag);
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
