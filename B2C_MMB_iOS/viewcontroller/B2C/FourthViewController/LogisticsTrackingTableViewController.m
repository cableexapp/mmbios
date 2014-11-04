//
//  LogisticsTrackingTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-27.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "LogisticsTrackingTableViewController.h"
#import "LogisticsTrackingTableViewCell.h"
#import "DCFChenMoreCell.h"

@interface LogisticsTrackingTableViewController ()
{
    DCFChenMoreCell *moreCell;
}
@end

@implementation LogisticsTrackingTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [moreCell startAnimation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_myArray || _myArray.count == 0)
    {
        return 44;
    }
    return 60;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 30)];
    [label setText:@" 物流详情"];
    [label setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0]];
    return label;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!_myArray || _myArray.count == 0)
    {
        return 1;
    }
    return [[_myArray lastObject] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_myArray || _myArray.count == 0)
    {
        static NSString *moreCellId = @"moreCell";
        moreCell = (DCFChenMoreCell *)[tableView dequeueReusableCellWithIdentifier:moreCellId];
        if(moreCell == nil)
        {
            moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
            [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
            if(_isRequest == YES)
            {
                [moreCell startAnimation];
            }
            else
            {
                [moreCell noDataAnimation]; 
            }
        }
        return moreCell;
    }
    
    static NSString *cellId = @"logisticsTrackingTableViewCell";
    LogisticsTrackingTableViewCell *cell = (LogisticsTrackingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[LogisticsTrackingTableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        
    }
    if(indexPath.row == 0)
    {
        [cell.showBtn setBackgroundColor:[UIColor greenColor]];
        [cell.statusLabel setTextColor:[UIColor greenColor]];
    }
    else
    {
        [cell.showBtn setBackgroundColor:[UIColor grayColor]];
        [cell.statusLabel setTextColor:[UIColor grayColor]];
    }
    [cell.statusLabel setText:[[[_myArray lastObject] objectAtIndex:indexPath.row] objectForKey:@"context"]];
    [cell.dateLabel setText:[[[_myArray lastObject] objectAtIndex:indexPath.row] objectForKey:@"time"]];
    
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

@end