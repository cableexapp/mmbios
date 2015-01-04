//
//  B2CSearchViewController.m
//  B2C_MMB_iOS
//
//  Created by developer on 15-1-4.
//  Copyright (c) 2015年 YUANDONG. All rights reserved.
//

#import "B2CSearchViewController.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "JSONKit.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "B2CGoodsListData.h"
#import "UIImageView+WebCache.h"

@interface B2CSearchViewController ()
{
    UISearchBar *mySearchBar;
    UIView *speakButtonView;
    UIButton *speakButton;
    NSString *searchBarText;
    NSMutableArray *dataArray;
    DCFChenMoreCell *moreCell;
    int intPage; //页数
    int intTotal; //总数
    int pageSize; //每页条数
    
    UIView * lineView_2;
    UIView * lineView_3;
    UIView * lineView_4;
    NSMutableArray *buttonLineViewArray;  //底部3条下滑线数组
    NSMutableArray *btnArray;
    NSMutableArray *btnRotationNumArray;
    NSString *seqmethod;
    NSMutableArray *sectionBtnIvArray;
    UIButton *selctBtn;
}

@end

@implementation B2CSearchViewController

@synthesize tempSearchText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航栏标题
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装馆搜索"];
    self.navigationItem.titleView = top;
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width-50, 45)];
    [mySearchBar setDelegate:self];
    [mySearchBar setBarStyle:0];
    mySearchBar.backgroundColor = [UIColor whiteColor];
    mySearchBar.placeholder = @"家装馆内电线型号、品牌等";
    [self.view addSubview:mySearchBar];
    
    UIButton *rightSearchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightSearchBtn.frame = CGRectMake(mySearchBar.frame.size.width, 0, 50, 45);
    [rightSearchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightSearchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightSearchBtn addTarget:self action:@selector(rightSearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightSearchBtn.backgroundColor = [UIColor colorWithRed:201.0/255 green:201.0/255 blue:206.0/255 alpha:1.0];
    [self.view addSubview:rightSearchBtn];
    
    speakButtonView = [[UIView alloc] initWithFrame:CGRectMake(mySearchBar.frame.size.width-36, 0, 36, 45)];
    speakButtonView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:speakButtonView atIndex:2];
    
    UITapGestureRecognizer *soundSearchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(soundSrarchTap)];
    [speakButtonView addGestureRecognizer:soundSearchTap];
    
    speakButton = [[UIButton alloc] initWithFrame:CGRectMake(mySearchBar.frame.size.width-30, 12, 21, 21)];
    [speakButton setBackgroundImage:[UIImage imageNamed:@"speak"] forState:UIControlStateNormal];
    [self.view insertSubview:speakButton atIndex:1];
    
    btnArray = [[NSMutableArray alloc] init];
    buttonLineViewArray = [[NSMutableArray alloc] init];
    btnRotationNumArray = [[NSMutableArray alloc] init];
    sectionBtnIvArray = [[NSMutableArray alloc] init];
    
    for(int i=0;i<3;i++)
    {
        selctBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selctBtn setFrame:CGRectMake(10 + 100*i, 13, 100, 30)];
        
        UIImageView *sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(selctBtn.frame.size.width-20, 10, 15, 15)];
        [sectionBtnIv setImage:[UIImage imageNamed:@"down_dark.png"]];
        [sectionBtnIv setContentMode:UIViewContentModeScaleAspectFit];
        [sectionBtnIv setHidden:YES];
        
        [sectionBtnIvArray addObject:sectionBtnIv];
        
        switch (i)
        {
            case 0:
                [selctBtn setTitle:@"相关度" forState:UIControlStateNormal];
                [selctBtn setSelected:YES];
                break;
            case 1:
                [selctBtn setTitle:@"价格" forState:UIControlStateNormal];
                [selctBtn addSubview:sectionBtnIv];
                break;
            case 2:
                [selctBtn setTitle:@"销量" forState:UIControlStateNormal];
                [selctBtn addSubview:sectionBtnIv];
                break;
            default:
                break;
        }
        
        int num = 0;
        [btnRotationNumArray addObject:[NSNumber numberWithInt:num]];
        
        
        
        [selctBtn setTitleColor:[UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        if(i == 0)
        {
            //蓝色下划线
            lineView_2 = [[UIView alloc] initWithFrame:CGRectMake(8, selctBtn.frame.origin.y+40, 100, 3)];
            [lineView_2 setBackgroundColor:[UIColor colorWithRed:9.0/255.0 green:99.0/255.0 blue:189.0/255.0 alpha:1.0]];
            [selectBtnView addSubview:lineView_2];
            [lineView_2 setTag:0];
            lineView_2.hidden = NO;
            [buttonLineViewArray addObject:lineView_2];
            
            lineView_3 = [[UIView alloc] initWithFrame:CGRectMake(110, selctBtn.frame.origin.y+40, 100, 3)];
            [lineView_3 setBackgroundColor:[UIColor colorWithRed:9.0/255.0 green:99.0/255.0 blue:189.0/255.0 alpha:1.0]];
            [selectBtnView addSubview:lineView_3];
            [lineView_3 setTag:1];
            lineView_3.hidden = YES;
            [buttonLineViewArray addObject:lineView_3];
            
            lineView_4 = [[UIView alloc] initWithFrame:CGRectMake(215, selctBtn.frame.origin.y+40, 100, 3)];
            [lineView_4 setBackgroundColor:[UIColor colorWithRed:9.0/255.0 green:99.0/255.0 blue:189.0/255.0 alpha:1.0]];
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
 
        [selectBtnView addSubview:selctBtn];
        [btnArray addObject:selctBtn];
    }

    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, selectBtnView.frame.origin.y + selectBtnView.frame.size.height, ScreenWidth, ScreenHeight - 175) style:0];
    [tv setDelegate:self];
    [tv setDataSource:self];
    tv.backgroundColor = [UIColor whiteColor];
    [tv setShowsVerticalScrollIndicator:NO];
    [tv setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:tv];
    
    intPage = 1;
    
    dataArray = [[NSMutableArray alloc] init];
    
    //ADD REFRESH VIEW
    _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -300, ScreenWidth, 300)];
    [self.refreshView setDelegate:self];
    [tv addSubview:self.refreshView];
    [self.refreshView refreshLastUpdatedDate];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"tempSearchText = %@",self.tempSearchText);
    [super viewWillAppear:YES];
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view isKindOfClass:[UIButton class]] || [view tag] == 101)
        {
            [view setHidden:YES];
        }
    }
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    mySearchBar.text = self.tempSearchText;
    if (mySearchBar.text.length > 0)
    {
        speakButton.hidden = YES;
        speakButtonView.hidden = YES;
    }
    else
    {
        speakButton.hidden = NO;
        speakButtonView.hidden = NO;
    }
    
    //初始化语音识别控件
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyRecognizerView.delegate = self;
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

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [_iflyRecognizerView cancel];
    _iflyRecognizerView.delegate = nil;
}

-(void)rightSearchBtnClick
{
    NSLog(@"家装馆搜索");
}

-(void)soundSrarchTap
{
    NSLog(@"点击语音搜索");
    [mySearchBar resignFirstResponder];
    //启动识别服务
    [_iflyRecognizerView start];
}

//结束识别
-(void)cancelIFlyRecognizer
{
    [_iflyRecognizerView cancel];
}

//键盘手动搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"键盘手动搜索");
}

/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic)
    {
        [result appendFormat:@"%@",key];
    }
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *arrDic = (NSDictionary *)[data mutableObjectFromJSONData];
    NSString *soundInput = [[[[[arrDic objectForKey:@"ws"] objectAtIndex:0] objectForKey:@"cw"] objectAtIndex:0] objectForKey:@"w"];

    mySearchBar.text = soundInput;

    if (soundInput != nil)
    {
        [self cancelIFlyRecognizer];
        speakButtonView.hidden = YES;
        speakButton.hidden = YES;
    }
}

//识别会话错误返回代理
- (void)onError: (IFlySpeechError *) error
{
    //    [self.view addSubview:_popView];
    //    [_popView setText:@"识别结束!"];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    searchBarText = searchText;
    if ([searchBar.text isEqualToString:@""])
    {
        speakButton.hidden = NO;
        speakButtonView.hidden = NO;
        
//        if (B2ChistoryArray.count > 0)
//        {
//            [self readHistoryData];
//            noResultView.hidden = YES;
//        }
//        if (B2ChistoryArray.count == 0)
//        {
//            dataArray = tempArray;
//            noResultView.hidden = NO;
//        }
    }
    else
    {
        speakButton.hidden = YES;
        speakButtonView.hidden = YES;
    }
//    [self.serchResultView reloadData];
}

- (void) loadRequest:(NSString *) seq WithUse:(NSString *) use
{
    pageSize = 10;
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"searchProduct_B2C",time];
    
    NSString *s = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"use=%@&seq=%@&content=%@&token=%@&pagesize=%d&pageindex=%d&seqmethod=%@",use,@"",@"",s,pageSize,intPage,seqmethod];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/searchProduct_B2C.html?"];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2CGoodsListSearchTag delegate:self];
    
    conn.LogIn = YES;
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLB2CGoodsListSearchTag)
    {
        
    }
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
        
        
        //        CGFloat h = size_1.height + 30;
        
        //        if(h <= 60)
        //        {
        //            return 80;
        //        }
        //        else
        //        {
        return size_1.height + 60 + 20;
        //        }
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
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 3)];
            [view setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
            [cell.contentView addSubview:view];
        }
        
        if(!dataArray || dataArray.count == 0)
        {
            
        }
        else
        {
            NSString *content = [[dataArray objectAtIndex:indexPath.row] productName];
            CGSize size_1;
            if([DCFCustomExtra validateString:content] == NO)
            {
                size_1 = CGSizeMake(100, 30);
            }
            else
            {
                size_1 = [DCFCustomExtra adjustWithFont:[UIFont boldSystemFontOfSize:15] WithText:content WithSize:CGSizeMake(220, MAXFLOAT)];
            }
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, ScreenWidth-100, size_1.height)];
            [contentLabel setText:content];
            [contentLabel setNumberOfLines:0];
            [contentLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [contentLabel setTextAlignment:NSTextAlignmentLeft];
            [cell.contentView addSubview:contentLabel];
            
            NSString *price = [NSString stringWithFormat:@"¥ %@",[[dataArray objectAtIndex:indexPath.row] productPrice]];
            CGSize size_2;
            if([DCFCustomExtra validateString:price] == NO)
            {
                size_2 = CGSizeMake(100, 30);
            }
            else
            {
                size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:price WithSize:CGSizeMake(MAXFLOAT, 30)];
            }
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y + contentLabel.frame.size.height, size_2.width, 30)];
            [priceLabel setText:price];
            [priceLabel setFont:[UIFont systemFontOfSize:12]];
            [priceLabel setTextAlignment:NSTextAlignmentLeft];
            [priceLabel setTextColor:[UIColor redColor]];
            [cell.contentView addSubview:priceLabel];
            
            CGSize size_3;
            NSString *saleOut = [NSString stringWithFormat:@"%@%@",@"已售出",[[dataArray objectAtIndex:indexPath.row] saleNum]];
            if([DCFCustomExtra validateString:saleOut] == NO)
            {
                size_3 = CGSizeMake(30, 30);
            }
            else
            {
                size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:saleOut WithSize:CGSizeMake(MAXFLOAT, 30)];
            }
            UILabel *saleOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-size_3.width, priceLabel.frame.origin.y, size_3.width, 30)];
            [saleOutLabel setText:saleOut];
            [saleOutLabel setFont:[UIFont systemFontOfSize:12]];
            [saleOutLabel setTextAlignment:NSTextAlignmentLeft];
            [saleOutLabel setTextColor:[UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0]];
            [cell.contentView addSubview:saleOutLabel];
            
            CGSize size_4;
            NSString *shopName = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] shopName]];
            if([DCFCustomExtra validateString:shopName] == NO)
            {
                size_4 = CGSizeMake(100, 30);
            }
            else
            {
                size_4 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:shopName WithSize:CGSizeMake(ScreenWidth-100, 30)];
            }
            UILabel *shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, saleOutLabel.frame.origin.y+saleOutLabel.frame.size.height, size_4.width, 30)];
            [shopNameLabel setText:shopName];
            [shopNameLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.contentView addSubview:shopNameLabel];
            
            UIImageView *cellIv = [[UIImageView alloc] init];
            
            [cellIv setFrame:CGRectMake(10, (size_1.height+20)/2, 60, 60)];
            NSString *picUrl = [[dataArray objectAtIndex:indexPath.row] p1Path];
            [cellIv setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"cabel.png"]];
            [cellIv.layer setCornerRadius:2.0]; //设置矩圆角半径
            [cellIv.layer setBorderWidth:1.0];   //边框宽度
            cellIv.layer.borderColor = [[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]CGColor];
            [cell.contentView addSubview:cellIv];
        }
        
        
        return cell;
    }
    return nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
