//
//  SpeedInquiryListTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-6.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "SpeedInquiryListTableViewController.h"
#import "MCDefine.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "LoginNaviViewController.h"
#import "DCFChenMoreCell.h"


@interface SpeedInquiryListTableViewController ()
{
    DCFChenMoreCell *moreCell;
    
    int intPage; //页数
    int intTotal; //总数
    int pageSize; //每页条数
    BOOL _reloading;
    BOOL flag;
    
    NSMutableArray *dataArray;
    NSMutableArray *lookBtnArray;  //查看按钮数组
    NSMutableArray *upTimeLabelArray;  //提交时间数组
}
@end

@implementation SpeedInquiryListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if(memberid.length == 0)
    {
        LoginNaviViewController *loginNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lookBtnArray = [[NSMutableArray alloc] init];
    
    dataArray = [[NSMutableArray alloc] init];
    
    upTimeLabelArray = [[NSMutableArray alloc] init];
    
    intPage = 1;
    
    
    //ADD REFRESH VIEW
    _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -300, 320, 300)];
    [self.refreshView setDelegate:self];
    [self.tableView addSubview:self.refreshView];
    [self.refreshView refreshLastUpdatedDate];
    
    [self loadRequest];
}

- (void) loadRequest
{
    pageSize = 10;
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"OemList",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&pagesize=%d&pageindex=%d",token,[self getMemberId],pageSize,intPage];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLInquiryListSpeedTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/OemList.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
    
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLInquiryListSpeedTag)
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
            NSString *result = [dicRespon objectForKey:@"result"];
            if([result isEqualToString:@"1"])
            {
                
                if(intPage == 1)
                {
                    [dataArray removeAllObjects];
                }
                [dataArray addObjectsFromArray:[B2BMyInquiryListFastData getListArray:[dicRespon objectForKey:@"items"]]];
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
                [moreCell noClasses];
            }
        }
        
        if(lookBtnArray.count != 0)
        {
            [lookBtnArray removeAllObjects];
        }
        if(upTimeLabelArray.count != 0)
        {
            [upTimeLabelArray removeAllObjects];
        }
        for(int i=0;i<dataArray.count;i++)
        {
            UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [lookBtn setTitle:@"查看" forState:UIControlStateNormal];
            [lookBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [lookBtn setTitleColor:MYCOLOR forState:UIControlStateNormal];
            [lookBtn setFrame:CGRectMake(ScreenWidth-50, 5, 50, 30)];
            [lookBtn setTag:i];
            [lookBtn addTarget:self action:@selector(lookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [lookBtnArray addObject:lookBtn];
            
            NSString *upTime = [[dataArray objectAtIndex:i] myTime];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 250, 30)];
            [label setText:[NSString stringWithFormat:@" 提交时间:%@",upTime]];
            [label setFont:[UIFont systemFontOfSize:12]];
            [upTimeLabelArray addObject:label];
        }
        
        [self.tableView reloadData];
        
    }
}

- (void) lookBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    MyFastInquiryOrder *myFastInquiryOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"myFastInquiryOrder"];
    myFastInquiryOrder.fastData = [dataArray objectAtIndex:sender.tag];
    [self.navigationController pushViewController:myFastInquiryOrder animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!dataArray || dataArray.count == 0)
    {
        return 1;
    }
    return dataArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 1;
    }
    if(section == dataArray.count)
    {
        if ((intPage-1)*pageSize < intTotal )
        {
            return 1;
        }
        return 0;
    }
    return  1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 0;
    }
    if(section == dataArray.count)
    {
        return 0;
    }
    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        return 44;
    }
    if(indexPath.section == dataArray.count)
    {
        return 44;
    }
    
    NSString *s = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.section] remark]];
    if(s.length == 0 || [s isKindOfClass:[NSNull class]])
    {
        return 100;
    }
    else
    {
        NSString *remark = [NSString stringWithFormat:@"询价需求:%@",s];
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:remark WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
        if(size.height<= 30)
        {
            return 100;
        }
        else
        {
            return size.height+70;
        }
    }
    
    
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return nil;
    }
    if(section == dataArray.count)
    {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    [view setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1.0]];
    
    CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"询价单号" WithSize:CGSizeMake(MAXFLOAT, 30)];
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size_1.width, 30)];
    [firstLabel setText:@"询价单号"];
    [firstLabel setFont:[UIFont systemFontOfSize:12]];
    [firstLabel setTextAlignment:NSTextAlignmentRight];
    [view addSubview:firstLabel];
    
    NSString *orderNum = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:section] oemNo]];
    UILabel *orderNumLabel = [[UILabel alloc] init];
    if([DCFCustomExtra validateString:orderNum] == NO)
    {
        [orderNumLabel setFrame:CGRectMake(firstLabel.frame.origin.x + firstLabel.frame.size.width + 5, 5, 30, 30)];
    }
    else
    {
        CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:orderNum WithSize:CGSizeMake(MAXFLOAT, 30)];
        [orderNumLabel setFrame:CGRectMake(firstLabel.frame.origin.x + firstLabel.frame.size.width + 5, 5, size_2.width, 30)];
    }
    [orderNumLabel setFont:[UIFont systemFontOfSize:12]];
    [orderNumLabel setTextAlignment:NSTextAlignmentLeft];
    [orderNumLabel setText:orderNum];
    [view addSubview:orderNumLabel];
    
    NSString *status = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:section] status]];
    UILabel *statusLabel = [[UILabel alloc] init];
    if(status.length == 0 || [status isKindOfClass:[NSNull class]])
    {
        [statusLabel setFrame:CGRectMake(ScreenWidth-40, 5, 30, 30)];
    }
    else
    {
        CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:status WithSize:CGSizeMake(MAXFLOAT, 30)];
        [statusLabel setFrame:CGRectMake(ScreenWidth-10-size_3.width, 5, size_3.width, 30)];
    }
    [statusLabel setFont:[UIFont systemFontOfSize:12]];
    [statusLabel setTextAlignment:NSTextAlignmentRight];
    [statusLabel setText:status];
    [statusLabel setTextColor:[UIColor redColor]];
    [view addSubview:statusLabel];
    
    
    CGSize size_4 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"状态:" WithSize:CGSizeMake(MAXFLOAT, 30)];
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-statusLabel.frame.size.width-5-size_4.width, 5, size_4.width, 30)];
    [secondLabel setFont:[UIFont systemFontOfSize:12]];
    [secondLabel setText:@"状态:"];
    [view addSubview:secondLabel];
    
    return view;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == dataArray.count)
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
    
    
    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        
        NSString *tel = [[dataArray objectAtIndex:indexPath.section] phone];
        UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, cell.contentView.frame.size.width-20, 30)];
        [telLabel setFont:[UIFont systemFontOfSize:12]];
        [telLabel setText:[NSString stringWithFormat:@"联系电话: %@",tel]];
        [cell.contentView addSubview:telLabel];
        
        NSString *time = [[dataArray objectAtIndex:indexPath.section] myTime];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, telLabel.frame.origin.y+telLabel.frame.size.height, cell.contentView.frame.size.width-70, 30)];
        [timeLabel setText:[NSString stringWithFormat:@"提交时间: %@",time]];
        [timeLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:timeLabel];
        
        UIButton *btn = [lookBtnArray objectAtIndex:indexPath.section];
        [btn setFrame:CGRectMake(cell.contentView.frame.size.width-60, timeLabel.frame.origin.y, 50, 30)];
        [cell.contentView addSubview:btn];
        
        NSString *s = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.section] remark]];
        NSString *remark = [NSString stringWithFormat:@"询价需求:%@",s];
        UILabel *remarkLabel = [[UILabel alloc] init];
        if(s.length == 0 || [s isKindOfClass:[NSNull class]])
        {
            [remarkLabel setFrame:CGRectMake(10, timeLabel.frame.origin.y+timeLabel.frame.size.height, cell.contentView.frame.size.width-20, 30)];
        }
        else
        {
            CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:remark WithSize:CGSizeMake(cell.contentView.frame.size.width-20, MAXFLOAT)];
            if(size.height<= 30)
            {
                [remarkLabel setFrame:CGRectMake(10, timeLabel.frame.origin.y+timeLabel.frame.size.height, cell.contentView.frame.size.width-20, 30)];
            }
            else
            {
                [remarkLabel setFrame:CGRectMake(10, timeLabel.frame.origin.y+timeLabel.frame.size.height, cell.contentView.frame.size.width-20, size.height)];
            }
        }
        [remarkLabel setText:remark];
        [remarkLabel setFont:[UIFont systemFontOfSize:12]];
        [remarkLabel setNumberOfLines:0];
        [cell.contentView addSubview:remarkLabel];
    }
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        
    }
    else
    {
        B2BMyInquiryListFastData *data = (B2BMyInquiryListFastData *)[dataArray objectAtIndex:indexPath.section];

        if([self.delegate respondsToSelector:@selector(pushViewController:)])
        {
            [self.delegate pushViewController:data];
        }
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    if (self.tableView == (UITableView *)scrollView)
    {
        if (scrollView.contentSize.height > 0 && (scrollView.contentSize.height-scrollView.frame.size.height)>0)
        {
            if (scrollView.contentOffset.y >= scrollView.contentSize.height-scrollView.frame.size.height)
            {
                NSLog(@"intpage = %d  pageSize = %d",intPage,pageSize);
                if ((intPage-1) * pageSize < intTotal )
                {
                    [self loadRequest];
                }
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.refreshView egoRefreshScrollViewDidScroll:self.tableView];
}
//
#pragma mark -
#pragma mark DATA SOURCE LOADING / RELOADING METHODS
- (void)reloadViewDataSource
{
    
    _reloading = YES;
    intPage = 1;
    [self loadRequest];
}
//
- (void)doneLoadingViewData
{
    
    _reloading = NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
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
@end
