//
//  AddReceiveFourthViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-25.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "AddReceiveFourthViewController.h"
#import "DCFCustomExtra.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "AppDelegate.h"
#import "AddReceiveFinalViewController.h"

@implementation AddReceiveFourthViewController
{
    AppDelegate *app;
    
    NSMutableArray *dataArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithData:(NSArray *) array WithTown:(NSString *) town;
{
    if(self = [super init])
    {
        dataArray = [[NSMutableArray alloc] initWithArray:array];
        
        _town = town;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    [self pushAndPopStyle];
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"新增收货地址"];
    self.navigationItem.titleView = top;
    
    
    [self loadDataBase];
}

- (void) loadDataBase
{
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight-64)];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:tv];
    
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *celldId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celldId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:celldId];
        [cell setSelectionStyle:0];
        [cell setAccessoryType:1];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    NSString *s = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [cell.textLabel setText:s];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%@%@",_town,[[dataArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    NSString *code = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"code"]];
    
    //    BOOL swithStatus = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"swithStatus"] boolValue];
    
    AddReceiveFinalViewController *final = [[AddReceiveFinalViewController alloc] initWithAddress:str WithCode:code WithSwithStatus:YES];
    
    [self.navigationController pushViewController:final animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
