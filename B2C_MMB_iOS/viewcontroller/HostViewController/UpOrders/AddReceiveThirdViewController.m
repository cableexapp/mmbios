//
//  AddReceiveThirdViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-25.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "AddReceiveThirdViewController.h"
#import "DCFCustomExtra.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "AppDelegate.h"
#import "AddReceiveFourthViewController.h"
#import "AddReceiveFinalViewController.h"

@implementation AddReceiveThirdViewController
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

- (id) initWithData:(NSDictionary *) dic WithProvince:(NSString *) province
{
    if(self = [super init])
    {
        _myDic = [[NSDictionary alloc] initWithDictionary:dic];
        
        _city = [_myDic objectForKey:@"name"];
        
        
        _provinceAndCity = [NSString stringWithFormat:@"%@,%@",province,_city];
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
    dataArray = [[NSMutableArray alloc] init];
    
    NSString *code = [_myDic objectForKey:@"code"];
    
    FMResultSet *rs = [app.db executeQuery:@"SELECT * FROM t_prov_city_area_street WHERE parentId = ?",code];
    while ([rs next])
    {
        NSString *level = [rs stringForColumn:@"level"];
        if([level isEqualToString:@"3"])
        {
            NSString *name = [rs stringForColumn:@"name"];
            NSString *code = [rs stringForColumn:@"code"];
            NSString *parentId = [rs stringForColumn:@"parentId"];
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 name,@"name",
                                 code,@"code",
                                 parentId,@"parentId",
                                 nil];
            [dataArray addObject:dic];
        }
    }
    [rs close];
    
    
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
    NSString *s = [NSString stringWithFormat:@"%@   %@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"name"],[[dataArray objectAtIndex:indexPath.row] objectForKey:@"code"]];
    [cell.textLabel setText:s];
    return cell;
}


#pragma mark - 在家修改

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSString *code = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"code"];
    
    FMResultSet *rs = [app.db executeQuery:@"SELECT * FROM t_prov_city_area_street WHERE parentId = ?",code];
    while ([rs next])
    {
        NSString *level = [rs stringForColumn:@"level"];
        if([level isEqualToString:@"4"])
        {
            NSString *name = [rs stringForColumn:@"name"];
            NSString *code = [rs stringForColumn:@"code"];
            NSString *parentId = [rs stringForColumn:@"parentId"];
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 name,@"name",
                                 code,@"code",
                                 parentId,@"parentId",
                                 nil];
            [arr addObject:dic];
        }
    }
    [rs close];
    
    NSString *town = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString *str = [NSString stringWithFormat:@"%@,%@",_provinceAndCity,town];

    
    if(arr.count != 0)
    {
        AddReceiveFourthViewController *fourth = [[AddReceiveFourthViewController alloc] initWithData:arr WithTown:str];
        [self.navigationController pushViewController:fourth animated:YES];
        
    }
    else
    {
        NSString *code = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"code"]];
        //        BOOL swithStatus = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"swithStatus"] boolValue];
        
        AddReceiveFinalViewController *final = [[AddReceiveFinalViewController alloc] initWithAddress:str WithCode:code WithSwithStatus:YES];
        
        [self.navigationController pushViewController:final animated:YES];
    }
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
