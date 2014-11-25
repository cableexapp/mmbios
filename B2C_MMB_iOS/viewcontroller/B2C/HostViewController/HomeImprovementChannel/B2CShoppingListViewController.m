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
#import "GoodsDetailViewController.h"
#import "SearchViewController.h"

#pragma mark - 少一个total字段,筛选部分
@interface B2CShoppingListViewController ()
{
    NSMutableArray *dataArray;
    
    NSMutableArray *phoneDescribeArray; //商品网址链接
    
    DCFChenMoreCell *moreCell;
    int intPage; //页数
    int intTotal; //总数
    int pageSize; //每页条数
    
    BOOL _reloading;
    
    UIView *backView;
    UIView * lineView_2;
    UIView * lineView_3;
    UIView * lineView_4;

    NSMutableArray *buttonLineViewArray;  //底部3条下滑线数组
    
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
        
        flag = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view tag] == 101 )
        {
            [view setHidden:YES];
        }
    }
}

#pragma mark - delegate
- (void) requestStringWithUse:(NSString *)myUse WithBrand:(NSString *)myBrand WithSpec:(NSString *)mySpec WithModel:(NSString *)myModel WithSeq:(NSString *)mySeq
{
    flag = NO;
    
    delegateMyUse = myUse;
    delegateMyBrand = myBrand;
    delegateMySpec = mySpec;
    delegateMyModel = myModel;
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductListByCondition",time];
    NSString *token = [DCFCustomExtra md5:string];
    
//    intPage = 1;
    pageSize = 10;

    NSString *pushString = [NSString stringWithFormat:@"pagesize=%d&pageindex=%d&token=%@&use=%@&model=%@&spec=%@&brand=%@&seq=%@",pageSize,intPage,token,delegateMyUse,delegateMyModel,delegateMySpec,delegateMyBrand,_seq];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2CGoodsListTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getProductListByCondition.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    [moreCell startAnimation];
}

- (void) searchBtnClick:(UIButton *) sender
{
    
    for(int i=0;i<btnArray.count;i++)
    {
        UIButton *selectBtn = [btnArray objectAtIndex:i];
        if(i == 0)
        {
            [selectBtn setSelected:YES];
        }
        else
        {
            [selectBtn setSelected:NO];
        }
    }
    
//    UIButton *btn = (UIButton *) sender;
//    btn.selected = !btn.selected;
//    [btn setUserInteractionEnabled:YES];
    
    _seq = @"";
    intPage = 1;
//    [self loadRequest:_seq WithUse:_use];
    
    //    if(!searchView)
    //    {
    
//    backView = [[UIView alloc] init];
//    backView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    backView.alpha = 0.6;
//    backView.hidden = NO;
//    backView.backgroundColor = [UIColor lightGrayColor];
//    [self.view insertSubview:backView aboveSubview:tv];

    searchView = [[UIView alloc] init];
    [searchView setFrame:CGRectMake(70, 50, ScreenWidth-40, ScreenHeight)];
    [searchView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:searchView];
    
    
    
    //    }
    //    if(!search)
    //    {
    
    //    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    search = [[B2CShoppingSearchViewController alloc] initWithFrame:searchView.bounds];
    search.delegate = self;
    [self addChildViewController:search];
    [searchView addSubview:search.view];
   
    
    
    [UIView commitAnimations];
    [search addHeadView];
    
    
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
    flag = YES;
}

- (void) selectBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    int tag = btn.tag;
    
    NSLog(@"tag = %d",tag);
    
    for(UIView *view in buttonLineViewArray)
    {
        if(view.tag == tag)
        {
            [view setHidden:NO];
        }
        else
        {
            [view setHidden:YES];
        }
    }
    
    
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
            if(flag == YES)
            {
                [self loadRequest:_seq WithUse:_use];
            }
            else
            {
                [self requestStringWithUse:delegateMyUse WithBrand:delegateMyBrand WithSpec:delegateMySpec WithModel:delegateMyModel WithSeq:_seq];
            }
        }
        else
        {
            [b setSelected:NO];
        }
    }
}

- (void) hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装馆频道"];
    self.navigationItem.titleView = top;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 321, 40)];
    [topView setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
    [self.view addSubview:topView];
    
    for(int i=0;i<2;i++)
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0+39*i, 320, 1)];
        [lineView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        [topView addSubview:lineView];
    }
    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 10, 265, 34)];
    [searchTextField setDelegate:self];
    [searchTextField setPlaceholder:@"搜索家装馆内电线型号、电线品牌等"];
    [searchTextField setBackgroundColor:[UIColor whiteColor]];
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 40, 38)];
    [leftView setImage:[UIImage imageNamed:@"magnifying glass.png"]];
    [searchTextField setLeftView:leftView];
    [searchTextField setFont:[UIFont systemFontOfSize:12]];
    searchTextField.layer.borderWidth = 0.3;
    searchTextField.layer.cornerRadius = 5;
    [searchTextField setReturnKeyType:UIReturnKeyDone];
    [searchTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.view setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
    [self.view addSubview:searchTextField];
    
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(searchTextField.frame.origin.x + searchTextField.frame.size.width+5, 12, 35, 30)];
    [searchBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    searchBtn.layer.borderWidth = 1.0f;
    searchBtn.layer.borderColor = MYCOLOR.CGColor;
    searchBtn.layer.masksToBounds = YES;
    [searchBtn setTitleColor:MYCOLOR forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:searchBtn];
    
    selectBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height+13, 320, 60)];
    [selectBtnView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:selectBtnView];
    
    btnArray = [[NSMutableArray alloc] init];
    buttonLineViewArray = [[NSMutableArray alloc] init];
    for(int i=0;i<3;i++)
    {
        UIButton *selctBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selctBtn setFrame:CGRectMake(10 + 100*i, 13, 100, 30)];
        switch (i)
        {
            case 0:
                [selctBtn setTitle:@"相关度" forState:UIControlStateNormal];
                [selctBtn setSelected:YES];
        
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
//        [selctBtn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
//        [selctBtn setBackgroundImage:[DCFCustomExtra imageWithColor:MYCOLOR size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        
        [selctBtn setTitleColor:[UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//        [selctBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        if(i == 0)
        {
            //蓝色下划线
            lineView_2 = [[UIView alloc] initWithFrame:CGRectMake(8, selctBtn.frame.origin.y+40, 100, 3)];
            [lineView_2 setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:91.0/255.0 blue:253.0/255.0 alpha:1.0]];
            [selectBtnView addSubview:lineView_2];
            [lineView_2 setTag:0];
            lineView_2.hidden = NO;
            [buttonLineViewArray addObject:lineView_2];

            lineView_3 = [[UIView alloc] initWithFrame:CGRectMake(110, selctBtn.frame.origin.y+40, 100, 3)];
            [lineView_3 setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:91.0/255.0 blue:253.0/255.0 alpha:1.0]];
            [selectBtnView addSubview:lineView_3];
            [lineView_3 setTag:1];
            lineView_3.hidden = YES;
            [buttonLineViewArray addObject:lineView_3];

            lineView_4 = [[UIView alloc] initWithFrame:CGRectMake(215, selctBtn.frame.origin.y+40, 100, 3)];
            [lineView_4 setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:91.0/255.0 blue:253.0/255.0 alpha:1.0]];
            [selectBtnView addSubview:lineView_4];
            [lineView_4 setTag:2];
            lineView_4.hidden = YES;
            [buttonLineViewArray addObject:lineView_4];
        }
        [selctBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [selctBtn setTag:i];
        
         _lineView = [[UIView alloc] initWithFrame:CGRectMake(110, selctBtn.frame.origin.y+5, 1, 20)];
        [_lineView setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
        [selectBtnView addSubview:_lineView];
        
        _lineView_1 = [[UIView alloc] initWithFrame:CGRectMake(207, selctBtn.frame.origin.y+5, 1, 20)];
        [_lineView_1 setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
        [selectBtnView addSubview:_lineView_1];
        
//        selctBtn.layer.borderColor = MYCOLOR.CGColor;
//        selctBtn.layer.borderWidth = 1.0f;
//        selctBtn.layer.masksToBounds = YES;
        
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
    [self loadRequest:_seq WithUse:_use];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == searchTextField)
    {
        [textField resignFirstResponder];
    }
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.searchFlag = [NSString stringWithFormat:@"B2C+%@",searchTextField.text];
    [self.navigationController pushViewController:searchVC animated:YES];
    return YES;
}

- (void) loadRequest:(NSString *) seq WithUse:(NSString *) use
{
    pageSize = 10;
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductList",time];
    
    NSString *s = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"use=%@&seq=%@&model=%@&brand=%@&shopid=%@&token=%@&pagesize=%d&pageindex=%d",use,_seq,@"",@"",@"",s,pageSize,intPage];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getProductList.html?"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2CGoodsListTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
}


- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    phoneDescribeArray = [dicRespon objectForKey:@"items"];
    
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
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
            [cell setSelectionStyle:0];
        }
        while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
        {
            [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
        }
        
        if(indexPath.row == 0)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 3)];
            [view setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
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
        [saleOutLabel setTextColor:[UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0]];
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
        NSLog(@"picUrl = %@",picUrl);
        [cellIv setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"cabel.png"]];
        [cell.contentView addSubview:cellIv];
        
        return cell;
    }
    return nil;
}


#pragma  mark  -  滚动加载
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
                    if(flag == YES)
                    {
                        [self loadRequest:_seq WithUse:_use];
                    }
                    else
                    {
                        [self requestStringWithUse:delegateMyUse WithBrand:delegateMyBrand WithSpec:delegateMySpec WithModel:delegateMyModel WithSeq:_seq];
                    }
                }
            }
        }
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *productId = [[dataArray objectAtIndex:indexPath.row] productId];
    GoodsDetailViewController *detail = [[GoodsDetailViewController alloc] initWithProductId:productId];
    detail.GoodsDetailUrl = [[phoneDescribeArray objectAtIndex:indexPath.row] objectForKey:@"phoneDescribe"];
    [self.navigationController pushViewController:detail animated:YES];
}



//#pragma mark -
#pragma mark SCROLLVIEW DELEGATE METHODS
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
    if(flag == YES)
    {
        [self loadRequest:_seq WithUse:_use];
    }
    else
    {
        [self requestStringWithUse:delegateMyUse WithBrand:delegateMyBrand WithSpec:delegateMySpec WithModel:delegateMyModel WithSeq:_seq];
    }
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
