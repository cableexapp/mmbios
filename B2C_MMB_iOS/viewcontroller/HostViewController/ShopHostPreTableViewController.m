//
//  ShopHostPreTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-11.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "ShopHostPreTableViewController.h"
#import "MCDefine.h"

@interface ShopHostPreTableViewController ()

@end

@implementation ShopHostPreTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithScoreArray:(NSArray *) scoreArray WithListArray:(NSArray *) listArray WithTitle:(NSString *) title
{
    if(self = [super init])
    {
        discussArray = [[NSMutableArray alloc] init];
        if(scoreArray.count != 0)
        {
            for(int i=0;i<4;i++)
            {
                [discussArray addObject:[scoreArray objectAtIndex:i]];
            }
        }
        NSLog(@"%@",discussArray);
        
        ListArray = [[NSArray alloc] initWithArray:listArray];
        NSLog(@"%@",ListArray);
        
        headTitle = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 190;
    }
    return 30;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [headLabel setText:headTitle];
    [headLabel setTextAlignment:NSTextAlignmentCenter];
    [headLabel setFont:[UIFont systemFontOfSize:20]];
    [headLabel setBackgroundColor:[UIColor whiteColor]];
    return headLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + ListArray.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    
    if(indexPath.row == 0)
    {
        for(int i=0;i<discussArray.count+1;i++)
        {
            UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+30*i, self.view.frame.size.width, 30)];
            [cellLabel setTextAlignment:NSTextAlignmentCenter];
            if(i == 0 || i == 1)
            {
                [cellLabel setText:[discussArray objectAtIndex:0]];
            }
            else
            {
                [cellLabel setText:[discussArray objectAtIndex:i-1]];
            }
            [cell.contentView addSubview:cellLabel];
        }
    }
    else
    {
        [cell.textLabel setText:[ListArray objectAtIndex:indexPath.row-1]];
    }
    return cell;
}





- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = nil;
    if(indexPath.row == 0)
    {
        str = @"";
    }
    else
    {
        str = [ListArray objectAtIndex:indexPath.row-1];
    }
    [self.delegate pushText:str];
}


@end
