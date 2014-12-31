//
//  MyInquiryListFirstViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-6.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyInquiryListFirstViewController.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "B2BMyInquiryListFastData.h"
//#import "MyCableOrderSearchViewController.h"

@interface MyInquiryListFirstViewController ()
{
    int currentPageIndex;
    NormalInquiryListTableViewController *normal;
    SpeedInquiryListTableViewController *speed;
//    UIView *rightButtonView;
}
@end

@implementation MyInquiryListFirstViewController

@synthesize orderBtnClick;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    rightButtonView.hidden = NO;
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    if ([self.orderBtnClick isEqualToString:@"询价单"])
    {
        self.segment.selectedSegmentIndex = 0;
        [self.sv setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if ([self.orderBtnClick isEqualToString:@"快速询价单"])
    {
        self.segment.selectedSegmentIndex = 1;
        [self.sv setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
    }
    
    normal = [self.storyboard instantiateViewControllerWithIdentifier:@"normalInquiryListTableViewController"];
    normal.view.frame = self.firstView.bounds;
    [normal loadRequest];
    normal.delegate = self;
    [self addChildViewController:normal];
    [self.firstView addSubview:normal.view];
    
    speed = [self.storyboard instantiateViewControllerWithIdentifier:@"speedInquiryListTableViewController"];
    speed.view.frame = self.secondView.bounds;
    [speed loadRequest];
    speed.delegate = self;
    [self addChildViewController:speed];
    [self.secondView addSubview:speed.view];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
//    rightButtonView.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"我的询价单"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    self.segment.segmentedControlStyle = UISegmentedControlStylePlain;
    self.segment.frame = CGRectMake(-3, 0, self.view.frame.size.width+6, 30);
    self.segment.tintColor = [UIColor colorWithRed:37/255.0 green:118/255.0 blue:254/255.0 alpha:1.0];
    
    [self.segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.sv setContentSize:CGSizeMake(ScreenWidth*2, self.sv.frame.size.height-200)];
    [self.sv setBounces:NO];
    [self.sv setShowsHorizontalScrollIndicator:NO];
    [self.sv setShowsVerticalScrollIndicator:NO];
    


}

//-(void)searchOrderBtnClick
//{
//    [self setHidesBottomBarWhenPushed:YES];
//    MyCableOrderSearchViewController *searchVC = [[MyCableOrderSearchViewController alloc] init];
//    [self.navigationController pushViewController:searchVC animated:YES];
//}

- (void)pushToNextVC:(MyNormalInquiryDetailController *) sender WithData:(B2BMyInquiryListNormalData *)data
{
    MyNormalInquiryDetailController *myNormalInquiryDetailController = sender;
    
    [self setHidesBottomBarWhenPushed:YES];
    
    NSString *orderNum = [NSString stringWithFormat:@"%@",[data inquiryserial]];
    myNormalInquiryDetailController.myOrderNum = orderNum;
    
    
    NSString *status = [NSString stringWithFormat:@"%@",[data status]];
    myNormalInquiryDetailController.myStatus = status;
    
    
    NSString *upTime = [data time];
    myNormalInquiryDetailController.myTime = upTime;
    
    NSString *Inquiryid = [data inquiryid];
    myNormalInquiryDetailController.myInquiryid = Inquiryid;
    
    NSDictionary *dic = [data pushDic];
    myNormalInquiryDetailController.myDic = [NSDictionary dictionaryWithDictionary:dic];
    
    [self.navigationController pushViewController:myNormalInquiryDetailController animated:YES];
}

- (void) pushViewController:(B2BMyInquiryListFastData *)data
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    [self setHidesBottomBarWhenPushed:YES];
    MyFastInquiryOrder *myFastInquiryOrder = [sb instantiateViewControllerWithIdentifier:@"myFastInquiryOrder"];
    myFastInquiryOrder.fastData = data;
    [self.navigationController pushViewController:myFastInquiryOrder animated:YES];
}

- (void) segmentChange:(UISegmentedControl *) sender
{
    int index = self.segment.selectedSegmentIndex;
    if(index == 0)
    {

        [self.sv setContentOffset:CGPointMake(0, 0) animated:YES];

    }
    if(index == 1)
    {
//        if(currentPageIndex == 0)
//        {
            [self.sv setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
//        }
//        else if (currentPageIndex == 1)
//        {
//            [self.sv setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;

    [self.segment setSelectedSegmentIndex:currentPageIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
