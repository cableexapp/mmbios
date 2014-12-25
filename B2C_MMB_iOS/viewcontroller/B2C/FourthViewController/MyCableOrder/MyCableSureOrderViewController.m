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

@interface MyCableSureOrderViewController ()
{
    MyCableSureOrderTableViewController *myCableSureOrderTableViewController;
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
//    MyCableOrderHostViewController *myCableOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableOrderHostViewController"];
//    myCableOrder.btnIndex = self.btnIndex;
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
        
        if(n == self.navigationController.viewControllers.count-1)
        {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        n++;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"确认订单"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableSubView.backgroundColor = [UIColor whiteColor];
    myCableSureOrderTableViewController.view.backgroundColor = [UIColor whiteColor];
    NSString *fullAddress = [NSString stringWithFormat:@"%@%@%@%@",_b2bMyCableOrderListData.receiveprovince,_b2bMyCableOrderListData.receivecity,_b2bMyCableOrderListData.receivedistrict,_b2bMyCableOrderListData.receiveaddress];
    fullAddress = [fullAddress stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    NSString *tel = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"联系电话:%@",_b2bMyCableOrderListData.tel]];
    NSString *name = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"联系人:%@",_b2bMyCableOrderListData.receivename]];
    NSDictionary *myDic = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",tel,@"tel",fullAddress,@"fullAddress",_b2bMyCableOrderListData.receiveprovince,@"receiveprovince",_b2bMyCableOrderListData.receivecity,@"receivecity",_b2bMyCableOrderListData.receivedistrict,@"receivedistrict",_b2bMyCableOrderListData.receiveaddress,@"receiveaddress", nil];
    
    myCableSureOrderTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableSureOrderTableViewController"];
    myCableSureOrderTableViewController.delegate = self;
    [self addChildViewController:myCableSureOrderTableViewController];
    myCableSureOrderTableViewController.addressDic = [[NSDictionary alloc] initWithDictionary:myDic];
    myCableSureOrderTableViewController.b2bMyCableOrderListData = _b2bMyCableOrderListData;
    myCableSureOrderTableViewController.myOrderid = [[NSString alloc] initWithFormat:@"%@",_b2bMyCableOrderListData.orderserial];
    myCableSureOrderTableViewController.view.frame = self.tableSubView.bounds;
    [self.tableSubView addSubview:myCableSureOrderTableViewController.view];


    self.sureBtn.layer.cornerRadius = 5.0f;
    self.sureBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if(_b2bMyCableOrderListData.cableOrderTime.length == 0 || [_b2bMyCableOrderListData.cableOrderTime isKindOfClass:[NSNull class]])
    {
        [self.myOrderTimeLabel setFrame:CGRectMake(ScreenWidth-85, 2, 80, 20)];
    }
    else
    {
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:[NSString stringWithFormat:@"%@",_b2bMyCableOrderListData.cableOrderTime] WithSize:CGSizeMake(MAXFLOAT, 20)];
        [self.myOrderTimeLabel setFrame:CGRectMake(ScreenWidth-5-size.width, 2, size.width, 20)];
    }
    [self.myOrderNumberLabel setFrame:CGRectMake(5, 2, ScreenWidth-5-self.myOrderTimeLabel.frame.size.width, 20)];
    [self.myOrderNumberLabel setText:[NSString stringWithFormat:@"订单号:%@",_b2bMyCableOrderListData.orderserial]];
    [self.myOrderTimeLabel setText:[NSString stringWithFormat:@"%@",_b2bMyCableOrderListData.cableOrderTime]];
    [self.myOrderStatusLabel setText:[NSString stringWithFormat:@"状态: %@",_b2bMyCableOrderListData.myStatus]];
    [self.myOrderTotalLabel setText:[NSString stringWithFormat:@"订单总额:¥ %@",_b2bMyCableOrderListData.ordertotal]];
    self.myOrderTotalLabel.textColor = [UIColor redColor];
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
