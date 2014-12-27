//
//  FifthTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-25.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "FifthTableViewController.h"
#import "SettingViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "HotLineViewController.h"
#import "AboutViewController.h"
#import "LoginNaviViewController.h"
#import "DCFCustomExtra.h"
#import "AppDelegate.h"
#import "MCDefine.h"
#import "DCFStringUtil.h"
#import "MyShoppingListViewController.h"
#import "B2BAskPriceCarViewController.h"
#import "KxMenu.h"

@interface FifthTableViewController ()
{
    AppDelegate *app;
    NSMutableArray *arr;
    UIStoryboard *sb;
    BOOL isPopShow;
    int tempCount;
    int tempShopCar;
}
@end

@implementation FifthTableViewController

@synthesize xmppRoom;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    if(HUD)
    {
        [HUD hide:YES];
    }
    [self setHidesBottomBarWhenPushed:NO];
    isPopShow = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popShopCar" object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"])
    {
        [self.logOutBtn setHidden:YES];
    }
    else
    {
        [self.logOutBtn setHidden:NO];
    }
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    
    [self loadbadgeCount];
    
    [self loadShopCarCount];
    
    self.tableView.scrollEnabled = YES;
    isPopShow = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popShopCar_more:) name:@"popShopCar" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (changeClick:) name:@"dissMiss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToHomeVC_more:) name:@"goToHomeView" object:nil];

}

-(void)goToHomeVC_more:(NSNotification *)sender
{
    [self.tabBarController setSelectedIndex:0];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    
    NSLog(@"更多");
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"更多"];
    self.navigationItem.titleView = top;
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self pushAndPopStyle];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.logOutBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:99/255.0 blue:206/255.0 alpha:1.0];
    [self.logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.logOutBtn.layer.cornerRadius = 5;
    [self.logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    self.logOutBtn.frame = CGRectMake(15, 30, self.view.frame.size.width-30, 60);
    
    self.tableView.separatorColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.view1.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.view2.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.view3.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
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

- (void)popShopCar_more:(NSNotification *)sender
{
    if (isPopShow == YES)
    {
        [KxMenu dismissMenu];
        isPopShow = NO;
        self.tableView.scrollEnabled = YES;
    }
    else
    {
        NSArray *menuItems =
        @[[KxMenuItem menuItem:[NSString stringWithFormat:@"购物车(%d)",tempShopCar]
                         image:nil
                        target:self
                        action:@selector(pushMenuItem_more:)],
          
          [KxMenuItem menuItem:[NSString stringWithFormat:@"询价车(%d)",tempCount]
                         image:nil
                        target:self
                        action:@selector(pushMenuItem_more:)],
          ];
        
        [KxMenu showMenuInView:self.view
                      fromRect:CGRectMake(self.view.frame.size.width/5-15, self.view.frame.size.height, self.view.frame.size.height/5, 49)
                     menuItems:menuItems];
        isPopShow = YES;
        self.tableView.scrollEnabled = NO;
    }
}

- (void)pushMenuItem_more:(id)sender
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
        b2bAskPriceCar.fromString = @"更多";
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)logOutBtnClick:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出登录"
                                                        message:@"是否确定退出登录？"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"取消",@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if(!HUD)
        {
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [HUD setLabelText:@"正在退出"];
            [HUD setDelegate:self];
        }
        NSString *time = [DCFCustomExtra getFirstRunTime];
        NSString *string = [NSString stringWithFormat:@"%@%@",@"deleteAppCartItems",time];
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
        
        
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLDeleteAppCartItemsTag delegate:self];
        //        conn.LogOut = YES;
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/deleteAppCartItems.html?"];
        
        
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    }
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(HUD)
    {
        [HUD hide:YES];
    }
     int result = [[dicRespon objectForKey:@"result"] intValue];
    if(URLTag == URLDeleteAppCartItemsTag)
    {
        if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            [self.logOutBtn setHidden:NO];
            [DCFStringUtil showNotice:@"退出失败"];
            return;
        }
        if(result == 0)
        {
            [self.logOutBtn setHidden:NO];
            [DCFStringUtil showNotice:@"退出失败"];
            return;
        }
        else if(result == 1)
        {
            [self.logOutBtn setHidden:YES];
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"memberId"];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hasLogin"];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserPhone"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserPhone"];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmail"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserEmail"];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"regiserDic"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"regiserDic"];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"headPortraitUrl"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"headPortraitUrl"];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultReceiveAddress"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"defaultReceiveAddress"];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"SppedAskPriceTelNum"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SppedAskPriceTelNum"];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"loginid"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginid"];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"HotKindNum"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HotKindNum"];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"HotScreenNum"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HotScreenNum"];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"BillMsg"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"BillMsg"];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hasLogOut" object:[NSNumber numberWithBool:YES]];
            
            [DCFStringUtil showNotice:@"退出成功"];

            [self loadbadgeCount];
            [self loadShopCarCount];

            //切换登录账号，结束之前对话
            [self.appDelegate goOffline];

            self.appDelegate.isConnect = @"断开";
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"app_username"];
        }
    }
    if (URLTag == URLInquiryCartCountTag)
    {
        if (result == 1)
        {
           tempCount = [[dicRespon objectForKey:@"value"] intValue];
        }
    }
    if (URLTag == URLShopCarCountTag)
    {
        if (result == 1)
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


- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setHidesBottomBarWhenPushed:YES];
    if(indexPath.row == 0)
    {
        SettingViewController *set = [self.storyboard instantiateViewControllerWithIdentifier:@"settingViewController"];
        [self.navigationController pushViewController:set animated:YES];
    }
    if(indexPath.row == 1)
    {
        HotLineViewController *hot = [self.storyboard instantiateViewControllerWithIdentifier:@"hotLineViewController"];
        [self.navigationController pushViewController:hot animated:YES];
    }
    if(indexPath.row == 2)
    {
        AboutViewController *about = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutViewController"];
        [self.navigationController pushViewController:about animated:YES];
    }
    [self setHidesBottomBarWhenPushed:NO];
}


- (void) hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}

@end
