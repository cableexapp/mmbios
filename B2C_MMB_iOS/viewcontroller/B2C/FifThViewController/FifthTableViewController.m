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

@interface FifthTableViewController ()
{
    AppDelegate *app;
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
