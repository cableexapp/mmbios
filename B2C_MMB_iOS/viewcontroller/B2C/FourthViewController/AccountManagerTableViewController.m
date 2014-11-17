//
//  AccountManagerTableViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-17.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "AccountManagerTableViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "ModifyLoginSecViewController.h"
#import "ModifyTelViewController.h"
#import "BangDingWithOutMobileOrEmailViewController.h"
#import "BangDingWithMobileOrEmailViewController.h"

@interface AccountManagerTableViewController ()
{
    NSString *phone;
    NSString *email;
}
@end

@implementation AccountManagerTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"账户管理"];
    self.navigationItem.titleView = top;
    
    phone = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserPhone"]];
    email = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmail"]];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setHidesBottomBarWhenPushed:YES];

    if(indexPath.row == 0)
    {
        if(phone.length == 0 && email.length == 0)
        {
            BangDingWithOutMobileOrEmailViewController *bangDingWithOutMobileOrEmailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"bangDingWithOutMobileOrEmailViewController"];
            [self.navigationController pushViewController:bangDingWithOutMobileOrEmailViewController animated:YES];
        }
        else
        {
            BangDingWithMobileOrEmailViewController *bangDingWithMobileOrEmailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"bangDingWithMobileOrEmailViewController"];
            [self.navigationController pushViewController:bangDingWithMobileOrEmailViewController animated:YES];
        }
    }
    if(indexPath.row == 1)
    {
        [self setHidesBottomBarWhenPushed:YES];
        ModifyTelViewController *modifyTelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"modifyTelViewController"];
        [self.navigationController pushViewController:modifyTelViewController animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
