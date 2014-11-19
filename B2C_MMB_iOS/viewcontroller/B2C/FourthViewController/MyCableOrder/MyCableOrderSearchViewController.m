//
//  MyCableOrderSearchViewController.m
//  B2C_MMB_iOS
//
//  Created by developer on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyCableOrderSearchViewController.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface MyCableOrderSearchViewController ()
{
    UISearchBar *search;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *searchResults;
    NSMutableArray *dataArray;
}

@end

@implementation MyCableOrderSearchViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航栏标题
    UILabel *naviTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100, 44)];
    naviTitle.textColor = [UIColor whiteColor];
    naviTitle.backgroundColor = [UIColor clearColor];
    naviTitle.font = [UIFont systemFontOfSize:19];
    naviTitle.textAlignment = NSTextAlignmentCenter;
    naviTitle.text = @"订单搜索";
    self.navigationItem.titleView = naviTitle;
    
//    search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 45)];
//    [search setDelegate:self];
////    [search setBarStyle:0];
//    search.autocorrectionType = UITextAutocorrectionTypeNo;
//    search.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    search.placeholder = @"输入搜索内容";
//    [self.view addSubview:search];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45,self.view.frame.size.width,self.view.frame.size.height-45) style:UITableViewStylePlain];
    self.tableView.separatorColor = [UIColor colorWithRed:153.0/255.0 green:206.0/255.0 blue:250.0/255.0 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    search = [[UISearchBar alloc] init];
    search.frame = CGRectMake(0, 0,self.view.frame.size.width, 45);
    search.delegate = self;
    search.backgroundColor = [UIColor clearColor];
    search.autocorrectionType = UITextAutocorrectionTypeNo;
    search.autocapitalizationType = UITextAutocapitalizationTypeNone;
    search.placeholder = @"搜索";
    
    //    search.backgroundImage = [UIImage imageNamed:@"搜索.png"];
    [self.view addSubview:search];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:search contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    dataArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return searchResults.count;
    }
    else
    {
        return dataArray.count;
    }
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [self.tableView setContentInset:UIEdgeInsetsZero];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];//以indexPath来唯一确定cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor blackColor];
//        UIImage *cellImage = [UIImage imageNamed:@"列表箭头.png"];
//        UIImageView *cellImageView = [[UIImageView alloc] initWithImage:cellImage];
//        cellImageView.frame = CGRectMake(290, 10, 15, 25);
//        [cell addSubview:cellImageView];
    }
//    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"列表背景.png"]];
//    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"列表背景-高亮.png"]];
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = searchResults[indexPath.row];
    }
    else
    {
        cell.textLabel.text = dataArray[indexPath.row];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"键盘搜索.....");
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidBeginEditing");
    search.frame = CGRectMake(0, 20,self.view.frame.size.width, 45);
     self.searchDisplayController.searchResultsTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    search.frame = CGRectMake(0, 0,self.view.frame.size.width, 45);
    NSLog(@"searchBarTextDidEndEditing");
}

- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchResults = [[NSMutableArray alloc]init];
    if (search.text.length>0&&![ChineseInclude isIncludeChineseInString:search.text])
    {
        for (int i=0; i<dataArray.count; i++)
        {
            if ([ChineseInclude isIncludeChineseInString:dataArray[i]])
            {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:dataArray[i]];
                NSRange titleResult=[tempPinYinStr rangeOfString:search.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0)
                {
                    [searchResults addObject:dataArray[i]];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:dataArray[i]];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:search.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0)
                {
                    [searchResults addObject:dataArray[i]];
                }
            }
            else
            {
                NSRange titleResult=[dataArray[i] rangeOfString:search.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0)
                {
                    [searchResults addObject:dataArray[i]];
                }
            }
        }
    }
    else if (search.text.length>0&&[ChineseInclude isIncludeChineseInString:search.text])
    {
        for (NSString *tempStr in dataArray)
        {
            NSRange titleResult=[tempStr rangeOfString:search.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0)
            {
                [searchResults addObject:tempStr];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
