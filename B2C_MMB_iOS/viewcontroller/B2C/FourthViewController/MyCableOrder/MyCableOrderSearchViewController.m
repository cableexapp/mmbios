//
//  MyCableOrderSearchViewController.m
//  B2C_MMB_iOS
//
//  Created by developer on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyCableOrderSearchViewController.h"

@interface MyCableOrderSearchViewController ()
{
    UISearchBar *mySearchBar;
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
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 45)];
    [mySearchBar setDelegate:self];
    [mySearchBar setBarStyle:0];
    mySearchBar.placeholder = @"输入搜索内容";
    [self.view addSubview:mySearchBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"键盘搜索.....");
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{

    if ([searchBar.text isEqualToString:@""])
    {
        
    }
    else
    {
       
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
