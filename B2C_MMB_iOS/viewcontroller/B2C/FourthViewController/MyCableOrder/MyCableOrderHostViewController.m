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

@interface MyCableOrderHostViewController ()
{
    NSMutableArray *topBtnArray;
    int currentPageIndex;
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    subTV_1 = [[MyCableHostSubTableViewController alloc] init];
    subTV_1.tag = 1;
    [self addChildViewController:subTV_1];
    subTV_1.view.frame = self.firstView.bounds;
    [self.firstView addSubview:subTV_1.view];
    
    subTV_2 = [[MyCableHostSubTableViewController alloc] init];
    subTV_2.tag = 2;
    [self addChildViewController:subTV_2];
    subTV_2.view.frame = self.secondView.bounds;
    [self.secondView addSubview:subTV_2.view];
    
    subTV_3 = [[MyCableHostSubTableViewController alloc] init];
    subTV_3.tag = 3;
    [self addChildViewController:subTV_3];
    subTV_3.view.frame = self.thirdView.bounds;
    [self.thirdView addSubview:subTV_3.view];
    
    subTV_4 = [[MyCableHostSubTableViewController alloc] init];
    subTV_4.tag = 4;
    [self addChildViewController:subTV_4];
    subTV_4.view.frame = self.fourView.bounds;
    [self.fourView addSubview:subTV_4.view];
    
    [self.sv setDelegate:self];
    
    
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
        btn.layer.cornerRadius = 5.0f;
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
    NSLog(@"tag = %d",tag);
    [self.sv setContentOffset:CGPointMake(ScreenWidth*tag, 0) animated:YES];
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
