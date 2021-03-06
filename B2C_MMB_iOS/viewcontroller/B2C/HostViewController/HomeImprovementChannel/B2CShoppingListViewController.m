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
#import "MyShoppingListViewController.h"
#import "DCFStringUtil.h"
#import "B2CSearchViewController.h"
#import "SpeedAskPriceFirstViewController.h"

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

#pragma mark - 少一个total字段,筛选部分
@interface B2CShoppingListViewController ()
{
    NSMutableArray *dataArray;
    
    DCFChenMoreCell *moreCell;
    int intPage; //页数
    int intTotal; //总数
    int pageSize; //每页条数
    
    BOOL _reloading;
    
    UIView *backView;
    UIView * lineView_2;
    UIView * lineView_3;
    UIView * lineView_4;
    
    UIWindow * window;
    
    NSMutableArray *buttonLineViewArray;  //底部3条下滑线数组
    
    NSMutableArray *btnArray;
    
    UIButton *searchBtn;
    
    UIView *searchView;  //搜索试图
    B2CShoppingSearchViewController *search;
    UIButton *rightBtn;
    UILabel *countLabel;
    
    NSArray *arr;
    
    AppDelegate *app;
    
    NSMutableArray *ScreeningCondition;
    
    NSMutableArray *btnRotationNumArray;
    
    NSString *seqmethod;
    
    NSMutableArray *sectionBtnIvArray;
    
    UIButton *selctBtn;
    
    UIButton *CustomizationBtn;
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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 15, 22);
    [btn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"购物车"] forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(0, 0, 34,34)];
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    countLabel = [[UILabel alloc] init];
    countLabel.frame = CGRectMake(22, 0, 18, 18);
    countLabel.layer.borderWidth = 1;
    countLabel.layer.cornerRadius = 10;
    countLabel.textColor = [UIColor whiteColor];
    countLabel.font = [UIFont systemFontOfSize:11];
    countLabel.textAlignment = 1;
    countLabel.hidden = YES;
    countLabel.layer.borderColor = [[UIColor clearColor] CGColor];
    countLabel.layer.backgroundColor = [[UIColor redColor] CGColor];
    [rightBtn addSubview:countLabel];
    self.navigationItem.rightBarButtonItem = right;
    [self loadShopCarCount];
    
    NSString *tempBtand = [[NSUserDefaults standardUserDefaults] objectForKey:@"brand_save"];
    NSString *tempModel = [[NSUserDefaults standardUserDefaults] objectForKey:@"model_save"];
    NSString *tempUse = [[NSUserDefaults standardUserDefaults] objectForKey:@"use_save"];
    NSString *tempSpec = [[NSUserDefaults standardUserDefaults] objectForKey:@"spec_save"];
    if (tempBtand.length > 0 || tempModel.length > 0 || tempSpec.length > 0 ||tempUse.length > 0)
    {
        flag = NO;
    }
    
    if(!CustomizationBtn)
    {
        CustomizationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [CustomizationBtn setTitle:@"定制" forState:UIControlStateNormal];
        [CustomizationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [CustomizationBtn setFrame:CGRectMake(MainScreenWidth-20-50*ScreenScaleX, MainScreenHeight-20-50*ScreenScaleX, 50*ScreenScaleX, 50*ScreenScaleX)];
        CustomizationBtn.layer.cornerRadius = 50*ScreenScaleX/2;
        CustomizationBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        CustomizationBtn.layer.borderWidth = 1.0f;
        [CustomizationBtn setBackgroundColor:[UIColor whiteColor]];
        [CustomizationBtn addTarget:self action:@selector(CustomizationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow insertSubview:CustomizationBtn aboveSubview:tv];
    }
}

-(void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"delateChoose" object:nil];
}

#pragma mark - delegate
- (void) requestStringWithUse:(NSString *)myUse WithBrand:(NSString *)myBrand WithSpec:(NSString *)mySpec WithModel:(NSString *)myModel WithSeq:(NSString *)mySeq
{
    if (myUse.length == 0 && myBrand.length == 0 && mySpec.length == 0 && myModel.length == 0)
    {
        flag = YES;
        if (selctBtn.tag == 0)
        {
            selctBtn.selected = YES;
        }
        _seq = @"";
        seqmethod = @"";
        [self loadRequest:_seq WithUse:_use];
    }
    else
    {
        flag = NO;
        delegateMyUse = myUse;
        delegateMyBrand = myBrand;
        delegateMySpec = [[mySpec componentsSeparatedByString:@"平方"] objectAtIndex:0];
        delegateMyModel = myModel;
        
        NSString *time = [DCFCustomExtra getFirstRunTime];
        NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductListByCondition",time];
        NSString *token = [DCFCustomExtra md5:string];
        
        pageSize = 10;
        
        NSString *pushString = [NSString stringWithFormat:@"token=%@&use=%@&model=%@&brand=%@&spec=%@&pagesize=%d&pageindex=%d&memberid=%@&loginid=%@",token,delegateMyUse,delegateMyModel,delegateMyBrand,delegateMySpec,pageSize,intPage,@"",@""];
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2CGoodsListTag delegate:self];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getProductListByCondition.html?"];
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
        [moreCell startAnimation];
    }
}

#pragma mark- 筛选
- (void) searchBtnClick:(UIButton *) sender
{
    if(!ScreeningCondition || ScreeningCondition.count == 0)
    {
        [DCFStringUtil showNotice:@"数据正在加载中..."];
        return;
    }
    _seq = @"";
    intPage = 1;
    
    searchView = [[UIView alloc] init];
    [searchView setFrame:CGRectMake(70, 0, ScreenWidth-40, ScreenHeight+50)];
    [self.view addSubview:searchView];
    
    backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    backView.alpha = 0.5;
    backView.hidden = NO;
    backView.backgroundColor = [UIColor lightGrayColor];
    [self.view insertSubview:backView aboveSubview:tv];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =  kCATransitionMoveIn;
    transition.subtype =  kCATransitionFromRight;
    transition.delegate = self;
    [searchView.layer addAnimation:transition forKey:@"animation"];

    search = [[B2CShoppingSearchViewController alloc] initWithFrame:searchView.bounds];
    search.delegate = self;
    search.ScreeningCondition = [[NSMutableArray alloc] initWithArray:ScreeningCondition];
    
    [self addChildViewController:search];
    [searchView addSubview:search.view];
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
    searchTextField.text = nil;
    flag = YES;
    
    if(CustomizationBtn)
    {
        [CustomizationBtn removeFromSuperview];
        CustomizationBtn = nil;
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
            if(dataArray.count != 0)
            {
                [dataArray removeAllObjects];
            }
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
            if(flag == YES)
            {
                [self loadRequest:_seq WithUse:_use];
            }
            else
            {
                //选择筛选条件后，数据排序
                [self seqencingData];
            }
        }
        else
        {
            num = 0;
            [btnRotationNumArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:num]];
            [arrowIv setHidden:YES];
            [b setSelected:NO];
        }
    }
}

//选择筛选条件后，数据排序
-(void)seqencingData
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductList",time];
    NSString *token = [DCFCustomExtra md5:string];
    pageSize = 10;
    
    /*use,token,seq,seqmethod,model,brand,spec,shopid,pagesize,pageindex,memberid,loginid*/

     NSString *pushString = [NSString stringWithFormat:@"token=%@&seq=%@&seqmethod=%@&model=%@&brand=%@&spec=%@&shopid=%@&pagesize=%d&pageindex=%d&memberid=%@&loginid=%@",token,_seq,seqmethod,delegateMyModel,delegateMyBrand,delegateMySpec,@"",pageSize,intPage,@"",@""];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2CGoodsListTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getProductList.html?"];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    [moreCell startAnimation];
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
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"ScreeningCondition",time];
    NSString *token = [DCFCustomExtra md5:string];
    NSString *pushString = [NSString stringWithFormat:@"token=%@&use=%@&model=%@&spec=%@&brand=%@",token,@"",@"",@"",@""];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLScreeningConditionTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/ScreeningCondition.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装馆电线频道"];
    self.navigationItem.titleView = top;
    
    seqmethod = @"";
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    [topView setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
    [self.view addSubview:topView];
    
    for(int i=0;i<2;i++)
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0+39*i, ScreenWidth, 1)];
        [lineView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        [topView addSubview:lineView];
    }
    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 260, 34)];
    [searchTextField setDelegate:self];
    [searchTextField setPlaceholder:@"家装馆内电线型号、品牌等"];
    [searchTextField setBackgroundColor:[UIColor whiteColor]];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0,22.0)];//左端缩进
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,2, 18, 18)];
    leftImageView.image = [UIImage imageNamed:@"search"];
    [view1 addSubview:leftImageView];
    searchTextField.leftView = view1;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    [searchTextField setReturnKeyType:UIReturnKeySearch];

    [searchTextField setFont:[UIFont systemFontOfSize:12]];
    searchTextField.layer.cornerRadius = 5;
    [self.view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    [self.view addSubview:searchTextField];
    
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(searchTextField.frame.origin.x + searchTextField.frame.size.width+1, 9, 43, 39)];
    //    [searchBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"choose_btn"] forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    searchBtn.layer.masksToBounds = YES;
    [searchBtn setTitleColor:MYCOLOR forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:searchBtn];
    selectBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height+13, ScreenWidth,40)];
    [selectBtnView setBackgroundColor:[UIColor whiteColor]];
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
    
    
    intPage = 1;
    
    dataArray = [[NSMutableArray alloc] init];
    
    //ADD REFRESH VIEW
    _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -300, ScreenWidth, 300)];
    [self.refreshView setDelegate:self];
    [tv addSubview:self.refreshView];
    [self.refreshView refreshLastUpdatedDate];
    
    _seq = @"";
    [self loadRequest:_seq WithUse:_use];
    
    //    设置隐藏背景VIEW的通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeView:) name:@"closeBackView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNomalData:) name:@"reloadNomalData" object:nil];
    
    

}

- (void) CustomizationBtnClick:(UIButton *) sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    SpeedAskPriceFirstViewController *speedAskPriceFirstViewController = [sb instantiateViewControllerWithIdentifier:@"speedAskPriceFirstViewController"];
    speedAskPriceFirstViewController.fromWherePush = @"首页";
    [self.navigationController pushViewController:speedAskPriceFirstViewController animated:YES];
}

-(void)reloadNomalData:(NSNotification *)sender
{
    flag = YES;
    if (selctBtn.tag == 0)
    {
        selctBtn.selected = YES;
    }
    _seq = @"";
    seqmethod = @"";
    [self loadRequest:_seq WithUse:_use];
}

-(void)rightItemClick
{
    [self setHidesBottomBarWhenPushed:YES];
    MyShoppingListViewController *shop = [[MyShoppingListViewController alloc] initWithDataArray:arr];
    [self.navigationController pushViewController:shop animated:YES];
}

-(void)closeView:(NSNotification *)close
{
    backView.hidden = YES;
    if (selctBtn.tag == 111)
    {
        selctBtn.selected = YES;
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

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.text.length != 0)
    {
        [textField setText:@""];
    }
    [textField resignFirstResponder];
    [self setHidesBottomBarWhenPushed:YES];
    B2CSearchViewController *B2CVC = [[B2CSearchViewController alloc] init];
//    B2CVC.tempSearchText = topTextField.text;
    [self.navigationController pushViewController:B2CVC animated:YES];
}

- (void) loadRequest:(NSString *) seq WithUse:(NSString *) use
{
    pageSize = 10;
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductList",time];
    NSString *s = [DCFCustomExtra md5:string];
    NSString *pushString = [NSString stringWithFormat:@"use=%@&seq=%@&model=%@&brand=%@&shopid=%@&token=%@&pagesize=%d&pageindex=%d&seqmethod=%@",use,_seq,@"",@"",@"",s,pageSize,intPage,seqmethod];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getProductList.html?"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2CGoodsListTag delegate:self];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    [moreCell startAnimation];
}


//获取购物车商品数量
-(void)loadShopCarCount
{
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getShoppingCartCount",time];
    NSString *token = [DCFCustomExtra md5:string];
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    NSString *visitorid = [app getUdid];
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

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLB2CGoodsListTag)
    {
        if(_reloading == YES)
        {
            if (dataArray.count > 0)
            {
                if(HUD)
                {
                    [HUD hide:YES];
                }
                 [self doneLoadingViewData];
            }
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
                if (dataArray.count > 0)
                {
                    if(HUD)
                    {
                        [HUD hide:YES];
                    }
                }
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
    if (URLTag == URLShopCarCountTag)
    {
        if ([[dicRespon objectForKey:@"total"] intValue] == 0)
        {
            countLabel.hidden = YES;
        }
        else if ([[dicRespon objectForKey:@"total"] intValue] >= 1 && [[dicRespon objectForKey:@"total"] intValue] < 99)
        {
            countLabel.hidden = NO;
            countLabel.text = [NSString stringWithFormat:@"%@", [dicRespon objectForKey:@"total"]];
        }
        else if ([[dicRespon objectForKey:@"total"] intValue] > 99)
        {
            countLabel.frame = CGRectMake(46, 2, 21, 19);
            countLabel.hidden = NO;
            countLabel.text = @"99+";
        }
    }
    if(URLTag == URLScreeningConditionTag)
    {
        int result = [[dicRespon objectForKey:@"result"] intValue];
        if(result == 0)
        {
            ScreeningCondition = [[NSMutableArray alloc] init];
        }
        else
        {
            NSMutableArray *brandsArray = [[NSMutableArray alloc] initWithArray:[self dealArray:[dicRespon objectForKey:@"brands"]]];
            NSMutableArray *modelsArray = [[NSMutableArray alloc] initWithArray:[self dealArray:[dicRespon objectForKey:@"models"]]];
            NSMutableArray *specsArray = [[NSMutableArray alloc] initWithArray:[self dealArray:[dicRespon objectForKey:@"specs"]]];
            NSMutableArray *usesArray = [[NSMutableArray alloc] initWithArray:[self dealArray:[dicRespon objectForKey:@"uses"]]];
            ScreeningCondition = [[NSMutableArray alloc] initWithObjects:brandsArray,modelsArray,specsArray,usesArray, nil];
        }
    }
}

#pragma mark - 去除重复元素
- (NSMutableArray *) dealArray:(NSMutableArray *) dealArray
{
    NSSet *set = [NSSet setWithArray:dealArray];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i=0;i<[[set allObjects] count];i++)
    {
        [array addObject:[[set allObjects] objectAtIndex:i]];
    }
    return array;
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
        CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont boldSystemFontOfSize:13] WithText:content WithSize:CGSizeMake(220, MAXFLOAT)];
        return size_1.height + 60 + 20;
    }
    else
    {
        return 40;
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
        if ((intPage-1)*pageSize < intTotal)
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
    if(!dataArray || dataArray.count == 0)
    {
        return;
    }
    [self setHidesBottomBarWhenPushed:YES];
    NSString *productId = [[dataArray objectAtIndex:indexPath.row] productId];
    GoodsDetailViewController *detail = [[GoodsDetailViewController alloc] initWithProductId:productId];
    [self.navigationController pushViewController:detail animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    backView.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeChooseView" object:nil];
}

//#pragma mark -
#pragma mark SCROLLVIEW DELEGATE METHODS
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshView egoRefreshScrollViewDidScroll:tv];
}

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

- (void)doneLoadingViewData
{
    _reloading = NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:tv];
}

//#pragma mark REFRESH HEADER DELEGATE METHODS
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self performSelectorOnMainThread:@selector(reloadViewDataSource)withObject:nil waitUntilDone:NO];
//    [self reloadViewDataSource];
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
