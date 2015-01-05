//
//  HasNotLoginViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-24.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "HasNotLoginViewController.h"
#import "DCFTopLabel.h"
#import "LoginNaviViewController.h"
#import "DCFCustomExtra.h"
#import "KxMenu.h"
#import "AppDelegate.h"
#import "MCDefine.h"
#import "MyShoppingListViewController.h"
#import "B2BAskPriceCarViewController.h"
#import "UIImageView+WebCache.h"
#import "RegisterViewController.h"

@interface HasNotLoginViewController ()
{
    BOOL isPopShow;
    AppDelegate *app;
    int tempCount;
    int tempShopCar;
    NSMutableArray *arr;
    UIStoryboard *sb;
}

@end

@implementation HasNotLoginViewController

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
    // Do any additional setup after loading the view.
    
    self.loginBtn.layer.cornerRadius = 5.0f;
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@""];
    self.navigationItem.titleView = top;
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
}

- (IBAction)loginBtnClick:(id)sender
{
    app.speedRegister = NO;

    LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
    [self presentViewController:loginNavi animated:YES completion:nil];

}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }

    [self setHidesBottomBarWhenPushed:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popShopCar" object:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [DCFCustomExtra cleanData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self loadbadgeCount];
    isPopShow = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popShopCar_notLogin:) name:@"popShopCar" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (changeClick:) name:@"dissMiss" object:nil];
    
    [self.headpic.layer setCornerRadius:CGRectGetHeight([self.headpic bounds])/2];  //修改半径，实现头像的圆形化
    self.headpic.layer.masksToBounds = YES;
    NSString *headPortraitUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"headPortraitUrl"];
    [self.headpic setImageWithURL:[NSURL URLWithString:headPortraitUrl] placeholderImage:[UIImage imageNamed:@"headPic.png"]];
}

//请求询价车商品数量
-(void)loadbadgeCount
{
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

//获取购物车商品数量
-(void)loadShopCarCount
{
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
     int result = [[dicRespon objectForKey:@"result"] intValue];
    if (URLTag == URLInquiryCartCountTag)
    {
        if(result == 1)
        {
            tempCount = [[dicRespon objectForKey:@"value"] intValue];
            
            [self loadShopCarCount];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidenRedPoint" object:@"1"];
    }
    if (tempCount == 0 && tempShopCar == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidenRedPoint" object:@"2"];
    }
}

- (void)popShopCar_notLogin:(NSNotification *)sender
{
    if (isPopShow == YES)
    {
        [KxMenu dismissMenu];
        isPopShow = NO;
    }
    else
    {
        NSArray *menuItems =
        @[[KxMenuItem menuItem:[NSString stringWithFormat:@"购物车(%d)",tempShopCar]
                         image:nil
                        target:self
                        action:@selector(pushMenuItem_mmb:)],
          
          [KxMenuItem menuItem:[NSString stringWithFormat:@"询价车(%d)",tempCount]
                         image:nil
                        target:self
                        action:@selector(pushMenuItem_mmb:)],
          ];
        
        [KxMenu showMenuInView:self.view
                      fromRect:CGRectMake(self.view.frame.size.width/5-15, self.view.frame.size.height, self.view.frame.size.height/5, 49)
                     menuItems:menuItems];
        isPopShow = YES;
    }
}

- (void)pushMenuItem_mmb:(id)sender
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
        [self.navigationController pushViewController:b2bAskPriceCar animated:YES];
    }
    [self setHidesBottomBarWhenPushed:NO];
}

-(void)changeClick:(NSNotification *)viewChanged
{
    if (isPopShow == YES)
    {
        isPopShow = NO;
    }
    else
    {
        isPopShow = YES;
    }
}

- (IBAction)registerBtnClick:(id)sender
{
    app.speedRegister = YES;
    
    LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
    [self presentViewController:loginNavi animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
