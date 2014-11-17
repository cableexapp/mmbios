//
//  AddInvoiceViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "AddInvoiceViewController.h"
#import "AddInvoiceAddedTableViewController.h"
#import "AddInvoiceNormalTableViewController.h"
#import "MCDefine.h"
#import "DCFStringUtil.h"
#import "DCFCustomExtra.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "LoginNaviViewController.h"

@interface AddInvoiceViewController ()
{
    NSArray *btnArray;
    
    AddInvoiceNormalTableViewController *addInvoiceNormalTableViewController;
    AddInvoiceAddedTableViewController *addInvoiceAddedTableViewController;
    
    int currentPageIndex;
}
@end

@implementation AddInvoiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if(memberid.length == 0)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}

- (IBAction)sureBtnClick:(id)sender
{
    if(currentPageIndex == 0)
    {
        if(addInvoiceNormalTableViewController)
        {
            [addInvoiceNormalTableViewController loadRequest];
        }
    }
    if(currentPageIndex == 1)
    {
        if(addInvoiceAddedTableViewController)
        {
            [addInvoiceAddedTableViewController loadRequest];
        }
    }
}



- (void) btnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    
    for(UIButton *b in btnArray)
    {
        if(b.tag == btn.tag)
        {
            
        }
        else
        {
            [b setSelected:NO];
        }
    }
    
    if(btn.tag == 0)
    {
        [self.sv setContentOffset:CGPointMake(0, 0) animated:YES];
        [addInvoiceAddedTableViewController keyBoardHide];
    }
    else
    {
        [self.sv setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
        [addInvoiceNormalTableViewController keyBoardHide];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"新增发票"];
    self.navigationItem.titleView = top;
    
    [self.normalBtn setSelected:YES];
    [self.normalBtn setTag:0];
    [self.addBtn setTag:1];
    [self.addBtn setSelected:NO];
    
    btnArray = [[NSArray alloc] initWithObjects:self.normalBtn,self.addBtn, nil];
    for(UIButton *btn in btnArray)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    
    addInvoiceNormalTableViewController = [[AddInvoiceNormalTableViewController alloc] init];
    [self addChildViewController:addInvoiceNormalTableViewController];
    addInvoiceNormalTableViewController.view.frame = self.firstView.bounds;
    [self.firstView addSubview:addInvoiceNormalTableViewController.view];
    
    addInvoiceAddedTableViewController = [[AddInvoiceAddedTableViewController alloc] init];
    [self addChildViewController:addInvoiceAddedTableViewController];
    addInvoiceAddedTableViewController.view.frame = self.secondView.bounds;
    [self.secondView addSubview:addInvoiceAddedTableViewController.view];
    
    [self.sv setContentSize:CGSizeMake(ScreenWidth*2, ScreenHeight-200)];
    
    self.sureBtn.layer.borderColor = [UIColor colorWithRed:228.0/255.0 green:121.0/255.0 blue:11.0/255.0 alpha:1.0].CGColor;
    self.sureBtn.layer.borderWidth = 1.0f;
    self.sureBtn.layer.cornerRadius =5.0f;
    [self.sureBtn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:228.0/255.0 green:121.0/255.0 blue:11.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];

}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    if(currentPageIndex == 0)
    {
        [addInvoiceAddedTableViewController keyBoardHide];
    }
    else
    {
        [addInvoiceNormalTableViewController keyBoardHide];
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(currentPageIndex == 0)
    {
        [self.normalBtn setSelected:YES];
        [self.addBtn setSelected:NO];
    }
    else
    {
        [self.addBtn setSelected:YES];
        [self.normalBtn setSelected:NO];
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
