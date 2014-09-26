//
//  ChooseListTableViewController.m
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-8-30.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import "ChooseListTableViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
//#import "FMDatabaseAdditions.h"
#import "AppDelegate.h"

@interface ChooseListTableViewController ()
{
    AppDelegate *app;
    NSMutableArray *cabelNameArray;
    
    NSMutableArray *contentArray;
    
    DCFPickerView *pickerView;
    
    UIButton *leftBtn;
    
    NSMutableArray *dataArray;
}
@end

@implementation ChooseListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - 查询用户的查询记录
- (void) exeuteCabelList
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSLog(@"userId = %@",userId);
    
    cabelNameArray = [[NSMutableArray alloc] init];

    FMResultSet *rs = [app.db executeQuery:@"SELECT * FROM PrivateMessage WHERE UserId = ?",userId];
    while ([rs next])
    {
        NSString *cabelName = [rs stringForColumn:@"SearchCabelName"];
        [cabelNameArray addObject:cabelName];
    }
    NSLog(@"%@",cabelNameArray);
    [rs close];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view isKindOfClass:[UIButton class]] || [view tag] == 101)
        {
            [view setHidden:YES];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self pushAndPopStyle];

//    [self.navigationItem setHidesBackButton:YES];
    
    [self exeuteCabelList];
    
    contentArray = [[NSMutableArray alloc] initWithObjects:@"电缆采购",@"家装线专卖", nil];
    
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 10, 80, 27)];
    [leftBtn setBackgroundColor:[UIColor grayColor]];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [leftBtn setTitle:@"电缆采购" forState:UIControlStateNormal];
    [leftBtn setShowsTouchWhenHighlighted:NO];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = left;
    

    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(leftBtn.frame.origin.x + leftBtn.frame.size.width + 10, 4, 180, 35)];
    [mySearchBar setDelegate:self];
    [mySearchBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar addSubview:mySearchBar];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:[UIColor redColor]];
    [rightBtn setFrame:CGRectMake(mySearchBar.frame.origin.x + mySearchBar.frame.size.width + 10, 10, 40, 25)];
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.navigationController.navigationBar addSubview:rightBtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    dataArray = [[NSMutableArray alloc] init];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [mySearchBar resignFirstResponder];
}

- (void) rightBtnClick:(UIButton *) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void) leftBtnClick:(UIButton *) sender
{
    if(mySearchBar.isFirstResponder)
    {
        [mySearchBar resignFirstResponder];
    }
        pickerView = [[DCFPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.window.frame.size.height) WithArray:contentArray];
        pickerView.delegate = self;
        [self.view.window setBackgroundColor:[UIColor blackColor]];
        [self.view.window addSubview:pickerView];
}


- (void) pickerView:(NSString *) title
{
    [leftBtn setTitle:title forState:UIControlStateNormal];
    
        dataArray = [[NSMutableArray alloc] initWithObjects:title,title,title,title,title,title,title,title,title,nil];
    [self.tableView reloadData];
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
    if(dataArray && dataArray.count == 0)
    {
        return 1;
    }
    return dataArray.count + 1;
}

- (void) clearBtnClick:(UIButton *) sender
{
    if(dataArray && dataArray.count != 0)
    {
        [dataArray removeAllObjects];
        [self.tableView reloadData];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(dataArray && dataArray.count == 0)
//    {
//        return 50;
//    }
    if(indexPath.row == dataArray.count)
    {
        return 50;
    }
    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == dataArray.count)
    {
        static NSString *cell_Id = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Id];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cell_Id];
        }
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearBtn setFrame:CGRectMake(80, 5, 160, 40)];
        [clearBtn setBackgroundColor:[UIColor redColor]];
        [clearBtn setTitle:@"清空历史纪录" forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        clearBtn.layer.borderColor = [UIColor blueColor].CGColor;
        clearBtn.layer.borderWidth = 1.0f;
        clearBtn.layer.cornerRadius = 5;
        clearBtn.layer.masksToBounds = YES;
        [cell.contentView addSubview:clearBtn];
        
        return cell;
    }
    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    [tableView setSeparatorStyle:0];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
    }
    [cell.textLabel setText:[dataArray objectAtIndex:indexPath.row]];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    [lineView setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:223.0/255.0 alpha:1.0]];
    [cell.contentView addSubview:lineView];
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
@end
