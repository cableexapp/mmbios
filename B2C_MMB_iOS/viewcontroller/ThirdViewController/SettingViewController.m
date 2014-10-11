//
//  SettingViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-10.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "SettingViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"设置"];
    self.navigationItem.titleView = top;
    
    [self.view setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.cleanBackView addGestureRecognizer:tap];
    [self.cleanBackView setUserInteractionEnabled:YES];
    
    [self.swith setOn:[[[NSUserDefaults standardUserDefaults] objectForKey:@"closeOrOpenPush"] boolValue]];
    [self.swith addTarget:self action:@selector(swichChange:) forControlEvents:UIControlEventValueChanged];
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    NSLog(@"tap");
    
    as = [[UIActionSheet alloc] initWithTitle:@"您确定要清除缓存图片吗" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [as showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"确定") ;
            break;
        case 1:
             break;
        default:
            break;
    }
}

- (void) swichChange:(UISwitch *) sender
{
    UISwitch *swith_1 = (UISwitch *)sender;
    BOOL isChange = [swith_1 isOn];
    if(isChange == YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"closeOrOpenPush"];
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge  | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"closeOrOpenPush"];
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
