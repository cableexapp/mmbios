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
#import "DCFCustomExtra.h"

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

- (void) viewWillAppear:(BOOL)animated
{
    phone = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserPhone"]];
    email = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmail"]];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"账户管理"];
    self.navigationItem.titleView = top;
    
    phone = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserPhone"]];
    email = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmail"]];
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.frame = CGRectMake(0, self.cell_1.frame.size.height-0.5, self.cell_1.frame.size.width, 0.5);
    lineView1.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.frame = CGRectMake(0, self.cell_1.frame.size.height-0.5, self.cell_1.frame.size.width, 0.5);
    lineView2.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.frame = CGRectMake(0, self.cell_1.frame.size.height-0.5, self.cell_1.frame.size.width, 0.5);
    lineView3.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    [self.cell_1 addSubview:lineView1];
    [self.cell_2 addSubview:lineView2];
    [self.cell_3 addSubview:lineView3];
    self.cell_1.contentView.backgroundColor = [UIColor whiteColor];
    self.cell_1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.cell_2.backgroundColor = [UIColor whiteColor];
    self.cell_2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.cell_3.backgroundColor = [UIColor whiteColor];
    self.cell_3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self.tableView reloadData];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 50;
        self.cell_1.contentView.backgroundColor = [UIColor whiteColor];
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
            self.cell_2.backgroundColor = [UIColor whiteColor];
            return 50;
        }
    }
    if(indexPath.row == 2)
    {
        if(phone.length == 0 || [phone isKindOfClass:[NSNull class]] || phone == NULL || phone == nil)
        {
            [self.cell_3 setHidden:NO];
            return 50;
        }
        else
        {
            [self.cell_3 setHidden:YES];
            return 0;
        }
    }
    return 50;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        //         UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
//        //         view.backgroundColor = [DCFColorUtil colorFromHexRGB:@"#f1f1f1"];
//        //         [cell.contentView addSubview:view];
//        
//        
//        //         cell.font = [UIFont systemFontOfSize:16];
//        cell.backgroundColor = [UIColor clearColor];
//        
//    }
//    return cell;
//}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setHidesBottomBarWhenPushed:YES];

//    cxboss405@163.com
    
//    phone = @"13921307054";
//    email = @"cxboss405@163.com";
    if(indexPath.row == 0)
    {
        if([DCFCustomExtra validateString:phone] == NO && [DCFCustomExtra validateString:email] == NO)
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
}

@end
