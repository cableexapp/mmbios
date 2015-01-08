//
//  HotClasscifyViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-27.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "HotClasscifyViewController.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFCustomExtra.h"
#import "AppDelegate.h"
#import "DCFStringUtil.h"
#import "B2BAskPriceCarViewController.h"
#import "ChatListViewController.h"
#import "SpeedAskPriceFirstViewController.h"
#import "ChatViewController.h"

#define pi 3.14159265359
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

@interface HotClasscifyViewController ()
{
    int page;
    NSMutableArray *btnArray;
    UIButton *askPriceBtn;
    
    int allPrice;
    int addPrice;
    
    NSMutableArray *addToCarArray;  //加入询价车数组
    
    AppDelegate *app;
    
    NSDictionary *dic;  //plist文件字典
    
    int carCount;  //询价车数量
    
    UIButton *badgeBtn;
    
    BOOL flag;//判断取消是在返回还是点击加入询价车情况下点击
    
    UIButton *btn;
    
    UIPageControl *pageControl;
    
    NSTimer *timer;
    
    NSTimer *timer2;
}
@end

@implementation HotClasscifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
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

}

- (void) loadAlertView
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"您尚有商品未加入询价车,是否加入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [av setTag:10];
    [av show];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view tag] == 101)
        {
            [view setHidden:YES];
        }
        if([view isKindOfClass:[UISearchBar class]])
        {
            [view setHidden:YES];
        }
    }
    [self loadAskPriceCarCount];
    

    if (addToCarArray.count > 0)
    {
        for(UIView *view in self.sv.subviews)
        {
            if(view.frame.origin.x >= 1820)
            {
            }
            else
            {
                for(UIButton *subBtn in view.subviews)
                {
                    subBtn.selected = NO;

                }
            }
        }
        [addToCarArray removeAllObjects];
    }
}

- (void) askPriceBtnClick:(UIButton *) sender
{
    flag = NO;
    if(addToCarArray && addToCarArray.count != 0)
    {
        [self loadAlertView];
    }
    else
    {
        [self setHidesBottomBarWhenPushed:YES];
        B2BAskPriceCarViewController *b2bAskPriceCarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"b2bAskPriceCarViewController"];
        [self.navigationController pushViewController:b2bAskPriceCarViewController animated:YES];
    }

}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(HUD)
    {
        [HUD hide:YES];
    }
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLBatchJoinInquiryCartTag)
    {
        [DCFStringUtil showNotice:msg];
        if(result == 1)
        {
            [self setHidesBottomBarWhenPushed:YES];
            
            if(badgeBtn)
            {
                carCount = carCount + addToCarArray.count;
                [badgeBtn setTitle:[NSString stringWithFormat:@"%d",carCount] forState:UIControlStateNormal];
            }
//            if(addToCarArray)
//            {
//                [addToCarArray removeAllObjects];
//            }
            B2BAskPriceCarViewController *b2bAskPriceCarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"b2bAskPriceCarViewController"];
            [self.navigationController pushViewController:b2bAskPriceCarViewController animated:YES];
        }
        else
        {
            [DCFStringUtil showNotice:msg];
        }
    }
    if(URLTag == URLInquiryCartCountTag)
    {
        if(result == 1)
        {
            carCount = [[dicRespon objectForKey:@"value"] intValue];
        }
        else
        {
            carCount = 0;
        }
        if(carCount < 99 && carCount > 0)
        {
            [badgeBtn setFrame:CGRectMake(askPriceBtn.frame.size.width-22, 5, 18, 18)];
            [badgeBtn setBackgroundImage:[UIImage imageNamed:@"msg_bq.png"] forState:UIControlStateNormal];
            [badgeBtn setTitle:[NSString stringWithFormat:@"%d",carCount] forState:UIControlStateNormal];
        }
        else if (carCount >= 99)
        {
            [badgeBtn setFrame:CGRectMake(askPriceBtn.frame.size.width-22, 5, 24, 18)];
            [badgeBtn setBackgroundImage:[UIImage imageNamed:@"msg_bqy.png"] forState:UIControlStateNormal];
            [badgeBtn setTitle:@"99+" forState:UIControlStateNormal];
        }
        if(carCount == 0)
        {
            [badgeBtn setHidden:YES];
        }
        else
        {
            [badgeBtn setHidden:NO];
        }
    }
}

- (void) back:(id) sender
{
    flag = YES;
    if(addToCarArray && addToCarArray.count != 0)
    {
        [self loadAlertView];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    addPrice = 1;
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self pushAndPopStyle];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 15, 22)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"热门型号"];
    self.navigationItem.titleView = top;
    
    [self.upBtn setTitle:@"上一页" forState:UIControlStateNormal];
    [self.nextBtn setTitle:@"换一页" forState:UIControlStateNormal];
    
    addToCarArray = [[NSMutableArray alloc] init];
    
    askPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [askPriceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [askPriceBtn setTitle:@"询价车" forState:UIControlStateNormal];
    [askPriceBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [askPriceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [askPriceBtn setFrame:CGRectMake(0, 0, 80, 50)];
    [askPriceBtn addTarget:self action:@selector(askPriceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    badgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [badgeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [askPriceBtn addSubview:badgeBtn];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:askPriceBtn];
    self.navigationItem.rightBarButtonItem = item;
 
    self.addToAskPriceBtn.layer.cornerRadius = 5.0f;
    [self.addToAskPriceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addToAskPriceBtn.layer.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:142.0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    [_sv setContentSize:CGSizeMake(ScreenWidth*7, self.sv.frame.size.height-200)];
    [_sv setBounces:NO];
    _sv.delegate = self;
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0, ScreenHeight-145, ScreenWidth, 30);
    pageControl.currentPage=0;
    pageControl.numberOfPages=7;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:19/255.0 green:90/255.0 blue:168/255.0 alpha:1.0];
    [self.view addSubview:pageControl];
    
    if (pageControl.currentPage == 0)
    {
        self.upBtn.hidden = YES;
    }
    
    self.hotLineBtn.layer.cornerRadius = 5.0f;
    self.imBtn.layer.cornerRadius = 5.0f;
    self.moreModelBtn.layer.cornerRadius = 5.0f;
    self.directBtn.layer.cornerRadius = 5.0f;
    
    btnArray = [[NSMutableArray alloc] init];
    for(UIView *view in self.sv.subviews)
    {
        if(view.frame.origin.x >= 1820)
        {
        }
        else
        {
            for(UIButton *subBtn in view.subviews)
            {
                //图片拉伸自适应
                [subBtn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                UIImage *image = [UIImage imageNamed:@"hotModelSelected.png"];
                image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 10, 10)];
                
                [subBtn setBackgroundImage:image forState:UIControlStateSelected];
                [subBtn addTarget:self action:@selector(hotModelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                [btnLabel setText:@"+1"];
                [btnLabel setBackgroundColor:[UIColor clearColor]];
                [btnLabel setTextColor:[UIColor redColor]];
                [btnLabel setFont:[UIFont systemFontOfSize:23]];
                [btnLabel setAlpha:0];
                [subBtn addSubview:btnLabel];
                
                [btnArray addObject:subBtn];
            }
        }
        
    }
    [self allKinds:btnArray];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(isShowPageControl) userInfo:nil repeats:NO];
}

-(void)isShowPageControl
{
    pageControl.hidden = YES;
}

-(void)loadAskPriceCarCount
{
    //请求询价车商品数量
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"InquiryCartCount",time];
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
    
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLInquiryCartCountTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/InquiryCartCount.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];

}


#pragma mark - 所有型号的分类，一级，二级，三级
- (void) allKinds:(NSMutableArray *) arr
{
    //读取plist文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"KindsPlist" ofType:@"plist"];
    dic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
}

- (void) hotModelBtnClick:(UIButton *) sender
{
    btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    UILabel *b = nil;
    for(UIView *view in btn.subviews)
    {
        if([view isKindOfClass:[UILabel class]])
        {
            b = (UILabel *)view;
        }
    }
   
    if(btn.selected == YES)
    {
        [addToCarArray addObject:btn];
    }
    else
    {
        [addToCarArray removeObject:btn];
    }
    
    
    
//    int badge = addToCarArray.count;
//    NSString *str = nil;
//    if(badge <= 0)
//    {
//        str = [NSString stringWithFormat:@"%@",@"询价车"];
//    }
//    else
//    {
//        str = [NSString stringWithFormat:@"询价车 +%i",badge];
//    }
//    [askPriceBtn setTitle:str forState:UIControlStateNormal];
}



- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    pageControl.hidden = NO;
    CGFloat pageWidth = self.view.frame.size.width;
    page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    pageControl.currentPage = page;
    if (pageControl.currentPage == 6)
    {
        self.nextBtn.hidden = YES;
        self.upBtn.hidden = NO;
    }
    if (pageControl.currentPage == 0)
    {
        self.nextBtn.hidden = NO;
        self.upBtn.hidden = YES;
    }
    if (pageControl.currentPage != 0)
    {
        self.upBtn.hidden = NO;
    }
    if (pageControl.currentPage != 6)
    {
        self.nextBtn.hidden = NO;
    }
    
    timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hidenPageControl) userInfo:nil repeats:NO];
}

-(void)hidenPageControl
{
    pageControl.hidden = YES;
}

- (NSString *)dictoJSON:(NSDictionary *)theDic
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strP = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    return [Rsa rsaEncryptString:strP];
    return strP;
}

- (void) addToCar
{
    if(!addToCarArray || addToCarArray.count == 0)
    {
        [DCFStringUtil showNotice:@"您尚未选择型号"];
        return;
    }
    
    NSMutableArray *modelListArray = [[NSMutableArray alloc] init];
    for(UIButton *btnn in addToCarArray)
    {
        NSString *s = [btnn titleLabel].text;
        
        NSDictionary *d = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:s]];
        
        NSString *oneKind = [d objectForKey:@"oneKind"];
        NSString *twoKind = [d objectForKey:@"twoKind"];
        NSString *threeKind = [d objectForKey:@"threeKind"];
        
        NSDictionary *senderDic = [[NSDictionary alloc] initWithObjectsAndKeys:s,@"model",oneKind,@"firsttype",twoKind,@"secondtype",threeKind,@"thirdtype", nil];
        
        [modelListArray addObject:senderDic];
    }
    
    NSDictionary *pushDic = [[NSDictionary alloc] initWithObjectsAndKeys:modelListArray,@"modellist", nil];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"BatchJoinInquiryCart",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    
    NSString *visitorid = [app getUdid];
    
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    NSString *pushString = nil;
    if(hasLogin == YES)
    {
        pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&items=%@",memberid,token,[self dictoJSON:pushDic]];
    }
    else
    {
        pushString = [NSString stringWithFormat:@"visitorid=%@&token=%@&items=%@",visitorid,token,[self dictoJSON:pushDic]];
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"正在加入询价车..."];
    [HUD setDelegate:self];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLBatchJoinInquiryCartTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/BatchJoinInquiryCart.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (IBAction)addToAskPriceCarBtnClick:(id)sender
{
    [self addToCar];
}

- (IBAction)searchBtnClick:(id)sender
{
}

- (IBAction)nextBtnClick:(id)sender
{
    if(page >= 6)
    {
        return;
    }
    else
    {
        page++;
        [self.sv setContentOffset:CGPointMake(ScreenWidth*page, 0) animated:YES];
    }
     timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hidenPageControl) userInfo:nil repeats:NO];
}

- (IBAction)upBtnClick:(id)sender
{
    if(page <= 0)
    {
        return;
    }
    else
    {
        page--;
        [self.sv setContentOffset:CGPointMake(ScreenWidth*page, 0) animated:YES];
    }
     timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hidenPageControl) userInfo:nil repeats:NO];
}

- (IBAction)hotLineBtnClick:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"您确定要拨打热线电话么" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    [av setTag:20];
    [av show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            if(alertView.tag == 10)
            {
                if(flag == YES)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [self setHidesBottomBarWhenPushed:YES];
                    B2BAskPriceCarViewController *b2bAskPriceCarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"b2bAskPriceCarViewController"];
                    [self.navigationController pushViewController:b2bAskPriceCarViewController animated:YES];
                }
            }
            break;
        case 1:
            if(alertView.tag == 10)
            {
                [self addToCar];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008280188"]];
            }
            break;
        default:
            break;
    }
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (IBAction)imbtnClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    if ([self.appDelegate.isConnect isEqualToString:@"连接"])
    {
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        chatVC.fromStringFlag = @"热门型号在线咨询";
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
        chatVC.fromString = @"热门型号在线咨询";
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

- (IBAction)moreModelBtnClick:(id)sender
{
   [self.sv setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)directBtnClick:(id)sender
{
    SpeedAskPriceFirstViewController *speedAskPriceFirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"speedAskPriceFirstViewController"];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:speedAskPriceFirstViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
