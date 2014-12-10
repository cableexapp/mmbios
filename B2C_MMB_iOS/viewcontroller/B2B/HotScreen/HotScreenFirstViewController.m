//
//  HotScreenFirstViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-10.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "HotScreenFirstViewController.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFCustomExtra.h"
#import "HotScreenSecondViewController.h"
#import "SpeedAskPriceFirstViewController.h"

@interface HotScreenFirstViewController ()
{
    int page;
    NSMutableArray *btnArray;
    
    UIPageControl *pageControl;
}
@end

@implementation HotScreenFirstViewController

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
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view tag] == 101)
        {
            [view setHidden:YES];
        }
        if([view isKindOfClass:[UISearchBar class]])
        {
            [view setHidden:YES];
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"请选择使用场合"];
    self.navigationItem.titleView = top;
    
    [_sv setContentSize:CGSizeMake(ScreenWidth*4, self.sv.frame.size.height-200)];
    [_sv setBounces:NO];
    [_sv setDelegate:self];
    
    [self pushAndPopStyle];
    
    btnArray = [[NSMutableArray alloc] init];
    for(UIView *view in self.sv.subviews)
    {
        for(UIView *subView in view.subviews)
        {
            if([subView isKindOfClass:[UILabel class]])
            {
                
            }
            else if ([subView isKindOfClass:[UIButton class]])
            {
                UIButton *subBtn = (UIButton *)subView;
                [subBtn.titleLabel setNumberOfLines:0];
                [subBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
                [btnArray addObject:subBtn];
            }
            
        }
    }
    
    
    for(UIButton *btn in btnArray)
    {
        NSString *tetx = btn.titleLabel.text;
        if([tetx isEqualToString:@"拨打热线电话"] || [tetx isEqualToString:@"在线咨询"] || [tetx isEqualToString:@"填写使用场合"] || [tetx isEqualToString:@"重新浏览"])
        {
            
        }
        else
        {
            [btn addTarget:self action:@selector(screenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0, ScreenHeight-145, ScreenWidth, 30);
    pageControl.currentPage=0;
    pageControl.numberOfPages=4;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:19/255.0 green:90/255.0 blue:168/255.0 alpha:1.0];
    [self.view addSubview:pageControl];
    
}

- (void) screenBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    HotScreenSecondViewController *hotScreenSecondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"hotScreenSecondViewController"];
    hotScreenSecondViewController.screen = sender.titleLabel.text;
    [self.navigationController pushViewController:hotScreenSecondViewController animated:YES];
}

- (IBAction)upBtnClick:(id)sender
{
    if(page <= 0)
    {
        NSLog(@"到头了");
        return;
    }
    else
    {
        page--;
        [self.sv setContentOffset:CGPointMake(ScreenWidth*page, 0) animated:YES];
    }
}

- (IBAction)nextbtnClick:(id)sender
{
    if(page >= 3)
    {
        NSLog(@"到底了");
        return;
    }
    else
    {
        page++;
        [self.sv setContentOffset:CGPointMake(ScreenWidth*page, 0) animated:YES];
    }
}

- (IBAction)hotBtnClick:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"您确定要拨打热线电话么" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    [av show];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-828-0188"]];
            break;
        default:
            break;
    }
}


- (IBAction)imBtnClick:(id)sender {
}

- (IBAction)chooseBtnClick:(id)sender
{
    SpeedAskPriceFirstViewController *speedAskPriceFirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"speedAskPriceFirstViewController"];
    [self.navigationController pushViewController:speedAskPriceFirstViewController animated:YES];
}

- (IBAction)reViewBtnClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
