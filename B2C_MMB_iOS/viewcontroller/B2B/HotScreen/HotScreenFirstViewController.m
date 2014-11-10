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

@interface HotScreenFirstViewController ()
{
    int page;
    NSMutableArray *btnArray;

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
    
    [self pushAndPopStyle];
    
    btnArray = [[NSMutableArray alloc] init];
    for(UIView *view in self.sv.subviews)
    {
        for(UIButton *subBtn in view.subviews)
        {
    
            NSLog(@"tag = %d",subBtn.tag);
            NSLog(@"%@",subBtn.titleLabel.text);
            [subBtn.titleLabel setNumberOfLines:0];
            [btnArray addObject:subBtn];
        }
    }
    
    
    for(UIButton *btn in btnArray)
    {
        [btn addTarget:self action:@selector(screenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void) screenBtnClick:(UIButton *) sender
{
    HotScreenSecondViewController *hotScreenSecondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HotScreenSecondViewController"];
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
    if(page >= 4)
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

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
