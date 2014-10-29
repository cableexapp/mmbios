//
//  HotClasscifyViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-27.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "HotClasscifyViewController.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"

@interface HotClasscifyViewController ()
{
    int page;
}
@end

@implementation HotClasscifyViewController

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
    
    [self pushAndPopStyle];
    
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"热门型号"];
    self.navigationItem.titleView = top;
    
    self.addToAskPriceBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.addToAskPriceBtn.layer.borderWidth = 1.0f;
    self.addToAskPriceBtn.layer.cornerRadius = 2.0f;

    [_sv setContentSize:CGSizeMake(ScreenWidth*4, self.sv.frame.size.height-200)];
    [_sv setBounces:NO];

    
    self.hotLineBtn.layer.borderColor = [UIColor colorWithRed:51.0/255.0 green:112.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor;
    self.hotLineBtn.layer.borderWidth = 1.0f;
    self.hotLineBtn.layer.cornerRadius = 2.0f;

    self.imBtn.layer.borderColor = [UIColor colorWithRed:51.0/255.0 green:112.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor;
    self.imBtn.layer.borderWidth = 1.0f;
    self.imBtn.layer.cornerRadius = 2.0f;

    self.moreModelBtn.layer.borderColor = [UIColor colorWithRed:51.0/255.0 green:112.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor;
    self.moreModelBtn.layer.borderWidth = 1.0f;
    self.moreModelBtn.layer.cornerRadius = 2.0f;

    self.directBtn.layer.borderColor = [UIColor colorWithRed:51.0/255.0 green:112.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor;
    self.directBtn.layer.borderWidth = 1.0f;
    self.directBtn.layer.cornerRadius = 2.0f;

}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;

}

- (IBAction)addToAskPriceCarBtnClick:(id)sender
{
    NSLog(@"加入询价车");
}

- (IBAction)searchBtnClick:(id)sender
{
    NSLog(@"搜索");
}

- (IBAction)nextBtnClick:(id)sender
{
    NSLog(@"下一页page=%d",page);
    if(page >= 3)
    {
        NSLog(@"到顶了");
        return;
    }
    else
    {
        page++;
        [self.sv setContentOffset:CGPointMake(ScreenWidth*page, 0) animated:YES];
    }
}

- (IBAction)upBtnClick:(id)sender
{
    NSLog(@"上一页page=%d",page);
    if(page <= 0)
    {
        NSLog(@"到顶了");
        return;
    }
    else
    {
        page--;
        [self.sv setContentOffset:CGPointMake(ScreenWidth*page, 0) animated:YES];
    }
}

- (IBAction)hotLineBtnClick:(id)sender
{
    NSLog(@"热线");
}

- (IBAction)imbtnClick:(id)sender
{
    NSLog(@"im");
}

- (IBAction)moreModelBtnClick:(id)sender
{
    NSLog(@"更多");
}

- (IBAction)directBtnClick:(id)sender
{
    NSLog(@"直接");
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
