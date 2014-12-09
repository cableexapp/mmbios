//
//  ThirdTableViewController.m
//  tttt
//
//  Created by xiaochen on 14-8-29.
//  Copyright (c) 2014年 MySelfDemo. All rights reserved.
//

#import "ThirdTableViewController.h"
#import "SettingViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "HotLineViewController.h"
#import "AboutViewController.h"
#import "LoginNaviViewController.h"

@interface ThirdTableViewController ()

@end

@implementation ThirdTableViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"更多"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
}

- (IBAction)logOutBtnClick:(id)sender
{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
    [self presentViewController:loginNavi animated:YES completion:nil];

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
