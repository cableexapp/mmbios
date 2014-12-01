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
}
@end

@implementation FifthTableViewController

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
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    [self setHidesBottomBarWhenPushed:NO];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"])
    {
        [self.logOutBtn setHidden:YES];
    }
    else
    {
        [self.logOutBtn setHidden:NO];
    }
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
    self.logOutBtn.frame = CGRectMake(15, 30, self.view.frame.size.width-30, 60);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popShopCar:) name:@"popShopCar" object:nil];
}

- (void)popShopCar:(NSNotification *)sender
{
    NSArray *menuItems =
    @[[KxMenuItem menuItem:@"  购物车  "
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"  询价车  "
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      ];
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(self.view.frame.size.width/5-15, self.view.frame.size.height, self.view.frame.size.height/5, 49)
                 menuItems:menuItems];
}

- (void)pushMenuItem:(id)sender
{
    NSLog(@"sender = %@",sender);
    NSLog(@"123 = %@",[[[[[NSString stringWithFormat:@"%@",sender] componentsSeparatedByString:@"   "] objectAtIndex:1] componentsSeparatedByString:@"  >"] objectAtIndex:0]);
    
    if ([[[[[[NSString stringWithFormat:@"%@",sender] componentsSeparatedByString:@"   "] objectAtIndex:1] componentsSeparatedByString:@"  >"] objectAtIndex:0] isEqualToString:@"购物车"])
    {
        NSLog(@"购物车");
//        [self setHidesBottomBarWhenPushed:YES];
        MyShoppingListViewController *shop = [[MyShoppingListViewController alloc] initWithDataArray:arr];
        [self.navigationController pushViewController:shop animated:YES];
        
    }
    else
    {
        NSLog(@"询价车");
//        [self setHidesBottomBarWhenPushed:YES];
        B2BAskPriceCarViewController *b2bAskPriceCar = [sb instantiateViewControllerWithIdentifier:@"b2bAskPriceCarViewController"];
        [self.navigationController pushViewController:b2bAskPriceCar animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)logOutBtnClick:(id)sender
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
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/deleteAppCartItems.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    NSLog(@"%@",dicRespon);
    if(HUD)
    {
        [HUD hide:YES];
    }
    if(URLTag == URLDeleteAppCartItemsTag)
    {
        int result = [[dicRespon objectForKey:@"result"] intValue];
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
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultReceiveAddress"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"defaultReceiveAddress"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hasLogOut" object:[NSNumber numberWithBool:YES]];
            
            [DCFStringUtil showNotice:@"退出成功"];
        }
    }
    
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
