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
#import "KxMenu.h"

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

@interface ChooseListTableViewController ()
{
    AppDelegate *app;
    NSMutableArray *cabelNameArray;
    
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
    
    cabelNameArray = [[NSMutableArray alloc] init];

    FMResultSet *rs = [app.db executeQuery:@"SELECT * FROM PrivateMessage WHERE UserId = ?",userId];
    while ([rs next])
    {
        NSString *cabelName = [rs stringForColumn:@"SearchCabelName"];
        [cabelNameArray addObject:cabelName];
    }
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

    //导航栏标题
    UILabel *naviTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,220, 44)];
    naviTitle.textColor = [UIColor blackColor];
    naviTitle.backgroundColor = [UIColor clearColor];
    naviTitle.textAlignment = NSTextAlignmentCenter;
    naviTitle.text = @"搜索";
    self.navigationItem.titleView = naviTitle;
    
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(-5, 10, 90, 37)];
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [leftBtn setTitle:@"电缆采购" forState:UIControlStateNormal];
    [leftBtn setShowsTouchWhenHighlighted:NO];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIImageView *sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(75,13,10,10)];
    [sectionBtnIv setImage:[UIImage imageNamed:@"down_dark.png"]];
    [sectionBtnIv setContentMode:UIViewContentModeScaleToFill];
    sectionBtnIv.tag = 300;
    [leftBtn addSubview: sectionBtnIv];
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(leftBtn.frame.origin.x + leftBtn.frame.size.width + 5, 5, 180, 40)];
    [mySearchBar setDelegate:self];
    [mySearchBar setBarStyle:0];
    mySearchBar.placeholder = @"输入搜索内容";
//    mySearchBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mySearchBar];
    
    UIButton *speakButton = [[UIButton alloc] initWithFrame:CGRectMake(leftBtn.frame.origin.x + leftBtn.frame.size.width + 193, 12.5, 33, 33)];
    [speakButton setBackgroundImage:[UIImage imageNamed:@"speak"] forState:UIControlStateNormal];
    [speakButton addTarget:self action:@selector(soundSrarch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:speakButton];
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.frame = CGRectMake(0, 47.5, self.view.frame.size.width, 0.5);
    separateLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:separateLine];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setFrame:CGRectMake(mySearchBar.frame.origin.x + mySearchBar.frame.size.width + 10, 10, 60, 25)];
    [rightBtn setTitle:@"询价车" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    dataArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (changeClick:) name:@"dissMiss" object:nil];
}

-(void)soundSrarch
{
    NSLog(@"语音搜素");
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
   [self.navigationController.tabBarController.tabBar setHidden:NO];
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
//    if(mySearchBar.isFirstResponder)
//    {
//        [mySearchBar resignFirstResponder];
//    }
//        pickerView = [[DCFPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.window.frame.size.height) WithArray:contentArray WithTag:1000];
//        pickerView.delegate = self;
//        [self.view.window setBackgroundColor:[UIColor blackColor]];
//        [self.view.window addSubview:pickerView];
    UIImageView *currentIV= (UIImageView *)[self.view viewWithTag:300];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"电缆采购"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"家装线专卖"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
    ];    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
    
}

- (void) pushMenuItem:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dissMiss" object:nil];
    NSLog(@"%@", sender);
    
}

-(void)changeClick:(NSNotification *)viewChanged
{
    UIImageView *currentIV= (UIImageView *)[self.view viewWithTag:300];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
}

- (void) pickerView:(NSString *) title WithTag:(int)tag
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
//        [cell.contentView addSubview:clearBtn];
        
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
