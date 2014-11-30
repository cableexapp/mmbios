//
//  SearchViewController.m
//  B2C_MMB_iOS
//
//  Created by developer on 14-11-11.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "SearchViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
//#import "FMDatabaseAdditions.h"
#import "AppDelegate.h"
#import "KxMenu.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "JSONKit.h"
#import "PopupView.h"
#import "CableSecondAndThirdStepViewController.h"
#import "CableChoosemodelViewController.h"
#import "GoodsDetailViewController.h"
#import "B2BAskPriceCarViewController.h"
#import "MyShoppingListViewController.h"

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

@interface SearchViewController ()
{
    AppDelegate *app;
    NSMutableArray *cabelNameArray;
    
    UILabel *leftBtn;
    
    NSMutableArray *dataArray;
    
    UIButton *speakButton;
    
    UIView *speakButtonView;
    
    UIImageView *sectionBtnIv;
    
    UISearchBar *mySearchBar;
    
    UIButton *rightBtn;
    
    NSString *searchBarText;
    
    NSString *tempType;
    
    UIButton *clearBtn;
    
    NSMutableArray *BBhistorySearch;
    NSMutableArray *BChistorySearch;
    NSMutableArray *tempArray;
    NSMutableArray *typeIdArray;
    
    NSMutableArray *B2BhistoryArray;
    
    NSMutableArray *B2ChistoryArray;
    
    NSString *tempFlag;
    
    UIView *coverView;
    
    UIStoryboard *sb;
    
    NSString *imageFlag;
    
    UIView *rightButtonView;
    
    NSArray *arr;
    
    UILabel *countLabel;
    
    UIImageView *searchImageView;
    
    UILabel *searchResultLabel;
}
@end

@implementation SearchViewController
@synthesize searchFlag;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    rightBtn.hidden = NO;
    rightButtonView.hidden = NO;
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view isKindOfClass:[UIButton class]] || [view tag] == 101)
        {
            [view setHidden:YES];
        }
    }
    [self readHistoryData];
    NSLog(@"viewWillAppear");
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
//    [self readHistoryData];
    
    NSLog(@"viewDidAppear");
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [_iflyRecognizerView cancel];
    _iflyRecognizerView.delegate = nil;
    NSLog(@"viewDidDisappear");
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    rightButtonView.hidden = YES;
    rightBtn.hidden = YES;
    clearBtn.hidden = NO;
    imageFlag = @"1";
    tempFlag = @"4";
    
    [mySearchBar resignFirstResponder];
//    [self readHistoryData];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    NSLog(@"viewDidDisappear");
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航栏标题
    UILabel *naviTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100, 44)];
    naviTitle.textColor = [UIColor whiteColor];
    naviTitle.backgroundColor = [UIColor clearColor];
    naviTitle.font = [UIFont systemFontOfSize:19];
    naviTitle.textAlignment = NSTextAlignmentCenter;
    naviTitle.text = @"搜索";
    self.navigationItem.titleView = naviTitle;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"返回";
    self.navigationItem.backBarButtonItem = backButton;
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(81, 0,self.view.frame.size.width-81, 45)];
    [mySearchBar setDelegate:self];
    [mySearchBar setBarStyle:0];
    mySearchBar.placeholder = @"输入搜索内容";
    [self.view addSubview:mySearchBar];
    
    leftBtn = [[UILabel alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 82, 45);
    leftBtn.backgroundColor = [UIColor colorWithRed:198.0/255 green:198.0/255 blue:203.0/255 alpha:1.0];
    leftBtn.font = [UIFont systemFontOfSize:12];
    leftBtn.textAlignment = NSTextAlignmentCenter;
    leftBtn.text = @"电缆采购";
    tempType = @"1";
    [self.view insertSubview:leftBtn aboveSubview:mySearchBar];
    
    UIView *tempview = [[UIView alloc] init];
    tempview.frame = CGRectMake(0, 0, 81, 45);
    [self.view insertSubview:tempview aboveSubview:leftBtn];
    
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftBtnClick:)];
    [tempview addGestureRecognizer:searchTap];
    
     sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(68,16,10,10)];
    [sectionBtnIv setImage:[UIImage imageNamed:@"down_dark.png"]];
    [sectionBtnIv setContentMode:UIViewContentModeScaleToFill];
    sectionBtnIv.tag = 300;
    [tempview addSubview:sectionBtnIv];
    
    speakButtonView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-36, 0, 36, 45)];
    speakButtonView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:speakButtonView atIndex:2];
    
    UITapGestureRecognizer *soundSearchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(soundSrarchTap:)];
    [speakButtonView addGestureRecognizer:soundSearchTap];
    
    speakButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-30, 10, 25, 25)];
    [speakButton setBackgroundImage:[UIImage imageNamed:@"speak"] forState:UIControlStateNormal];
    [self.view insertSubview:speakButton atIndex:1];
    
    self.serchResultView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height-45) style:UITableViewStylePlain];
    self.serchResultView.dataSource = self;
    self.serchResultView.delegate = self;
    self.serchResultView.scrollEnabled = YES;
    self.serchResultView.backgroundColor = [UIColor whiteColor];
    self.serchResultView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    self.serchResultView.separatorColor = [UIColor lightGrayColor];
    self.serchResultView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.serchResultView];
    
    rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-70, 0, 60, 44)];
    [self.navigationController.navigationBar addSubview:rightButtonView];
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"询价车" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightBtn setFrame:CGRectMake(0, 0, 60, 44)];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:rightBtn];
    
    countLabel = [[UILabel alloc] init];
    countLabel.frame = CGRectMake(50, 2, 18, 18);
    countLabel.layer.borderWidth = 1;
    countLabel.layer.cornerRadius = 10;
    countLabel.textColor = [UIColor whiteColor];
    countLabel.font = [UIFont systemFontOfSize:11];
    countLabel.textAlignment = 1;
    countLabel.hidden = YES;
    countLabel.layer.borderColor = [[UIColor clearColor] CGColor];
    countLabel.layer.backgroundColor = [[UIColor redColor] CGColor];
    [rightButtonView addSubview:countLabel];
    
    [self coverClearButton];
    
    dataArray = [[NSMutableArray alloc] init];
    tempArray = [[NSMutableArray alloc] init];
    typeIdArray = [[NSMutableArray alloc] init];
    B2BhistoryArray = [[NSMutableArray alloc] init];
    B2ChistoryArray = [[NSMutableArray alloc] init];

    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (changeClick:) name:@"dissMiss" object:nil];
    
    //初始化语音识别控件
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyRecognizerView.delegate = self;
    
    _popView = [[PopupView alloc] initWithFrame:CGRectMake(100, 300, 0, 0)];
    _popView.ParentView = self.view;
    
    [self createDataBase_B2B];
    [self createDataBase_B2C];

    [dataArray removeAllObjects];
    
    if ([[[self.searchFlag componentsSeparatedByString:@"+"] objectAtIndex:0] isEqualToString:@"B2C"])
    {
        clearBtn.hidden = YES;
        tempFlag = @"4";
        imageFlag = @"0";
        leftBtn.text = @"家装线专卖";
        tempType = @"2";
        sectionBtnIv.frame = CGRectMake(72,17.5,10,10);
         [rightBtn setTitle:@"购物车" forState:UIControlStateNormal];
        mySearchBar.text = [[self.searchFlag componentsSeparatedByString:@"+"] objectAtIndex:1];
        searchBarText = [[self.searchFlag componentsSeparatedByString:@"+"] objectAtIndex:1];
        speakButton.hidden = YES;
        speakButtonView.hidden = YES;
        [self sendRquest];
    }
    NSLog(@"viewDidLoad");
}

-(void)coverClearButton
{
    self.serchResultView.scrollEnabled = NO;
    coverView = [[UIView alloc] init];
    coverView.frame = CGRectMake(0, 45, self.view.frame.size.width,self.view.frame.size.height-324);
    coverView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:coverView aboveSubview:self.serchResultView];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if (URLTag == URLSearchProductTypeTag)
    {
         [self refreshTableView];
        if ([tempType isEqualToString:@"1"] && [leftBtn.text isEqualToString:@"电缆采购"] && [[dicRespon objectForKey:@"types"] count] != 0)
        {
            dataArray = [dicRespon objectForKey:@"types"];
            [self.serchResultView reloadData];
            coverView.hidden = YES;
            [mySearchBar resignFirstResponder];
        }
        else if ([tempType isEqualToString:@"2"] && [leftBtn.text isEqualToString:@"家装线专卖"] && [[dicRespon objectForKey:@"products"] count] != 0)
        {
            dataArray = [dicRespon objectForKey:@"products"];
            coverView.hidden = YES;
            [self.serchResultView reloadData];
            [mySearchBar resignFirstResponder];
        }
        else if ([[dicRespon objectForKey:@"types"] count] == 0 || [[dicRespon objectForKey:@"products"] count] == 0)
        {
            self.serchResultView.scrollEnabled = NO;
            [self remindNoSearchResult];
        }
    }
}

//提示没有符合查询条件的数据
-(void)remindNoSearchResult
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"没有符合查询条件的数据"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    [alertView show];
    [self performSelector:@selector(dimissAlert:) withObject:alertView afterDelay:1.5];
}

- (void)dimissAlert:(UIAlertView *)alertView
{
    if(alertView)
    {
        [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
    }
}

//请求接口
-(void)sendRquest
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"SearchProduct",time];
    NSString *token = [DCFCustomExtra md5:string];
    NSString *pushString = [NSString stringWithFormat:@"token=%@&type=%@&content=%@",token,tempType,searchBarText];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSearchProductTypeTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/SearchProduct.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

//结束识别
-(void)cancelIFlyRecognizer
{
    [_iflyRecognizerView cancel];
}

//键盘手动搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    clearBtn.hidden = YES;
    tempFlag = @"4";
    imageFlag = @"0";
    [self sendRquest];
}

//语音搜索
-(void)soundSrarchTap:(UITapGestureRecognizer *) sender
{
    clearBtn.hidden = YES;
    tempFlag = @"4";
    imageFlag = @"0";
    [mySearchBar resignFirstResponder];
    //启动识别服务
    [_iflyRecognizerView start];

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
    searchBarText = soundInput;
    mySearchBar.text = soundInput;
    if (soundInput != nil)
    {
        [self cancelIFlyRecognizer];
        speakButtonView.hidden = YES;
        speakButton.hidden = YES;
        [self sendRquest];
    }
}
/*识别会话错误返回代理
 @ param error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
    [self.view addSubview:_popView];
    [_popView setText:@"识别结束!"];
}

-(void)refreshTableView
{
    [self.serchResultView removeFromSuperview];
    self.serchResultView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height-45) style:UITableViewStylePlain];
    self.serchResultView.dataSource = self;
    self.serchResultView.delegate = self;
    self.serchResultView.scrollEnabled = YES;
    self.serchResultView.backgroundColor = [UIColor whiteColor];
    self.serchResultView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    self.serchResultView.separatorColor = [UIColor lightGrayColor];
    self.serchResultView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.serchResultView];
}


-(void)readHistoryData
{
    coverView.hidden = YES;
    self.serchResultView.scrollEnabled = YES;
    imageFlag = @"1";
    tempFlag = @"4";
    if ([tempType isEqualToString:@"1"])
    {
        [self SearchB2BDataFromDataBase];
        dataArray = B2BhistoryArray;
    }
    else if ([tempType isEqualToString:@"2"])
    {
        [self SearchB2CDataFromDataBase];
        dataArray = B2ChistoryArray;
    }
    [self.serchResultView reloadData];
    [self refreshClearButton];
}

//-(void)shopCarArray:(NSNotification*)array
//{
//    NSLog(@"+++++++++++array = %@",array.object);
//    arr = array.object;
//    
//}

- (void) rightBtnClick:(UIButton *)sender
{
    if ([tempType isEqualToString:@"1"])
    {
        [self setHidesBottomBarWhenPushed:YES];
        B2BAskPriceCarViewController *b2bAskPriceCar = [sb instantiateViewControllerWithIdentifier:@"b2bAskPriceCarViewController"];
        [self.navigationController pushViewController:b2bAskPriceCar animated:YES];
    }
    else if ([tempType isEqualToString:@"2"])
    {
//        if (arr.count > 0)
//        {
//            countLabel.hidden = NO;
//            countLabel.text = [NSString stringWithFormat:@"%d",arr.count];
//        }
//        else if (arr.count == 0)
//        {
//            countLabel.hidden = YES;
//        }
        [self setHidesBottomBarWhenPushed:YES];
        MyShoppingListViewController *shop = [[MyShoppingListViewController alloc] initWithDataArray:arr];
//        NSLog(@"arr = %@",arr);
//        countLabel.hidden = NO;
        [self.navigationController pushViewController:shop animated:YES];
    }
    
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidBeginEditing");
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
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
    }
    else
    {
        speakButton.hidden = YES;
        speakButtonView.hidden = YES;
    }
}

- (void)leftBtnClick:(UITapGestureRecognizer *) sender
{
    UIImageView *currentIV= (UIImageView *)[self.view viewWithTag:300];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"电缆采购"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"家装线专卖"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      ];
    [KxMenu showMenuInView:self.view
                  fromRect:leftBtn.frame
                 menuItems:menuItems];
    
}

- (void)pushMenuItem:(id)sender
{
    mySearchBar.text = nil;
    speakButton.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dissMiss" object:nil];
    if ([[[[[[NSString stringWithFormat:@"%@",sender] componentsSeparatedByString:@" "] objectAtIndex:2] componentsSeparatedByString:@">"] objectAtIndex:0] isEqualToString:@"家装线专卖"])
    {
        NSLog(@"家装线专卖");
        sectionBtnIv.frame = CGRectMake(72,17.5,10,10);
        [rightBtn setTitle:nil forState:UIControlStateNormal];
        [rightBtn setTitle:@"购物车" forState:UIControlStateNormal];
        tempType = @"2";
        [self refreshTableView];
        [self readHistoryData];
        [self refreshClearButton];
        [self.serchResultView reloadData];
    }
    else
    {
        NSLog(@"询价车");
        sectionBtnIv.frame = CGRectMake(68,17.5,10,10);
        [rightBtn setTitle:nil forState:UIControlStateNormal];
        [rightBtn setTitle:@"询价车" forState:UIControlStateNormal];
        tempType = @"1";
    }
    leftBtn.text = [[[[[NSString stringWithFormat:@"%@",sender] componentsSeparatedByString:@" "] objectAtIndex:2] componentsSeparatedByString:@">"] objectAtIndex:0];
    speakButton.hidden = NO;
    speakButtonView.hidden = NO;
    [self refreshTableView];
    [self readHistoryData];
    [self refreshClearButton];
    [self.serchResultView reloadData];
}

-(void)changeClick:(NSNotification *)viewChanged
{
    UIImageView *currentIV= (UIImageView *)[self.view viewWithTag:300];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
}

-(void)refreshClearButton
{
    [clearBtn removeFromSuperview];
    clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clearBtn setBackgroundColor:[UIColor colorWithRed:12.0/255 green:63.0/255 blue:148.0/255 alpha:1.0]];
    [clearBtn setTitle:@"清空历史纪录" forState:UIControlStateNormal];
    [clearBtn setTintColor:[UIColor whiteColor]];
    clearBtn.hidden = YES;
    [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.layer.cornerRadius = 3;
    [self.view insertSubview:clearBtn aboveSubview:self.serchResultView];
    if (dataArray.count > 0 && dataArray.count < 9)
    {
        [clearBtn setFrame:CGRectMake((self.view.frame.size.width-230)/2,dataArray.count*50+50, 230, 35)];
        clearBtn.hidden = NO;
    }
    else if (dataArray.count == 0)
    {
        clearBtn.hidden = YES;
    }
    else
    {
        [clearBtn setFrame:CGRectMake((self.view.frame.size.width-230)/2,self.view.frame.size.height-42, 230, 35)];
        clearBtn.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (void)clearBtnClick:(UIButton *) sender
{
    tempFlag = @"3";
    imageFlag = @"0";
    clearBtn.hidden = YES;
    if(dataArray && dataArray.count != 0)
    {
         dataArray = tempArray;
        [self.serchResultView reloadData];
    }
    [self coverClearButton];
    [self deleteData];
    
    [self createDataBase_B2B];
    [self createDataBase_B2C];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor colorWithRed:232.0/255 green:232.0/255 blue:232.0/255 alpha:1.0];
       
        searchImageView = [[UIImageView alloc] init];
        searchImageView.frame = CGRectMake(8, 12, 20, 20);
        [cell addSubview:searchImageView];
        
       searchResultLabel = [[UILabel alloc] init];
        searchResultLabel.frame = CGRectMake(38, 5, cell.frame.size.width-38, 34);
        searchResultLabel.font = [UIFont systemFontOfSize:16];
        [cell addSubview:searchResultLabel];
        
        if ([imageFlag isEqualToString:@"1"])
        {
            searchImageView.image = [UIImage imageNamed:@"clock"];
        }
        else if ([imageFlag isEqualToString:@"0"])
        {
            searchImageView.image = [UIImage imageNamed:@"search"];
        }
        
        if ([tempFlag isEqualToString:@"3"])
        {
            searchResultLabel.text = dataArray[indexPath.row];
        }
        else if ([tempFlag isEqualToString:@"4"])
        {
            coverView.hidden = YES;
            if ([tempType isEqualToString:@"1"])
            {
                if ([[dataArray[indexPath.row] objectForKey:@"seq"] isEqualToString:@"1"])
                {
                    searchResultLabel.text = [dataArray[indexPath.row] objectForKey:@"firsttype"];
                }
                else if([[dataArray[indexPath.row] objectForKey:@"seq"] isEqualToString:@"2"])
                {
                    searchResultLabel.text = [dataArray[indexPath.row] objectForKey:@"secondtype"];
                }
                else if ([[dataArray[indexPath.row] objectForKey:@"seq"] isEqualToString:@"3"])
                {
                    searchResultLabel.text = [dataArray[indexPath.row] objectForKey:@"thirdtype"];
                }
            }
            else if ([tempType isEqualToString:@"2"])
            {
                searchResultLabel.text = [dataArray[indexPath.row] objectForKey:@"productName"];
            }
        }
    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CableSecondAndThirdStepViewController *cstVC = [sb instantiateViewControllerWithIdentifier:@"cableSecondAndThirdStepViewController"];
    CableChoosemodelViewController *ccmVC = [sb instantiateViewControllerWithIdentifier:@"cableChoosemodelViewController"];
        if ([tempType isEqualToString:@"1"])
        {
            if ([[dataArray[indexPath.row] objectForKey:@"seq"] isEqualToString:@"1"])
            {
                cstVC.myTitle = [dataArray[indexPath.row] objectForKey:@"firsttype"];
                cstVC.typeId = [dataArray[indexPath.row] objectForKey:@"fid"];
                
                NSString *Fid = [dataArray[indexPath.row] objectForKey:@"fid"];
                NSString *Firsttype = [dataArray[indexPath.row] objectForKey:@"firsttype"];
                NSString *SecondType = [dataArray[indexPath.row] objectForKey:@"secondtype"];
                NSString *Seq = [dataArray[indexPath.row] objectForKey:@"seq"];
                NSString *Sid = [dataArray[indexPath.row] objectForKey:@"sid"];
                NSString *ThridType = [dataArray[indexPath.row] objectForKey:@"thirdtype"];
                NSString *Tid = [dataArray[indexPath.row] objectForKey:@"tid"];
                //数据存入数据库
                [self saveType:@"1" Fid:Fid Firsttype:Firsttype SecondType:SecondType Seq:Seq Sid:Sid ThridType:ThridType Tid:Tid];
                
                [self.navigationController pushViewController:cstVC animated:YES];
            }
            else if([[dataArray[indexPath.row] objectForKey:@"seq"] isEqualToString:@"2"])
            {
                cstVC.myTitle = [dataArray[indexPath.row] objectForKey:@"firsttype"];
                cstVC.typeId = [dataArray[indexPath.row] objectForKey:@"fid"];
        
                NSString *Fid = [dataArray[indexPath.row] objectForKey:@"fid"];
                NSString *Firsttype = [dataArray[indexPath.row] objectForKey:@"firsttype"];
                NSString *SecondType = [dataArray[indexPath.row] objectForKey:@"secondtype"];
                NSString *Seq = [dataArray[indexPath.row] objectForKey:@"seq"];
                NSString *Sid = [dataArray[indexPath.row] objectForKey:@"sid"];
                NSString *ThridType = [dataArray[indexPath.row] objectForKey:@"thirdtype"];
                NSString *Tid = [dataArray[indexPath.row] objectForKey:@"tid"];
                //数据存入数据库
                [self saveType:@"1" Fid:Fid Firsttype:Firsttype SecondType:SecondType Seq:Seq Sid:Sid ThridType:ThridType Tid:Tid];
                                 
                [self.navigationController pushViewController:cstVC animated:YES];
            }
            else if ([[dataArray[indexPath.row] objectForKey:@"seq"] isEqualToString:@"3"])
            {
                ccmVC.myTitle = [NSString stringWithFormat:@"%@>%@>%@",[dataArray[indexPath.row] objectForKey:@"firsttype"],[dataArray[indexPath.row] objectForKey:@"secondtype"],[dataArray[indexPath.row] objectForKey:@"thirdtype"]];
                ccmVC.myTypeId = [dataArray[indexPath.row] objectForKey:@"tid"];
                
                NSString *Fid = [dataArray[indexPath.row] objectForKey:@"fid"];
                NSString *Firsttype = [dataArray[indexPath.row] objectForKey:@"firsttype"];
                NSString *SecondType = [dataArray[indexPath.row] objectForKey:@"secondtype"];
                NSString *Seq = [dataArray[indexPath.row] objectForKey:@"seq"];
                NSString *Sid = [dataArray[indexPath.row] objectForKey:@"sid"];
                NSString *ThridType = [dataArray[indexPath.row] objectForKey:@"thirdtype"];
                NSString *Tid = [dataArray[indexPath.row] objectForKey:@"tid"];
                //数据存入数据库
                [self saveType:@"1" Fid:Fid Firsttype:Firsttype SecondType:SecondType Seq:Seq Sid:Sid ThridType:ThridType Tid:Tid];
                [self.navigationController pushViewController:ccmVC animated:YES];
            }
        }
        else if ([tempType isEqualToString:@"2"])
        {
            NSString *productId = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"productId"];
            NSString *productName = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"productName"];
            GoodsDetailViewController *detail = [[GoodsDetailViewController alloc] initWithProductId:productId];
            
            [self saveType:@"2" ProductId:productId ProductName:productName];
            [self.navigationController pushViewController:detail animated:YES];
        }
    NSLog(@"cstVC.myTitle = %@",cstVC.myTitle);
    NSLog(@"cstVC.typeId = %@",cstVC.typeId);
}


//删除数据
-(void)deleteData
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    if ([tempType isEqualToString:@"1"])
    {
        databasePathB2B = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contact_B2B.sqlite"]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:databasePathB2B] == YES)
        {
            [[NSFileManager defaultManager] removeItemAtPath:databasePathB2B error:nil];
        }
    }
    else if ([tempType isEqualToString:@"2"])
    {
        databasePathB2C = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contact_B2C.sqlite"]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:databasePathB2C] == YES)
        {
            [[NSFileManager defaultManager] removeItemAtPath:databasePathB2C error:nil];
        }
    }
    [B2BhistoryArray removeAllObjects];
    [B2ChistoryArray removeAllObjects];
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//创建B2B数据表
-(void)createDataBase_B2B
{
    /*根据路径创建数据库并创建一个表contact(type,fid,firsttype,secondtype,seq,sid,thirdtype,tid)*/

    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    databasePathB2B = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contact_B2B.sqlite"]];
 
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePathB2B] == NO)
    {
        const char *dbpath = [databasePathB2B UTF8String];
        if (sqlite3_open(dbpath, &contactDBB2B)==SQLITE_OK)
        {
            NSLog(@"创建B2B表成功\n");
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS(ID INTEGER PRIMARY KEY AUTOINCREMENT,TYPE TEXT ,FID TEXT, FIRSTTYPE TEXT,SECONDTYPE TEXT,SEQ TEXT,SID TEXT,THIRDTYPE TEXT,TID TEXT)";
            if (sqlite3_exec(contactDBB2B, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
            {
                NSLog(@"创建B2B表失败\n");
            }
        }
        else
        {
            NSLog(@"创建B2B_打开数据库失败\n");
        }
    }
}

//保存B2B数据
-(void)saveType:(NSString *)type Fid:(NSString *)fid Firsttype:(NSString *)firsttype SecondType:(NSString *)secondtype Seq:(NSString *)seq Sid:(NSString *)sid ThridType:(NSString *)thirdtype Tid:(NSString *)tid
{
    sqlite3_stmt *statement;
    
    const char *dbpath = [databasePathB2B UTF8String];
    
    if (sqlite3_open(dbpath, &contactDBB2B)==SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO CONTACTS (type,fid,firsttype,secondtype,seq,sid,thirdtype,tid) VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",type,fid,firsttype,secondtype,seq,sid,thirdtype,tid];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(contactDBB2B, insert_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"已存储到数据库");
        }
        else
        {
            NSLog(@"保存失败！");
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDBB2B);
    }
}

//查询B2B数据
- (void)SearchB2BDataFromDataBase
{
    const char *dbpath = [databasePathB2B UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDBB2B) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT fid,firsttype,secondtype,seq,sid,thirdtype,tid from contacts where type=\"%@\"",tempType];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDBB2B, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSDictionary *dic;
                if (B2BhistoryArray.count > 0)
                {
//                    [historyArray removeAllObjects];
                }
                else if (B2BhistoryArray.count == 0)
                {
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        
                        NSString *fid = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
                        
                        NSString *firsttype = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,1)];
                        
                        NSString *secondtype = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,2)];
                        
                        NSString *seq = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,3)];
                        
                        NSString *sid = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,4)];
                        
                        NSString *thirdtype = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,5)];
                        
                        NSString *tid = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,6)];
                        
                        NSLog(@"查询结果 = %@ %@ %@ %@ %@ %@ %@",fid,firsttype,secondtype,seq,sid,thirdtype,tid);
                        NSLog(@"已查到结果\n\n");
                        
                        dic = [[NSDictionary alloc] initWithObjectsAndKeys:fid,@"fid",firsttype,@"firsttype",secondtype,@"secondtype",seq,@"seq",sid,@"sid",thirdtype,@"thirdtype",tid,@"tid",nil];
                        NSLog(@"dic = %@\n\n",dic);
                        
                        [B2BhistoryArray addObject:dic];

//                        [self.serchResultView reloadData];
                        NSLog(@"B2Bhistory = %@",B2BhistoryArray);
                    }
                }
            }
            else
            {
                NSLog(@"未查到结果");
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDBB2B);
    }
}

//创建B2C数据表
-(void)createDataBase_B2C
{
    /*根据路径创建数据库并创建一个表contact(type,productId,productName)*/
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    databasePathB2C = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contact_B2C.sqlite"]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePathB2C] == NO)
    {
        const char *dbpath = [databasePathB2C UTF8String];
        if (sqlite3_open(dbpath, &contactDBB2C)==SQLITE_OK)
        {
             NSLog(@"创建B2C表成功\n");
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS(ID INTEGER PRIMARY KEY AUTOINCREMENT,TYPE TEXT ,PRODUCTID TEXT, PRODUCTNAME TEXT)";
            if (sqlite3_exec(contactDBB2C, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
            {
                NSLog(@"创建B2C表失败\n");
            }
        }
        else
        {
            NSLog(@"创建B2C_打开数据库失败\n");
        }
    }
}

//保存B2C数据表
-(void)saveType:(NSString *)type ProductId:(NSString *)productId ProductName:(NSString *)productName
{
    sqlite3_stmt *statement;
    
    const char *dbpath = [databasePathB2C UTF8String];
    
    if (sqlite3_open(dbpath, &contactDBB2C)==SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO CONTACTS (type,productId,productName) VALUES(\"%@\",\"%@\",\"%@\")",type,productId,productName];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(contactDBB2C, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"已存储到数据库");
        }
        else
        {
            NSLog(@"保存失败！");
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDBB2C);
    }

}

//查询B2C数据
- (void)SearchB2CDataFromDataBase
{
    const char *dbpath = [databasePathB2C UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDBB2C) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT productId,productName from contacts where type=\"%@\"",tempType];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDBB2C, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSDictionary *dic;
                if (B2ChistoryArray.count > 0)
                {
                    //                    [historyArray removeAllObjects];
                }
                else if (B2ChistoryArray.count == 0)
                {
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        
                        NSString *productId = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
                        
                        NSString *productName = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,1)];
                        
                        NSLog(@"查询结果 = %@ %@",productId,productName);
                        NSLog(@"已查到结果\n\n");
                        
                        dic = [[NSDictionary alloc] initWithObjectsAndKeys:productId,@"productId",productName,@"productName",nil];
                        NSLog(@"dic = %@\n\n",dic);
                        
                        [B2ChistoryArray addObject:dic];
//                        [self.serchResultView reloadData];
                        NSLog(@"self.history = %@",B2ChistoryArray);
                    }
                    
                }
            }
            else
            {
                NSLog(@"未查到结果");
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDBB2C);
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

@end
