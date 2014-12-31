//
//  MyCableSureOrderViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyCableSureOrderViewController.h"
#import "MCDefine.h"
#import "DCFStringUtil.h"
#import "DCFCustomExtra.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "MyCableOrderHostViewController.h"
#import "MyInquiryListFirstViewController.h"

@interface MyCableSureOrderViewController ()
{
    MyCableSureOrderTableViewController *myCableSureOrderTableViewController;
    B2BMyCableDetailData *detailData;
}
@end

@implementation MyCableSureOrderViewController

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
    [myCableSureOrderTableViewController loadRequest];
}

- (void) popDelegate
{
    int n = self.navigationController.viewControllers.count;
    for(UIViewController *vc in self.navigationController.viewControllers)
    {
        if([vc isKindOfClass:[MyCableOrderHostViewController class]])
        {
//            [myCableOrder loadRequest:self.btnIndex];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyCableOrderHostViewControllerRefreshRequest" object:[NSNumber numberWithInt:self.btnIndex]];
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        if([vc isKindOfClass:[MyInquiryListFirstViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        
        if(n == self.navigationController.viewControllers.count-1)
        {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        n++;
    }
}

- (void) refreshView
{
    NSString *orderNum = [NSString stringWithFormat:@"订单号:%@",detailData.ordernum];
    [self.myOrderNumberLabel setFrame:CGRectMake(5, 0, 150, 20)];
    [self.myOrderNumberLabel setText:orderNum];
    [self.myOrderNumberLabel setFont:[UIFont systemFontOfSize:11]];
    
    [self.myOrderTimeLabel setFrame:CGRectMake(self.myOrderNumberLabel.frame.origin.x+self.myOrderNumberLabel.frame.size.width, 0, ScreenWidth-10-self.myOrderNumberLabel.frame.size.width, 20)];
    [self.myOrderTimeLabel setText:[NSString stringWithFormat:@"%@",detailData.cableOrderTime]];
    
    
    NSString *orderStatus = [NSString stringWithFormat:@"状态: %@",detailData.myStatus];
    NSMutableAttributedString *theOrderStatus = [[NSMutableAttributedString alloc] initWithString:orderStatus];
    [theOrderStatus addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    [theOrderStatus addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3, orderStatus.length-3)];
    [self.myOrderStatusLabel setAttributedText:theOrderStatus];
    
    NSString *orderTotal = [NSString stringWithFormat:@"订单总额: ¥%@",detailData.ordertotal];
    NSMutableAttributedString *theOrderTotal = [[NSMutableAttributedString alloc] initWithString:orderTotal];
    [theOrderTotal addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    [theOrderTotal addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(5, orderTotal.length-5)];
    [self.myOrderTotalLabel setAttributedText:theOrderTotal];
    
}

- (void) doMyCableSureOrderTableVCHasFinished:(NSNotification *) noti
{
    detailData = (B2BMyCableDetailData *)[noti object];
    [self refreshView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"确认订单"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doMyCableSureOrderTableVCHasFinished:) name:@"MyCableSureOrderTableVCHasFinished" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableSubView.backgroundColor = [UIColor whiteColor];
    myCableSureOrderTableViewController.view.backgroundColor = [UIColor whiteColor];

    
    
    myCableSureOrderTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableSureOrderTableViewController"];
    myCableSureOrderTableViewController.delegate = self;
    [self addChildViewController:myCableSureOrderTableViewController];
    myCableSureOrderTableViewController.myOrderid = [[NSString alloc] initWithFormat:@"%@",_theOrderId];
    myCableSureOrderTableViewController.view.frame = self.tableSubView.bounds;
    [self.tableSubView addSubview:myCableSureOrderTableViewController.view];


    self.sureBtn.layer.cornerRadius = 5.0f;
    self.sureBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    if(_b2bMyCableOrderListData.cableOrderTime.length == 0 || [_b2bMyCableOrderListData.cableOrderTime isKindOfClass:[NSNull class]])
//    {
//        [self.myOrderTimeLabel setFrame:CGRectMake(ScreenWidth-85, 2, 80, 20)];
//    }
//    else
//    {
//        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:[NSString stringWithFormat:@"%@",_b2bMyCableOrderListData.cableOrderTime] WithSize:CGSizeMake(MAXFLOAT, 20)];
//        [self.myOrderTimeLabel setFrame:CGRectMake(ScreenWidth-5-size.width, 2, size.width, 20)];
//    }
//    [self.myOrderNumberLabel setFrame:CGRectMake(5, 2, ScreenWidth-5-self.myOrderTimeLabel.frame.size.width, 20)];
//    [self.myOrderNumberLabel setText:[NSString stringWithFormat:@"订单号:%@",_b2bMyCableOrderListData.orderserial]];
//    [self.myOrderTimeLabel setText:[NSString stringWithFormat:@"%@",_b2bMyCableOrderListData.cableOrderTime]];
//    [self.myOrderStatusLabel setText:[NSString stringWithFormat:@"状态: %@",_b2bMyCableOrderListData.myStatus]];
//    [self.myOrderTotalLabel setText:[NSString stringWithFormat:@"订单总额:¥ %@",_b2bMyCableOrderListData.ordertotal]];
//    self.myOrderTotalLabel.textColor = [UIColor redColor];
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
