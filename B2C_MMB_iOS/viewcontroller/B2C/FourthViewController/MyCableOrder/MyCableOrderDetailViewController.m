//
//  MyCableOrderDetailViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyCableOrderDetailViewController.h"
#import "MCDefine.h"
#import "DCFStringUtil.h"
#import "DCFCustomExtra.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "MyCableSureOrderViewController.h"
#import "B2BMyCableDetailData.h"

@interface MyCableOrderDetailViewController ()
{
    B2BMyCableDetailData *detailData;
}
@end

@implementation MyCableOrderDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) sureBtnClick:(UIButton *) sender
{
    NSLog(@"sure");
    
    
    MyCableSureOrderViewController *myCableSureOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableSureOrderViewController"];
    myCableSureOrderViewController.btnIndex = self.btnIndex;
    myCableSureOrderViewController.theOrderId = _myOrderNumber;
    [self.navigationController pushViewController:myCableSureOrderViewController animated:YES];
}

- (void) requestHasFinished:(B2BMyCableDetailData *)b2bMyCableDetailData
{
    detailData = b2bMyCableDetailData;
    [self refreshView];
}

- (void) refreshView
{
    NSString *status = [[NSString alloc] initWithFormat:@"%@",detailData.status];
    if([status intValue] == 0 )
    {
        [self.sureBtn setHidden:NO];
        [self.buttomLabel setHidden:YES];
    }
    //待付款
    else if([status intValue] == 2)
    {
        [self.sureBtn setHidden:YES];
        [self.buttomLabel setHidden:NO];
    }
    else
    {
        [self.buttomView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 0)];
        [self.buttomLabel setFrame:CGRectMake(self.buttomLabel.frame.origin.x, self.buttomLabel.frame.origin.y, self.buttomLabel.frame.size.width, 0)];
        [self.sureBtn setFrame:CGRectMake(self.sureBtn.frame.origin.x, self.sureBtn.frame.origin.y, self.sureBtn.frame.size.width, 0)];
        [self.tableSubView setFrame:CGRectMake(self.tableSubView.frame.origin.x, self.tableSubView.frame.origin.y, self.tableSubView.frame.size.width, MainScreenHeight-self.topView.frame.size.height)];
    }
    
    
    NSString *orderNum = [NSString stringWithFormat:@"订单号:%@",detailData.ordernum];
    [self.myOrderNumberLabel setFrame:CGRectMake(5, 0, 180, 20)];
    [self.myOrderNumberLabel setText:orderNum];
    [self.myOrderNumberLabel setFont:[UIFont systemFontOfSize:11]];
    
    [self.myOrderTimeLabel setFrame:CGRectMake(self.myOrderNumberLabel.frame.origin.x+self.myOrderNumberLabel.frame.size.width, 0, ScreenWidth-10-self.myOrderNumberLabel.frame.size.width, 20)];
    [self.myOrderTimeLabel setText:[NSString stringWithFormat:@"%@",detailData.cableOrderTime]];
    
    
    NSString *orderStatus = [NSString stringWithFormat:@"状态: %@",detailData.myStatus];
    NSMutableAttributedString *theOrderStatus = [[NSMutableAttributedString alloc] initWithString:orderStatus];
    [theOrderStatus addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    [theOrderStatus addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, orderStatus.length-3)];
    [self.myOrderStatusLabel setAttributedText:theOrderStatus];

    NSString *orderTotal = [NSString stringWithFormat:@"订单总额: ¥%@",detailData.ordertotal];
    NSMutableAttributedString *theOrderTotal = [[NSMutableAttributedString alloc] initWithString:orderTotal];
    [theOrderTotal addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    [theOrderTotal addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, orderTotal.length-5)];
    [self.myOrderTotalLabel setAttributedText:theOrderTotal];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"电缆订单详情"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    
    self.sureBtn.layer.cornerRadius = 5.0f;
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:144/255.0 blue:1/255.0 alpha:1.0];
    [self.sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    

    
    myCableDetailTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableDetailTableViewController"];
    myCableDetailTableViewController.delegate = self;
    [self addChildViewController:myCableDetailTableViewController];
    myCableDetailTableViewController.myOrderid = _myOrderNumber;
    myCableDetailTableViewController.view.frame = self.tableSubView.bounds;
    [self.tableSubView addSubview:myCableDetailTableViewController.view];
    
    
    
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
