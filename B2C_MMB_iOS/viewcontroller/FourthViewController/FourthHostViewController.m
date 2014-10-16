//
//  FourthHostViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "FourthHostViewController.h"
#import "MyOrderHostTableViewCell.h"
#import "DCFTopLabel.h"
#import "DCFStringUtil.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "DCFChenMoreCell.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "MyOrderHostBtnTableViewCell.h"
#import "LookForCustomViewController.h"
#import "DiscussViewController.h"

@interface FourthHostViewController ()
{
    NSMutableArray *btnArray;
}
@end

@implementation FourthHostViewController

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
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"我的家装馆订单"];
    self.navigationItem.titleView = top;
    
    btnArray = [[NSMutableArray alloc] initWithObjects:self.allBtn,self.waitForPayBtn,self.waitForSureBtn,self.waitForDiscussBtn, nil];
    for(int i=0;i<btnArray.count;i++)
    {
        UIButton *btn = (UIButton *)[btnArray objectAtIndex:i];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithRed:97.0/255.0 green:93.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:238.0/255.0 green:234.0/255.0 blue:241.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        
        [btn setTag:i];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.tv setDataSource:self];
    [self.tv setDelegate:self];
}


- (void) btnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    
    int tag = btn.tag;
    
    for(UIButton *b in btnArray)
    {
        if(b.tag == tag)
        {
            [b setSelected:YES];
        }
        else
        {
            [b setSelected:NO];
        }
    }
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 56;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    [headView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
    
    for(int i=0;i<4;i++)
    {
        UILabel *label = [[UILabel alloc] init];
        if(i == 0)
        {
            [label setFrame:CGRectMake(0, 5, 65, 21)];
            [label setFont:[UIFont systemFontOfSize:13]];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setText:@"订单编号:"];
        }
        if(i == 1)
        {
            [label setFrame:CGRectMake(65, 5, 136, 21)];
            [label setFont:[UIFont systemFontOfSize:13]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setText:@"201409809876793"];
        }
        if(i == 2)
        {
            [label setFrame:CGRectMake(201, 5, 119, 21)];
            [label setFont:[UIFont systemFontOfSize:11]];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setText:@"2014-08-15 18:05"];
        }
        if(i == 3)
        {
            [label setFrame:CGRectMake(10, 26, ScreenWidth-10, 25)];
            [label setFont:[UIFont systemFontOfSize:14]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setText:@"华东电缆旗舰店"];
        }
        [headView addSubview:label];
    }
    
    return headView;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1)
    {
        static NSString *cellId = @"myOrderHostBtnTableViewCell";
        MyOrderHostBtnTableViewCell *cell = (MyOrderHostBtnTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        if(cell == nil)
        {
            cell = [[MyOrderHostBtnTableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        }
        [cell.lookForCustomBtn setTag:0];
        [cell.lookForCustomBtn addTarget:self action:@selector(lookForCustomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.discussBtn setTag:1];
        [cell.discussBtn addTarget:self action:@selector(discussBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.lookForTradeBtn setTag:2];
        [cell.lookForTradeBtn addTarget:self action:@selector(lookForTradeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.cancelOrderBtn setTag:3];
        [cell.cancelOrderBtn addTarget:self action:@selector(cancelOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    static NSString *cellId = @"myOrderHostTableViewCell";
    MyOrderHostTableViewCell *cell = (MyOrderHostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[MyOrderHostTableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
    }
//    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
//    {
//        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
//    }
    
    return cell;
}

- (void) lookForCustomBtnClick:(UIButton *) sender
{
    NSLog(@"%d",sender.tag);
    
    [self setHidesBottomBarWhenPushed:YES];
    LookForCustomViewController *custom = [self.storyboard instantiateViewControllerWithIdentifier:@"lookForCustomViewController"];
    [self.navigationController pushViewController:custom animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}


- (void) discussBtnClick:(UIButton *) sender
{
    NSLog(@"%d",sender.tag);
    
    [self setHidesBottomBarWhenPushed:YES];
    DiscussViewController *disCuss = [self.storyboard instantiateViewControllerWithIdentifier:@"discussViewController"];
    [self.navigationController pushViewController:disCuss animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void) lookForTradeBtnClick:(UIButton *) sender
{
    NSLog(@"%d",sender.tag);
}

- (void) cancelOrderBtnClick:(UIButton *) sender
{
    NSLog(@"%d",sender.tag);
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
//- (IBAction)allBtnClick:(id)sender
//{
//    
//}
//
//- (IBAction)waitForBtnClick:(id)sender
//{
//    
//}
//
//- (IBAction)waitForSureBtnClick:(id)sender
//{
//    
//}
//
//- (IBAction)waitForDiscussBtnClick:(id)sender
//{
//    
//}

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
