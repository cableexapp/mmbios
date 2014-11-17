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
#import "SpeedAskPriceFirstViewController.h"
#import "MCDefine.h"
#import "HotClasscifyViewController.h"
#import "HotKindFirstViewController.h"
#import "CableSecondAndThirdStepViewController.h"
#import "ChatListViewController.h"
#import "HotScreenFirstViewController.h"
#import "SearchViewController.h"
#import "ChatViewController.h"

@interface HostTableViewController ()
{
    NSArray *textViewDataArray;
    NSArray *moneyDataArray;
    
    NSArray *listDataArray;
    
    NSArray *typeArray;  //一级分类数组
    NSMutableArray *typeBtnArray;  //一级分类按钮
    
    UIStoryboard *sb;
    
    NSMutableArray *typeIdArray;
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
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    [self setHidesBottomBarWhenPushed:NO];
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
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopNsTimer" object:nil];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
//    [self.navigationController.tabBarController.tabBar setHidden:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startNsTimer" object:nil];
}


- (void) searchTap:(UITapGestureRecognizer *) sender
{
//    ChooseListTableViewController *choose = [[ChooseListTableViewController alloc] init];
//    [self setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:choose animated:YES];
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void) search:(UIButton *) sender
{
    ChooseListTableViewController *choose = [[ChooseListTableViewController alloc] init];
     [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:choose animated:YES];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    //    NSString *msg = [NSString stringWithFormat:@"%@",[dicRespon objectForKey:@"msg"]];
    if(URLTag == URLGetProductTypeTag)
    {

        if(result == 1)
        {
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            
            typeIdArray = [[NSMutableArray alloc] init];
            
            for(int i=0;i<[(NSArray *)[dicRespon objectForKey:@"items"] count];i++)
            {
                NSDictionary *dic = [[dicRespon objectForKey:@"items"] objectAtIndex:i];
                NSString  *typeName = [dic objectForKey:@"typeName"];
                [dataArray addObject:typeName];
                
                NSString *typeId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"typeId"]];
                NSLog(@"typeId = %@",typeId);
                [typeIdArray addObject:typeId];
            }
            
            
#pragma mark - 数组里的字符串按长度重新排序
            typeArray = [dataArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSUInteger len0 = [(NSString *)obj1 length];
                NSUInteger len1 = [(NSString *)obj2 length];
                return len0 > len1 ? NSOrderedAscending : NSOrderedDescending;
            }];
            
            typeBtnArray = [[NSMutableArray alloc] init];
            
            for(int i=0;i<typeArray.count;i++)
            {
                NSString *str = [typeArray objectAtIndex:i];
                UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [typeBtn setFrame:CGRectZero];
                [typeBtn setTitle:str forState:UIControlStateNormal];
                [typeBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:112.0/255.0 blue:245.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                typeBtn.layer.borderColor = [UIColor colorWithRed:28.0/255.0 green:112.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor;
                typeBtn.layer.borderWidth = 0.5f;
                [typeBtn setTag:i];
                [typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                //                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:typeBtn.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5, 5)];
                //                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                //                maskLayer.frame = typeBtn.bounds;
                //                maskLayer.path = maskPath.CGPath;
                //                typeBtn.layer.mask = maskLayer;
                
                
                [typeBtnArray addObject:typeBtn];
            }
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }
        else
        {
            
        }
    }
}


- (void) typeBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    int tag = [btn tag];
    NSLog(@"tag = %d",tag);
    [self setHidesBottomBarWhenPushed:YES];
    CableSecondAndThirdStepViewController *cableSecondAndThirdStepViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cableSecondAndThirdStepViewController"];
    cableSecondAndThirdStepViewController.myTitle = btn.titleLabel.text;
    cableSecondAndThirdStepViewController.typeId = [typeIdArray objectAtIndex:tag];
    [self.navigationController pushViewController:cableSecondAndThirdStepViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];

    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductType",time];
    NSString *token = [DCFCustomExtra md5:string];
    
#pragma mark - 一级分类
    NSString *pushString = [NSString stringWithFormat:@"token=%@&type=%@",token,@"1"];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetProductTypeTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/getProductType.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    UIImage *naviimage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mmb" ofType:@"png"]];
    UIImageView *naviImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 7, 100, 30)];
    [naviImageView setImage:naviimage];
    [naviImageView setTag:100];
    [self.navigationController.navigationBar addSubview:naviImageView];
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(naviImageView.frame.origin.x + naviImageView.frame.size.width + 10, naviImageView.frame.origin.y-2, 200, 30)];
    [searchImageView setUserInteractionEnabled:YES];
    [searchImageView setTag:101];
    searchImageView.backgroundColor = [UIColor whiteColor];
    searchImageView.layer.cornerRadius = 3;
    searchImageView.layer.borderColor = [[UIColor clearColor] CGColor];
    searchImageView.layer.borderWidth = 1;
    [self.navigationController.navigationBar addSubview:searchImageView];

    UIImageView *search = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 22, 22)];
    search.image = [UIImage imageNamed:@"search"];
    [searchImageView addSubview:search];
    
    UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 5, 150, 20)];
    searchLabel.text = @"输入搜索内容";
    searchLabel.font = [UIFont systemFontOfSize:14];
    searchLabel.textColor = [UIColor lightGrayColor];
    [searchImageView addSubview:searchLabel];
    
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
    
    listDataArray = [[NSArray alloc] initWithObjects:
                     @"照明/插座用线",
                     @"空调/热水器用线",
                     @"进户总线",
                     @"装潢明线",
                     @"电源连接线",
                     @"",nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (goToChatView:) name:@"goToChatView" object:nil];
}

-(void)goToChatView:(NSNotification *)goToChat
{
    NSLog(@"11111");
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    [self presentViewController:chatVC animated:YES completion:nil];
}

- (void) section1BtnClick:(UIButton *) sender
{
    NSLog(@"tag = %d",[sender tag]);
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
        if(!typeArray || typeArray.count == 0)
        {
            return 0;
        }
        else
        {
            if(typeArray.count <= 2)
            {
                return 1;
            }
            else
            {
                NSString *str = [typeArray objectAtIndex:2];
                if(str.length >= 5) //此时这行只加载2个按钮
                {
                    if(typeBtnArray.count == 4)
                    {
                        return 2;
                    }
                    if(typeBtnArray.count >= 5)
                    {
                        return 3;
                    }
                }
                else  //3个按钮
                {
                    if(typeBtnArray.count <= 5)
                    {
                        return 2;
                    }
                    else
                    {
                        return 3;
                    }
                }
                //                return typeArray.count/2;
            }
        }
        return 3;
    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        return 50;
    }
    else if (indexPath.section == 0)
    {
        return 80;
    }
    else if (indexPath.section == 1)
    {
        return 185;
        //        return 200;
    }
    return 260;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0 || section == 1)
    {
        return 0;
    }
    if(section == 2)
    {
        if(!typeArray || typeArray.count == 0)
        {
            return 0;
        }
        return 30;
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
        [headLabel setText:@"电缆分类"];
    }
    else
    {
        [headLabel setText:@""];
    }
    [headLabel setTextAlignment:NSTextAlignmentLeft];
    [headBackView addSubview:headLabel];
    
    return headBackView;
}

- (void) HostSection1BtnClick:(UIButton *)btn
{
    NSLog(@"btn = %d  %@",btn.tag,btn.titleLabel.text);
    [self setHidesBottomBarWhenPushed:YES];
    if(btn.tag == 0)
    {
        SpeedAskPriceFirstViewController *speedAskPriceFirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"speedAskPriceFirstViewController"];
        [self.navigationController pushViewController:speedAskPriceFirstViewController animated:YES];
    }
    if(btn.tag == 2)
    {
       [self setHidesBottomBarWhenPushed:YES];
        ShoppingHostViewController *shoppingHost = [[ShoppingHostViewController alloc] init];
        [self.navigationController pushViewController:shoppingHost animated:YES];
//        [self setHidesBottomBarWhenPushed:NO];
    }
    if(btn.tag == 3)
    {
//        [self setHidesBottomBarWhenPushed:YES];
        HotClasscifyViewController *hot = [sb instantiateViewControllerWithIdentifier:@"hotClasscifyViewController" ];
        [self.navigationController pushViewController:hot animated:YES];
//        [self setHidesBottomBarWhenPushed:NO];
    }
    if(btn.tag == 4)
    {
        #pragma mark - 热门分类
          HotKindFirstViewController *hotKindFirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"hotKindFirstViewController"];
        NSLog(@"%@",hotKindFirstViewController);
        [self.navigationController pushViewController:hotKindFirstViewController animated:YES];
    }
    if(btn.tag == 5)
    {
#pragma mark - 场景选择
        HotScreenFirstViewController *hotScreenFirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"hotScreenFirstViewController"];
        [self.navigationController pushViewController:hotScreenFirstViewController animated:YES];
    }
    if (btn.tag == 6)
    {
        #pragma mark - 在线客服
        ChatListViewController *chatVC = [[ChatListViewController alloc] init];
        chatVC.fromString = @"首页在线客服";
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type =  kCATransitionMoveIn;
        transition.subtype =  kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:chatVC animated:NO];
    }
    [self setHidesBottomBarWhenPushed:NO];
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
        HostSection1TableViewCell *section1 = (HostSection1TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HostTableViewSecondCell"];
        if(section1 == nil)
        {
            section1 = [[HostSection1TableViewCell alloc] initWithStyle:0 reuseIdentifier:@"HostTableViewSecondCell"];
        }
        section1.delegate = self;
        return section1;
        //        UIView *section_two = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 200)];
        //        [section_two setBackgroundColor:[UIColor lightGrayColor]];
        //        [cell.contentView addSubview:section_two];
        //
        //        for(int i=0;i<3;i++)
        //        {
        //            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //            [btn setShowsTouchWhenHighlighted:NO];
        //            switch (i) {
        //                case 0:
        //                    [btn setFrame:CGRectMake(10, 10, 145, 180)];
        //                    [btn setBackgroundImage:[UIImage imageNamed:@"cell_1.png"] forState:UIControlStateNormal];
        //                    break;
        //                case 1:
        //                    [btn setFrame:CGRectMake(165, 10, 135, 60)];
        //                    [btn setBackgroundImage:[UIImage imageNamed:@"cell_2.png"] forState:UIControlStateNormal];
        //                    break;
        //                case 2:
        //                    [btn setFrame:CGRectMake(165, 80, 135, 110)];
        //                    [btn setBackgroundImage:[UIImage imageNamed:@"cell_3.png"] forState:UIControlStateNormal];
        //                    break;
        //                default:
        //                    break;
        //            }
        //            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //            [btn setTag:i+10];
        //            [section_two addSubview:btn];
        //        }
    }
    if(indexPath.section == 2)
    {
        if(!typeArray || typeArray.count == 0)
        {
            
        }
        else
        {
            if(indexPath.row == 0)
            {
                for(int i=0;i<2;i++)
                {
                    UIButton *btn = [typeBtnArray objectAtIndex:i];
                    [btn setFrame:CGRectMake(ScreenWidth/2*i, 0, ScreenWidth/2, 50)];
                    [cell.contentView addSubview:btn];
                }
            }
            if(indexPath.row == 1)
            {
                UIButton *btn = [typeBtnArray objectAtIndex:2];
                NSString *str = [typeArray objectAtIndex:2];
                if(str.length >= 5)   //此时这行只加载2个按钮
                {
                    [btn  setFrame:CGRectMake(0, 0, ScreenWidth/2, 49)];
                    
                    UIButton *b = [typeBtnArray objectAtIndex:3];
                    [b  setFrame:CGRectMake(btn.frame.origin.x + btn.frame.size.width, 0, ScreenWidth/2, 50)];
                    [cell.contentView addSubview:b];
                    [cell.contentView addSubview:btn];
                }
                else   //此时这行加载3个按钮
                {
                    for(int i=2;i<5;i++)
                    {
                        UIButton *btn = [typeBtnArray objectAtIndex:i];
                        [btn setFrame:CGRectMake(ScreenWidth/3*(i-2), 0, ScreenWidth/3, 49)];
                        [cell.contentView addSubview:btn];
                    }
                }
            }
            if(indexPath.row == 2)
            {
                //最后一行加载的按钮数目根据第二行的来确定
                NSString *str = [typeArray objectAtIndex:2];
                if(str.length >= 5)   //此时这行加载3个按钮
                {
                    for(int i=4;i<typeBtnArray.count;i++)
                    {
                        UIButton *b = [typeBtnArray objectAtIndex:i];
                        [b setFrame:CGRectMake(ScreenWidth/3*(i-4), 0, ScreenWidth/3, 49)];
                        [cell.contentView addSubview:b];
                    }
                }
                else   //此时这行加载2个按钮
                {
                    for(int i=5;i<typeBtnArray.count;i++)
                    {
                        UIButton *b = [typeBtnArray objectAtIndex:i];
                        [b setFrame:CGRectMake(ScreenWidth/2*(i-5), 0, ScreenWidth/2, 49)];
                        [cell.contentView addSubview:b];
                    }
                }
            }
        }
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

#pragma mark - 热门型号
- (IBAction)hotModelBtnClick:(id)sender
{
  
}


- (void) btnClick:(UIButton *) sender
{
    int tag = [sender tag];
    if(tag == 12)
    {
        //        [self setHidesBottomBarWhenPushed:YES];
        //        ShoppingHostViewController *shoppingHost = [[ShoppingHostViewController alloc] init];
        //        [self.navigationController pushViewController:shoppingHost animated:YES];
        //        [self setHidesBottomBarWhenPushed:NO];
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
