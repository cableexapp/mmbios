//
//  NormalInquiryListTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-6.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "NormalInquiryListTableViewController.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "LoginNaviViewController.h"
#import "DCFChenMoreCell.h"
#import "B2BMyInquiryListNormalData.h"

@interface NormalInquiryListTableViewController ()
{
    DCFChenMoreCell *moreCell;
    
    int intPage; //页数
    int intTotal; //总数
    int pageSize; //每页条数
    BOOL _reloading;
    BOOL flag;

    NSMutableArray *dataArray;
    NSMutableArray *lookBtnArray;  //查看按钮数组
}
@end

@implementation NormalInquiryListTableViewController

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
    NSString *string = [NSString stringWithFormat:@"%@%@",@"InquiryList",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&pagesize=%d&pageindex=%d",token,[self getMemberId],pageSize,intPage];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLInquiryListTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/InquiryList.html?"];
    
    pageSize = 10;
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];

}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLInquiryListTag)
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
                [dataArray addObjectsFromArray:[B2BMyInquiryListNormalData getListArray:[dicRespon objectForKey:@"ctems"]]];
                
                intTotal = [[dicRespon objectForKey:@"total"] intValue];
                
//                if(intTotal == 0)
//                {
//                    [moreCell noDataAnimation];
//                }
//                else
//                {
//                    [moreCell stopAnimation];
//                }
                intPage++;
            }
            else
            {
                [moreCell failAcimation];
            }
        }
        
        if(lookBtnArray.count != 0)
        {
            [lookBtnArray removeAllObjects];
        }
        
        for(int i=0;i<dataArray.count;i++)
        {
            UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [lookBtn setTitle:@"查看" forState:UIControlStateNormal];
            [lookBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [lookBtn setFrame:CGRectMake(ScreenWidth-40, 5, 30, 30)];
            [lookBtn setTag:i];
            [lookBtn addTarget:self action:@selector(lookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [lookBtnArray addObject:lookBtn];
        }
        
        [self.tableView reloadData];

    }
}

- (void) lookBtnClick:(UIButton *) sender
{
    
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
    return [[[dataArray objectAtIndex:section] myItems] count] + 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 0;
    }
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
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
    
    NSString *orderNum = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:section] inquiryserial]];
    UILabel *orderNumLabel = [[UILabel alloc] init];
    if(orderNum.length == 0 || [orderNum isKindOfClass:[NSNull class]])
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
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
        [(UIView *) CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
//    [cell.textLabel setText:[NSString stringWithFormat:@"cell%d%d",indexPath.section*10,indexPath.row*10]];
    return cell;
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
