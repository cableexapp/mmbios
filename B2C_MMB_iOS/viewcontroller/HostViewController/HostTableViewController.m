//
//  HostTableViewController.m
//  tttt
//
//  Created by xiaochen on 14-8-29.
//  Copyright (c) 2014年 MySelfDemo. All rights reserved.
//

#import "HostTableViewController.h"
#import "DCFCustomExtra.h"
#import "ChooseListTableViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "ShoppingHostViewController.h"

@interface HostTableViewController ()
{
    NSArray *textViewDataArray;
    NSArray *moneyDataArray;
    
    NSArray *categoryDataArray;
    NSArray *listDataArray;
}
@end

@implementation HostTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    if(searchBar)
//    {
//        [searchBar resignFirstResponder];
//    }
    
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view tag] == 101)
        {
            [view setHidden:NO];
        }
        if([view isKindOfClass:[UISearchBar class]])
        {
            [view setHidden:YES];
        }
    }
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopNsTimer" object:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startNsTimer" object:nil];
}


- (void) searchTap:(UITapGestureRecognizer *) sender
{
    ChooseListTableViewController *choose = [[ChooseListTableViewController alloc] init];
    [self.navigationController pushViewController:choose animated:YES];
}

- (void) search:(UIButton *) sender
{
    ChooseListTableViewController *choose = [[ChooseListTableViewController alloc] init];
    [self.navigationController pushViewController:choose animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self pushAndPopStyle];
    
    UIImage *naviimage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mmb" ofType:@"png"]];
    UIImageView *naviImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [naviImageView setImage:naviimage];
    [naviImageView setTag:100];
    [self.navigationController.navigationBar addSubview:naviImageView];
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(naviImageView.frame.origin.x + naviImageView.frame.size.width + 10, naviImageView.frame.origin.y+5, 200, 34)];
//    searchImageView setImage:<#(UIImage *)#>
    [searchImageView setUserInteractionEnabled:YES];
    [searchImageView setTag:101];
    [self.navigationController.navigationBar addSubview:searchImageView];
    [searchImageView setBackgroundColor:[UIColor greenColor]];
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTap:)];
    [searchImageView addGestureRecognizer:searchTap];
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    textViewDataArray = [[NSArray alloc] initWithObjects:
                         @"查看",
                         @"查看UIGestureRecognizer源码发现了问题，苹果已经给我们做了封装，获取他都父视图不是通过superview，而是在 ",
                         @"查看UIGestureRecognizer源码发现了问题，苹果已经给我们做了封装，获取他都父视图不是通过superview，而是在UIGestureRecognizer中声明了一个属性view，通过这个属性就可以获取它都父视图 ",
                         @"查看UIGestureRecognizer源码发现了问题，苹果已经给我们做了封装，获取他都父视图不是通过superview，而是在UIGestureRecognizer中声明了一个属性view，通过这个属性就可以获取它都父视图 ",
                         @"查看UIGestureRecognizer源码发现了问题，苹果已经给我们做了封装，获取他都父视图不是通过superview，而是在UIGestureRecognizer中声明了一个属性view，通过这个属性就可以获取它都父视图 ",
                         @"查看UIGestureRecognizer源码发现了问题，苹果已经给我们做了封装，获取他都父视图不是通过superview，而是在UIGestureRecognizer中声明了一个属性view，通过这个属性就可以获取它都父视图 ",
                         
                         @"查看UIGestureRecognizer源码发现了问题，苹果已经给我们做了封装，获取他都父视图不是通过superview，而是在UIGestureRecognizer中声明了一个属性view，通过这个属性就可以获取它都父视图 ",
                         @"查看UIGestureRecognizer源码发现了问题，苹果已经给我们做了封装，获取他都父视图不是通过superview，而是在UIGestureRecognizer中声明了一个属性view，通过这个属性就可以获取它都父视图 ",
                         @"查看UIGestureRecognizer源码发现了问题，苹果已经给我们做了封装，获取他都父视图不是通过superview，而是在UIGestureRecognizer中声明了一个属性view，通过这个属性就可以获取它都父视图 ",
                         @"查看UIGestureRecognizer源码发现了问题，苹果已经给我们做了封装，获取他都父视图不是通过superview，而是在UIGestureRecognizer中声明了一个属性view，通过这个属性就可以获取它都父视图 ",
                   
                         nil];
    
    moneyDataArray = [[NSArray alloc] initWithObjects:@"98",@"99",@"100",@"101",@"102",@"103",@"104",@"105",@"106",@"107", nil];
    
    categoryDataArray = [[NSArray alloc] initWithObjects:
                         @"通信电缆       网络线",
                         @"通信电缆    宽带用铜芯聚乙烯绝缘铝综合护套",
                         @"低压电力电缆宽带用铜芯聚乙烯绝缘铝综合护套",
                         nil];
    
    listDataArray = [[NSArray alloc] initWithObjects:
                     @"照明/插座用线",
                     @"空调/热水器用线",
                     @"进户总线",
                     @"装潢明线",
                     @"电源连接线",
                     @"",nil];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 3)
    {
        return textViewDataArray.count/2;
    }
    if(section == 2)
    {
        return 3;
    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        return 44;
    }
    else if (indexPath.section == 0)
    {
        return 80;
    }
    else if (indexPath.section == 1)
    {
        return 200;
    }
    return 260;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0 || section == 1)
    {
        return 0;
    }
    return 30;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [headBackView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    [headImageView setImage:[UIImage imageNamed:@"caLogo.png"]];
    [headBackView addSubview:headImageView];
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.frame.origin.x + headImageView.frame.size.width + 10, headImageView.frame.origin.y, 200, 20)];
    if(section == 3)
    {
        [headLabel setText:@"热门电缆"];
    }
    else if (section == 2)
    {
        [headLabel setText:@"强势分类"];
    }
    else
    {
        [headLabel setText:@""];
    }
    [headLabel setTextAlignment:NSTextAlignmentLeft];
    [headBackView addSubview:headLabel];
    
    return headBackView;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:0];
    }
    if(indexPath.section == 0)
    {
        if(!es)
        {
            NSArray *imageArray = [[NSArray alloc] initWithObjects:@"sv_1.png",@"sv_2.png",@"sv_3.png", nil];
            es = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, 320, 80) ImageArray:imageArray TitleArray:nil WithTag:0];
            es.delegate = self;
            [cell.contentView addSubview:es];
        }

    }
    if(indexPath.section == 1)
    {
        UIView *section_two = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 200)];
        [section_two setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:section_two];
        
        for(int i=0;i<3;i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setShowsTouchWhenHighlighted:NO];
            switch (i) {
                case 0:
                    [btn setFrame:CGRectMake(10, 10, 145, 180)];
                    [btn setBackgroundImage:[UIImage imageNamed:@"cell_1.png"] forState:UIControlStateNormal];
                    break;
                case 1:
                    [btn setFrame:CGRectMake(165, 10, 135, 60)];
                    [btn setBackgroundImage:[UIImage imageNamed:@"cell_2.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [btn setFrame:CGRectMake(165, 80, 135, 110)];
                    [btn setBackgroundImage:[UIImage imageNamed:@"cell_3.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:i+10];
            [section_two addSubview:btn];
        }
    }
    if(indexPath.section == 2)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setText:[categoryDataArray objectAtIndex:indexPath.row]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    }
    if(indexPath.section == 3)
    {
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
        [firstLabel setTextAlignment:NSTextAlignmentLeft];
        [firstLabel setText:[listDataArray objectAtIndex:indexPath.row]];
        [firstLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:firstLabel];
        
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, 5, 20, 20)];
        [arrowImageView setImage:[UIImage imageNamed:@"caLogo.png"]];
        [cell.contentView addSubview:arrowImageView];
        
        for(int i = 0;i < 2; i++)
        {
            
            UIView *cabelShowView = [[UIView alloc] initWithFrame:CGRectMake(10 + 155*i,firstLabel.frame.origin.y + firstLabel.frame.size.height + 10, 145, 220)];
            [cabelShowView setBackgroundColor:[UIColor grayColor]];
            [cabelShowView setTag:2*indexPath.row + i ];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [cabelShowView addGestureRecognizer:tap];
            
            [cell.contentView addSubview:cabelShowView];
            
            UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 145, 145)];
            [pic setImage:[UIImage imageNamed:@"cabel.png"]];
            [cabelShowView addSubview:pic];
            
            UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(pic.frame.origin.x, pic.frame.origin.y + pic.frame.size.height + 10, pic.frame.size.width, 30)];
            [tv setBackgroundColor:[UIColor clearColor]];
            [tv setDelegate:self];
            [tv setText:[textViewDataArray objectAtIndex:2*indexPath.row + i]];
            [tv setFont:[UIFont systemFontOfSize:9]];
            [cabelShowView addSubview:tv];
            
            UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(pic.frame.origin.x, tv.frame.origin.y + tv.frame.size.height + 5, pic.frame.size.width, 20)];
            NSString *money = [NSString stringWithFormat:@"  %@  %@",@"¥",[moneyDataArray objectAtIndex:2*indexPath.row + i]];
            [moneyLabel setText:money];
            [moneyLabel setTextColor:[UIColor redColor]];
            [cabelShowView addSubview:moneyLabel];
        }
    }
 
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
    return cell;
}

-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    
}

- (void) timer:(NSTimer *) sender
{
    
}

- (void) btnClick:(UIButton *) sender
{
    int tag = [sender tag];
    if(tag == 12)
    {
        [self setHidesBottomBarWhenPushed:YES];
        ShoppingHostViewController *shoppingHost = [[ShoppingHostViewController alloc] init];
        [self.navigationController pushViewController:shoppingHost animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}



- (void) tap:(UITapGestureRecognizer *) sender
{    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
