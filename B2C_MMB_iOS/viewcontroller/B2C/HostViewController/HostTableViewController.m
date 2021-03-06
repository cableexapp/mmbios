//
//  HostTableViewController.m
//  tttt
//
//  Created by xiaochen on 14-8-29.
//  Copyright (c) 2014年 MySelfDemo. All rights reserved.
//

#import "HostTableViewController.h"
#import "DCFCustomExtra.h"
#import "ChooseListTableViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "ShoppingHostViewController.h"
#import "SpeedAskPriceFirstViewController.h"
#import "MCDefine.h"
#import "HotClasscifyViewController.h"
#import "HotKindFirstViewController.h"
#import "CableSecondAndThirdStepViewController.h"
#import "ChatListViewController.h"
#import "HotScreenFirstViewController.h"
#import "SearchViewController.h"
#import "MCDefine.h"
#import "ChatViewController.h"
#import "B2CShoppingListViewController.h"
#import "UIImageView+WebCache.h"
#import "B2CHotSaleData.h"
#import "GoodsDetailViewController.h"
#import "KxMenu.h"
#import "MyShoppingListViewController.h"
#import "B2BAskPriceCarViewController.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "DCFStringUtil.h"

int isgo = 1;
BOOL isPopShow = NO;

@interface HostTableViewController ()
{
    NSArray *typeArray;  //一级分类数组
    NSMutableArray *typeBtnArray;  //一级分类按钮
    UIStoryboard *sb;
    NSMutableArray *typeIdArray;
    ZSYPopoverListView *listView;
    NSArray *useArray;
    NSArray *picArray;
    UIActivityIndicatorView *activityIndicator;
    UILabel *labell;
    NSMutableArray *dataArray;
    UIView *secondBarView;
    NSMutableArray *arr;
    NSString *fromPage;
    UIImageView *countLabel;
    int tempCount;
    int tempShopCar;
}
@end

@implementation HostTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    isgo = 1;
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view tag] == 101)
        {
            [view setHidden:NO];
            
        }
        if([view isKindOfClass:[UISearchBar class]])
        {
            [view setHidden:YES];
        }
    }
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"frommmb"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"frommore"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"goToHostView_hasnologin"];
    isPopShow = NO;
    self.tableView.scrollEnabled = YES;
    [self loadbadgeCount];
    [self loadShopCarCount];
}

- (void) viewWillDisappear:(BOOL)animated
{
    isgo = 2;
    [super viewWillDisappear:YES];
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
    [self setHidesBottomBarWhenPushed:NO];
    self.tableView.scrollEnabled = YES;
    [KxMenu dismissMenu];
    isPopShow = NO;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startNsTimer" object:nil];
}

- (void) searchTap:(UITapGestureRecognizer *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void) search:(UIButton *) sender
{
    ChooseListTableViewController *choose = [[ChooseListTableViewController alloc] init];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:choose animated:YES];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(_reloading == YES)
    {
        [self doneLoadingViewData];
    }
    else if(_reloading == NO)
    {
        
    }
    int result = [[dicRespon objectForKey:@"result"] intValue];
    if(URLTag == URLGetProductTypeTag)
    {
        NSString *msg = [dicRespon objectForKey:@"msg"];
        if(result == 1)
        {
            NSMutableArray *dataArrayy = [[NSMutableArray alloc] init];
            typeIdArray = [[NSMutableArray alloc] init];
            for(int i=0;i<[(NSArray *)[dicRespon objectForKey:@"items"] count];i++)
            {
                NSDictionary *dic = [[dicRespon objectForKey:@"items"] objectAtIndex:i];
                NSString  *typeName = [dic objectForKey:@"typeName"];
                [dataArrayy addObject:typeName];
                NSString *typeId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"typeId"]];
                [typeIdArray addObject:typeId];
            }
#pragma mark - 数组里的字符串按长度重新排序
            typeArray = [dataArrayy sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSUInteger len0 = [(NSString *)obj1 length];
                NSUInteger len1 = [(NSString *)obj2 length];
                return len0 > len1 ? NSOrderedAscending : NSOrderedDescending;
            }];
            typeBtnArray = [[NSMutableArray alloc] init];
            for(int i=0;i<typeArray.count;i++)
            {
                NSString *str = [typeArray objectAtIndex:i];
                UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [typeBtn setFrame:CGRectZero];
                [typeBtn setTitle:str forState:UIControlStateNormal];
                [typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [typeBtn setTag:i];
                typeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [typeBtnArray addObject:typeBtn];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }
        else
        {
            if([DCFCustomExtra validateString:msg] == NO)
            {
                [DCFStringUtil showNotice:@"请求失败,请重试"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
    if(URLTag == URLHotSaleProductTag)
    {
        if([[dicRespon allKeys] copy] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            dataArray = [[NSMutableArray alloc] init];
        }
        if([[dicRespon objectForKey:@"items"] count] == 0 || [[dicRespon objectForKey:@"items"] isKindOfClass:[NSNull class]])
        {
            dataArray = [[NSMutableArray alloc] init];
        }
        if([[dicRespon objectForKey:@"items"] count] != 0 || ![[dicRespon objectForKey:@"items"] isKindOfClass:[NSNull class]])
        {
            dataArray = [[NSMutableArray alloc] initWithArray:[B2CHotSaleData getListArray:[dicRespon objectForKey:@"items"]]];
        }
        [self.tableView reloadData];
    }
    if (URLTag == URLInquiryCartCountTag)
    {
        if(result == 1)
        {
           tempCount = [[dicRespon objectForKey:@"value"] intValue];
        }
    }
    if (URLTag == URLShopCarCountTag)
    {
        if(result == 1)
        {
           tempShopCar = [[dicRespon objectForKey:@"total"] intValue];
        }
    }
    if (tempCount > 0 || tempShopCar > 0)
    {
         countLabel.hidden = NO;
    }
    if (tempCount == 0 && tempShopCar == 0)
    {
        countLabel.hidden = YES;
    }
}

- (void) typeBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    int tag = [btn tag];
    [self setHidesBottomBarWhenPushed:YES];
    CableSecondAndThirdStepViewController *cableSecondAndThirdStepViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cableSecondAndThirdStepViewController"];
    cableSecondAndThirdStepViewController.myTitle = btn.titleLabel.text;
    cableSecondAndThirdStepViewController.fromPage = @"电缆分类";
    if (typeArray.count == 5)
    {
        if (tag == 3)
        {
            cableSecondAndThirdStepViewController.typeId = [typeIdArray objectAtIndex:1];
        }
        else if (tag == 4)
        {
            cableSecondAndThirdStepViewController.typeId = [typeIdArray objectAtIndex:3];
        }
        else if (tag == 1)
        {
            cableSecondAndThirdStepViewController.typeId = [typeIdArray objectAtIndex:2];
        }
        else if (tag == 0)
        {
            cableSecondAndThirdStepViewController.typeId = [typeIdArray objectAtIndex:0];
        }
        else if (tag == 2)
        {
            cableSecondAndThirdStepViewController.typeId = [typeIdArray objectAtIndex:4];
        }
    }
    else
    {
         cableSecondAndThirdStepViewController.typeId = [typeIdArray objectAtIndex:tag];
    }
    [self.navigationController pushViewController:cableSecondAndThirdStepViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void) reRequest
{
    [self loadProductType];
}

- (void) loadProductType
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductType",time];
    NSString *token = [DCFCustomExtra md5:string];
    
#pragma mark - 一级分类
    NSString *pushString = [NSString stringWithFormat:@"token=%@&type=%@",token,@"1"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetProductTypeTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/getProductType.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) loadRequest
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"HotSaleProduct",time];
    NSString *token = [DCFCustomExtra md5:string];
    NSString *pushString = [NSString stringWithFormat:@"token=%@",token];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/HotSaleProduct.html?"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLHotSaleProductTag delegate:self];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self pushAndPopStyle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reRequest) name:@"NetisConnect" object:nil];
    [self loadRequest];
    [self loadProductType];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    //ADD REFRESH VIEW
    _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -300, ScreenWidth, 300)];
    [self.refreshView setDelegate:self];
    [self.tableView addSubview:self.refreshView];
    [self.refreshView refreshLastUpdatedDate];
    
    UIImageView *naviImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,8, 28,28)];
    naviImageView.image = [UIImage imageNamed:@"global_main_logo"];
    [naviImageView setTag:100];
    [self.navigationController.navigationBar addSubview:naviImageView];
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(46,7,ScreenWidth-56, 30)];
    [searchImageView setUserInteractionEnabled:YES];
    [searchImageView setTag:101];
    searchImageView.backgroundColor = [UIColor whiteColor];
    searchImageView.layer.cornerRadius = 3;
    searchImageView.layer.borderColor = [[UIColor clearColor] CGColor];
    searchImageView.layer.borderWidth = 1;
    [self.navigationController.navigationBar addSubview:searchImageView];

    UIImageView *search = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 18,18)];
    search.image = [UIImage imageNamed:@"search"];
    [searchImageView addSubview:search];
    
    UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 5, 190, 20)];
    searchLabel.text = @"寻找电缆、品牌、型号、规格";
    searchLabel.font = [UIFont systemFontOfSize:13];
    searchLabel.textColor = [UIColor lightGrayColor];
    [searchImageView addSubview:searchLabel];
    
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTap:)];
    [searchImageView addGestureRecognizer:searchTap];
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    secondBarView = [[UIView alloc] init];
    secondBarView.frame = CGRectMake(self.view.frame.size.width/5, 0, self.view.frame.size.width/5, 49);
    [self.navigationController.tabBarController.tabBar addSubview:secondBarView];
    
    UITapGestureRecognizer *popShopCarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popShopCarTap:)];
    [secondBarView addGestureRecognizer:popShopCarTap];

    useArray = [[NSArray alloc] initWithObjects:@"照明",@"插座",@"热水器",@"挂壁空调",@"立式空调",@"中央空调",@"网络",@"电话",@"音/视频",@"电源连接线",@"进户主线",@"装潢明线", nil];
    picArray = [[NSArray alloc] initWithObjects:@"0.png",@"1.png",@"2.png",@"3.png",@"4.png",@"5.png",@"6.png",@"7.png",@"8.png",@"9.png",@"10.png",@"11", nil];
    countLabel = [[UIImageView alloc] init];
    countLabel.frame = CGRectMake(self.view.frame.size.width/5-24, 5, 10, 10);
    countLabel.hidden = YES;
    countLabel.image = [UIImage imageNamed:@"msg_bq"];
    [secondBarView addSubview:countLabel];

    NSArray *imageArray = [[NSArray alloc] initWithObjects:@"iosappAd.png",@"iosappAd2.png", nil];
    es = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, ScreenWidth, 100) ImageArray:imageArray TitleArray:nil WithTag:0];
    es.delegate = self;
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (goToChatView:) name:@"goToChatView" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (changeClick:) name:@"dissMiss" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (hidenShopCarRedPoint:) name:@"hidenRedPoint" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToHostVC_mmb:) name:@"goToHostView_mmb" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToHostVC_more:) name:@"goToHostView_more" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToHostView_hasnologin:) name:@"goToHostView_hasnologin" object:nil];
}

-(void)goToHostVC_mmb:(NSNotification *)sender
{
   [self.tabBarController setSelectedIndex:0];
}

-(void)goToHostVC_more:(NSNotification *)sender
{
    [self.tabBarController setSelectedIndex:0];
}

-(void)goToHostView_hasnologin:(NSNotification *)sender
{
    [self.tabBarController setSelectedIndex:0];
}

-(void)hidenShopCarRedPoint:(NSNotification *)sender
{
    if ([sender.object isEqualToString:@"1"])
    {
        countLabel.hidden = NO;
    }
    if ([sender.object isEqualToString:@"2"])
    {
        countLabel.hidden = YES;
    }
}

//请求询价车商品数量
-(void)loadbadgeCount
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"InquiryCartCount",time];
    NSString *token = [DCFCustomExtra md5:string];
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    NSString *visitorid = [self.appDelegate getUdid];
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString *pushString = nil;
    if(hasLogin == YES)
    {
        pushString = [NSString stringWithFormat:@"memberid=%@&token=%@",memberid,token];
    }
    else
    {
        pushString = [NSString stringWithFormat:@"visitorid=%@&token=%@",visitorid,token];
    }
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLInquiryCartCountTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/InquiryCartCount.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

//获取购物车商品数量
-(void)loadShopCarCount
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getShoppingCartCount",time];
    NSString *token = [DCFCustomExtra md5:string];
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    NSString *visitorid = [self.appDelegate getUdid];
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString *pushString = nil;
    if(hasLogin == YES)
    {
        pushString = [NSString stringWithFormat:@"memberid=%@&token=%@",memberid,token];
    }
    else
    {
        pushString = [NSString stringWithFormat:@"visitorid=%@&token=%@",visitorid,token];
    }
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLShopCarCountTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getShoppingCartCount.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - 在线客服
-(void)IMTap:(UITapGestureRecognizer *)sender
{
    if ([self.appDelegate.isConnect isEqualToString:@"连接"])
    {
        [self setHidesBottomBarWhenPushed:YES];
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        chatVC.fromStringFlag = @"工具栏客服";
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        transition.type =  kCATransitionMoveIn;
        transition.subtype =  kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:chatVC animated:NO];
        [self setHidesBottomBarWhenPushed:NO];
    }
    else
    {
        [self setHidesBottomBarWhenPushed:YES];
        ChatListViewController *chatVC = [[ChatListViewController alloc] init];
        chatVC.fromString = @"工具栏客服";
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type =  kCATransitionMoveIn;
        transition.subtype =  kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:chatVC animated:NO];
        [self setHidesBottomBarWhenPushed:NO];
    }
}

- (void)popShopCarTap:(UITapGestureRecognizer *)sender
{
    if (isgo == 1)
    {
        if (isPopShow == YES)
        {
            [KxMenu dismissMenu];
            isPopShow = NO;
            self.tableView.scrollEnabled = YES;
        }
        else
        {
            self.tableView.scrollEnabled = NO;
            NSArray *menuItems =
            @[[KxMenuItem menuItem:[NSString stringWithFormat:@"购物车(%d)",tempShopCar]
                             image:nil
                            target:self
                            action:@selector(pushMenuItem:)],
              
              [KxMenuItem menuItem:[NSString stringWithFormat:@"询价车(%d)",tempCount]
                             image:nil
                            target:self
                            action:@selector(pushMenuItem:)],
              ];
            
            [KxMenu showMenuInView:self.view
                          fromRect:CGRectMake(self.view.frame.size.width/5-15, self.view.frame.size.height, self.view.frame.size.height/5, 49)
                         menuItems:menuItems];
            isPopShow = YES;
        }
    }
    else if (isgo == 2)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"popShopCar" object:nil];
    }
}

- (void)pushMenuItem:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];

    if ([[[[[[NSString stringWithFormat:@"%@",sender] componentsSeparatedByString:@" "] objectAtIndex:2] componentsSeparatedByString:@"("] objectAtIndex:0] isEqualToString:@"购物车"])
    {
        MyShoppingListViewController *shop = [[MyShoppingListViewController alloc] initWithDataArray:arr];
        [self.navigationController pushViewController:shop animated:YES];
    }
    else
    {
        B2BAskPriceCarViewController *b2bAskPriceCar = [sb instantiateViewControllerWithIdentifier:@"b2bAskPriceCarViewController"];
        b2bAskPriceCar.fromString = @"首页";
        [self.navigationController pushViewController:b2bAskPriceCar animated:YES];
    }
    [self setHidesBottomBarWhenPushed:NO];
}

-(void)changeClick:(NSNotification *)viewChanged
{
    if (isPopShow == YES)
    {
        isPopShow = NO;
        self.tableView.scrollEnabled = YES;
    }
    else
    {
        isPopShow = YES;
        self.tableView.scrollEnabled = YES;
    }
}

-(void)goToChatView:(NSNotification *)goToChat
{
    [self setHidesBottomBarWhenPushed:YES];
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    chatVC.fromStringFlag = @"首页在线客服";
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type =  kCATransitionMoveIn;
    transition.subtype =  kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:chatVC animated:NO];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void) section1BtnClick:(UIButton *) sender
{
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 3)
    {
       return 1;
    }
    if(section == 4)
    {
        if(!dataArray || dataArray.count == 0)
        {
            return 0;
        }
        return dataArray.count/2 + dataArray.count%2;
    }
    if(section == 2)
    {
        if(!typeArray || typeArray.count == 0)
        {
            return 0;
        }
        else
        {
            if(typeArray.count <= 2)
            {
                return 1;
            }
            else
            {
                NSString *str = [typeArray objectAtIndex:2];
                if(str.length >= 5) //此时这行只加载2个按钮
                {
                    if(typeBtnArray.count == 4)
                    {
                        return 2;
                    }
                    if(typeBtnArray.count >= 5)
                    {
                        return 3;
                    }
                    if (typeBtnArray.count == 5)
                    {
                        return 1;
                    }
                }
                else  //3个按钮
                {
                    if(typeBtnArray.count < 5)
                    {
                        return 2;
                    }
                    if (typeBtnArray.count == 5)
                    {
                        return 1;
                    }
                    else
                    {
                        return 3;
                    }
                }
            }
        }
        return 3;
    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        return 103;
    }
    else if (indexPath.section == 0)
    {
        return 100;
    }
    else if (indexPath.section == 1)
    {
        return 185;
    }
    else if (indexPath.section == 3)
    {
        return 225;
    }
    else if (indexPath.section == 4)
    {
        if(!dataArray || dataArray.count == 0)
        {
            return 0;
        }
        return 235;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0 || section == 1)
    {
        return 0;
    }
    if(section == 2)
    {
        if(!typeArray || typeArray.count == 0)
        {
            return 0;
        }
        return 35;
    }
    if(section == 4)
    {
        if(!dataArray || dataArray.count == 0)
        {
            return 0;
        }
        return 35;
    }
    return 35;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    [headBackView setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];

    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,ScreenWidth-10, 35)];
    headLabel.font = [UIFont systemFontOfSize:15];
    
    if(section == 3)
    {
        [headLabel setText:@"电线用途"];
    }
    else if(section == 4)
    {
        if(!dataArray || dataArray.count == 0)
        {
            return nil;
        }
        [headLabel setText:@"热门电线"];
    }
    else if (section == 2)
    {
        [headLabel setText:@"电缆分类"];
    }
    else
    {
        [headLabel setText:@""];
    }
    [headLabel setTextAlignment:NSTextAlignmentLeft];
    [headBackView addSubview:headLabel];
    
    return headBackView;
}

- (void) HostSection1BtnClick:(UIButton *)btn
{
    [self setHidesBottomBarWhenPushed:YES];
    if(btn.tag == 0)
    {
        SpeedAskPriceFirstViewController *speedAskPriceFirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"speedAskPriceFirstViewController"];
        speedAskPriceFirstViewController.fromWherePush = @"首页";
        [self.navigationController pushViewController:speedAskPriceFirstViewController animated:YES];
    }
    if(btn.tag == 1)
    {
        listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-50,250)];
        listView.titleName.text = @"选择一级分类";
        listView.datasource = self;
        listView.delegate = self;
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake(10, 38, 30, 30);
        [listView addSubview:activityIndicator];
        labell = [[UILabel alloc] init];
        labell.frame = CGRectMake(40, 38, self.view.frame.size.width-50, 30);
        labell.text = @"数据加载中";
        labell.hidden = YES;
        [listView addSubview:labell];
        [listView show];
    }
    if(btn.tag == 2)
    {
       [self setHidesBottomBarWhenPushed:YES];
        ShoppingHostViewController *shoppingHost = [[ShoppingHostViewController alloc] init];
        [self.navigationController pushViewController:shoppingHost animated:YES];
//        [self setHidesBottomBarWhenPushed:NO];
    }
    if(btn.tag == 3)
    {
//        [self setHidesBottomBarWhenPushed:YES];
        HotClasscifyViewController *hot = [sb instantiateViewControllerWithIdentifier:@"hotClasscifyViewController" ];
        [self.navigationController pushViewController:hot animated:YES];
//        [self setHidesBottomBarWhenPushed:NO];
    }
    if(btn.tag == 4)
    {
        #pragma mark - 热门分类
          HotKindFirstViewController *hotKindFirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"hotKindFirstViewController"];
        [self.navigationController pushViewController:hotKindFirstViewController animated:YES];
    }
    if(btn.tag == 5)
    {
#pragma mark - 场景选择
        HotScreenFirstViewController *hotScreenFirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"hotScreenFirstViewController"];
        [self.navigationController pushViewController:hotScreenFirstViewController animated:YES];
    }
    
    if (btn.tag == 6)
    {
        #pragma mark - 在线客服
        if ([self.appDelegate.isConnect isEqualToString:@"连接"])
        {
            ChatViewController *chatVC = [[ChatViewController alloc] init];
            chatVC.fromStringFlag = @"首页在线客服";
            CATransition *transition = [CATransition animation];
            transition.duration = 0.4f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            transition.type =  kCATransitionMoveIn;
            transition.subtype =  kCATransitionFromTop;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:chatVC animated:NO];
        }
        else
        {
            ChatListViewController *chatVC = [[ChatListViewController alloc] init];
            chatVC.fromString = @"首页在线客服";
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type =  kCATransitionMoveIn;
            transition.subtype =  kCATransitionFromTop;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:chatVC animated:NO];
        }
    }
    if (btn.tag == 7)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"友情提示"
                                                            message:@"系统将拨打400客服电话，是否确认？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"拨打", nil];
        [alertView show];
    }
    [self setHidesBottomBarWhenPushed:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *tel = [NSString stringWithFormat:@"tel://%@",@"4008280188"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    }
}

- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return typeArray.count;
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = typeArray[indexPath.row];
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [listView dismiss];
    [self setHidesBottomBarWhenPushed:YES];
    CableSecondAndThirdStepViewController *cableSecondAndThirdStepViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cableSecondAndThirdStepViewController"];
    cableSecondAndThirdStepViewController.myTitle = typeArray[indexPath.row];
    cableSecondAndThirdStepViewController.fromPage = @"电缆选购";
    if (typeArray.count == 5)
    {
        if (indexPath.row == 3)
        {
            cableSecondAndThirdStepViewController.typeId = [typeIdArray objectAtIndex:1];
        }
        else if (indexPath.row == 4)
        {
            cableSecondAndThirdStepViewController.typeId = [typeIdArray objectAtIndex:3];
        }
        else if (indexPath.row == 1)
        {
            cableSecondAndThirdStepViewController.typeId = [typeIdArray objectAtIndex:2];
        }
        else if (indexPath.row == 0)
        {
            cableSecondAndThirdStepViewController.typeId = [typeIdArray objectAtIndex:0];
        }
        else if (indexPath.row == 2)
        {
            cableSecondAndThirdStepViewController.typeId = [typeIdArray objectAtIndex:4];
        }
    }
    else
    {
        cableSecondAndThirdStepViewController.typeId = [typeIdArray objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:cableSecondAndThirdStepViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0)
    {
        [cell.contentView addSubview:es];
    }
    if(indexPath.section == 1)
    {
        HostSection1TableViewCell *section1 = (HostSection1TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HostTableViewSecondCell"];
        if(section1 == nil)
        {
            section1 = [[HostSection1TableViewCell alloc] initWithStyle:0 reuseIdentifier:@"HostTableViewSecondCell"];
        }
        section1.delegate = self;
        return section1;
    }
    if(indexPath.section == 2)
    {
        if(!typeArray || typeArray.count == 0)
        {
            
        }
        else
        {
            if(indexPath.row == 0)
            {
                for(int i=0;i<2;i++)
                {
                    UIButton *btn;
                    if (i == 0)
                    {
                        btn = [typeBtnArray objectAtIndex:3];
                       [btn setFrame:CGRectMake(ScreenWidth/3*i+4, 4, ScreenWidth/3-3, 45.5)];
                        btn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:237.0/255.0 blue:232.0/255.0 alpha:1.0];
                    }
                    else
                    {
                         btn = [typeBtnArray objectAtIndex:4];
                        [btn setFrame:CGRectMake( ScreenWidth/3*2+4, 4, ScreenWidth/3-8, 45.5)];
                        btn.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:250.0/255.0 alpha:1.0];
                    }
                    [cell.contentView addSubview:btn];
                    
                    for(int i=2;i<5;i++)
                    {
                        UIButton *btn;
                        if (i == 3)
                        {
                             btn = [typeBtnArray objectAtIndex:0];
                            [btn setFrame:CGRectMake(ScreenWidth/3*(i-2)+4, 4, ScreenWidth/3-3, 95)];
                            btn.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:245.0/255.0 blue:237.0/255.0 alpha:1.0];
                        }
                        else if(i == 2)
                        {
                            btn = [typeBtnArray objectAtIndex:1];
                            [btn setFrame:CGRectMake(ScreenWidth/3*(i-2)+4, 53, ScreenWidth/3-3, 45.5)];
                            btn.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:240.0/255.0 blue:255.0/255.0 alpha:1.0];
                        }
                        else if(i == 4)
                        {
                            btn = [typeBtnArray objectAtIndex:2];
                            [btn setFrame:CGRectMake(ScreenWidth/3*(i-2)+4, 53, ScreenWidth/3-8, 45.5)];
                            btn.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:246.0/255.0 blue:223.0/255.0 alpha:1.0];
                        }
                        [cell.contentView addSubview:btn];
                    }
                }
            }
            if(indexPath.row == 1)
            {
                UIButton *btn = [typeBtnArray objectAtIndex:2];
                NSString *str = [typeArray objectAtIndex:2];
                if(str.length >= 5)   //此时这行只加载2个按钮
                {
                    [btn  setFrame:CGRectMake(0, 0, ScreenWidth/2, 49)];
                    
                    UIButton *b = [typeBtnArray objectAtIndex:3];
                    [b  setFrame:CGRectMake(btn.frame.origin.x + btn.frame.size.width, 0, ScreenWidth/2, 50)];
                    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [cell.contentView addSubview:b];
                    [cell.contentView addSubview:btn];
                }
                else   //此时这行加载3个按钮
                {
                    for(int i=2;i<5;i++)
                    {
                        UIButton *btn = [typeBtnArray objectAtIndex:i];
                        if (i == 3)
                        {
                            [btn setFrame:CGRectMake(ScreenWidth/3*(i-2)+3, 3, ScreenWidth/3-5, 49)];
                        }
                        else
                        {
                           [btn setFrame:CGRectMake(ScreenWidth/3*(i-2)+3, 3, ScreenWidth/3-5, 49)];
                            [cell.contentView addSubview:btn];
                        }
                        [cell.contentView addSubview:btn];
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        
                    }
                }
            }
            if(indexPath.row == 2)
            {
                //最后一行加载的按钮数目根据第二行的来确定
                NSString *str = [typeArray objectAtIndex:2];
                if(str.length >= 5)   //此时这行加载3个按钮
                {
                    for(int i=4;i<typeBtnArray.count;i++)
                    {
                        UIButton *b = [typeBtnArray objectAtIndex:i];
                        [b setFrame:CGRectMake(ScreenWidth/3*(i-4), 0, ScreenWidth/3, 49)];
                        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [cell.contentView addSubview:b];
                    }
                }
                else   //此时这行加载2个按钮
                {
                    for(int i=5;i<typeBtnArray.count;i++)
                    {
                        UIButton *b = [typeBtnArray objectAtIndex:i];
                        [b setFrame:CGRectMake(ScreenWidth/2*(i-5), 0, ScreenWidth/2, 49)];
                        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [cell.contentView addSubview:b];
                    }
                }
            }
        }
    }
    if(indexPath.section == 3)
    {
        for (int i = 0; i < 3; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(5, 7.5, 30, 30);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            if (i == 0)
            {
                button.frame = CGRectMake(ScreenWidth/3*i+6, 15, ScreenWidth/3-6, 45);
            }
            else if (i == 1)
            {
                button.frame = CGRectMake(ScreenWidth/3*i+6, 15, ScreenWidth/3-6, 45);
            }
            else if (i == 2)
            {
                button.frame = CGRectMake(ScreenWidth/3*i+6, 15, ScreenWidth/3-12, 45);
            }
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0] CGColor];
            [cell addSubview:button];
            [button setTitle:[useArray objectAtIndex:i] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
            [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentLeft;
            button.tag = i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
            [button addSubview:imageView];
        }
        for (int i = 3; i < 6; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(5, 7.5, 30, 30);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            if (i == 3)
            {
                button.frame = CGRectMake(6, 65, ScreenWidth/3-6, 45);
            }
            else if (i == 4)
            {
                button.frame = CGRectMake(ScreenWidth/3+6, 65, ScreenWidth/3-6, 45);
            }
            else if (i == 5)
            {
                button.frame = CGRectMake(ScreenWidth/3*2+6,65, ScreenWidth/3-12, 45);
            }
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0] CGColor];
            [cell addSubview:button];
            [button setTitle:[useArray objectAtIndex:i] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
            [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentLeft;
            button.tag = i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
            [button addSubview:imageView];
        }
        for (int i = 6; i < 9; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(5, 7.5, 30, 30);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            if (i == 6)
            {
                button.frame = CGRectMake(6, 115, ScreenWidth/3-6, 45);
            }
            else if (i == 7)
            {
                button.frame = CGRectMake(ScreenWidth/3+6, 115, ScreenWidth/3-6, 45);
            }
            else
            {
                button.frame = CGRectMake(ScreenWidth/3*2+6, 115, ScreenWidth/3-12, 45);
            }
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0] CGColor];
            [cell addSubview:button];
            button.tag = i;
            [button setTitle:[useArray objectAtIndex:i] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
            [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentLeft;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
            [button addSubview:imageView];
        }
        for (int i = 9; i < 12; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(5, 7.5, 30, 30);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            if (i == 9)
            {
                button.frame = CGRectMake(6, 165, ScreenWidth/3-6, 45);
            }
            else if (i == 10)
            {
                button.frame = CGRectMake(ScreenWidth/3+6, 165, ScreenWidth/3-6, 45);
            }
            else
            {
                button.frame = CGRectMake(ScreenWidth/3*2+6, 165, ScreenWidth/3-12, 45);
            }
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0] CGColor];
            [cell addSubview:button];
            button.tag = i;
            [button setTitle:[useArray objectAtIndex:i] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
            [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentLeft;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
            [button addSubview:imageView];
        }
    }
    if(indexPath.section == 4)
    {
        if(!dataArray || dataArray.count == 0)
        {
            
        }
        else
        {
            for(int i = 0;i < 2; i++)
            {
                if((indexPath.row*2 + i) >= dataArray.count)
                {
                    
                }
                else
                {
                    UIView *cabelShowView = [[UIView alloc] initWithFrame:CGRectMake(10 + 155*i,0, 145, 215)];
                    [cabelShowView setBackgroundColor:[UIColor whiteColor]];
                    cabelShowView.layer.borderWidth = 0.5;
                    cabelShowView.layer.borderColor = [[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0] CGColor];
                    [cabelShowView setTag:2*indexPath.row + i ];
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                    [cabelShowView addGestureRecognizer:tap];
                    
                    [cell.contentView addSubview:cabelShowView];
                    
                    NSString *picUrl = [[dataArray objectAtIndex:indexPath.row*2 + i] p1Path];
                    NSString *content = [[dataArray objectAtIndex:indexPath.row*2 + i] productName];
                    NSString *price = [[dataArray objectAtIndex:indexPath.row*2 + i] productPrice];
                    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 145, 145)];
                    [pic setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"cabel.png"]];
                    pic.layer.borderWidth = 0.5;
                    pic.layer.borderColor = [[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0] CGColor];
                    [cabelShowView addSubview:pic];
                    
                    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(pic.frame.origin.x+5, pic.frame.origin.y + pic.frame.size.height + 5, pic.frame.size.width-10, 40)];
                    [contentLabel setBackgroundColor:[UIColor clearColor]];
                    [contentLabel setNumberOfLines:0];
                    [contentLabel setText:[NSString stringWithFormat:@"%@",content]];
                    [contentLabel setFont:[UIFont systemFontOfSize:11]];
                    [cabelShowView addSubview:contentLabel];
                    
                    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(pic.frame.origin.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + 5, pic.frame.size.width, 20)];
                    NSString *money = [NSString stringWithFormat:@" %@%@",@"¥",price];
                    [moneyLabel setText:money];
                    moneyLabel.font = [UIFont systemFontOfSize:13];
                    [moneyLabel setTextColor:[UIColor redColor]];
                    [cabelShowView addSubview:moneyLabel];
                    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    cell.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
                }
            }
        }
    }
    return cell;
}

-(void)buttonClick:(UIButton *)sender
{
    B2CShoppingListViewController *shoppingList = [[B2CShoppingListViewController alloc] initWithUse:[useArray objectAtIndex:sender.tag]];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:shoppingList animated:YES];
}

-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    [self setHidesBottomBarWhenPushed:YES];
    if (index == 2)
    {
        SpeedAskPriceFirstViewController *speedAskPriceFirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"speedAskPriceFirstViewController"];
        speedAskPriceFirstViewController.fromWherePush = @"首页";
        [self.navigationController pushViewController:speedAskPriceFirstViewController animated:YES];
    }
    else
    {
        ShoppingHostViewController *shoppingHost = [[ShoppingHostViewController alloc] init];
        [self.navigationController pushViewController:shoppingHost animated:YES];
    }
}

- (void) timer:(NSTimer *) sender
{
    
}

#pragma mark - 热门型号
- (IBAction)hotModelBtnClick:(id)sender
{
  
}

- (void) btnClick:(UIButton *) sender
{
    int tag = [sender tag];
    if(tag == 12)
    {
        //        [self setHidesBottomBarWhenPushed:YES];
        //        ShoppingHostViewController *shoppingHost = [[ShoppingHostViewController alloc] init];
        //        [self.navigationController pushViewController:shoppingHost animated:YES];
        //        [self setHidesBottomBarWhenPushed:NO];
    }
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *) sender;
    int tag = [[tap view] tag];
    NSString *s = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:tag] myProductId]];
   [self setHidesBottomBarWhenPushed:YES];
    GoodsDetailViewController *goodsDetail = [[GoodsDetailViewController alloc] initWithProductId:s];
    [self.navigationController pushViewController:goodsDetail animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma  mark  -  滚动加载
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    if (self.tableView == (UITableView *)scrollView)
    {
        if (scrollView.contentSize.height > 0 && (scrollView.contentSize.height-scrollView.frame.size.height)>0)
        {
            if (scrollView.contentOffset.y >= scrollView.contentSize.height-scrollView.frame.size.height)
            {
//                [self loadRequest];
//                
//                [self loadProductType];
//                
//                [self loadbadgeCount];
//                
//                [self loadShopCarCount];
            }
        }
    }
}

#pragma mark SCROLLVIEW DELEGATE METHODS
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshView egoRefreshScrollViewDidScroll:self.tableView];
}

#pragma mark -
#pragma mark DATA SOURCE LOADING / RELOADING METHODS
- (void)reloadViewDataSource
{
    _reloading = YES;
    [self loadRequest];
    [self loadProductType];
    [self loadbadgeCount];
    [self loadShopCarCount];
}

- (void)doneLoadingViewData
{
    _reloading = NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

//#pragma mark REFRESH HEADER DELEGATE METHODS
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    
    [self reloadViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
