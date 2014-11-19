//
//  AddReceiveAddressViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-24.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "AddReceiveAddressViewController.h"
#import "DCFCustomExtra.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "AppDelegate.h"
#import "AddReceiveAddressSecondViewController.h"

@interface AddReceiveAddressViewController ()
{
    AppDelegate *app;
    
    NSMutableArray *dataArray;
}
@end

@implementation AddReceiveAddressViewController

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
    
    [self.view setBackgroundColor:[UIColor redColor]];
    
    [self pushAndPopStyle];
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"新增收货地址"];
    self.navigationItem.titleView = top;
    
    
    [self loadDataBase];
    
    // Do any additional setup after loading the view.
}

- (void) loadDataBase
{
    dataArray = [[NSMutableArray alloc] init];
    
    FMResultSet *rs = [app.db executeQuery:@"SELECT * FROM t_prov_city_area_street"];
    while ([rs next])
    {
        NSString *level = [rs stringForColumn:@"level"];
        if([level isEqualToString:@"1"])
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    AddReceiveAddressSecondViewController *second = [[AddReceiveAddressSecondViewController alloc] initWithData:[dataArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:second animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
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
