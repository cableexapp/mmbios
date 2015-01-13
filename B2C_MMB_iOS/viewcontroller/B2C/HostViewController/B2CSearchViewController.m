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
#import "GoodsDetailViewController.h"

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

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
    
    BOOL _reloading;
    
    UIView *noResultView; //无符合搜索条件的提示视图
    
    NSMutableArray *homehistoryArray;//数据库查询搜索关键词结果存储数组
    
    UIButton *clearBtn;
    
    int tempFlag;
    
    UIImageView *searchImageView;
    
    UILabel *searchResultLabel;
    
    NSMutableArray *tempDataArray;
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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width-50, 45)];
    [mySearchBar setDelegate:self];
    [mySearchBar setBarStyle:0];
    mySearchBar.backgroundColor = [UIColor whiteColor];
    mySearchBar.placeholder = @"家装馆内电线型号、品牌等";
    [self.view addSubview:mySearchBar];
    
    //创建搜索数据库表
    [self createDataBase_home];
    
    homehistoryArray = [[NSMutableArray alloc] init];
    tempDataArray = [[NSMutableArray alloc] init];
    
    UIButton *rightSearchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightSearchBtn.frame = CGRectMake(mySearchBar.frame.size.width, 0, 50, 45);
    [rightSearchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightSearchBtn setTitleColor:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:69/255.0 alpha:1.0] forState:UIControlStateNormal];
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
    
    selectBtnView = [[UIView alloc] initWithFrame:CGRectMake(0,45, ScreenWidth,40)];
    [selectBtnView setBackgroundColor:[UIColor whiteColor]];
    selectBtnView.hidden = YES;
    [self.view addSubview:selectBtnView];
    
    btnArray = [[NSMutableArray alloc] init];
    buttonLineViewArray = [[NSMutableArray alloc] init];
    btnRotationNumArray = [[NSMutableArray alloc] init];
    sectionBtnIvArray = [[NSMutableArray alloc] init];
    
    for(int i=0;i<3;i++)
    {
        selctBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selctBtn setFrame:CGRectMake(10 + 100*i, 5, 100, 30)];
        [selctBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
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
        [selctBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if(i == 0)
        {
            //蓝色下划线
            lineView_2 = [[UIView alloc] initWithFrame:CGRectMake(10, 36, 100, 2)];
            [lineView_2 setBackgroundColor:[UIColor colorWithRed:9.0/255.0 green:99.0/255.0 blue:189.0/255.0 alpha:1.0]];
            [selectBtnView addSubview:lineView_2];
            [lineView_2 setTag:0];
            lineView_2.hidden = NO;
            [buttonLineViewArray addObject:lineView_2];
            
            lineView_3 = [[UIView alloc] initWithFrame:CGRectMake(110,36, 100, 2)];
            [lineView_3 setBackgroundColor:[UIColor colorWithRed:9.0/255.0 green:99.0/255.0 blue:189.0/255.0 alpha:1.0]];
            [selectBtnView addSubview:lineView_3];
            [lineView_3 setTag:1];
            lineView_3.hidden = YES;
            [buttonLineViewArray addObject:lineView_3];
            
            lineView_4 = [[UIView alloc] initWithFrame:CGRectMake(215,36, 100, 2)];
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
        
        UIView *toplineView = [[UIView alloc] init];
        toplineView.frame = CGRectMake(0, selectBtnView.frame.size.height-1, ScreenWidth, 1);
        toplineView.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0];
        [selectBtnView addSubview:toplineView];
        
        [selectBtnView addSubview:selctBtn];
        [btnArray addObject:selctBtn];
    }
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, selectBtnView.frame.origin.y + selectBtnView.frame.size.height, ScreenWidth, ScreenHeight - 155) style:0];
    [tv setDelegate:self];
    [tv setDataSource:self];
    tv.backgroundColor = [UIColor whiteColor];
    [tv setShowsVerticalScrollIndicator:NO];
    [tv setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:tv];
    
    noResultView = [[UIView alloc] init];
    noResultView.frame = CGRectMake(0, 45, ScreenWidth, ScreenHeight-45);
    noResultView.backgroundColor = [UIColor whiteColor];
    noResultView.hidden = YES;
    [self.view insertSubview:noResultView aboveSubview:tv];
    
    UIImageView *noResultImageView = [[UIImageView alloc] init];
    noResultImageView.frame = CGRectMake((ScreenWidth-200)/2, 40,200,115);
    noResultImageView.image = [UIImage imageNamed:@"noResult"];
    [noResultView addSubview:noResultImageView];
    
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
        [self loadRequestSeq:@"" WithseqMethod:@"" WithContent:mySearchBar.text];
        [self saveType:nil ProductId:nil ProductName:mySearchBar.text];
        [self saveType:nil ProductId:nil ProductName:mySearchBar.text];
        [self.navigationController.tabBarController.tabBar setHidden:YES];
    }
    else
    {
        speakButton.hidden = NO;
        speakButtonView.hidden = NO;
        [self readHistoryData];
    }
    
    //初始化语音识别控件
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyRecognizerView.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
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
    [_iflyRecognizerView cancel];
    _iflyRecognizerView.delegate = nil;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

-(void)rightSearchBtnClick
{
    intPage = 1;
    tempFlag = 1;
    if (selctBtn.tag == 0)
    {
        selctBtn.selected = YES;
    }
    if (selctBtn.tag == 1 || selctBtn.tag == 2)
    {
        lineView_2.hidden = NO;
        lineView_3.hidden = YES;
        lineView_4.hidden = YES;
    }
    [self loadRequestSeq:@"" WithseqMethod:@"" WithContent:mySearchBar.text];
    if (mySearchBar.text.length > 0)
    {
        [self saveType:nil ProductId:nil ProductName:mySearchBar.text];
        [self saveType:nil ProductId:nil ProductName:mySearchBar.text];
    }
}

-(void)soundSrarchTap
{
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
    intPage = 1;
    tempFlag = 1;
    if (selctBtn.tag == 0)
    {
        selctBtn.selected = YES;
        lineView_2.hidden = NO;
        lineView_3.hidden = YES;
        lineView_4.hidden = YES;
    }
    [self loadRequestSeq:@"" WithseqMethod:@"" WithContent:mySearchBar.text];
    if (mySearchBar.text.length > 0)
    {
        [self saveType:nil ProductId:nil ProductName:mySearchBar.text];
        [self saveType:nil ProductId:nil ProductName:mySearchBar.text];
    }
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
    NSString * str = [[NSString alloc]init];
    str = [str stringByAppendingString:soundInput];
    //去掉识别结果最后的标点符号
    if ([str isEqualToString:@"。"] || [str isEqualToString:@"？"] || [str isEqualToString:@"！"]  || [str isEqualToString:@"，"])
    {
        
    }
    else
    {
        searchBarText = str;
        mySearchBar.text = str;
    }
    intPage = 1;
    tempFlag = 1;
    if (mySearchBar.text.length > 0)
    {
        [self loadRequestSeq:@"" WithseqMethod:@"" WithContent:mySearchBar.text];
        [self cancelIFlyRecognizer];
        speakButtonView.hidden = YES;
        speakButton.hidden = YES;
        [self saveType:nil ProductId:nil ProductName:mySearchBar.text];
        [self saveType:nil ProductId:nil ProductName:mySearchBar.text];
    }
    if (selctBtn.tag == 0)
    {
        selctBtn.selected = YES;
        lineView_2.hidden = NO;
        lineView_3.hidden = YES;
        lineView_4.hidden = YES;
    }
}

//识别会话错误返回代理
- (void)onError: (IFlySpeechError *) error
{
    [self cancelIFlyRecognizer];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)readHistoryData
{
    [self SearchHomeDataFromDataBase];
    if (homehistoryArray.count > 0)
    {
        selectBtnView.hidden = YES;
        tv.frame = CGRectMake(0, 45, ScreenWidth, ScreenHeight-45);
        tempFlag = 2;
        dataArray = [self arrayWithMemberIsOnly:homehistoryArray];
    }
    else
    {
        noResultView.hidden = NO;
        [self.view bringSubviewToFront:noResultView];
    }
    [tv reloadData];
}

-(NSMutableArray *)arrayWithMemberIsOnly:(NSMutableArray *)array
{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [array count]; i++)
    {
        {
            if ([categoryArray containsObject:[array objectAtIndex:i]] == NO)
            {
                [categoryArray addObject:[array objectAtIndex:i]];
            }
        }
    }
    return categoryArray;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if (searchBar.text.length == 0)
    {
        [self readHistoryData];
        speakButton.hidden = NO;
        speakButtonView.hidden = NO;
        if (homehistoryArray.count > 0)
        {
            noResultView.hidden = YES;
        }
        if (homehistoryArray.count == 0)
        {
            noResultView.hidden = NO;
        }
    }
    else
    {
        speakButton.hidden = YES;
        speakButtonView.hidden = YES;
    }
}

- (void) selectBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    int tag = btn.tag;
    //遍历数组比较tag
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
    
    int number = [[btnRotationNumArray objectAtIndex:tag] intValue];
    
#pragma mark - 图片旋转
    if(number == 0)
    {
        seqmethod=@"desc";
    }
    else
    {
        UIImageView *currentIV= (UIImageView *)[sectionBtnIvArray objectAtIndex:tag];
        if(number % 2 == 0)
        {
            [UIView animateWithDuration:0.3 animations:^{
                currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
            }];
            seqmethod=@"desc";
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(-180));
            }];
            seqmethod=@"asc";
        }
    }
    
    number++;
    [btnRotationNumArray replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:number]];
    
    for(int i = 0;i < btnArray.count; i++)
    {
        UIButton *b = (UIButton *)[btnArray objectAtIndex:i];
        UIImageView *arrowIv = (UIImageView *)[sectionBtnIvArray objectAtIndex:i];
        int num = [[btnRotationNumArray objectAtIndex:i] intValue];
        if(i == tag)
        {
            [arrowIv setHidden:NO];
            _seq = b.titleLabel.text;

            intPage = 1;
            
            //价格product_price  销量:sale_num
            
            if(i == 0)
            {
                _seq = @"";
                seqmethod = @"";
            }
            if(i == 1)
            {
                _seq = @"product_price";
            }
            if(i == 2)
            {
                _seq = @"sale_num";
            }
        }
        else
        {
            num = 0;
            [btnRotationNumArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:num]];
            [arrowIv setHidden:YES];
            [b setSelected:NO];
        }
        if(dataArray.count != 0)
        {
            [dataArray removeAllObjects];
        }
        
    }
    [self loadRequestSeq:_seq WithseqMethod:seqmethod WithContent:mySearchBar.text];
}

- (void) loadRequestSeq:(NSString *)seq WithseqMethod:(NSString *)seqMethod WithContent:(NSString *)content
{
    pageSize = 10;
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"searchProduct_B2C",time];
    
    NSString *s = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"use=%@&seq=%@&content=%@&token=%@&pagesize=%d&pageindex=%d&seqmethod=%@",@"",seq,content,s,pageSize,intPage,seqMethod];
    
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
            if(_reloading == YES)
            {
                if (dataArray.count > 0)
                {
                    [self doneLoadingViewData];
                }
                
            }
            else if(_reloading == NO)
            {
                
            }
            if([[dicRespon allKeys] count] == 0)
            {
                noResultView.hidden = NO;
                [self.view bringSubviewToFront:noResultView];
            }
            else
            {
                NSString *result = [dicRespon objectForKey:@"result"];
                intTotal = [[dicRespon objectForKey:@"total"] intValue];
                if([result isEqualToString:@"1"])
                {
                    if(intPage == 1)
                    {
                        [dataArray removeAllObjects];
                    }
                    [dataArray addObjectsFromArray:[B2CGoodsListData getListArray:[dicRespon objectForKey:@"items"]]];
                    if (dataArray.count > 0)
                    {
                        tempFlag = 1;
                        noResultView.hidden = YES;
                        selectBtnView.hidden = NO;
                        tv.frame = CGRectMake(0, selectBtnView.frame.origin.y + selectBtnView.frame.size.height, ScreenWidth, ScreenHeight -85);
                        tv.hidden = NO;
                        [mySearchBar resignFirstResponder];
                    }
                    if(intTotal == 0)
                    {
                        noResultView.hidden = NO;
                        [self.view bringSubviewToFront:noResultView];
                    }
                    else
                    {
                        [moreCell stopAnimation];
                    }
                    intPage++;
                }
                else
                {
                    noResultView.hidden = NO;
                    [self.view bringSubviewToFront:noResultView];
                }
            }
            [tv reloadData];
        }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(dataArray.count == 0)
    {
        return 0;
    }
    if (tempFlag == 2)
    {
        if(indexPath.row <= dataArray.count - 1)
        {
            
            return 40;
        }
        else
        {
            return 44;
        }
    }
    else
    {
        if(indexPath.row <= dataArray.count - 1)
        {
            NSString *content = [[dataArray objectAtIndex:indexPath.row] productName];
            CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont boldSystemFontOfSize:13] WithText:content WithSize:CGSizeMake(220, MAXFLOAT)];
            return size_1.height + 60 + 20;
        }
        else
        {
            return 40;
        }
    }
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tempFlag == 2)
    {
        if (dataArray.count == 0)
        {
            return 0;
        }
        else
        {
            return dataArray.count+1;
        }
    }
    else
    {
        if (dataArray.count == 0)
        {
            return 0;
        }
        else
        {
            if ((intPage-1)*pageSize < intTotal)
            {
                return dataArray.count+1;
            }
            return dataArray.count;
        }
    }
}

//删除数据
-(void)deleteData
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contact_home.sqlite"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath] == YES)
    {
        [[NSFileManager defaultManager] removeItemAtPath:databasePath error:nil];
    }
    [homehistoryArray removeAllObjects];
}

//清空搜索历史
- (void)clearBtnClick:(UIButton *) sender
{
    [dataArray removeAllObjects];
    [self deleteData];
    [tv reloadData];
    [self createDataBase_home];
    noResultView.hidden = NO;
    [self.view bringSubviewToFront:noResultView];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:CellIdentifier];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
        [cell setSelectionStyle:0];
    }
    else
    {
        while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
        {
            [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
        }
    }
    searchImageView = [[UIImageView alloc] init];
    searchImageView.frame = CGRectMake(8, 13, 20, 20);
    [cell.contentView addSubview:searchImageView];
    
    searchResultLabel = [[UILabel alloc] init];
    searchResultLabel.frame = CGRectMake(38, 0, cell.frame.size.width-38, 44);
    searchResultLabel.numberOfLines = 3;
    searchResultLabel.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:searchResultLabel];

    if (dataArray.count > 0)
    {
        if (tempFlag == 2)
        {
            if (indexPath.row == dataArray.count)
            {
                searchResultLabel.text = nil;
                searchImageView.image = nil;
                clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [clearBtn setBackgroundColor:[UIColor colorWithRed:9/255 green:99.0/255 blue:189.0/255 alpha:1.0]];
                [clearBtn setTitle:@"清空历史纪录" forState:UIControlStateNormal];
                clearBtn.frame = CGRectMake((ScreenWidth-100)/2, 4.5, 100, 35);
                [clearBtn setTintColor:[UIColor whiteColor]];
                [clearBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                clearBtn.layer.cornerRadius = 3;
                [cell.contentView addSubview:clearBtn];
            }
            else
            {
                searchImageView.image = [UIImage imageNamed:@"clock.png"];
                searchResultLabel.text = [dataArray[indexPath.row] objectForKey:@"searchName"];
            }
        }
        else
        {
            if(indexPath.row == dataArray.count)
            {
                static NSString *moreCellId = @"moreCell";
                moreCell = (DCFChenMoreCell *)[tableView dequeueReusableCellWithIdentifier:moreCellId];
                if(moreCell == nil)
                {
                    moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
                    [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
                    [moreCell stopAnimation];
                }
                return moreCell;
            }
            
        
            NSString *content = [[dataArray objectAtIndex:indexPath.row] productName];
            CGSize size_1;
            if([DCFCustomExtra validateString:content] == NO)
            {
                size_1 = CGSizeMake(100, 30);
            }
            else
            {
                size_1 = [DCFCustomExtra adjustWithFont:[UIFont boldSystemFontOfSize:13] WithText:content WithSize:CGSizeMake(220, MAXFLOAT)];
            }
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, ScreenWidth-100, size_1.height)];
            [contentLabel setText:content];
            [contentLabel setNumberOfLines:0];
            [contentLabel setFont:[UIFont boldSystemFontOfSize:13]];
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
                size_4 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:shopName WithSize:CGSizeMake(ScreenWidth-100, 30)];
            }
            UILabel *shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, saleOutLabel.frame.origin.y+saleOutLabel.frame.size.height, size_4.width, 30)];
            [shopNameLabel setText:shopName];
            [shopNameLabel setFont:[UIFont systemFontOfSize:12]];
            [cell.contentView addSubview:shopNameLabel];
            
            UIImageView *cellIv = [[UIImageView alloc] init];
            
            [cellIv setFrame:CGRectMake(10, (size_1.height+10)/2, 70, 70)];
            NSString *picUrl = [[dataArray objectAtIndex:indexPath.row] p1Path];
            [cellIv setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"cabel.png"]];
            [cellIv.layer setBorderWidth:0.5];   //边框宽度
            cellIv.layer.borderColor = [[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]CGColor];
            [cell.contentView addSubview:cellIv];
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
    if (tempFlag == 1)
    {
        [self setHidesBottomBarWhenPushed:YES];
        NSString *productId = [[dataArray objectAtIndex:indexPath.row] productId];
        GoodsDetailViewController *detail = [[GoodsDetailViewController alloc] initWithProductId:productId];
        [self.navigationController pushViewController:detail animated:YES];
    }
    else
    {
        tempFlag = 1;
        if (indexPath.row == dataArray.count)
        {
            
        }
        else
        {
            searchBarText = [dataArray[indexPath.row] objectForKey:@"searchName"];
            mySearchBar.text = searchBarText;
            speakButton.hidden = YES;
            speakButtonView.hidden = YES;
            intPage = 1;
            [self loadRequestSeq:@"" WithseqMethod:@"" WithContent:mySearchBar.text];
        }
    }
}

//创建B2C数据表
-(void)createDataBase_home
{
    /*根据路径创建数据库并创建一个表contact(type,productId,productName)*/
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contact_home.sqlite"]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &contact)==SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS(ID INTEGER PRIMARY KEY AUTOINCREMENT,TYPE TEXT ,PRODUCTID TEXT, PRODUCTNAME TEXT)";
            if (sqlite3_exec(contact, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
            {
            }
        }
        else
        {
        }
    }
}

//保存B2C数据表
-(void)saveType:(NSString *)type ProductId:(NSString *)productId ProductName:(NSString *)productName
{
    sqlite3_stmt *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contact)==SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO CONTACTS (type,productId,productName) VALUES(\"%@\",\"%@\",\"%@\")",type,productId,productName];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(contact, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement)==SQLITE_DONE)
        {
        }
        else
        {
        }
        sqlite3_finalize(statement);
        sqlite3_close(contact);
    }
}

//查询B2C数据
- (void)SearchHomeDataFromDataBase
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contact) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT * FROM contacts";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contact, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *type = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,1)];
                    
                    NSString *productId = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,2)];
                    
                    NSString *productName = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,3)];
                    
                    
                    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:type,@"type",productId,@"productId",productName,@"searchName",nil];
                    
                    [homehistoryArray addObject:dic];
                    
                }
            }
            else
            {
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contact);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma  mark  -  滚动加载
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (tempFlag == 2)
    {
        
    }
    else
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
                        if (mySearchBar.text.length > 0)
                        {
                            tempFlag = 1;
                            [self loadRequestSeq:@"" WithseqMethod:@"" WithContent:mySearchBar.text];
                        }
                    }
                }
            }
        }

    }
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
    if (mySearchBar.text.length > 0)
    {
        tempFlag = 1;
        [self loadRequestSeq:@"" WithseqMethod:@"" WithContent:mySearchBar.text];
    }
}

- (void)doneLoadingViewData
{
    _reloading = NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:tv];
}

//#pragma mark REFRESH HEADER DELEGATE METHODS
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self performSelectorOnMainThread:@selector(reloadViewDataSource)withObject:nil waitUntilDone:NO];
}

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
}

@end
