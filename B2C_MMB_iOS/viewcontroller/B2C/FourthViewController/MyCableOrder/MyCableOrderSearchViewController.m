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
    int isSearch;
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45,self.view.frame.size.width,self.view.frame.size.height-109) style:UITableViewStylePlain];
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
    search.placeholder = @"输入搜索内容";
    [self.view addSubview:search];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:search contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.delegate = self;
    
    dataArray = [[NSMutableArray alloc] initWithObjects:@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"10", nil];
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
	return 100;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor blackColor];
    }
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
    NSLog(@"didSelectRowAtIndexPath");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"键盘搜索.....");
    [search resignFirstResponder];
    search.frame = CGRectMake(0, 20,self.view.frame.size.width, 45);
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    search.frame = CGRectMake(0, 20,self.view.frame.size.width, 45);
    self.searchDisplayController.searchResultsTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (search.text.length > 0)
    {
        search.frame = CGRectMake(0, 20,self.view.frame.size.width, 45);
    }
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    NSLog(@"searchDisplayControllerWillBeginSearch");
}
- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
     NSLog(@"searchDisplayControllerDidBeginSearch");
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    NSLog(@"searchDisplayControllerWillEndSearch");
    search.frame = CGRectMake(0, 0,self.view.frame.size.width, 45);
}
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    NSLog(@"searchDisplayControllerDidEndSearch");
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    NSLog(@"willHideSearchResultsTableView");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    NSLog(@"didHideSearchResultsTableView");
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
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",searchText];
    NSLog(@"searchArray = %@",[NSArray arrayWithArray:[dataArray filteredArrayUsingPredicate:pred]]);
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
