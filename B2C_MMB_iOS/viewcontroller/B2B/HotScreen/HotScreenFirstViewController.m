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
#import "ChatListViewController.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "HotScreenFirstViewController.h"

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
    
    [_sv setContentSize:CGSizeMake(ScreenWidth*5, self.sv.frame.size.height-200)];
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
        if([tetx isEqualToString:@"拨打400电话"] || [tetx isEqualToString:@"在线咨询"] || [tetx isEqualToString:@"填写使用场合"] || [tetx isEqualToString:@"重新浏览"])
        {
            
        }
        else
        {
            UIImageView *iv = [[UIImageView alloc] init];
            if([tetx isEqualToString:@"插座照明"])
            {
                btn.titleEdgeInsets = UIEdgeInsetsMake(-80, 0, -20, 0);
                [iv setFrame:CGRectMake(20, btn.frame.size.height/2-30,btn.frame.size.width-40, 60)];
                [iv setImage:[UIImage imageNamed:@"hot_situation_itemimage_1.png"]];
                [btn addSubview:iv];
            }
            if([tetx isEqualToString:@"电梯供电"])
            {
                btn.titleEdgeInsets = UIEdgeInsetsMake(-80, 0, -20, 0);
                [iv setFrame:CGRectMake(20, btn.frame.size.height/2-30,btn.frame.size.width-40, 60)];
                [iv setImage:[UIImage imageNamed:@"hot_situation_itemimage_2.png"]];
                [btn addSubview:iv];
            }
            if([tetx isEqualToString:@"电话线"])
            {
                btn.titleEdgeInsets = UIEdgeInsetsMake(-80, 0, -20, 0);
                [iv setFrame:CGRectMake(20, btn.frame.size.height/2-30,btn.frame.size.width-40, 60)];
                [iv setImage:[UIImage imageNamed:@"hot_situation_itemimage_3.png"]];
                [btn addSubview:iv];
            }
            if([tetx isEqualToString:@"有线电视"])
            {
                btn.titleEdgeInsets = UIEdgeInsetsMake(-80, 0, -20, 0);
                [iv setFrame:CGRectMake(20, btn.frame.size.height/2-30,btn.frame.size.width-40, 60)];
                [iv setImage:[UIImage imageNamed:@"hot_situation_itemimage_10.png"]];
                [btn addSubview:iv];
            }
            if([tetx isEqualToString:@"电源连接线"])
            {
                btn.titleEdgeInsets = UIEdgeInsetsMake(-80, 0, -20, 0);
                [iv setFrame:CGRectMake(20, btn.frame.size.height/2-30,btn.frame.size.width-40, 60)];
                [iv setImage:[UIImage imageNamed:@"hot_situation_itemimage_11.png"]];
                [btn addSubview:iv];
            }
            if([tetx isEqualToString:@"电脑网线"])
            {
                btn.titleEdgeInsets = UIEdgeInsetsMake(-80, 0, -20, 0);
                [iv setFrame:CGRectMake(20, btn.frame.size.height/2-30,btn.frame.size.width-40, 60)];
                [iv setImage:[UIImage imageNamed:@"hot_situation_itemimage_12.png"]];
                [btn addSubview:iv];
            }
            [btn addTarget:self action:@selector(screenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0, ScreenHeight-100, ScreenWidth, 30);
    pageControl.currentPage=0;
    pageControl.numberOfPages=5;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:9/255.0 green:99/255.0 blue:189/255.0 alpha:1.0];
    [self.view addSubview:pageControl];
    
    self.hotTelBtn.layer.cornerRadius = 5;
    self.imBtn.layer.cornerRadius = 5;
    self.chooseBtn.layer.cornerRadius = 5;
    self.reViewBtn.layer.cornerRadius = 5;
    
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
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008280188"]];
            break;
        default:
            break;
    }
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - 在线客服
- (IBAction)imBtnClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    if ([self.appDelegate.isConnect isEqualToString:@"连接"])
    {
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        chatVC.fromStringFlag = @"场合选择客服";
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        transition.type =  kCATransitionMoveIn;
        transition.subtype =  kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:chatVC animated:NO];
    }
    else
    {
        ChatListViewController *chatVC = [[ChatListViewController alloc] init];
        chatVC.fromString = @"场合选择客服";
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type =  kCATransitionMoveIn;
        transition.subtype =  kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:chatVC animated:NO];
    }

}

- (IBAction)chooseBtnClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    SpeedAskPriceFirstViewController *speedAskPriceFirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"speedAskPriceFirstViewController"];
    [self.navigationController pushViewController:speedAskPriceFirstViewController animated:YES];
}

- (IBAction)reViewBtnClick:(id)sender
{
    [self.sv setContentOffset:CGPointMake(0, 0) animated:NO];
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
