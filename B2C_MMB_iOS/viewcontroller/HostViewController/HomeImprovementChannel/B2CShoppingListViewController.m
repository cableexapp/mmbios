//
//  B2CShoppingListViewController.m
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-16.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import "B2CShoppingListViewController.h"
#import "DCFTopLabel.h"
#import "DCFConnectionUtil.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "UIImageView+WebCache.h"
#import "DCFCustomExtra.h"
#import "AppDelegate.h"
#import "B2CGoodsListData.h"
#import "DCFCustomExtra.h"

@interface B2CShoppingListViewController ()
{
    NSMutableArray *dataArray;

    DCFChenMoreCell *moreCell;
    int intPage; //页数
    int intTotal; //总数
    int pageSize; //每页条数
    
    BOOL _reloading;
    
    NSMutableArray *btnArray;
    
    UIButton *searchBtn;
    
    UIView *searchView;  //搜索试图
    B2CShoppingSearchViewController *search;
}
@end

@implementation B2CShoppingListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithUse:(NSString *) string
{
    if(self = [super init])
    {
        _use = string;
    }
    return self;
}

- (void) searchBtnClick:(UIButton *) sender
{
    NSLog(@"筛选");
    
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    [btn setUserInteractionEnabled:YES];
    
    if(!searchView)
    {
        searchView = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 200, ScreenHeight-60)];
//        [searchView setBackgroundColor:[UIColor redColor]];
        [self.view addSubview:searchView];
    }
    if(!search)
    {
        search = [[B2CShoppingSearchViewController alloc] init];
        [self addChildViewController:search];
//        [search.view setBackgroundColor:[UIColor redColor]];
        search.view.frame = searchView.bounds;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    
    [searchView setFrame:CGRectMake(100, 0, 220, ScreenHeight-60)];
    [searchView addSubview:search.view];
    [UIView commitAnimations];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
    if(HUD)
    {
        [HUD hide:YES];
    }
    if(moreCell)
    {
        [moreCell stopAnimation];
    }
}

- (void) selectBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    int tag = btn.tag;
    for(int i = 0;i < btnArray.count; i++)
    {
        UIButton *b = (UIButton *)[btnArray objectAtIndex:i];
        if(i == tag)
        {
            _seq = b.titleLabel.text;
            if(dataArray.count != 0)
            {
                [dataArray removeAllObjects];
            }
            intPage = 1;
            
            //价格product_price  销量:sale_num

            if(i == 0)
            {
                _seq = @"";
            }
            if(i == 1)
            {
                _seq = @"product_price";
            }
            if(i == 2)
            {
                _seq = @"sale_num";
            }
            [self loadRequest:_seq];
        }
        else
        {
            [b setSelected:NO];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装馆频道"];
    self.navigationItem.titleView = top;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 321, 40)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
    
    for(int i=0;i<2;i++)
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0+39*i, 320, 1)];
        [lineView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        [topView addSubview:lineView];
    }
    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 1, 270, 38)];
    [searchTextField setDelegate:self];
    [searchTextField setPlaceholder:@"搜索家装馆内电线型号,电线品牌等"];
    [searchTextField setBackgroundColor:[UIColor whiteColor]];
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 40, 38)];
    [leftView setImage:[UIImage imageNamed:@"magnifying glass.png"]];
    [searchTextField setLeftView:leftView];
    [searchTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.view addSubview:searchTextField];
    
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(searchTextField.frame.origin.x + searchTextField.frame.size.width, 5, 40, 30)];
    [searchBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    searchBtn.layer.borderWidth = 1.0f;
    searchBtn.layer.borderColor = [UIColor blueColor].CGColor;
    searchBtn.layer.masksToBounds = YES;
    [searchBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:searchBtn];
    
    selectBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height, 320, 40)];
    [selectBtnView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
    [self.view addSubview:selectBtnView];
    
    btnArray = [[NSMutableArray alloc] init];
    for(int i=0;i<3;i++)
    {
        UIButton *selctBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selctBtn setFrame:CGRectMake(10 + 100*i, 5, 100, 30)];
        switch (i)
        {
            case 0:
                [selctBtn setTitle:@"相关度" forState:UIControlStateNormal];
                break;
            case 1:
                [selctBtn setTitle:@"价格" forState:UIControlStateNormal];
                break;
            case 2:
                [selctBtn setTitle:@"销量" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        [selctBtn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [selctBtn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor blueColor] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        
        [selctBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [selctBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [selctBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [selctBtn setTag:i];
        
        selctBtn.layer.borderColor = [UIColor blueColor].CGColor;
        selctBtn.layer.borderWidth = 1.0f;
        selctBtn.layer.masksToBounds = YES;
        
        [selectBtnView addSubview:selctBtn];
        [btnArray addObject:selctBtn];
    }
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, selectBtnView.frame.origin.y + selectBtnView.frame.size.height, 320, ScreenHeight - 80 - 64) style:0];
    [tv setDelegate:self];
    [tv setDataSource:self];
    [tv setShowsVerticalScrollIndicator:NO];
    [tv setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:tv];
   
    
    intPage = 1;
    
    dataArray = [[NSMutableArray alloc] init];

    //ADD REFRESH VIEW
    _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -300, 320, 300)];
    [self.refreshView setDelegate:self];
    [tv addSubview:self.refreshView];
    [self.refreshView refreshLastUpdatedDate];
    
    _seq = @"";
    [self loadRequest:_seq];
    

    
}

- (void) loadRequest:(NSString *) seq
{
    
    
    pageSize = 10;

    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductList",time];
    
    NSString *s = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"use=%@&seq=%@&model=%@&brand=%@&shopid=%@&token=%@&pagesize=%d&pageindex=%d",_use,_seq,@"",@"",@"",s,pageSize,intPage];
    
    NSLog(@"%@",pushString);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getProductList.html?"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2CGoodsListTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
}


- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLB2CGoodsListTag)
    {
        if(_reloading == YES)
        {
            [self doneLoadingViewData];
        }
        else if(_reloading == NO)
        {
            
        }
        NSLog(@"dic = %@",dicRespon);
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
                [dataArray addObjectsFromArray:[B2CGoodsListData getListArray:[dicRespon objectForKey:@"items"]]];
                
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
   
        [tv reloadData];

    }
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == searchTextField)
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(dataArray.count == 0)
    {
        return 43;
    }
    if(indexPath.row <= dataArray.count - 1)
    {
        NSString *content = [[dataArray objectAtIndex:indexPath.row] productName];
        CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont boldSystemFontOfSize:15] WithText:content WithSize:CGSizeMake(220, MAXFLOAT)];

        
        CGFloat h = size_1.height + 30;
        
        if(h <= 60)
        {
            return 80;
        }
        else
        {
            return size_1.height + 30 + 20;
        }
    }
    else
    {
        return 43;
    }
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray.count == 0)
    {
        return 1;
    }
    else
    {
        if ((intPage-1)*pageSize < intTotal )
        {
            return dataArray.count+1;
        }
        return dataArray.count;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == dataArray.count)
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
    else
    {
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        }
        while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
        {
            [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
        }
        
        if(indexPath.row == 0)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            [view setBackgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:view];
        }
        
        
        NSString *content = [[dataArray objectAtIndex:indexPath.row] productName];
        CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont boldSystemFontOfSize:15] WithText:content WithSize:CGSizeMake(220, MAXFLOAT)];
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 220, size_1.height)];
        [contentLabel setText:content];
        [contentLabel setNumberOfLines:0];
        [contentLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [contentLabel setTextAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:contentLabel];
        
        NSString *price = [NSString stringWithFormat:@"¥ %@",[[dataArray objectAtIndex:indexPath.row] productPrice]];
        CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:price WithSize:CGSizeMake(MAXFLOAT, 30)];
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y + contentLabel.frame.size.height, size_2.width, 30)];
        [priceLabel setText:price];
        [priceLabel setFont:[UIFont systemFontOfSize:12]];
        [priceLabel setTextAlignment:NSTextAlignmentLeft];
        [priceLabel setTextColor:[UIColor redColor]];
        [cell.contentView addSubview:priceLabel];
        
        
        NSString *saleOut = [NSString stringWithFormat:@"%@%@",@"已售出",[[dataArray objectAtIndex:indexPath.row] saleNum]];
        CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:saleOut WithSize:CGSizeMake(MAXFLOAT, 30)];
        UILabel *saleOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-10-size_3.width, priceLabel.frame.origin.y, size_3.width, 30)];
        [saleOutLabel setText:saleOut];
        [saleOutLabel setFont:[UIFont systemFontOfSize:12]];
        [saleOutLabel setTextAlignment:NSTextAlignmentLeft];
        [saleOutLabel setTextColor:[UIColor blackColor]];
        [cell.contentView addSubview:saleOutLabel];
        
        
        UIImageView *cellIv = [[UIImageView alloc] init];
        if(size_1.height + 30 <= 60)
        {
            [cellIv setFrame:CGRectMake(10, 10, 60, 60)];
        }
        else
        {
            [cellIv setFrame:CGRectMake(10, (size_1.height+30+20)/2 - 30, 60, 60)];
        }
        NSString *picUrl = [[dataArray objectAtIndex:indexPath.row] p1Path];
        
        [cellIv setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"magnifying glass.png"]];
        [cell.contentView addSubview:cellIv];
        
        return cell;
    }
    return nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    if (tv == (UITableView *)scrollView)
    {
        if (scrollView.contentSize.height > 0 && (scrollView.contentSize.height-scrollView.frame.size.height)>0)
        {
            if (scrollView.contentOffset.y >= scrollView.contentSize.height-scrollView.frame.size.height)
            {
                if ((intPage-1) * pageSize < intTotal )
                {
                    [self loadRequest:_seq];
                }
            }
        }
    }
}
//
//
//
//#pragma mark -
//#pragma mark SCROLLVIEW DELEGATE METHODS
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.refreshView egoRefreshScrollViewDidScroll:tv];
}
//
#pragma mark -
#pragma mark DATA SOURCE LOADING / RELOADING METHODS
- (void)reloadViewDataSource
{
    
    _reloading = YES;
    intPage = 1;
    [self loadRequest:_seq];
}
//
- (void)doneLoadingViewData
{
    
    _reloading = NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:tv];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
