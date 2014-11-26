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
#import "MyNormalInquiryDetailController.h"

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
    NSMutableArray *upTimeLabelArray;  //提交时间数组
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
    NSString *string = [NSString stringWithFormat:@"%@%@",@"InquiryList",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&pagesize=%d&pageindex=%d",token,[self getMemberId],pageSize,intPage];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLInquiryListTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/InquiryList.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
    
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    NSLog(@"dicRespon = %@",[[dicRespon objectForKey:@"ctems"] objectAtIndex:0]);
    if(URLTag == URLInquiryListTag)
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
                [dataArray addObjectsFromArray:[B2BMyInquiryListNormalData getListArray:[dicRespon objectForKey:@"ctems"]]];
                
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
            [lookBtn setFrame:CGRectMake(ScreenWidth-50, 5, 40, 30)];
            [lookBtn setTag:i];
            [lookBtn addTarget:self action:@selector(lookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [lookBtnArray addObject:lookBtn];
            
            NSString *upTime = [[dataArray objectAtIndex:i] time];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 250, 30)];
            [label setText:[NSString stringWithFormat:@" 提交时间:%@",upTime]];
            [label setFont:[UIFont systemFontOfSize:13]];
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
    return [[[dataArray objectAtIndex:section] myItems] count] + 1;
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
    NSArray *myItems = [NSArray arrayWithArray:[[dataArray objectAtIndex:indexPath.section] myItems]];
    if(indexPath.row < myItems.count)
    {
        CGSize size_Kind;
        NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[myItems objectAtIndex:indexPath.row]];
        
        NSString *firtKind = [NSString stringWithFormat:@"%@",[dic objectForKey:@"firstType"]];
        NSString *secondKind = [NSString stringWithFormat:@"%@",[dic objectForKey:@"secondType"]];
        NSString *thirdKind = [NSString stringWithFormat:@"%@",[dic objectForKey:@"thridType"]];
        NSString *kind = [NSString stringWithFormat:@"%@%@%@",firtKind,secondKind,thirdKind];
        if(kind.length == 0 || [kind isKindOfClass:[NSNull class]])
        {
            size_Kind = CGSizeMake(10, 30);
        }
        else
        {
            size_Kind = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:kind WithSize:CGSizeMake(ScreenWidth-65, MAXFLOAT)];
        }
        //        if(size_Kind.height <= 30)
        //        {
        //            return 70;
        //        }
        return size_Kind.height+40;
    }
    else
    {
        return 40;
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
        
        NSArray *myItems = [NSArray arrayWithArray:[[dataArray objectAtIndex:indexPath.section] myItems]];
        
        if(indexPath.row < myItems.count)
        {
            //        [cell.textLabel setText:[NSString stringWithFormat:@"cell%d%d",indexPath.section*10,indexPath.row*10]];
            NSString *model = nil;
            CGSize size_model;
            
            NSString *unitString = nil;
            CGSize size_unitString;
            
            NSString *priceString = nil;
            CGSize size_priceString;
            
            
            NSString *kind = nil;
            CGSize size_Kind;
            
            if(myItems.count == 0 || [myItems isKindOfClass:[NSNull class]])
            {
                model = @"";
                size_model = CGSizeMake(10, 30);
                
                unitString = @"";
                size_unitString = CGSizeMake(cell.contentView.frame.size.width-40, 30);
                
                priceString = @"";
                size_priceString = CGSizeMake(cell.contentView.frame.size.width-70, 30);
                
                kind = @"";
                size_Kind = CGSizeMake(cell.contentView.frame.size.width-20, 30);
            }
            else
            {
                NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[myItems objectAtIndex:indexPath.row]];
                
                model = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquiryModel"]];
                
                if(model.length == 0 || [model isKindOfClass:[NSNull class]])
                {
                    size_model = CGSizeMake(40, 30);
                }
                else
                {
                    size_model = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:model WithSize:CGSizeMake(MAXFLOAT, 30)];
                }
                
                unitString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unit"]];
                
                if(unitString.length == 0 || [unitString isKindOfClass:[NSNull class]])
                {
                    size_unitString = CGSizeMake(30, 30);
                }
                else
                {
                    size_unitString = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:unitString WithSize:CGSizeMake(MAXFLOAT, 30)];
                }
                
                priceString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];
                
                if(priceString.length == 0 || [priceString isKindOfClass:[NSNull class]])
                {
                    size_priceString = CGSizeMake(30, 30);
                }
                else
                {
                    size_priceString = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:priceString WithSize:CGSizeMake(MAXFLOAT, 30)];
                }
                
                NSString *firtKind = [NSString stringWithFormat:@"%@",[dic objectForKey:@"firstType"]];
                NSString *secondKind = [NSString stringWithFormat:@"%@",[dic objectForKey:@"secondType"]];
                NSString *thirdKind = [NSString stringWithFormat:@"%@",[dic objectForKey:@"thridType"]];
                kind = [NSString stringWithFormat:@"%@%@%@",firtKind,secondKind,thirdKind];
                if(kind.length == 0 || [kind isKindOfClass:[NSNull class]])
                {
                    size_Kind = CGSizeMake(10, 30);
                }
                else
                {
                    size_Kind = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:kind WithSize:CGSizeMake(cell.contentView.frame.size.width-65, MAXFLOAT)];
                }
                
            }
            UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size_model.width+40, 30)];
            if(model.length == 0 || [model isKindOfClass:[NSNull class]])
            {
                //                [modelLabel setText:[NSString stringWithFormat:@"%@",model]];
            }
            else
            {
                //                [modelLabel setText:[NSString stringWithFormat:@"型号:%@",model]];
            }
            [modelLabel setText:[NSString stringWithFormat:@"型号:%@",model]];
            [modelLabel setFont:[UIFont systemFontOfSize:12]];
            [cell.contentView addSubview:modelLabel];
            
            UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-10-size_unitString.width-20, 5, size_unitString.width+20, 30)];
            if(unitString.length == 0 || [unitString isKindOfClass:[NSNull class]])
            {
                [unitLabel setText:unitString];
            }
            else
            {
                [unitLabel setText:[NSString stringWithFormat:@"元/%@",unitString]];
            }
            [unitLabel setFont:[UIFont systemFontOfSize:12]];
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-10-unitLabel.frame.size.width-size_priceString.width-20, 5, size_priceString.width+20, 30)];
            if(priceString.length == 0 || [priceString isKindOfClass:[NSNull class]])
            {
                [priceLabel setText:priceString];
            }
            else
            {
                [priceLabel setText:[NSString stringWithFormat:@"¥%@",priceString]];
            }
            [priceLabel setTextColor:[UIColor redColor]];
            [priceLabel setFont:[UIFont systemFontOfSize:12]];
            
            if([[[dataArray objectAtIndex:indexPath.section] status] isEqualToString:@"4"] || [[[dataArray objectAtIndex:indexPath.section] status] isEqualToString:@"6"])
            {
                //                [priceLabel setHidden:YES];
                //                [unitLabel setHidden:YES];
            }
            else
            {
                [cell.contentView addSubview:priceLabel];
                [cell.contentView addSubview:unitLabel];
            }
            
            UILabel *kindLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, modelLabel.frame.origin.y+modelLabel.frame.size.height, cell.contentView.frame.size.width-65, size_Kind.height)];
            [kindLabel setFont:[UIFont systemFontOfSize:12]];
            [kindLabel setText:kind];
            [kindLabel setNumberOfLines:0];
            [cell.contentView addSubview:kindLabel];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, kindLabel.frame.origin.y, 40, kindLabel.frame.size.height)];
            [label setText:@"分类:"];
            [label setFont:[UIFont systemFontOfSize:12]];
            [cell.contentView addSubview:label];
        }
        if(indexPath.row == myItems.count)
        {
            UILabel *firstLabel = (UILabel *)[upTimeLabelArray objectAtIndex:indexPath.section];
            [firstLabel setTag:10];
            [cell.contentView addSubview:firstLabel];
            
            UIButton *lookBtn = (UIButton *)[lookBtnArray objectAtIndex:indexPath.section];
            [lookBtn setTag:11];
            [cell.contentView addSubview:lookBtn];
        }
        
        
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyNormalInquiryDetailController *myNormalInquiryDetailController = [self.storyboard instantiateViewControllerWithIdentifier:@"myNormalInquiryDetailController"];
    
    B2BMyInquiryListNormalData *data = (B2BMyInquiryListNormalData *)[dataArray objectAtIndex:indexPath.section];
    
    if([self.delegate respondsToSelector:@selector(pushToNextVC:WithData:)])
    {
        [self.delegate pushToNextVC:myNormalInquiryDetailController WithData:data];
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
