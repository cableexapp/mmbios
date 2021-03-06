//
//  SearchViewController.m
//  B2C_MMB_iOS
//
//  Created by developer on 14-11-11.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "SearchViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "AppDelegate.h"
#import "KxMenu.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "JSONKit.h"
#import "CableSecondAndThirdStepViewController.h"
#import "CableChoosemodelViewController.h"
#import "GoodsDetailViewController.h"
#import "B2BAskPriceCarViewController.h"
#import "MyShoppingListViewController.h"
#import "DCFStringUtil.h"
#import "DCFTopLabel.h"
#import "B2CSearchViewController.h"

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

@interface SearchViewController ()
{
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

    NSMutableArray *tempArray;
    
    NSMutableArray *typeIdArray;
    
    NSMutableArray *B2ChistoryArray;
    
    NSString *tempFlag;
    
    UIStoryboard *sb;
    
    UIView *rightButtonView;
    
    NSArray *arr;
    
    UILabel *countLabel;
    
    UIImageView *searchImageView;
    
    UILabel *searchResultLabel;
    
    int tempCount;
    
    int tempShopCar;
    
    NSMutableArray *btnArray;
    
    int btnTag;
    
    NSMutableArray *addToCarArray;  //加入询价车数组
    
    int carCount;  //询价车数量
    
    UIButton *clearBtn;
    
    int isShowClearBtn;
    
    UIView *noResultView;
    
    int tempSearch;//标记搜出的是型号
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
    if(addToCarArray)
    {
        [addToCarArray removeAllObjects];
    }
    
    //初始化语音识别控件
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyRecognizerView.delegate = self;
   
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
    tempSearch = 0;
    [self readHistoryData];
    if ([rightBtn.titleLabel.text isEqualToString:@"购物车"])
    {
        [self loadShopCarCount];
    }
    else
    {
        [self loadbadgeCount];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];

    isShowClearBtn = 1;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [_iflyRecognizerView cancel];
    _iflyRecognizerView.delegate = nil;
    rightButtonView.hidden = YES;
    rightBtn.hidden = YES;
    tempFlag = @"4";

    [mySearchBar resignFirstResponder];

    [self.navigationController.tabBarController.tabBar setHidden:NO];

    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航栏标题
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"搜索"];
    self.navigationItem.titleView = top;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    addToCarArray = [[NSMutableArray alloc] init];
    
    //创建搜索数据库表
    [self createDataBase_B2C];
    
    if(btnArray)
    {
        [btnArray removeAllObjects];
    }
    else
    {
        btnArray = [[NSMutableArray alloc] init];
    }
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(81, 0,self.view.frame.size.width-81, 45)];
    [mySearchBar setDelegate:self];
    [mySearchBar setBarStyle:0];
    mySearchBar.backgroundColor = [UIColor whiteColor];
    mySearchBar.placeholder = @"输入您想搜索的关键词";
    [self.view addSubview:mySearchBar];
    
    leftBtn = [[UILabel alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 82, 45);
    leftBtn.backgroundColor = [UIColor colorWithRed:201.0/255 green:201.0/255 blue:206.0/255 alpha:1.0];
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
    
    speakButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-30, 12, 21, 21)];
    [speakButton setBackgroundImage:[UIImage imageNamed:@"speak"] forState:UIControlStateNormal];
    [self.view insertSubview:speakButton atIndex:1];

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
    countLabel.frame = CGRectMake(46, 2, 18, 18);
    countLabel.layer.borderWidth = 1;
    countLabel.layer.cornerRadius = 10;
    countLabel.textColor = [UIColor whiteColor];
    countLabel.font = [UIFont systemFontOfSize:11];
    countLabel.textAlignment = 1;
    countLabel.hidden = YES;
    countLabel.layer.borderColor = [[UIColor clearColor] CGColor];
    countLabel.layer.backgroundColor = [[UIColor redColor] CGColor];
    [rightButtonView addSubview:countLabel];
    
    dataArray = [[NSMutableArray alloc] init];
    tempArray = [[NSMutableArray alloc] init];
    typeIdArray = [[NSMutableArray alloc] init];
    B2ChistoryArray = [[NSMutableArray alloc] init];
    
    self.serchResultView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height-109) style:UITableViewStylePlain];
    self.serchResultView.dataSource = self;
    self.serchResultView.delegate = self;
    self.serchResultView.scrollEnabled = YES;
    self.serchResultView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.serchResultView.backgroundColor = [UIColor whiteColor];
    self.serchResultView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    self.serchResultView.separatorColor = [UIColor lightGrayColor];
    self.serchResultView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.serchResultView];
    
    noResultView = [[UIView alloc] init];
    noResultView.frame = CGRectMake(0, 45, ScreenWidth, ScreenHeight-45);
    noResultView.backgroundColor = [UIColor whiteColor];
    noResultView.hidden = YES;
    [self.view insertSubview:noResultView aboveSubview:self.serchResultView];
    
    UIImageView *noResultImageView = [[UIImageView alloc] init];
    noResultImageView.frame = CGRectMake((ScreenWidth-200)/2, 40,200,115);
    noResultImageView.image = [UIImage imageNamed:@"noResult"];
    [noResultView addSubview:noResultImageView];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (changeClick:) name:@"dissMiss" object:nil];
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

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    if (URLTag == URLSearchProductTypeTag)
    {
        [self refreshTableView];
        if ([tempType isEqualToString:@"1"])
        {
            if ([[dicRespon objectForKey:@"types"] count] > 0)
            {
                noResultView.hidden = YES;
                dataArray = [dicRespon objectForKey:@"types"];
                isShowClearBtn = 2;
                tempSearch = 0;
                [mySearchBar resignFirstResponder];
            }
            if ([[dicRespon objectForKey:@"items"] count] > 0)
            {
                dataArray = [dicRespon objectForKey:@"items"];
                tempSearch = 2;
                [rightBtn setTitle:@"询价车" forState:UIControlStateNormal];
                noResultView.hidden = YES;
                isShowClearBtn = 2;
                [mySearchBar resignFirstResponder];
                if(btnArray.count > 0)
                {
                    [btnArray removeAllObjects];
                }
                
                btnArray = [[NSMutableArray alloc] init];
                
                for(int i=0;i<dataArray.count;i++)
                {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setFrame:CGRectMake(ScreenWidth-90, 7, 80, 30)];
                    [btn setTitle:@"加入询价车" forState:UIControlStateNormal];
                    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn setTag:i];
                    [btn setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:142.0/255.0 blue:0/255.0 alpha:1.0]];
                    btn.layer.cornerRadius = 5.0f;
                    [btn addTarget:self action:@selector(addtoAskCarClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                    [btnLabel setText:@"+1"];
                    [btnLabel setBackgroundColor:[UIColor clearColor]];
                    [btnLabel setTextColor:[UIColor redColor]];
                    [btnLabel setFont:[UIFont systemFontOfSize:23]];
                    [btnLabel setAlpha:0];
                    [btn addSubview:btnLabel];
                    
                    [btnArray addObject:btn];
                }
            }
            if ([[dicRespon objectForKey:@"items"] count] == 0 && [[dicRespon objectForKey:@"types"] count] == 0)
            {
                noResultView.hidden = NO;
                dataArray = tempArray;
                [self.view bringSubviewToFront:noResultView];
            }
        }
       if ([tempType isEqualToString:@"2"] && [leftBtn.text isEqualToString:@"家装线专卖"])
        {
//            if ([[dicRespon objectForKey:@"products"] count] > 0)
//            {
//                noResultView.hidden = YES;
//                dataArray = [dicRespon objectForKey:@"products"];
//                isShowClearBtn = 2;
//                tempSearch = 0;
//                [mySearchBar resignFirstResponder];
//            }
//            else
//            {
//                noResultView.hidden = NO;
//                dataArray = tempArray;
//            }
            tempType = @"2";
        }
        [self.serchResultView reloadData];
    }
    if (URLTag == URLInquiryCartCountTag)
    {
        tempCount = [[dicRespon objectForKey:@"value"] intValue];
      
        if ([[dicRespon objectForKey:@"value"] intValue] == 0)
        {
            countLabel.hidden = YES;
        }
        else if ([[dicRespon objectForKey:@"value"] intValue] > 0 && [[dicRespon objectForKey:@"value"] intValue] < 99)
        {
            countLabel.hidden = NO;
            
            countLabel.text = [dicRespon objectForKey:@"value"];
        }
        else if ([[dicRespon objectForKey:@"value"] intValue] > 99)
        {
            countLabel.frame = CGRectMake(46, 2, 21, 19);
            countLabel.hidden = NO;
            countLabel.text = @"99+";
        }
        if(result == 1)
        {
            carCount = [[dicRespon objectForKey:@"value"] intValue];
        }
        else
        {
            carCount = 0;
        }
    }
    if (URLTag == URLShopCarCountTag)
    {
        tempShopCar = [[dicRespon objectForKey:@"total"] intValue];
        if ([[dicRespon objectForKey:@"total"] intValue] == 0)
        {
            countLabel.hidden = YES;
        }
        else if ([[dicRespon objectForKey:@"total"] intValue] > 0 && [[dicRespon objectForKey:@"total"] intValue] < 99)
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
    if(URLTag == URLJoinInquiryCartTag)
    {
        int result = [[dicRespon objectForKey:@"result"] intValue];
        NSString *msg = [dicRespon objectForKey:@"msg"];
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            
            UIButton *btn = [btnArray objectAtIndex:btnTag];
            
            UILabel *label = nil;
            for(UIView *view in btn.subviews)
            {
                if([view isKindOfClass:[UILabel class]])
                {
                    label = (UILabel *)view;
                }
            }
            
            [addToCarArray addObject:btn];
            
            //加入购物车动画效果
            CALayer *transitionLayer = [[CALayer alloc] init];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            transitionLayer.opacity = 1.0;
            transitionLayer.contents = label.layer.contents;
            
            //修改动画路线宽度
            transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:CGRectMake(0, 0, 20, 20) fromView:btn.titleLabel];
            [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
            [CATransaction commit];
            
            //路径曲线
            UIBezierPath *movePath = [UIBezierPath bezierPath];
            [movePath moveToPoint:transitionLayer.position];
            CGPoint toPoint = CGPointMake(ScreenWidth-rightBtn.center.x, rightBtn.center.y+20);
            [movePath addQuadCurveToPoint:toPoint
                             controlPoint:CGPointMake(ScreenWidth-rightBtn.center.x,transitionLayer.position.y)];
            
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
            imgView.image = img;
            [self.view addSubview:imgView];
            
            //关键帧
            CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            positionAnimation.path = movePath.CGPath;
            positionAnimation.removedOnCompletion = YES;
            //
            CAAnimationGroup *group = [CAAnimationGroup animation];
            group.beginTime = CACurrentMediaTime();
            group.duration = 0.8;
            group.animations = [NSArray arrayWithObjects:positionAnimation,nil];
            group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            group.delegate = self;
            group.fillMode = kCAFillModeForwards;
            group.removedOnCompletion = NO;
            group.autoreverses= NO;
            //
            [transitionLayer addAnimation:group forKey:@"opacity"];
            [self performSelector:@selector(addShopFinished:) withObject:transitionLayer afterDelay:1.0];
        }
        else
        {
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"加入询价车失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
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
    tempFlag = @"4";
}

//结束识别
-(void)cancelIFlyRecognizer
{
    [_iflyRecognizerView cancel];
}

//键盘手动搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if(mySearchBar.text.length  == 0)
    {
        [DCFStringUtil showNotice:@"搜索内容不能为空哦~"];
        return;
    }
   
    if ([tempType isEqualToString:@"1"])
    {
         [self sendRquest];
        if (mySearchBar.text.length > 0)
        {
            [self saveType:@"1" ProductId:nil ProductName:mySearchBar.text];
            [self saveType:@"1" ProductId:nil ProductName:mySearchBar.text];
        }
    }
    if ([tempType isEqualToString:@"2"])
    {
         [self sendRquest];
        if (mySearchBar.text.length > 0)
        {
            [self saveType:@"2" ProductId:nil ProductName:mySearchBar.text];
            [self saveType:@"2" ProductId:nil ProductName:mySearchBar.text];
        }
        [self setHidesBottomBarWhenPushed:YES];
        B2CSearchViewController *B2CVC = [[B2CSearchViewController alloc] init];
        B2CVC.tempSearchText = mySearchBar.text;
        [self.navigationController pushViewController:B2CVC animated:YES];
    }
    clearBtn.hidden = YES;
}

//语音搜索
-(void)soundSrarchTap:(UITapGestureRecognizer *) sender
{
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
    NSString * str = [[NSString alloc]init];
    if (soundInput.length > 0)
    {
        str = [str stringByAppendingString:soundInput];
        //去掉识别结果最后的标点符号
        if ([str isEqualToString:@"。"] || [str isEqualToString:@"？"] || [str isEqualToString:@"！"] || [str isEqualToString:@"，"])
        {
            
        }
        else
        {
            searchBarText = str;
            mySearchBar.text = str;
        }
    }
    if (mySearchBar.text.length > 0)
    {
        speakButtonView.hidden = YES;
        speakButton.hidden = YES;
        clearBtn.hidden = YES;
    }
    if ([tempType isEqualToString:@"1"])
    {
        if (mySearchBar.text.length > 0)
        {
            [self sendRquest];
            [self cancelIFlyRecognizer];
            [self saveType:@"1" ProductId:nil ProductName:mySearchBar.text];
            [self saveType:@"1" ProductId:nil ProductName:mySearchBar.text];
        }
    }
    if ([tempType isEqualToString:@"2"])
    {
        if (mySearchBar.text.length > 0)
        {
            [self sendRquest];
            [self cancelIFlyRecognizer];
            [self saveType:@"2" ProductId:nil ProductName:mySearchBar.text];
            [self saveType:@"2" ProductId:nil ProductName:mySearchBar.text];
        }
    }
}
//识别会话错误返回代理
- (void)onError: (IFlySpeechError *) error
{
   if (error.errorCode ==0 )
     {
        if (mySearchBar.text.length==0)
        {
            
        }
        else
        {
            if ([tempType isEqualToString:@"2"])
            {
                [self setHidesBottomBarWhenPushed:YES];
                B2CSearchViewController *B2CVC = [[B2CSearchViewController alloc] init];
                B2CVC.tempSearchText = mySearchBar.text;
                [self.navigationController pushViewController:B2CVC animated:YES];
            }
        }
    }
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
    self.serchResultView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.serchResultView.separatorColor = [UIColor lightGrayColor];
    self.serchResultView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.serchResultView];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}


-(void)readHistoryData
{
    self.serchResultView.scrollEnabled = YES;
    [self SearchB2CDataFromDataBase];
    
    if (B2ChistoryArray.count > 0)
    {
        tempFlag = @"5";
        dataArray = [self arrayWithMemberIsOnly:B2ChistoryArray];
    }
    [self refreshTableView];
    [self.serchResultView reloadData];
    
    if (dataArray.count > 0)
    {
        isShowClearBtn = 1;
    }
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
        [self setHidesBottomBarWhenPushed:YES];
        MyShoppingListViewController *shop = [[MyShoppingListViewController alloc] initWithDataArray:arr];
        [self.navigationController pushViewController:shop animated:YES];
    }
    
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

float lastContentOffset;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    lastContentOffset = scrollView.contentOffset.y;
}



- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (lastContentOffset < scrollView.contentOffset.y)
    {
        if ([tempFlag isEqualToString:@"4"])
        {
            leftBtn.hidden = YES;
            sectionBtnIv.hidden = YES;
            mySearchBar.hidden = YES;
            self.serchResultView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        }
    }
    else
    {
        if ([tempFlag isEqualToString:@"4"])
        {
            leftBtn.hidden = NO;
            sectionBtnIv.hidden = NO;
            mySearchBar.hidden = NO;
            self.serchResultView.frame = CGRectMake(0, 45, ScreenWidth, ScreenHeight-45);
        }
    }
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

        if (B2ChistoryArray.count > 0)
        {
            [self readHistoryData];
            noResultView.hidden = YES;
        }
        if (B2ChistoryArray.count == 0)
        {
           dataArray = tempArray;
           noResultView.hidden = NO;
        }
    }
    else
    {
        speakButton.hidden = YES;
        speakButtonView.hidden = YES;
    }
     [self.serchResultView reloadData];
}

- (void)leftBtnClick:(UITapGestureRecognizer *) sender
{
    UIImageView *currentIV= (UIImageView *)[self.view viewWithTag:300];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    NSArray *menuItems =
    @[[KxMenuItem menuItem:@"电缆采购"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"家装线专卖"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],];
    [KxMenu showMenuInView:self.view
                  fromRect:leftBtn.frame
                 menuItems:menuItems];
}

- (void)pushMenuItem:(id)sender
{
    mySearchBar.text = nil;
    tempSearch = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dissMiss" object:nil];

    if ([[[[[[NSString stringWithFormat:@"%@",sender] componentsSeparatedByString:@" "] objectAtIndex:2] componentsSeparatedByString:@">"] objectAtIndex:0] isEqualToString:@"家装线专卖"])
    {
        sectionBtnIv.frame = CGRectMake(72,17.5,10,10);
        [rightBtn setTitle:nil forState:UIControlStateNormal];
        [rightBtn setTitle:@"购物车" forState:UIControlStateNormal];
        tempType = @"2";
        [self loadShopCarCount];
       if (tempShopCar > 0)
        {
            countLabel.hidden = NO;
        }
        else
        {
            countLabel.hidden = YES;
        }
    }
    else
    {
        sectionBtnIv.frame = CGRectMake(68,17.5,10,10);
        [rightBtn setTitle:nil forState:UIControlStateNormal];
        [rightBtn setTitle:@"询价车" forState:UIControlStateNormal];
        tempType = @"1";
        [self loadbadgeCount];
        if (tempCount > 0)
        {
            countLabel.hidden = NO;
        }
        else
        {
            countLabel.hidden = YES;
        }
    }
    leftBtn.text = [[[[[NSString stringWithFormat:@"%@",sender] componentsSeparatedByString:@" "] objectAtIndex:2] componentsSeparatedByString:@">"] objectAtIndex:0];
    speakButton.hidden = NO;
    speakButtonView.hidden = NO;
    [self refreshTableView];
    [self readHistoryData];
}

-(void)changeClick:(NSNotification *)viewChanged
{
    UIImageView *currentIV= (UIImageView *)[self.view viewWithTag:300];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
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
    int tempRow = 0;
    if (dataArray.count > 0)
    {
        tempRow = dataArray.count;
    }
    if ([tempFlag isEqualToString:@"5"])
    {
        if (B2ChistoryArray.count > 0)
        {
            tempRow = dataArray.count+1;
        }
    }
    return tempRow;
}

//清空搜索历史
- (void)clearBtnClick:(UIButton *) sender
{
    [dataArray removeAllObjects];
    [self deleteData];
    [self.serchResultView reloadData];
    [self createDataBase_B2C];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)addtoAskCarClick:(UIButton *)sender
{
    btnTag = sender.tag;

    NSString *text = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:sender.tag] objectForKey:@"model"]];
    
    if ([text isEqualToString:@""])
    {
    }
    else
    {
        NSString *time = [DCFCustomExtra getFirstRunTime];
        NSString *string = [NSString stringWithFormat:@"%@%@",@"JoinInquiryCart",time];
        NSString *token = [DCFCustomExtra md5:string];
    
        NSString *visitorid = [self.appDelegate getUdid];
        NSString *firstType = @"";
        NSString *secondType = @"";
        NSString *thirdType = @"";
        NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
        NSString *pushString = nil;
        if([DCFCustomExtra validateString:memberid] == YES)
        {
            pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&model=%@&firsttype=%@&secondtype=%@&thirdtype=%@",memberid,token,text,firstType,secondType,thirdType];
        }
        else
        {
            pushString = [NSString stringWithFormat:@"visitorid=%@&token=%@&model=%@&firsttype=%@&secondtype=%@&thirdtype=%@",visitorid,token,text,firstType,secondType,thirdType];
        }
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLJoinInquiryCartTag delegate:self];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/JoinInquiryCart.html?"];
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    }
}

- (void)addShopFinished:(CALayer*)transitionLayer
{
    if(addToCarArray.count+carCount <= 0)
    {
        
    }
    else
    {
        countLabel.text = [NSString stringWithFormat:@"%d",addToCarArray.count+carCount];
        countLabel.hidden = NO;
        if(addToCarArray.count+carCount >= 50)
        {
            [DCFStringUtil showNotice:@"数目不能超过50个"];
            return;
        }
    }
    transitionLayer.opacity = 0;
    CALayer *transitionLayer1 = [[CALayer alloc] init];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    transitionLayer1.contents = (id)rightBtn.layer.contents;
    transitionLayer1.frame = [[UIApplication sharedApplication].keyWindow convertRect:rightBtn.bounds fromView:rightBtn];
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer1];
    [CATransaction commit];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
       
        searchImageView = [[UIImageView alloc] init];
        searchImageView.frame = CGRectMake(8, 13, 20, 20);
        [cell addSubview:searchImageView];
        
        searchResultLabel = [[UILabel alloc] init];
        searchResultLabel.frame = CGRectMake(38, 0, cell.frame.size.width-38, 44);
        searchResultLabel.numberOfLines = 3;
        searchResultLabel.font = [UIFont systemFontOfSize:13];
        [cell addSubview:searchResultLabel];

        if (tempSearch == 2 && dataArray.count >0)
        {
            if (B2ChistoryArray.count ==0)
            {
                [cell.contentView addSubview:(UIButton *)[btnArray objectAtIndex:indexPath.row]];
            }
            else
            {
                if (indexPath.row == dataArray.count)
                {
                    
                }
                else
                {
                    [cell.contentView addSubview:(UIButton *)[btnArray objectAtIndex:indexPath.row]];
                }
            }
        }
        
        if ([tempFlag isEqualToString:@"4"] && dataArray.count > 0)
        {
            if ([tempType isEqualToString:@"1"])
            {
                if (indexPath.row == dataArray.count)
                {
                    if (isShowClearBtn == 2)
                    {
                         searchImageView.image = nil;
                    }
                    else if (isShowClearBtn == 1)
                    {
                        searchImageView.image = nil;
                        clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        [clearBtn setBackgroundColor:[UIColor colorWithRed:0/255 green:86.0/255 blue:176.0/255 alpha:1.0]];
                        [clearBtn setTitle:@"清空历史纪录" forState:UIControlStateNormal];
                        clearBtn.frame = CGRectMake((ScreenWidth-120)/2, 4.5, 120, 35);
                        [clearBtn setTintColor:[UIColor whiteColor]];
                        [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        clearBtn.layer.cornerRadius = 3;
                        [cell addSubview:clearBtn];
                    }
                 }
                 else
                 {
                    if ([[dataArray[indexPath.row] objectForKey:@"seq"] isEqualToString:@"0"])
                    {
        
                        searchResultLabel.text = [dataArray[indexPath.row] objectForKey:@"model"];
               
                        for(int i=0;i<dataArray.count;i++)
                        {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            [btn setFrame:CGRectMake(ScreenWidth-90, 7, 80, 30)];
                            [btn setTitle:@"加入询价车" forState:UIControlStateNormal];
                            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
                            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [btn setTag:i];
                            [btn setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:142.0/255.0 blue:0/255.0 alpha:1.0]];
                            btn.layer.cornerRadius = 5.0f;
                            [btn addTarget:self action:@selector(addtoAskCarClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            
                            UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                            [btnLabel setText:@"+1"];
                            [btnLabel setBackgroundColor:[UIColor clearColor]];
                            [btnLabel setTextColor:[UIColor redColor]];
                            [btnLabel setFont:[UIFont systemFontOfSize:23]];
                            [btnLabel setAlpha:0];
                            [btn addSubview:btnLabel];
                            [btnArray addObject:btn];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                     }
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
                    if (tempSearch == 2)
                    {
                        searchResultLabel.font = [UIFont systemFontOfSize:13];
                        searchResultLabel.text = [dataArray[indexPath.row] objectForKey:@"model"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    searchImageView.image = [UIImage imageNamed:@"search"];
                }
        }
     }
    else if ([tempFlag isEqualToString:@"5"])
    {
        if (indexPath.row == dataArray.count)
        {
            if (isShowClearBtn == 2)
            {
                searchImageView.image = nil;
            }
            else if (isShowClearBtn == 1)
            {
                searchImageView.image = nil;
                clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [clearBtn setBackgroundColor:[UIColor colorWithRed:9/255 green:99.0/255 blue:189.0/255 alpha:1.0]];
                [clearBtn setTitle:@"清空历史纪录" forState:UIControlStateNormal];
                clearBtn.frame = CGRectMake((ScreenWidth-100)/2, 4.5, 100, 35);
                [clearBtn setTintColor:[UIColor whiteColor]];
                [clearBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                clearBtn.layer.cornerRadius = 3;
                [cell addSubview:clearBtn];
            }
        }
        else
        {
            searchImageView.image = [UIImage imageNamed:@"clock.png"];
            searchResultLabel.text = [dataArray[indexPath.row] objectForKey:@"productName"];
        }
    }
  }
    if (indexPath.row != dataArray.count)
    {
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, cell.frame.size.height-0.5, cell.frame.size.width, 0.5);
        lineView.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:lineView];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if ([tempFlag isEqualToString:@"4"])
    {
        if (dataArray.count > 0)
        {
            [self setHidesBottomBarWhenPushed:YES];
            CableSecondAndThirdStepViewController *cstVC = [sb instantiateViewControllerWithIdentifier:@"cableSecondAndThirdStepViewController"];
            CableChoosemodelViewController *ccmVC = [sb instantiateViewControllerWithIdentifier:@"cableChoosemodelViewController"];
            if ([tempType isEqualToString:@"1"])
            {
                if ([[dataArray[indexPath.row] objectForKey:@"seq"] isEqualToString:@"1"])
                {
                    cstVC.myTitle = [dataArray[indexPath.row] objectForKey:@"firsttype"];
                    cstVC.typeId = [dataArray[indexPath.row] objectForKey:@"fid"];
                    
                    [self.navigationController pushViewController:cstVC animated:YES];
                }
                else if([[dataArray[indexPath.row] objectForKey:@"seq"] isEqualToString:@"2"])
                {
                    [self setHidesBottomBarWhenPushed:YES];
                    cstVC.myTitle = [dataArray[indexPath.row] objectForKey:@"firsttype"];
                    cstVC.typeId = [dataArray[indexPath.row] objectForKey:@"fid"];
                    [self.navigationController pushViewController:cstVC animated:YES];
                }
                else if ([[dataArray[indexPath.row] objectForKey:@"seq"] isEqualToString:@"3"])
                {
                    [self setHidesBottomBarWhenPushed:YES];
                    ccmVC.myTitle = [NSString stringWithFormat:@"%@>%@>%@",[dataArray[indexPath.row] objectForKey:@"firsttype"],[dataArray[indexPath.row] objectForKey:@"secondtype"],[dataArray[indexPath.row] objectForKey:@"thirdtype"]];
                    ccmVC.myTypeId = [dataArray[indexPath.row] objectForKey:@"tid"];
                    [self.navigationController pushViewController:ccmVC animated:YES];
                    [self setHidesBottomBarWhenPushed:NO];
                }
            }
        }
    }
    if ([tempFlag isEqualToString:@"5"])
    {
        if ([[dataArray[indexPath.row] objectForKey:@"type"] isEqualToString:@"1"])
        {
            searchBarText = [dataArray[indexPath.row] objectForKey:@"productName"];
            mySearchBar.text = searchBarText;
            speakButton.hidden = YES;
            speakButtonView.hidden = YES;
            tempType = @"1";
            [self sendRquest];
            [self loadbadgeCount];
        }
        else if ([[dataArray[indexPath.row] objectForKey:@"type"] isEqualToString:@"2"])
        {
            tempType = @"2";
            [self setHidesBottomBarWhenPushed:YES];
            B2CSearchViewController *B2CVC = [[B2CSearchViewController alloc] init];
            B2CVC.tempSearchText = [dataArray[indexPath.row] objectForKey:@"productName"];
            [self.navigationController pushViewController:B2CVC animated:YES];
            [self setHidesBottomBarWhenPushed:NO];
        }
    }
}

//删除数据
-(void)deleteData
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePathB2C = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contact_B2C.sqlite"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePathB2C] == YES)
    {
        [[NSFileManager defaultManager] removeItemAtPath:databasePathB2C error:nil];
    }
    [B2ChistoryArray removeAllObjects];
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS(ID INTEGER PRIMARY KEY AUTOINCREMENT,TYPE TEXT ,PRODUCTID TEXT, PRODUCTNAME TEXT)";
            if (sqlite3_exec(contactDBB2C, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
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
    
    const char *dbpath = [databasePathB2C UTF8String];
    
    if (sqlite3_open(dbpath, &contactDBB2C)==SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO CONTACTS (type,productId,productName) VALUES(\"%@\",\"%@\",\"%@\")",type,productId,productName];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(contactDBB2C, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement)==SQLITE_DONE)
        {
        }
        else
        {
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
//        NSString *querySQL = [NSString stringWithFormat:@"SELECT productId,productName from contacts where type=\"%@\"",tempType];
        NSString *querySQL = @"SELECT * FROM contacts";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDBB2C, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        NSString *type = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,1)];
                        
                        NSString *productId = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,2)];
                        
                        NSString *productName = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,3)];

                        
                        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:type,@"type",productId,@"productId",productName,@"productName",nil];
                        
                        [B2ChistoryArray addObject:dic];

                    }
            }
            else
            {
//                NSLog(@"未查到结果");
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
