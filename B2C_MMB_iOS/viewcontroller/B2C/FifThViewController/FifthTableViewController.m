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
#import "PhoneHelper.h"
#import "AccountManagerTableViewController.h"

@interface FifthTableViewController ()
{
    AppDelegate *app;
    NSMutableArray *arr;
    UIStoryboard *sb;
    BOOL isPopShow;
    int tempCount;
    int tempShopCar;
    
    
    NSString *sdPath;
    
    float sdPicCache;  //SDWebImage图片缓存大小
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
//    [self.navigationController.tabBarController.tabBar setHidden:NO];
    
    [self loadbadgeCount];
    
    [self loadShopCarCount];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popShopCar_more:) name:@"popShopCar" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (changeClick:) name:@"dissMiss" object:nil];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"frommore"];
    if (str.length > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToHostView_more" object:nil];
    }
    
    self.tableView.scrollEnabled = YES;
    isPopShow = NO;
    [KxMenu dismissMenu];
    
    //    NSLog(@"%@",NSHomeDirectory());
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    //    NSLog(@"%@",paths);
    NSString *LibraryDirectory = [paths objectAtIndex:0];
    //    NSLog(@"%@",LibraryDirectory);
    sdPath = [NSString stringWithFormat:@"%@/%@/%@",LibraryDirectory,@"Caches",@"com.hackemist.SDWebImageCache.default"];
    //    NSLog(@"%@",sdPath);
    
    [self folderSizeAtPath:sdPath];
    
    [self.cacheBtn setTitle:[NSString stringWithFormat:@"%.2fM",sdPicCache] forState:UIControlStateNormal];
    [self.cacheBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.cacheBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    self.cacheBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
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
//    self.logOutBtn.frame = CGRectMake(15, 30, self.view.frame.size.width-30, 60);
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.view1.frame = CGRectMake(0,50-0.5 , ScreenWidth+10, 0.5);
//    self.view2.frame = CGRectMake(0,50-0.5 , ScreenWidth+10, 0.5);
//    self.view3.frame = CGRectMake(0,50-0.5 , ScreenWidth+10, 0.5);
//    self.view1.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
//    self.view2.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
//    self.view3.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
}

#pragma mark - 单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - 遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    sdPicCache = folderSize/(1024.0*1024.0);
    return sdPicCache;
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            BOOL bRet = [fileMgr fileExistsAtPath:sdPath];
            if (bRet)
            {
                NSError *err;
                [fileMgr removeItemAtPath:sdPath error:&err];
                
                [self.cacheBtn setTitle:[NSString stringWithFormat:@"%.2fM",[self folderSizeAtPath:sdPath]] forState:UIControlStateNormal];
                [self.tableView reloadData];
            }
            break;
        }
        case 1:
        {
            break;
        }
        default:
            break;
    }
}

- (IBAction)cacheBtnClick:(id)sender
{
    as = [[UIActionSheet alloc] initWithTitle:@"您确定要清除缓存图片吗？"
                                     delegate:self
                            cancelButtonTitle:@"取消"
                       destructiveButtonTitle:@"确定"
                            otherButtonTitles:nil, nil];
    [as showInView:[UIApplication sharedApplication].keyWindow];
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
        if([DCFCustomExtra validateString:memberid] == NO)
        {
            memberid = @"";
        }
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
            
            [DCFCustomExtra cleanData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hasLogOut" object:[NSNumber numberWithBool:YES]];
            
            [DCFStringUtil showNotice:@"退出成功"];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"app_username"];
            [self loadbadgeCount];

            //切换登录账号，结束之前对话
            [self.appDelegate goOffline];
            [self.appDelegate logout];
            [[NSUserDefaults standardUserDefaults] setObject:[PhoneHelper getDeviceId] forKey:@"userName_IM"];
            [self.appDelegate reConnect];
            self.appDelegate.isConnect = @"断开";
        }
    }
    if (URLTag == URLInquiryCartCountTag)
    {
        if (result == 1)
        {
           tempCount = [[dicRespon objectForKey:@"value"] intValue];
        }
        [self loadShopCarCount];
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
        NSLog(@"第一个");
        [self setHidesBottomBarWhenPushed:YES];
        AccountManagerTableViewController *accountManagerTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"accountManagerTableViewController"];
        [self.navigationController pushViewController:accountManagerTableViewController animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }
    if(indexPath.row == 1)
    {
        SettingViewController *set = [self.storyboard instantiateViewControllerWithIdentifier:@"settingViewController"];
        [self.navigationController pushViewController:set animated:YES];
    }
    if(indexPath.row == 2)
    {
        NSLog(@"清理缓存");
    }
    if(indexPath.row == 3)
    {
        HotLineViewController *hot = [self.storyboard instantiateViewControllerWithIdentifier:@"hotLineViewController"];
        [self.navigationController pushViewController:hot animated:YES];
    }
    if(indexPath.row == 4)
    {
        NSLog(@"意见与建议");
    }
    if(indexPath.row == 5)
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
