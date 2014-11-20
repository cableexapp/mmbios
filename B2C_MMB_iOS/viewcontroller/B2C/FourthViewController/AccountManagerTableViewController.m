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
#import "ModifyBangDingMobileViewController.h"
#import "BangDingWithOutMobileOrEmailViewController.h"
#import "BangDingWithMobileOrEmailViewController.h"
#import "AddBangDingMobileViewController.h"

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
   
//    phone = @"13921307065";
    email = @"306233304@qq.com";
    
    [self.tableView reloadData];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 44;
    }
    if(indexPath.row == 1)
    {
        if(phone.length == 0 || [phone isKindOfClass:[NSNull class]] || phone == NULL || phone == nil)
        {
            [self.cell_2 setHidden:YES];
            return 0;
        }
        else
        {
            [self.cell_2 setHidden:NO];
            return 44;
        }
    }
    if(indexPath.row == 2)
    {
        if(phone.length == 0 || [phone isKindOfClass:[NSNull class]] || phone == NULL || phone == nil)
        {
            [self.cell_3 setHidden:NO];
            return 44;
        }
        else
        {
            [self.cell_3 setHidden:YES];
            return 0;
        }
    }
    return 44;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setHidesBottomBarWhenPushed:YES];

    

    

    if(indexPath.row == 0)
    {
        if((phone.length == 0 || [phone isKindOfClass:[NSNull class]] || phone == NULL || phone == nil) && (email.length == 0 || [email isKindOfClass:[NSNull class]] || email ==NULL || email == nil))
        {
            BangDingWithOutMobileOrEmailViewController *bangDingWithOutMobileOrEmailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"bangDingWithOutMobileOrEmailViewController"];
            [self.navigationController pushViewController:bangDingWithOutMobileOrEmailViewController animated:YES];
        }
        else
        {
            BangDingWithMobileOrEmailViewController *bangDingWithMobileOrEmailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"bangDingWithMobileOrEmailViewController"];
            bangDingWithMobileOrEmailViewController.myPhone = phone;
            bangDingWithMobileOrEmailViewController.myEmail = email;
            [self.navigationController pushViewController:bangDingWithMobileOrEmailViewController animated:YES];
        }
    }
    if(indexPath.row == 1)
    {
        ModifyBangDingMobileViewController *modifyBangDingMobileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"modifyBangDingMobileViewController"];
        [self.navigationController pushViewController:modifyBangDingMobileViewController animated:YES];
    }
    if(indexPath.row == 2)
    {
        AddBangDingMobileViewController *addBangDingMobileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addBangDingMobileViewController"];
        [self.navigationController pushViewController:addBangDingMobileViewController animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
