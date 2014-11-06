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

@interface MyInquiryListFirstViewController ()
{
    int currentPageIndex;

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
