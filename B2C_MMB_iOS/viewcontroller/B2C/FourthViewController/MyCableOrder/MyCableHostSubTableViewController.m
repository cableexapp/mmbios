//
//  MyCableHostSubTableViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-12.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyCableHostSubTableViewController.h"
#import "MCDefine.h"
#import "DCFStringUtil.h"
#import "DCFChenMoreCell.h"
#import "DCFCustomExtra.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "LoginNaviViewController.h"
#import "B2BMyCableOrderListData.h"

@interface MyCableHostSubTableViewController ()
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
    
    UIStoryboard *sb;
    
}
@end

@implementation MyCableHostSubTableViewController

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
        
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
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
    NSString *string = [NSString stringWithFormat:@"%@%@",@"OrderList",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&pagesize=%d&pageindex=%d&status=%@",token,@"668",pageSize,intPage,@""];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLOrderListTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/OrderList.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
    
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLOrderListTag)
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
                [dataArray addObjectsFromArray:[B2BMyCableOrderListData getListArray:[dicRespon objectForKey:@"items"]]];
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
            
            NSString *upTime = @"123";
            
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
    return  [[[dataArray objectAtIndex:section] myItems] count] + 2;
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
    
    if(indexPath.row >= [[[dataArray objectAtIndex:indexPath.section] myItems] count])
    {
        return 44;
    }
    
    return 100;
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
    
    NSString *orderNum = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:section] orderserial]];
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
        
        CGFloat cellWidth = cell.contentView.frame.size.width;
        
        if(indexPath.row < [[[dataArray objectAtIndex:indexPath.section] myItems] count])
        {
            NSArray *itemArray = [[dataArray objectAtIndex:indexPath.section] myItems];
            
            UILabel *orderNumLabel = [[UILabel alloc] init];
            [orderNumLabel setFont:[UIFont systemFontOfSize:12]];
            
            UILabel *numLabel = [[UILabel alloc] init];
            [numLabel setFont:[UIFont systemFontOfSize:12]];

            UILabel *timeLabel = [[UILabel alloc] init];
            [timeLabel setFont:[UIFont systemFontOfSize:12]];

            UILabel *priceLabel = [[UILabel alloc] init];
            [priceLabel setFont:[UIFont systemFontOfSize:12]];

            UILabel *specLabel = [[UILabel alloc] init];
            [specLabel setFont:[UIFont systemFontOfSize:12]];

            UILabel *volLabel = [[UILabel alloc] init];
            [volLabel setFont:[UIFont systemFontOfSize:12]];

            UILabel *feathLabel = [[UILabel alloc] init];
            [feathLabel setFont:[UIFont systemFontOfSize:12]];

//            UILabel *colorLabel = [[UILabel alloc] init];
//            [colorLabel setFont:[UIFont systemFontOfSize:12]];

            if(itemArray.count == 0 || [itemArray isKindOfClass:[NSNull class]])
            {
                [orderNumLabel setFrame:CGRectMake(10, 5, cellWidth-20, 0)];
                
                [numLabel setFrame:CGRectMake(10, orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height, (cellWidth-20)/3, 0)];
                
                [timeLabel setFrame:CGRectMake(numLabel.frame.origin.x + numLabel.frame.size.width, orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height, (cellWidth-20)/3, 0)];
                
                [priceLabel setFrame:CGRectMake(cellWidth-10-cellWidth/3,  orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height,  (cellWidth-20)/3, 0)];
                
                [specLabel setFrame:CGRectMake(10, numLabel.frame.origin.y + numLabel.frame.size.height, (cellWidth-20)/2, 0)];
                
                [volLabel setFrame:CGRectMake(specLabel.frame.origin.x + specLabel.frame.size.width, timeLabel.frame.origin.y + timeLabel.frame.size.height, (cellWidth-20)/2, 0)];
                
                [feathLabel setFrame:CGRectMake(10, specLabel.frame.origin.y + specLabel.frame.size.height, (cellWidth-20)/2, 0)];
                
//                [colorLabel setFrame:CGRectMake(feathLabel.frame.origin.x + feathLabel.frame.size.width, volLabel.frame.origin.y + volLabel.frame.size.height, (cellWidth-20)/2, 0)];
            }
            else
            {
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[itemArray objectAtIndex:indexPath.row]];
                if([[dic allKeys] count] == 0 || [dic isKindOfClass:[NSNull class]])
                {
                    [orderNumLabel setFrame:CGRectMake(10, 5, cellWidth-20, 0)];
                    
                    [numLabel setFrame:CGRectMake(10, orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height, (cellWidth-20)/3, 0)];

                    [timeLabel setFrame:CGRectMake(numLabel.frame.origin.x + numLabel.frame.size.width, orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height, (cellWidth-20)/3, 0)];

                    [priceLabel setFrame:CGRectMake(cellWidth-10-cellWidth/3,  orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height,  (cellWidth-20)/3, 0)];

                    [specLabel setFrame:CGRectMake(10, numLabel.frame.origin.y + numLabel.frame.size.height, (cellWidth-20)/2, 0)];

                    [volLabel setFrame:CGRectMake(specLabel.frame.origin.x + specLabel.frame.size.width, timeLabel.frame.origin.y + timeLabel.frame.size.height, (cellWidth-20)/2, 0)];

                    [feathLabel setFrame:CGRectMake(10, specLabel.frame.origin.y + specLabel.frame.size.height, (cellWidth-20)/2, 0)];

//                    [colorLabel setFrame:CGRectMake(feathLabel.frame.origin.x + feathLabel.frame.size.width, volLabel.frame.origin.y + volLabel.frame.size.height, (cellWidth-20)/2, 0)];

                }
                else
                {
                    NSString *theModel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"model"]];
                    NSString *theUnit = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unit"]];
                    
                    NSString *theNumber = [NSString stringWithFormat:@"%@",[dic objectForKey:@"num"]];
                    
                    NSString *theTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deliver"]];
                    
                    NSString *thePrice = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"price"],theUnit];
                    
                    NSString *theSpec = [NSString stringWithFormat:@"%@",[dic objectForKey:@"spec"]];
                    
                    NSString *theVol = [NSString stringWithFormat:@"%@",[dic objectForKey:@"voltage"]];
                    
                    NSString *theFeature = [NSString stringWithFormat:@"%@",[dic objectForKey:@"feature"]];
                    
//#pragma mark - color字段没有
//                    NSString *theColor = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                    
                    if(theModel.length == 0 || [theModel isKindOfClass:[NSNull class]])
                    {
                        [orderNumLabel setFrame:CGRectMake(10, 5, cellWidth-20, 0)];
                    }
                    else
                    {
                        [orderNumLabel setFrame:CGRectMake(10, 5, cellWidth-20, 30)];
                        [orderNumLabel setText:[NSString stringWithFormat:@"型号:%@",theModel]];
                    }
                    
                    if(theNumber.length == 0 || [theNumber isKindOfClass:[NSNull class]])
                    {
                        [numLabel setFrame:CGRectMake(10, orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height, (cellWidth-20)/3, 0)];

                    }
                    else
                    {
                        [numLabel setFrame:CGRectMake(10, orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height, (cellWidth-20)/3, 30)];
                        [numLabel setText:[NSString stringWithFormat:@"采购数量: %@%@",theNumber,theUnit]];

                    }
                    
                    if(theTime.length == 0 || [theTime isKindOfClass:[NSNull class]])
                    {
                        [timeLabel setFrame:CGRectMake(numLabel.frame.origin.x + numLabel.frame.size.width, orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height, (cellWidth-20)/3, 0)];
                    }
                    else
                    {
                        [timeLabel setFrame:CGRectMake(numLabel.frame.origin.x + numLabel.frame.size.width, orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height, (cellWidth-20)/3, 30)];
                        [timeLabel setText:[NSString stringWithFormat:@"交货期 %@天",theTime]];

                    }
                    
                    if(thePrice.length == 0 || [thePrice isKindOfClass:[NSNull class]])
                    {
                        [priceLabel setFrame:CGRectMake(cellWidth-10-cellWidth/3,  orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height,  (cellWidth-20)/3, 0)];
                    }
                    else
                    {
                        [priceLabel setFrame:CGRectMake(cellWidth-10-cellWidth/3,   orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height,  (cellWidth-20)/3, 30)];
                        [priceLabel setText:[NSString stringWithFormat:@"¥ %@元%@",thePrice,theUnit]];
                    }
                    
                    if(theSpec.length == 0 || [theSpec isKindOfClass:[NSNull class]])
                    {
                        [specLabel setFrame:CGRectMake(10, numLabel.frame.origin.y + numLabel.frame.size.height, (cellWidth-20)/2, 0)];
                    }
                    else
                    {
                        [specLabel setFrame:CGRectMake(10, numLabel.frame.origin.y + numLabel.frame.size.height, (cellWidth-20)/2, 30)];
                        [specLabel setText:[NSString stringWithFormat:@"规格: %@",theSpec]];
                    }
                    
                    if(theVol.length == 0 || [theVol isKindOfClass:[NSNull class]])
                    {
                        [volLabel setFrame:CGRectMake(specLabel.frame.origin.x + specLabel.frame.size.width, timeLabel.frame.origin.y + timeLabel.frame.size.height, (cellWidth-20)/2, 0)];
                    }
                    else
                    {
                        [volLabel setFrame:CGRectMake(specLabel.frame.origin.x + specLabel.frame.size.width, timeLabel.frame.origin.y + timeLabel.frame.size.height, (cellWidth-20)/2, 30)];
                        [volLabel setText:[NSString stringWithFormat:@"电压: %@",theVol]];
                    }
                    
                    if(theFeature.length == 0 || [theFeature isKindOfClass:[NSNull class]])
                    {
                        [feathLabel setFrame:CGRectMake(10, specLabel.frame.origin.y + specLabel.frame.size.height, (cellWidth-20)/2, 0)];
                    }
                    else
                    {
                        [feathLabel setFrame:CGRectMake(10, specLabel.frame.origin.y + specLabel.frame.size.height, (cellWidth-20)/2, 30)];
                        [feathLabel setText:[NSString stringWithFormat:@"阻燃耐火: %@",theFeature]];
                    }
                    
//                    if(theColor.length == 0 || [theColor isKindOfClass:[NSNull class]])
//                    {
//                        [colorLabel setFrame:CGRectMake(feathLabel.frame.origin.x + feathLabel.frame.size.width, volLabel.frame.origin.y + volLabel.frame.size.height, (cellWidth-20)/2, 0)];
//                    }
//                    else
//                    {
//                        [colorLabel setFrame:CGRectMake(feathLabel.frame.origin.x + feathLabel.frame.size.width, volLabel.frame.origin.y + volLabel.frame.size.height, (cellWidth-20)/2, 30)];
//                        [colorLabel setText:[NSString stringWithFormat:@"外观颜色 %@",theColor]];
//                    }
                }
            }
            

            
            [cell.contentView addSubview:orderNumLabel];
            [cell.contentView addSubview:numLabel];
            [cell.contentView addSubview:timeLabel];
            [cell.contentView addSubview:priceLabel];
            [cell.contentView addSubview:specLabel];
            [cell.contentView addSubview:volLabel];
            [cell.contentView addSubview:feathLabel];
//            [cell.contentView addSubview:colorLabel];
        }
        else
        {
            
        }
    }
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
