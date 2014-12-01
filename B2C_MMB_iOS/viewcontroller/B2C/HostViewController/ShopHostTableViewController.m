//
//  ShopHostTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-26.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "ShopHostTableViewController.h"
#import "DCFTopLabel.h"
#import "DCFConnectionUtil.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "UIImageView+WebCache.h"
#import "DCFCustomExtra.h"
#import "B2CGoodsListData.h"
#import "DCFCustomExtra.h"
#import "GoodsDetailViewController.h"
#import "DCFStringUtil.h"

@interface ShopHostTableViewController ()
{
    NSMutableArray *dataArray;
    
    DCFChenMoreCell *moreCell;
    int intPage; //页数
    int intTotal; //总数
    int pageSize; //每页条数
    
    BOOL _reloading;
    
    NSArray *scoreArray;
    
    NSArray *typeArray;
    
    ShopHostPreTableViewController *preVC;
}
@end

@implementation ShopHostTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithHeadTitle:(NSString *) title WithShopId:(NSString *) shopId WithUse:(NSString *) use
{
    if(self = [super init])
    {
        _myTitle = title;
        _shopId = shopId;
        
        shopUse = use;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];

    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装馆频道"];
    self.navigationItem.titleView = top;
    
    intPage = 1;
    
    dataArray = [[NSMutableArray alloc] init];
    
    //ADD REFRESH VIEW
    _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -300, 320, 300)];
    [self.refreshView setDelegate:self];
    [self.tableView addSubview:self.refreshView];
    [self.refreshView refreshLastUpdatedDate];
    
    [self loadRequest:_shopId WithUse:shopUse];
    

}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    if([NSStringFromClass([touch.view class]) isEqualToString:@"DCFNavigationBar"])
    {
        [self preViewTap];
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
//    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITabBarButton"])
//    {
//        return NO;
//    }
    return  YES;
}

- (void) preViewTap
{
    if(preVC)
    {
        [preVC.view removeFromSuperview];
        preVC.view = nil;
        
        [preVC removeFromParentViewController];
        preVC = nil;
    }
    if(preView)
    {
        [preView removeFromSuperview];
        preView = nil;
    }
}

- (void) loadRequest:(NSString *) shopId WithUse:(NSString *) use
{
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [HUD setDelegate:self];
//    [HUD setLabelText:@"正在登陆....."];
    
    pageSize = 10;
//    intPage = 1;
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductList",time];
    
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"use=%@&seq=%@&model=%@&brand=%@&shopid=%@&token=%@&pagesize=%d&pageindex=%d",use,@"",@"",@"",_shopId,token,pageSize,intPage];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getProductList.html?"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2CGoodsListTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(dataArray.count == 0)
    {
        return 43;
    }
    int row = dataArray.count%2 + dataArray.count/2;

    
    if(indexPath.row <= row - 1)
    {
        for(int i=0;i<2;i++)
        {
            int n = indexPath.row*2 + i;
            if(n <= dataArray.count-1)
            {
                NSString *str_1 = [[dataArray objectAtIndex:n] productName];
                CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str_1 WithSize:CGSizeMake(125, MAXFLOAT)];
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, 125, size_1.height)];
                [nameLabel setText:str_1];
                [nameLabel setFont:[UIFont systemFontOfSize:12]];
                [nameLabel setNumberOfLines:0];
                
                NSString *str_2 = [[dataArray objectAtIndex:n] productPrice];
                CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:str_2 WithSize:CGSizeMake(125, MAXFLOAT)];
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.frame.origin.y+nameLabel.frame.size.height+10, 125, size_2.height)];
                [priceLabel setText:str_2];
                [priceLabel setFont:[UIFont systemFontOfSize:13]];
                
                return 125+size_1.height+size_2.height+5+20;
            }
        }
    }
//    else
//    {
        return 43;
//    }
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    
    if(URLTag == URLB2CGoodsListTag)
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
                [dataArray addObjectsFromArray:[B2CGoodsListData getListArray:[dicRespon objectForKey:@"items"]]];
                
                scoreArray = [[NSArray alloc] initWithArray:[dicRespon objectForKey:@"score"]];
                
                intTotal = [[dicRespon objectForKey:@"total"] intValue];
                NSLog(@"total = %d",intTotal);
                if(intTotal == 0)
                {
                    [moreCell noDataAnimation];
                }
                else
                {
                    [moreCell stopAnimation];
                }
                intPage++;
                
                NSString *time = [DCFCustomExtra getFirstRunTime];
                
                NSString *string = [NSString stringWithFormat:@"%@%@",@"getShopProductType",time];
                
                NSString *token = [DCFCustomExtra md5:string];
                
                NSString *pushString = [NSString stringWithFormat:@"token=%@&shopid=%@",token,_shopId];
                
                NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getShopProductType.html?"];

                conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2CGetShopProductTypeTag delegate:self];
                [conn getResultFromUrlString:urlString postBody:pushString method:POST];
            }
            else
            {
                [moreCell failAcimation];
            }
        }
        
        [self.tableView reloadData];
        
    }
    if(URLTag == URLB2CGetShopProductTypeTag)
    {
        if(result == 1)
        {
            typeArray = [[NSArray alloc] initWithArray:[dicRespon objectForKey:@"types"]];
        }
        else
        {
            
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [headView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250, 40)];
    [headLabel setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [headLabel setText:[NSString stringWithFormat:@"   %@",_myTitle]];
    [headLabel setTextColor:MYCOLOR];
    [headLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [headView addSubview:headLabel];
    
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [preBtn setFrame:CGRectMake(320-40, 5, 30, 30)];
    [preBtn setBackgroundImage:[UIImage imageNamed:@"Set.png"] forState:UIControlStateNormal];
    [preBtn addTarget:self action:@selector(preBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:preBtn];
    
    return headView;
}

- (void) preBtnClick:(UIButton *) sender
{
    if(!scoreArray || scoreArray.count == 0 || !typeArray || typeArray.count == 0)
    {
        [DCFStringUtil showNotice:@"数据正在读取中"];
        return;
    }
    else
    {
        intPage = 1;

        preView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, ScreenHeight)];
        [preView setBackgroundColor:[UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:0.6]];
        [self.view.window addSubview:preView];
        
        preVC = [[ShopHostPreTableViewController alloc] initWithScoreArray:scoreArray WithListArray:typeArray WithTitle:_myTitle];
        preVC.delegate = self;
        [preVC.view setFrame:CGRectMake(preView.frame.size.width-200, 0, 200, preView.frame.size.height)];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preViewTap)];
        [tap setDelegate:self];
        [self.view addGestureRecognizer:tap];

        
        [preView addSubview:preVC.view];
        [self addChildViewController:preVC];
    }
}



#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray.count == 0)
    {
        return 1;
    }
    else
    {
        int row = dataArray.count%2 + dataArray.count/2;
        if ((intPage-1)*pageSize < intTotal )
        {
            return row+1;
        }
        return row;
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
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
            [cell setSelectionStyle:0];
        }
        while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
            [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
        }
        for(int i=0;i<2;i++)
        {
            int n = indexPath.row*2 + i;
            if(n <= dataArray.count-1)
            {
                UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(20+155*i, 10, 125, 125)];
                [cellView setTag:n];
                [cell.contentView addSubview:cellView];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                [cellView addGestureRecognizer:tap];
                
                NSString *picUrl = [[dataArray objectAtIndex:n] p1Path];
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
                [iv setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"magnifying glass.png"]];
                [cellView addSubview:iv];
                
                NSString *str_1 = [[dataArray objectAtIndex:n] productName];
                CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str_1 WithSize:CGSizeMake(125, MAXFLOAT)];
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, 125, size_1.height)];
                [nameLabel setText:str_1];
                [nameLabel setFont:[UIFont systemFontOfSize:12]];
                [nameLabel setNumberOfLines:0];
                [cellView addSubview:nameLabel];
                
                NSString *str_2 = [[dataArray objectAtIndex:n] productPrice];
                CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:str_2 WithSize:CGSizeMake(125, MAXFLOAT)];
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.frame.origin.y+nameLabel.frame.size.height+5, 125, size_2.height)];
                [priceLabel setText:str_2];
                [priceLabel setFont:[UIFont systemFontOfSize:13]];
                [priceLabel setTextColor:[UIColor redColor]];
                [cellView addSubview:priceLabel];
            }
        }

        
        return cell;
    }
    return nil;
}

#pragma mark - 筛选代理
- (void) pushText:(NSString *)text
{
    shopUse = text;
    if(text.length == 0)
    {
        
    }
    else
    {
        if(dataArray && dataArray.count != 0)
        {
            [dataArray removeAllObjects];
        }
        [self.tableView reloadData];
        [self loadRequest:_shopId WithUse:shopUse];
    }
    [self preViewTap];
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    int tag = [[sender view] tag];

    NSString *productId = [[dataArray objectAtIndex:tag] productId];
    GoodsDetailViewController *detail = [[GoodsDetailViewController alloc] initWithProductId:productId];
    [self.navigationController pushViewController:detail animated:YES];
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
                    [self loadRequest:_shopId WithUse:shopUse];
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
    
    [self.refreshView egoRefreshScrollViewDidScroll:self.tableView];
}
//
#pragma mark -
#pragma mark DATA SOURCE LOADING / RELOADING METHODS
- (void)reloadViewDataSource
{
    
    _reloading = YES;
    intPage = 1;
    [self loadRequest:_shopId WithUse:shopUse];
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
