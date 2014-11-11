//
//  SearchViewController.m
//  B2C_MMB_iOS
//
//  Created by developer on 14-11-11.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "SearchViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
//#import "FMDatabaseAdditions.h"
#import "AppDelegate.h"
#import "KxMenu.h"

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

@interface SearchViewController ()
{
    AppDelegate *app;
    NSMutableArray *cabelNameArray;
    
    UILabel *leftBtn;
    
    NSMutableArray *dataArray;
}
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self exeuteCabelList];
    
    //导航栏标题
    UILabel *naviTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,220, 44)];
    naviTitle.textColor = [UIColor blackColor];
    naviTitle.backgroundColor = [UIColor clearColor];
    naviTitle.textAlignment = NSTextAlignmentCenter;
    naviTitle.text = @"搜索";
    self.navigationItem.titleView = naviTitle;
    
    leftBtn = [[UILabel alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 95, 47);
    leftBtn.backgroundColor = [UIColor clearColor];
    leftBtn.font = [UIFont systemFontOfSize:13];
    leftBtn.textAlignment = 1;
    leftBtn.text = @"电缆采购";
    [self.view addSubview:leftBtn];
    
    UIView *tempview = [[UIView alloc] init];
    tempview.frame = CGRectMake(0, 0, 80, 47);
    [self.view insertSubview:tempview aboveSubview:leftBtn];
    
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftBtnClick:)];
    [tempview addGestureRecognizer:searchTap];
    
    UIImageView *sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(83,18.5,10,10)];
    [sectionBtnIv setImage:[UIImage imageNamed:@"down_dark.png"]];
    [sectionBtnIv setContentMode:UIViewContentModeScaleToFill];
    sectionBtnIv.tag = 300;
    [tempview addSubview:sectionBtnIv];
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(leftBtn.frame.origin.x + leftBtn.frame.size.width + 5, 3.5, 215, 40)];
    [mySearchBar setDelegate:self];
    [mySearchBar setBarStyle:0];
    mySearchBar.placeholder = @"输入搜索内容";
    mySearchBar.layer.cornerRadius = 8;
    mySearchBar.layer.borderWidth = 1;
    mySearchBar.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:mySearchBar];
    
    UIButton *speakButton = [[UIButton alloc] initWithFrame:CGRectMake(178, 7, 25, 25)];
    [speakButton setBackgroundImage:[UIImage imageNamed:@"speak"] forState:UIControlStateNormal];
    [speakButton addTarget:self action:@selector(soundSrarch) forControlEvents:UIControlEventTouchUpInside];
    [mySearchBar addSubview:speakButton];
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.frame = CGRectMake(0, 47.5, self.view.frame.size.width, 0.5);
    separateLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:separateLine];
    
    self.serchResultView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, self.view.frame.size.width, self.view.frame.size.height-48) style:UITableViewStylePlain];
    self.serchResultView.dataSource = self;
    self.serchResultView.delegate = self;
    self.serchResultView.scrollEnabled = YES;
    self.serchResultView.backgroundColor = [UIColor lightGrayColor];
    self.serchResultView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    self.serchResultView.separatorColor = [UIColor lightGrayColor];
    [self.view addSubview:self.serchResultView];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setFrame:CGRectMake(mySearchBar.frame.origin.x + mySearchBar.frame.size.width + 10, 10, 60, 25)];
    [rightBtn setTitle:@"询价车" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    dataArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3", nil];
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

- (void) leftBtnClick:(UITapGestureRecognizer *) sender
{
    //    if(mySearchBar.isFirstResponder)
    //    {
    //        [mySearchBar resignFirstResponder];
    //    }
    NSLog(@"searchTap:");
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
                  fromRect:leftBtn.frame
                 menuItems:menuItems];
    
}

- (void) pushMenuItem:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dissMiss" object:nil];
    NSLog(@"%@",[[[[[NSString stringWithFormat:@"%@",sender] componentsSeparatedByString:@" "] objectAtIndex:2] componentsSeparatedByString:@">"] objectAtIndex:0]);
    leftBtn.text = [[[[[NSString stringWithFormat:@"%@",sender] componentsSeparatedByString:@" "] objectAtIndex:2] componentsSeparatedByString:@">"] objectAtIndex:0];
    
    
}

-(void)changeClick:(NSNotification *)viewChanged
{
    UIImageView *currentIV= (UIImageView *)[self.view viewWithTag:300];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return dataArray.count;
}

- (void) clearBtnClick:(UIButton *) sender
{
    if(dataArray && dataArray.count != 0)
    {
        [dataArray removeAllObjects];
        [self.serchResultView reloadData];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor colorWithRed:232.0/255 green:232.0/255 blue:232.0/255 alpha:1.0];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.text = dataArray[indexPath.row];
        
        UITableViewHeaderFooterView *view = [self.serchResultView footerViewForSection:1];
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360, 57.0)];
        UIButton* btnNextPage = [[UIButton alloc] initWithFrame:footerView.frame];
        btnNextPage.titleLabel.text = @"next_page";
        [footerView addSubview:btnNextPage];
        [view addSubview:footerView];
    }
    return cell;
    
    
//    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        if(!cell)
//        {
//            cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cell_Id];
//        }
//        
//        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [clearBtn setFrame:CGRectMake(80, 5, 160, 40)];
//        [clearBtn setBackgroundColor:[UIColor redColor]];
//        [clearBtn setTitle:@"清空历史纪录" forState:UIControlStateNormal];
//        [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        clearBtn.layer.borderColor = [UIColor blueColor].CGColor;
//        clearBtn.layer.borderWidth = 1.0f;
//        clearBtn.layer.cornerRadius = 5;
//        clearBtn.layer.masksToBounds = YES;
//        //        [cell.contentView addSubview:clearBtn];
//        
//
//    
//
//   [cell.textLabel setText:[dataArray objectAtIndex:indexPath.row]];
//
//    return cell;
}

//- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [UIView new];
//}
//
//- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.1;
//}


@end
