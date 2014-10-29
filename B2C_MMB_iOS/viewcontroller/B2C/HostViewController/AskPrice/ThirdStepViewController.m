//
//  ThirdStepViewController.m
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-19.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import "ThirdStepViewController.h"
#import "DCFTopLabel.h"
#import "ChooseTypeViewController.h"

@interface ThirdStepViewController ()
{
    NSArray *dataArray;
}
@end

@implementation ThirdStepViewController

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
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"三级分类选择"];
    self.navigationItem.titleView = top;
    
    dataArray = [[NSArray alloc] initWithObjects:
                 @"三级分类",
                 @"6～35kv交联聚乙烯绝缘",
                 @"耐高温电力电缆",
                 @"普通",
                 @"钢芯铝绞线芯",
                 @"钢芯铝合金绞线芯",
                 @"铝合金芯",
                 @"铝芯",
                 @"铜芯",
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
    NSString *title = [NSString stringWithFormat:@"%@>%@",_headTitle,[dataArray objectAtIndex:indexPath.row]];
    ChooseTypeViewController *choose = [[ChooseTypeViewController alloc] initWithHeadTitle:title];
    [self.navigationController pushViewController:choose animated:YES];
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
