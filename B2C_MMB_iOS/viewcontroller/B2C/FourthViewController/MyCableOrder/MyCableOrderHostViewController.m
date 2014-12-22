//
//  MyCableOrderHostViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-12.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyCableOrderHostViewController.h"
#import "MCDefine.h"
#import "DCFStringUtil.h"
#import "DCFCustomExtra.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "MyCableOrderDetailViewController.h"
#import "MyCableOrderB2BViewController.h"
#import "MyCableSureOrderViewController.h"

@interface MyCableOrderHostViewController ()
{
    NSMutableArray *topBtnArray;
    int currentPageIndex;
    UIView *rightButtonView;
    UIButton *rightBtn;
}
@end

@implementation MyCableOrderHostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.sv setContentOffset:CGPointMake(ScreenWidth*self.btnIndex, 0) animated:YES];
    rightButtonView.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    rightButtonView.hidden = YES;
}

- (void) pushToDetailVCWithData:(B2BMyCableOrderListData *)data WithFlag:(int)flag
{
    [self setHidesBottomBarWhenPushed:YES];
    if(flag == 1)
    {
        MyCableSureOrderViewController *myCableSureOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableSureOrderViewController"];
        myCableSureOrderViewController.btnIndex = self.btnIndex;
        myCableSureOrderViewController.b2bMyCableOrderListData = data;
        [self.navigationController pushViewController:myCableSureOrderViewController animated:YES];
    }
    else
    {
        MyCableOrderDetailViewController *myCableOrderDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableOrderDetailViewController"];
        myCableOrderDetailViewController.btnIndex = self.btnIndex;
        myCableOrderDetailViewController.b2bMyCableOrderListData = data;
        [self.navigationController pushViewController:myCableOrderDetailViewController animated:YES];
    }

    
}

- (void) loadRequest:(int) sender
{
    if(sender == 1)
    {
        subTV_2.statusIndex = @"0";
        [subTV_2 loadRequestWithStatus:@"0"];
    }
    if(sender == 2)
    {
        subTV_3.statusIndex = @"2";
        [subTV_3 loadRequestWithStatus:@"2"];
    }
    if(sender == 3)
    {
        subTV_4.statusIndex = @"5";
        [subTV_4 loadRequestWithStatus:@"5"];
    }
}

- (void) refreshRequest:(NSNotification *) noti
{
    int index = [[noti object] intValue];
    subTV_1.intPage = 1;
    subTV_2.intPage = 1;
    subTV_3.intPage = 1;
    subTV_4.intPage = 1;
    [self loadRequest:index];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRequest:) name:@"MyCableOrderHostViewControllerRefreshRequest" object:nil];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"我的电缆订单"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];

    rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 0, 60, 44)];
    [self.navigationController.navigationBar addSubview:rightButtonView];
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightBtn setFrame:CGRectMake(0, 0, 60, 44)];
    [rightBtn addTarget:self action:@selector(searchOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:rightBtn];
    
    subTV_1 = [[MyCableHostSubTableViewController alloc] init];
    subTV_1.tag = 1;
    subTV_1.delegate = self;
    [self addChildViewController:subTV_1];
    subTV_1.view.frame = self.firstView.bounds;
    [self.firstView addSubview:subTV_1.view];
    
    subTV_2 = [[MyCableHostSubTableViewController alloc] init];
    subTV_2.tag = 2;
    subTV_2.delegate = self;
    [self addChildViewController:subTV_2];
    subTV_2.view.frame = self.secondView.bounds;
    [self.secondView addSubview:subTV_2.view];
    
    subTV_3 = [[MyCableHostSubTableViewController alloc] init];
    subTV_3.tag = 3;
    subTV_3.delegate = self;
    [self addChildViewController:subTV_3];
    subTV_3.view.frame = self.thirdView.bounds;
    [self.thirdView addSubview:subTV_3.view];
    
    subTV_4 = [[MyCableHostSubTableViewController alloc] init];
    subTV_4.tag = 4;
    subTV_4.delegate = self;
    [self addChildViewController:subTV_4];
    subTV_4.view.frame = self.fourView.bounds;
    [self.fourView addSubview:subTV_4.view];
    
    [self.sv setDelegate:self];
    [self.sv setContentSize:CGSizeMake(ScreenWidth*4, ScreenHeight-200)];
    
    topBtnArray = [[NSMutableArray alloc] initWithObjects:self.allBtn,self.sureBtn,self.payBtn,self.receiveBtn, nil];
    for(int i=0;i<topBtnArray.count;i++)
    {
        UIButton *btn = (UIButton *)[topBtnArray objectAtIndex:i];
        [btn setTag:i];
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:MYCOLOR size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:MYCOLOR forState:UIControlStateNormal];
        btn.layer.borderColor = MYCOLOR.CGColor;
        btn.layer.borderWidth = 0.5f;
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if(btn.tag == self.btnIndex)
        {
            [btn setSelected:YES];
        }
        else
        {
            [btn setSelected:NO];
        }
    }

    [self loadRequest:_btnIndex];
}

-(void)searchOrderBtnClick
{
    [self setHidesBottomBarWhenPushed:YES];
    MyCableOrderB2BViewController *searchVC = [[MyCableOrderB2BViewController alloc] init];
    searchVC.fromFlag = @"我的电缆订单";
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void) topBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    for(UIButton *b in topBtnArray)
    {
        if(b == btn)
        {
            [b setSelected:YES];
        }
        else
        {
            [b setSelected:NO];
        }
//        if(btn.selected == YES)
//        {
//            
//        }
//        else
//        {
//            [btn setSelected:NO];
//        }
    }
    
    int tag = btn.tag;
    [self.sv setContentOffset:CGPointMake(ScreenWidth*tag, 0) animated:YES];
    
    if(tag == 0)
    {
        subTV_1.statusIndex = @"";
        subTV_1.intPage = 1;
        [subTV_1 loadRequestWithStatus:@""];
    }
    if(tag == 1)
    {
        subTV_2.statusIndex = @"0";
        subTV_2.intPage = 1;
        [subTV_2 loadRequestWithStatus:@"0"];
    }
    if(tag == 2)
    {
        subTV_3.statusIndex = @"2";
        subTV_3.intPage = 1;
        [subTV_3 loadRequestWithStatus:@"2"];
    }
    if(tag == 3)
    {
        subTV_4.statusIndex = @"5";
        subTV_4.intPage = 1;
        [subTV_4 loadRequestWithStatus:@"5"];
    }
    
    _btnIndex = tag;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    
    for(UIButton *btn in topBtnArray)
    {
        if(btn.tag == currentPageIndex)
        {
            [btn setSelected:YES];
        }
        else
        {
            [btn setSelected:NO];
        }
    }
    

}

//- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    
//}
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(currentPageIndex == 0)
    {
        subTV_1.statusIndex = @"";
        subTV_1.intPage = 1;
        [subTV_1 loadRequestWithStatus:@""];
    }
    if(currentPageIndex == 1)
    {
        subTV_2.statusIndex = @"0";
        subTV_2.intPage = 1;
        [subTV_2 loadRequestWithStatus:@"0"];
    }
    if(currentPageIndex == 2)
    {
        subTV_3.statusIndex = @"2";
        subTV_3.intPage = 1;
        [subTV_3 loadRequestWithStatus:@"2"];
    }
    if(currentPageIndex == 3)
    {
        subTV_4.statusIndex = @"5";
        subTV_4.intPage = 1;
        [subTV_4 loadRequestWithStatus:@"5"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
