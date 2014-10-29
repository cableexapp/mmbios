//
//  LogisticsTrackingTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-27.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "LogisticsTrackingTableViewController.h"
#import "LogisticsTrackingTableViewCell.h"

@interface LogisticsTrackingTableViewController ()

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"logisticsTrackingTableViewCell";
    LogisticsTrackingTableViewCell *cell = (LogisticsTrackingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[LogisticsTrackingTableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
    }
    [cell.statusLabel setText:@"123"];
    [cell.dateLabel setText:@"321"];
    return cell;
}

@end
