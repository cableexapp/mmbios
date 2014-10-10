//
//  B2CShoppingSearchTableViewController.m
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-16.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import "B2CShoppingSearchViewController.h"
#import "MCDefine.h"

@interface B2CShoppingSearchViewController ()
{
    NSArray *sectionArray;
    NSArray *brandArray;
    
    
    NSMutableArray *ivArray;

}
@end

@implementation B2CShoppingSearchViewController

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

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [topView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [self.view addSubview:topView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    [label setText:@"商品分类"];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont boldSystemFontOfSize:17]];
    [label setBackgroundColor:[UIColor clearColor]];
    [topView addSubview:label];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn setFrame:CGRectMake(130, 10, 40, 20)];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:clearBtn];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(clearBtn.frame.origin.x + clearBtn.frame.size.width, clearBtn.frame.origin.y, 1, 20)];
    [lineView setBackgroundColor:[UIColor blueColor]];
    [topView addSubview:lineView];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setFrame:CGRectMake(lineView.frame.origin.x+lineView.frame.size.width, lineView.frame.origin.y, 40, 20)];
    [sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:sureBtn];
    
//    sectionArray = [[NSArray alloc] initWithObjects:@"品牌",@"用途",@"型号",@"横截面",@"颜色",@"芯数",@"单位", nil];


    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height, 320, ScreenHeight -  40 - 100) style:0];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:tv];
    
//    brandArray = [[NSArray alloc] initWithObjects:<#(id), ...#>, nil];
    
    NSArray *array1 = [[NSArray alloc] initWithObjects:@"诸葛亮",@"张飞",@"赵云",@"威严",nil];
	NSArray *array2 = [[NSArray alloc] initWithObjects:@"司马懿",@"郭嘉",@"典伟",@"寻",@"曹仁",nil];
	NSArray *array3 = [[NSArray alloc] initWithObjects:@"关羽",@"赵云",nil];
	NSArray *array4 = [[NSArray alloc] initWithObjects:@"马呆",@"张合",nil];
	
	myDic = [[NSDictionary alloc] initWithObjectsAndKeys:array1,@"我的兄弟",
			 array2,@"魏国大将",
			 array3,@"我的最爱",
			 array4,@"最爱小兵",nil];
	
    ivArray = [[NSMutableArray alloc] init];
    
    for(int i=0;i<[[myDic allKeys] count];i++)
    {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 1, 23, 27)];
        [iv setImage:[UIImage imageNamed:@"next.png"]];
        
        [ivArray addObject:iv];
    }
    
    flag = (BOOL*)malloc([[myDic allKeys] count]*sizeof(BOOL*));
    memset(flag, NO, sizeof(flag));

}

- (void) clear:(UIButton *) sender
{
}

- (void) sure:(UIButton *) sender
{
    sender.selected = !sender.selected;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [[self.view superview] setFrame:CGRectMake(320, 0, 220, ScreenHeight-100)];
    [UIView commitAnimations];

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[myDic allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
	return [self numberOfRowsInSection:section];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    [headView setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1.0]];
//    
//    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
//    [firstLabel setText:[sectionArray objectAtIndex:section]];
//    [firstLabel setTextAlignment:NSTextAlignmentLeft];
//    [firstLabel setFont:[UIFont boldSystemFontOfSize:15]];
//    [headView addSubview:firstLabel];
//    
//    UILabel *secondlabel = [[UILabel alloc] initWithFrame:CGRectMake(320-260, 0, 120, 40)];
//    [secondlabel setTextAlignment:NSTextAlignmentRight];
//    [secondlabel setText:@"远东电线电缆"];
//    [secondlabel setTextColor:[UIColor blueColor]];
//    [secondlabel setFont:[UIFont systemFontOfSize:12]];
//    [headView addSubview:secondlabel];
//    
//    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(320-130, 10, 20, 20)];
//    [iv setImage:[UIImage imageNamed:@"arrow.png"]];
//    [headView addSubview:iv];
//    
//    return headView;
    
    view1 = nil;
	view2 = nil;
	view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
	view1.backgroundColor = [UIColor colorWithRed:0.9 green:0.95 blue:0.9 alpha:1.0];
	
	view2 = [[UIView alloc] initWithFrame:CGRectMake(2, 1, 320, 30)];
	view2.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0];
	[view1 addSubview:view2];
	
    
    UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
	abtn.backgroundColor = [UIColor clearColor];
    abtn.frame = CGRectMake(0, 0,320, 32);
    
    UIImageView *iv =[ivArray objectAtIndex:section];
    [abtn addSubview:iv];
    
	abtn.tag = section;
	[abtn addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
	[view2 addSubview:abtn];
    
    
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 70, 30)];
	label1.backgroundColor = [UIColor clearColor];
	label1.text = [[myDic allKeys] objectAtIndex:section];
    [abtn addSubview:label1];
	
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 50, 30)];
	label2.backgroundColor = [UIColor clearColor];
	label2.text = [NSString stringWithFormat:@"(%d/%d)",section,[[myDic valueForKey:[[myDic allKeys] objectAtIndex:section]] count]];
	[abtn addSubview:label2];
	return view1;

}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
	NSString *str = [[myDic valueForKey:[[myDic allKeys] objectAtIndex:[indexPath section]]] objectAtIndex:indexPath.row];
	//label = (UILabel *)[cell.contentView viewWithTag:101];
	cell.imageView.image = [UIImage imageNamed:@"102.png"];
	cell.textLabel.text = str;
	cell.detailTextLabel.text = @"cocoaChina 会员";
    
    return cell;
    
}


-(void)headerClicked:(id)sender
{
	int sectionIndex = ((UIButton*)sender).tag;
    
	UIButton *btn = (UIButton *)sender;
	flag[sectionIndex] = !flag[sectionIndex];
    
    UIImageView *iv = [ivArray objectAtIndex:sectionIndex];
    
	if(flag[sectionIndex])
	{
		btn.selected = YES;
        [iv setImage:[UIImage imageNamed:@"click1.png"]
         ];
	}
	else
    {
		btn.selected = NO;
        [iv setImage:[UIImage imageNamed:@"next.png"]];
	}
    
	[tv reloadData];
}

- (int)numberOfRowsInSection:(NSInteger)section
{
	if (flag[section]) {
		return [[myDic valueForKey:[[myDic allKeys] objectAtIndex:section]] count];
	}
	else {
		return 0;
	}
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
