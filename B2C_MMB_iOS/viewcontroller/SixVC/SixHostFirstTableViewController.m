//
//  SixHostFirstTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 15-3-25.
//  Copyright (c) 2015年 YUANDONG. All rights reserved.
//

#import "SixHostFirstTableViewController.h"
#import "MCDefine.h"

@interface SixHostFirstTableViewController ()
{
    NSIndexPath *selectPath;
}
@end

@implementation SixHostFirstTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0,0,0,0);

    [self.tableView setShowsVerticalScrollIndicator:NO];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    [self.tableView deselectRowAtIndexPath:selectPath animated:YES];
}


- (void)didReceiveMemoryWarning {
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        [cellLabel setTag:10];
        [cell.contentView addSubview:cellLabel];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    [label setText:[NSString stringWithFormat:@" cell%ld--%ld",(long)indexPath.section,(long)indexPath.row]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectPath = indexPath;
}
@end
