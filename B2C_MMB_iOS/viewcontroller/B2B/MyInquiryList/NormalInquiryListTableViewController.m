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
    
//    [self loadRequest];
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
            UILabel *lookLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-50, 5, 40, 30)];
            [lookLabel setText:@"查看"];
            [lookLabel setFont:[UIFont systemFontOfSize:13]];
            [lookLabel setTextColor:MYCOLOR];
            [lookLabel setTextAlignment:NSTextAlignmentRight];
            [lookBtnArray addObject:lookLabel];
            
            NSString *upTime = [[dataArray objectAtIndex:i] time];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 250, 30)];
            [label setText:[NSString stringWithFormat:@"提交时间:%@",upTime]];
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
    return [[[dataArray objectAtIndex:section] myItems] count]+1;
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
        NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[myItems objectAtIndex:indexPath.row]];
        NSString *firtKind = [NSString stringWithFormat:@"%@",[dic objectForKey:@"firstType"]];
        NSString *secondKind = [NSString stringWithFormat:@"%@",[dic objectForKey:@"secondType"]];
        NSString *thirdKind = [NSString stringWithFormat:@"%@",[dic objectForKey:@"thridType"]];
        NSString *kind = [NSString stringWithFormat:@"分类: %@%@%@",firtKind,secondKind,thirdKind];
        
        CGSize kindSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:kind WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
        CGFloat kindSizeHeight = 0.0;
        if(kindSize.height <= 30)
        {
            kindSizeHeight = 30;
        }
        else
        {
            kindSizeHeight = kindSize.height;
        }
        
        return kindSizeHeight+40;
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
    [view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    
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

            NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[myItems objectAtIndex:indexPath.row]];
            
            NSString *model = [NSString stringWithFormat:@"型号: %@",[dic objectForKey:@"inquiryModel"]];
            NSMutableAttributedString *myModel = [[NSMutableAttributedString alloc] initWithString:model];
            [myModel addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [myModel addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, model.length-3)];
            UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 30)];
            [modelLabel setAttributedText:myModel];
            [modelLabel setFont:[UIFont systemFontOfSize:12]];
            [cell.contentView addSubview:modelLabel];
            
            
            NSString *firtKind = [NSString stringWithFormat:@"%@",[dic objectForKey:@"firstType"]];
            NSString *secondKind = [NSString stringWithFormat:@"%@",[dic objectForKey:@"secondType"]];
            NSString *thirdKind = [NSString stringWithFormat:@"%@",[dic objectForKey:@"thridType"]];
            NSString *kind = [NSString stringWithFormat:@"分类: %@%@%@",firtKind,secondKind,thirdKind];
            NSString *finalKind = nil;
            if([kind rangeOfString:@"(null)"].location != NSNotFound)
            {
                finalKind = [kind stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                finalKind = [kind stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"(null)"]];
            }
            else if([kind rangeOfString:@"null"].location != NSNotFound)
            {
                finalKind = [kind stringByReplacingOccurrencesOfString:@"null" withString:@""];
                finalKind = [kind stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"null"]];
            }
            else
            {
                finalKind = kind;
            }
            NSMutableAttributedString *finalKind_1 = [[NSMutableAttributedString alloc] initWithString:finalKind];
            [finalKind_1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [finalKind_1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, finalKind.length-3)];
            
            CGSize kindSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:kind WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
            CGFloat kindSizeHeight = 0.0;
            if(kindSize.height <= 30)
            {
                kindSizeHeight = 30;
            }
            else
            {
                kindSizeHeight = kindSize.height;
            }
            UILabel *kindlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, modelLabel.frame.origin.y+modelLabel.frame.size.height, ScreenWidth-20, kindSizeHeight)];
            [kindlabel setFont:[UIFont systemFontOfSize:12]];
            [kindlabel setNumberOfLines:0];
            [kindlabel setAttributedText:finalKind_1];
            [cell.contentView addSubview:kindlabel];
            
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
    if(!dataArray || dataArray.count == 0)
    {
        return;
    }
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
