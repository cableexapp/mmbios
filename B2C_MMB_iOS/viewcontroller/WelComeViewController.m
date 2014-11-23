//
//  WelComeViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-16.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "WelComeViewController.h"
#import "DCFColorUtil.h"
#import "DCFImageUtil.h"
#import "MCDefine.h"
#import "DCFTabBarCtrl.h"
#import "DCFRootNaviController.h"

@interface WelComeViewController ()
{
    NSMutableArray *imageViewArray;    //图片数组
    UIStoryboard *sb;
    DCFTabBarCtrl *tabbar;
    DCFRootNaviController *dcfRoot;
}
@end

@implementation WelComeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    [self.jumpView setBackgroundColor:[UIColor clearColor]];
    [self.jumpBtn setBackgroundImage:[UIImage imageNamed:@"tg.png"] forState:UIControlStateNormal];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    imageViewArray = [[NSMutableArray alloc] init];
    
    [self.pageControl setFrame:CGRectMake(141, self.view.frame.size.height - 50, 38, 37)];
    UIImageView *pageView = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 10, self.pageControl.frame.size.width+20, self.pageControl.frame.size.height-20)];
    [pageView setImage:[UIImage imageNamed:@"by.png"]];
    [self.pageControl addSubview:pageView];
    [self.pageControl setNumberOfPages:3];
    [self.pageControl setCurrentPage:0];
    
    [self.sv setDelegate:self];
    [self.sv setContentSize:CGSizeMake(self.view.frame.size.width*3, ScreenHeight)];
    
    
    //加载图片
    
    UIImage *image_1 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"welcome_1" ofType:@"png"]];
    [self.iv_Fir setImage:image_1];
    
    UIImage *image_2 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"welcome_2" ofType:@"png"]];
    [self.iv_Sec setImage:image_2];
    
    UIImage *image_3 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"welcome_3" ofType:@"png"]];
    [self.iv_Third setImage:image_3];
    
    [self.startBtn setBackgroundImage:[UIImage imageNamed:@"ty.png"] forState:UIControlStateNormal];
    [self.startBtn setFrame:CGRectMake(ScreenWidth-140, ScreenHeight-90, 120, 40)];
    [self.startBtn addTarget:self action:@selector(starButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.starView addSubview:self.startBtn];

}


- (void) jumpToHostView
{
//    dcfRoot = [self.storyboard instantiateViewControllerWithIdentifier:@"dcfRootNaviController"];
//    [self presentViewController:dcfRoot animated:YES completion:nil];
    tabbar = [sb instantiateViewControllerWithIdentifier:@"dcfTabBarCtrl"];
    [self presentViewController:tabbar animated:YES completion:nil];
//    TabbarViewController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"tabbarController"];
}

- (void) starButtonClick:(UIButton *) sender
{
    //跳转到主页
    [self jumpToHostView];
    
    //    [self.navigationController pushViewController:tabbar animated:YES];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (IBAction)jumpBtnClick:(id)sender
{
    [self jumpToHostView];
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
