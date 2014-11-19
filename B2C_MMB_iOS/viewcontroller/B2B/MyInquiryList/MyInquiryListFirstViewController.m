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

@interface MyInquiryListFirstViewController ()
{
    int currentPageIndex;

    NormalInquiryListTableViewController *normal;
    SpeedInquiryListTableViewController *speed;
}
@end

@implementation MyInquiryListFirstViewController

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
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"我的询价单"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    [self.segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.sv setContentSize:CGSizeMake(ScreenWidth*2, self.sv.frame.size.height-200)];
    [self.sv setBounces:NO];
    [self.sv setShowsHorizontalScrollIndicator:NO];
    [self.sv setShowsVerticalScrollIndicator:NO];
    
    normal = [self.storyboard instantiateViewControllerWithIdentifier:@"normalInquiryListTableViewController"];
    normal.view.frame = self.firstView.bounds;
    normal.delegate = self;
    [self addChildViewController:normal];
    [self.firstView addSubview:normal.view];
    
    speed = [self.storyboard instantiateViewControllerWithIdentifier:@"speedInquiryListTableViewController"];
    speed.view.frame = self.secondView.bounds;
    speed.delegate = self;
    [self addChildViewController:speed];
    [self.secondView addSubview:speed.view];
}

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
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
