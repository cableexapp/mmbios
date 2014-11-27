//
//  SecondStepViewController.m
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-19.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import "SecondStepViewController.h"
#import "DCFTopLabel.h"
#import "ThirdStepViewController.h"

@interface SecondStepViewController ()
{
    NSArray *dataArray;
}
@end

@implementation SecondStepViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithHeadTitle:(NSString *) title
{
    if(self = [super init])
    {
        _headTitle = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"二级分类选择"];
    self.navigationItem.titleView = top;
    
    dataArray = [[NSArray alloc] initWithObjects:
                 @"布电线",
                 @"防火电缆",
                 @"电焊机电缆",
                 @"船用电缆",
                 @"计算机电缆",
                 @"特种电器装备电缆",
                 @"控制电缆",
                 @"橡套电缆",
                 @"公路车辆用线",
                 nil];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight) style:0];
    [tv setDelegate:self];
    [tv setDataSource:self];
    [tv setShowsVerticalScrollIndicator:NO];
    [tv setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255 blue:242.0/255.0 alpha:1.0]];
    [self.view addSubview:tv];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [headview setBackgroundColor:[UIColor whiteColor]];
    NSString *title = [NSString stringWithFormat:@"已选分类:%@",_headTitle];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 50)];
    [label setText:title];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setBackgroundColor:[UIColor clearColor]];
    [headview addSubview:label];
    
    return headview;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    
    UIView  *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [cellView setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255 blue:242.0/255.0 alpha:1.0]];
    [cell.contentView addSubview:cellView];

    
    [cell.textLabel setText:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        return;
    }
    NSString *title = [NSString stringWithFormat:@"%@>%@",_headTitle,[dataArray objectAtIndex:indexPath.row]];
    ThirdStepViewController *third = [[ThirdStepViewController alloc] initWithHeadTitle:title];
    [self.navigationController pushViewController:third animated:YES];
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
