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

@interface MyCableOrderDetailViewController ()
{
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
    myCableSureOrderViewController.b2bMyCableOrderListData = _b2bMyCableOrderListData;
    [self.navigationController pushViewController:myCableSureOrderViewController animated:YES];
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
    
    NSString *status = [[NSString alloc] initWithFormat:@"%@",_b2bMyCableOrderListData.status];
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
        [self.tableSubView setFrame:CGRectMake(self.tableSubView.frame.origin.x, self.tableSubView.frame.origin.y, self.tableSubView.frame.size.width, ScreenHeight-self.topView.frame.size.height)];
    }
    
    NSString *fullAddress = [NSString stringWithFormat:@"%@%@%@%@",_b2bMyCableOrderListData.receiveprovince,_b2bMyCableOrderListData.receivecity,_b2bMyCableOrderListData.receivedistrict,_b2bMyCableOrderListData.receiveaddress];
    NSString *tel = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"联系电话:%@",_b2bMyCableOrderListData.tel]];
    NSString *name = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"联系人:%@",_b2bMyCableOrderListData.receivename]];
    NSDictionary *myDic = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",tel,@"tel",fullAddress,@"fullAddress", nil];
    
    myCableDetailTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableDetailTableViewController"];
    [self addChildViewController:myCableDetailTableViewController];
    myCableDetailTableViewController.addressDic = [[NSDictionary alloc] initWithDictionary:myDic];
    myCableDetailTableViewController.myOrderid = [[NSString alloc] initWithFormat:@"%@",_b2bMyCableOrderListData.orderserial];
    myCableDetailTableViewController.view.frame = self.tableSubView.bounds;
    [self.tableSubView addSubview:myCableDetailTableViewController.view];
    

    
    NSString *orderNum = [NSString stringWithFormat:@"订单号:%@",_b2bMyCableOrderListData.orderserial];
    [self.myOrderNumberLabel setFrame:CGRectMake(5, 0, 150, 20)];
    [self.myOrderNumberLabel setText:orderNum];
    [self.myOrderNumberLabel setFont:[UIFont systemFontOfSize:11]];
    
    [self.myOrderTimeLabel setFrame:CGRectMake(self.myOrderNumberLabel.frame.origin.x+self.myOrderNumberLabel.frame.size.width, 0, ScreenWidth-10-self.myOrderNumberLabel.frame.size.width, 20)];
    [self.myOrderTimeLabel setText:[NSString stringWithFormat:@"%@",_b2bMyCableOrderListData.cableOrderTime]];
    
    [self.myOrderStatusLabel setText:[NSString stringWithFormat:@"状态: %@",_b2bMyCableOrderListData.myStatus]];
    [self.myOrderTotalLabel setText:[NSString stringWithFormat:@"订单总额: %@",_b2bMyCableOrderListData.ordertotal]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
