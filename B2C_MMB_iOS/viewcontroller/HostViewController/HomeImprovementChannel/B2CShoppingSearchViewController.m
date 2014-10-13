//
//  B2CShoppingSearchTableViewController.m
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-16.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import "B2CShoppingSearchViewController.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"

@interface B2CShoppingSearchViewController ()
{
    NSMutableArray *ivArray;

    
    NSMutableArray *array1;
    NSMutableArray *array2;
    NSMutableArray *array3;
    NSMutableArray *array4;
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

- (void) addHeadView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myRect.size.width, 40)];
    [topView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [self.view addSubview:topView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    [label setText:@"商品分类"];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont boldSystemFontOfSize:17]];
    [label setBackgroundColor:[UIColor clearColor]];
    [topView addSubview:label];
    
    _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clearBtn setFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 20, 10, 40, 20)];
    [_clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    [_clearBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_clearBtn addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_clearBtn];
    
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_clearBtn.frame.origin.x + _clearBtn.frame.size.width, _clearBtn.frame.origin.y, 1, 20)];
    [_lineView setBackgroundColor:[UIColor blueColor]];
    [topView addSubview:_lineView];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setFrame:CGRectMake(_lineView.frame.origin.x+_lineView.frame.size.width, _lineView.frame.origin.y, 40, 20)];
    [_sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_sureBtn];
    
    //    sectionArray = [[NSArray alloc] initWithObjects:@"品牌",@"用途",@"型号",@"横截面",@"颜色",@"芯数",@"单位", nil];
    
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height, myRect.size.width, ScreenHeight -  40 - 100) style:0];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:tv];
    
    
    float btnWidth = (myRect.size.width-20)/3;
#pragma mark - 用途数组
    array1 = [[NSMutableArray alloc] init];
    for(int i=0;i<13;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i == 0)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*1 + 30*0, btnWidth, 30)];
            [btn setTitle:@"照明" forState:UIControlStateNormal];
        }
        if(i == 1)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1, 5*1 + 30*0, btnWidth, 30)];
            [btn setTitle:@"插座" forState:UIControlStateNormal];
        }
        if(i == 2)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2, 5*1 + 30*0, btnWidth, 30)];
            [btn setTitle:@"热水器" forState:UIControlStateNormal];
        }
        if(i == 3)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*2 + 30*1, btnWidth, 30)];
            [btn setTitle:@"立式空调" forState:UIControlStateNormal];
        }
        if(i == 4)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1, 5*2 + 30*1, btnWidth, 30)];
            [btn setTitle:@"挂壁空调" forState:UIControlStateNormal];
        }
        if(i == 5)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2, 5*2 + 30*1, btnWidth, 30)];
            [btn setTitle:@"中央空调" forState:UIControlStateNormal];
        }
        if(i == 6)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*3 + 30*2, btnWidth, 30)];
            [btn setTitle:@"装潢明线" forState:UIControlStateNormal];
        }
        if(i == 7)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1, 5*3 + 30*2, btnWidth, 30)];
            [btn setTitle:@"进户总线" forState:UIControlStateNormal];
        }
        if(i == 8)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2, 5*3 + 30*2, btnWidth, 30)];
            [btn setTitle:@"网络" forState:UIControlStateNormal];
        }
        if(i == 9)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*4 + 30*3, btnWidth, 30)];
            [btn setTitle:@"电话" forState:UIControlStateNormal];
        }
        if(i == 10)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1, 5*4 + 30*3, btnWidth, 30)];
            [btn setTitle:@"电源连接线" forState:UIControlStateNormal];
        }
        if(i == 11)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2, 5*4 + 30*3, btnWidth, 30)];
            [btn setTitle:@"视频" forState:UIControlStateNormal];
        }
        if(i == 12)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*5 + 30*4, btnWidth, 30)];
            [btn setTitle:@"音频" forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:167.0/255.0 green:167.0/255.0 blue:167.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [array1 addObject:btn];
    }
    
#pragma mark - 品牌数组
    array2 = [[NSMutableArray alloc] init];
    for(int i=0;i<9;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i == 0)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*1 + 30*0, btnWidth, 30)];
            [btn setTitle:@"远东" forState:UIControlStateNormal];
        }
        if(i == 1)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1, 5*1 + 30*0, btnWidth, 30)];
            [btn setTitle:@"华东电缆" forState:UIControlStateNormal];
        }
        if(i == 2)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2, 5*1 + 30*0, btnWidth, 30)];
            [btn setTitle:@"鑫园电缆" forState:UIControlStateNormal];
        }
        if(i == 3)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*2 + 30*1, btnWidth, 30)];
            [btn setTitle:@"玖开电缆" forState:UIControlStateNormal];
        }
        if(i == 4)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1, 5*2 + 30*1, btnWidth, 30)];
            [btn setTitle:@"澳航" forState:UIControlStateNormal];
        }
        if(i == 5)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2, 5*2 + 30*1, btnWidth, 30)];
            [btn setTitle:@"陆通舜山" forState:UIControlStateNormal];
        }
        if(i == 6)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*3 + 30*2, btnWidth, 30)];
            [btn setTitle:@"上进" forState:UIControlStateNormal];
        }
        if(i == 7)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1, 5*3 + 30*2, btnWidth, 30)];
            [btn setTitle:@"安徽电缆" forState:UIControlStateNormal];
        }
        if(i == 8)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2, 5*3 + 30*2, btnWidth, 30)];
            [btn setTitle:@"荣宜天康" forState:UIControlStateNormal];
        }
        
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:167.0/255.0 green:167.0/255.0 blue:167.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [array2 addObject:btn];
    }
    
#pragma mark - 型号数组
    array3 = [[NSMutableArray alloc] init];
    for(int i=0;i<13;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i == 0)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*1 + 30*0, btnWidth, 30)];
            [btn setTitle:@"BV" forState:UIControlStateNormal];
        }
        if(i == 1)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1, 5*1 + 30*0, btnWidth, 30)];
            [btn setTitle:@"BVR" forState:UIControlStateNormal];
        }
        if(i == 2)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2, 5*1 + 30*0, btnWidth, 30)];
            [btn setTitle:@"BVV" forState:UIControlStateNormal];
        }
        if(i == 3)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*2 + 30*1, btnWidth, 30)];
            [btn setTitle:@"BRVV" forState:UIControlStateNormal];
        }
        if(i == 4)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1, 5*2 + 30*1, btnWidth, 30)];
            [btn setTitle:@"ZR-BV" forState:UIControlStateNormal];
        }
        if(i == 5)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2, 5*2 + 30*1, btnWidth, 30)];
            [btn setTitle:@"NH-BV" forState:UIControlStateNormal];
        }
        if(i == 6)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*3 + 30*2, btnWidth, 30)];
            [btn setTitle:@"ZR-RVS" forState:UIControlStateNormal];
        }
        if(i == 7)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1, 5*3 + 30*2, btnWidth, 30)];
            [btn setTitle:@"NH-RVS" forState:UIControlStateNormal];
        }
        if(i == 8)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2, 5*3 + 30*2, btnWidth, 30)];
            [btn setTitle:@"ZR-BVR" forState:UIControlStateNormal];
        }
        if(i == 9)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*4 + 30*3, btnWidth, 30)];
            [btn setTitle:@"NH-BVR" forState:UIControlStateNormal];
        }
        if(i == 10)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1, 5*4 + 30*3, btnWidth, 30)];
            [btn setTitle:@"ZR-RVV" forState:UIControlStateNormal];
        }
        if(i == 11)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2, 5*4 + 30*3, btnWidth, 30)];
            [btn setTitle:@"NH-RVV" forState:UIControlStateNormal];
        }
        if(i == 12)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*5 + 30*4, btnWidth, 30)];
            [btn setTitle:@"HSYV-5" forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:167.0/255.0 green:167.0/255.0 blue:167.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [array3 addObject:btn];
    }
    
#pragma MARK - 横截面数组
    array4 = [[NSMutableArray alloc] init];
    for(int i=0;i<11;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i == 0)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*1 + 30*0, btnWidth, 30)];
            [btn setTitle:@"0.5平方" forState:UIControlStateNormal];
        }
        if(i == 1)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1, 5*1 + 30*0, btnWidth, 30)];
            [btn setTitle:@"0.75平方" forState:UIControlStateNormal];
        }
        if(i == 2)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2, 5*1 + 30*0, btnWidth, 30)];
            [btn setTitle:@"1平方" forState:UIControlStateNormal];
        }
        if(i == 3)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*2 + 30*1, btnWidth, 30)];
            [btn setTitle:@"1.5平方" forState:UIControlStateNormal];
        }
        if(i == 4)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1, 5*2 + 30*1, btnWidth, 30)];
            [btn setTitle:@"2.5平方" forState:UIControlStateNormal];
        }
        if(i == 5)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2, 5*2 + 30*1, btnWidth, 30)];
            [btn setTitle:@"4平方" forState:UIControlStateNormal];
        }
        if(i == 6)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*3 + 30*2, btnWidth, 30)];
            [btn setTitle:@"6平方" forState:UIControlStateNormal];
        }
        if(i == 7)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1, 5*3 + 30*2, btnWidth, 30)];
            [btn setTitle:@"10平方" forState:UIControlStateNormal];
        }
        if(i == 8)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2, 5*3 + 30*2, btnWidth, 30)];
            [btn setTitle:@"16平方" forState:UIControlStateNormal];
        }
        if(i == 9)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0, 5*4 + 30*3, btnWidth, 30)];
            [btn setTitle:@"25平方" forState:UIControlStateNormal];
        }
        if(i == 10)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1, 5*4 + 30*3, btnWidth, 30)];
            [btn setTitle:@"35平方" forState:UIControlStateNormal];
        }
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:167.0/255.0 green:167.0/255.0 blue:167.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        
        [array4 addObject:btn];
    }
    _myDic = [[NSDictionary alloc] initWithObjectsAndKeys:array1,@"按用途筛选",
              array2,@"按品牌筛选",
              array3,@"按型号筛选",
              array4,@"按横截面筛选",nil];
    
    ivArray = [[NSMutableArray alloc] init];
    
    for(int i=0;i<[[_myDic allKeys] count];i++)
    {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 1, 23, 27)];
        [iv setImage:[UIImage imageNamed:@"next.png"]];
        
        [ivArray addObject:iv];
    }
    
    flag = (BOOL*)malloc([[_myDic allKeys] count]*sizeof(BOOL*));
    memset(flag, NO, sizeof(flag));

}

- (id) initWithFrame:(CGRect) rect
{
    if(self = [super init])
    {
        
        myRect = rect;
        self.view.frame = rect;
        
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

   
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
    [[self.view superview] setFrame:CGRectMake(myRect.size.width, 0, 220, ScreenHeight-100)];
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
    return [[_myDic allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
	return [self numberOfRowsInSection:section];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[_myDic valueForKey:[[_myDic allKeys] objectAtIndex:indexPath.section]] count];
    
    UIButton *btn = (UIButton *)[[_myDic valueForKey:[[_myDic allKeys] objectAtIndex:indexPath.section]] lastObject];

//    if(indexPath.section == 0)
//    {
//        if(indexPath.row == 0)
//        {
//            UIButton *btn = (UIButton *)[array1 lastObject];
            return btn.frame.origin.y + btn.frame.size.height +5;
//        }
//    }
//
//    if(indexPath.section == 1)
//    {
//        if(indexPath.row == 0)
//        {
//            UIButton *btn = (UIButton *)[array2 lastObject];
//            return btn.frame.origin.y + btn.frame.size.height +5;
//        }
//    }
//
//    
//    if(indexPath.section == 2)
//    {
//        if(indexPath.row == 0)
//        {
//            UIButton *btn = (UIButton *)[array3 lastObject];
//            return btn.frame.origin.y + btn.frame.size.height +5;
//        }
//    }
//
//    
//    if(indexPath.section == 3)
//    {
//        if(indexPath.row == 0)
//        {
//            UIButton *btn = (UIButton *)[array4 lastObject];
//            return btn.frame.origin.y + btn.frame.size.height +5;
//        }
//    }

    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    view1 = nil;
	view2 = nil;
	view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myRect.size.width, 32)];
	view1.backgroundColor = [UIColor colorWithRed:0.9 green:0.95 blue:0.9 alpha:1.0];
	
	view2 = [[UIView alloc] initWithFrame:CGRectMake(2, 1, myRect.size.width, 30)];
	view2.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0];
	[view1 addSubview:view2];
	
    
    UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
	abtn.backgroundColor = [UIColor clearColor];
    abtn.frame = CGRectMake(0, 0,myRect.size.width, 32);
    
    UIImageView *iv =[ivArray objectAtIndex:section];
    [abtn addSubview:iv];
    
	abtn.tag = section;
	[abtn addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
	[view2 addSubview:abtn];
    
    
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, myRect.size.width, 30)];
	label1.backgroundColor = [UIColor clearColor];
    [label1 setFont:[UIFont systemFontOfSize:13]];
	label1.text = [[_myDic allKeys] objectAtIndex:section];
    [abtn addSubview:label1];
	

	return view1;

}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
//        [cell.contentView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
//	NSString *str = [[_myDic valueForKey:[[_myDic allKeys] objectAtIndex:[indexPath section]]] objectAtIndex:indexPath.row];
//	cell.imageView.image = [UIImage imageNamed:@"102.png"];
//	cell.textLabel.text = str;
//	cell.detailTextLabel.text = @"cocoaChina 会员";
    
    NSMutableArray *array = [_myDic valueForKey:[[_myDic allKeys] objectAtIndex:indexPath.section]];
    for(UIButton *btn in array)
    {
        [cell.contentView addSubview:btn];
    }
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
//		return [[_myDic valueForKey:[[_myDic allKeys] objectAtIndex:section]] count];
        return 1;
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
