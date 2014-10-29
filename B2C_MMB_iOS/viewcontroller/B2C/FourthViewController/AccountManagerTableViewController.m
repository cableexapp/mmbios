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

@interface AccountManagerTableViewController ()

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
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        [self setHidesBottomBarWhenPushed:YES];
        ModifyLoginSecViewController *modifyLoginSecViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"modifyLoginSecViewController"];
        [self.navigationController pushViewController:modifyLoginSecViewController animated:YES];
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
