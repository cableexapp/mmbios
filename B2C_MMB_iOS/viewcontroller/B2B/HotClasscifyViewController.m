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
#import "DCFCustomExtra.h"

@interface HotClasscifyViewController ()
{
    int page;
    NSMutableArray *btnArray;
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

- (void) askPriceBtnClick:(UIButton *) sender
{
    NSLog(@"加入询价车");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"热门型号"];
    self.navigationItem.titleView = top;
    
    UIButton *askPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [askPriceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [askPriceBtn setTitle:@"询价车" forState:UIControlStateNormal];
    [askPriceBtn setFrame:CGRectMake(0, 0, 50, 50)];
    [askPriceBtn addTarget:self action:@selector(askPriceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:askPriceBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    self.addToAskPriceBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.addToAskPriceBtn.layer.borderWidth = 1.0f;
    self.addToAskPriceBtn.layer.cornerRadius = 2.0f;
    
    [_sv setContentSize:CGSizeMake(ScreenWidth*7, self.sv.frame.size.height-200)];
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
    
    btnArray = [[NSMutableArray alloc] init];
    for(UIView *view in self.sv.subviews)
    {
        if(view.frame.origin.x >= 1820)
        {
        }
        else
        {
            for(UIButton *subBtn in view.subviews)
            {
                //图片拉伸自适应
                [subBtn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                UIImage *image = [UIImage imageNamed:@"hotModelSelected.png"];
                image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 10, 10)];
                
                [subBtn setBackgroundImage:image forState:UIControlStateSelected];
                [subBtn addTarget:self action:@selector(hotModelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btnArray addObject:subBtn];
            }
        }
        
    }
    
    [self allKinds:btnArray];
}

#pragma mark - 所有型号的分类，一级，二级，三级
- (void) allKinds:(NSMutableArray *) arr
{
    //读取plist文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"KindsPlist" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSLog(@"%d",[[dic allKeys] count]);
}

- (void) hotModelBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
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
    if(page >= 6)
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
