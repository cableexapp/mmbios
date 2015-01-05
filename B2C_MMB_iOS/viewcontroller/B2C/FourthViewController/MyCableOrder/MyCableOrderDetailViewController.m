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
#import "MyCableOrderHostViewController.h"

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
    
    NSString *btnTitle = [(UIButton *)sender titleLabel].text;
    if([btnTitle isEqualToString:@"确认订单"])
    {
        MyCableSureOrderViewController *myCableSureOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableSureOrderViewController"];
        myCableSureOrderViewController.btnIndex = self.btnIndex;
        myCableSureOrderViewController.theOrderId = _myOrderNumber;
        [self.navigationController pushViewController:myCableSureOrderViewController animated:YES];
    }
    else if([btnTitle isEqualToString:@"确认收货"])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"您确认要收货嘛" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认收货", nil];
        [av show];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
        {
            [self sureReceiveRequest];
            break;
        }
        default:
            break;
    }
}

- (void) sureReceiveRequest
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"ConfirmReceive",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&orderid=%@",token,[NSString stringWithFormat:@"%@",[detailData ordernum]]];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLConfirmReceiveTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/ConfirmReceive.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLConfirmReceiveTag)
    {
        for(UIViewController *vc in self.navigationController.viewControllers)
        {
            if([vc isKindOfClass:[MyCableOrderHostViewController class]])
            {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
    }
}

- (void) requestHasFinished:(B2BMyCableDetailData *)b2bMyCableDetailData
{
    detailData = b2bMyCableDetailData;
    [self refreshView];
}

- (void) refreshView
{
    NSString *status = [[NSString alloc] initWithFormat:@"%@",detailData.status];
    //确认订单
    if([status intValue] == 0 )
    {
        [self.sureBtn setHidden:NO];
        [self.buttomLabel setHidden:YES];
        [self.sureBtn setTitle:@"确认订单" forState:UIControlStateNormal];
    }
    //待付款
    else if([status intValue] == 2)
    {
        [self.sureBtn setHidden:YES];
        [self.buttomLabel setHidden:NO];
    }
    //确认收货
    else
    {
        
        float shippedLastestNum = 0.0;
        NSArray *myItems = [NSArray arrayWithArray:[detailData myItems]];
        for(int i=0;i<myItems.count;i++)
        {
            NSDictionary *itemDic = [NSDictionary dictionaryWithDictionary:[myItems objectAtIndex:i]];
            shippedLastestNum = [[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"shippedLastestNum"]] floatValue] + shippedLastestNum;
        }
        if(shippedLastestNum <= 0.0)
        {
            [self.sureBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [self.sureBtn setHidden:NO];
            [self.buttomLabel setHidden:YES];
        }
        else
        {
            [self.sureBtn setFrame:CGRectMake(0, 5, 0, 0)];
            [self.sureBtn setHidden:YES];
            [self.buttomLabel setHidden:YES];
        }
    }
    
    
    NSString *orderNum = [NSString stringWithFormat:@"订单号: %@",detailData.ordernum];
    [self.myOrderNumberLabel setFrame:CGRectMake(5, 0, 180, 20)];
    [self.myOrderNumberLabel setText:orderNum];
    self.myOrderNumberLabel.backgroundColor = [UIColor whiteColor];
    [self.myOrderNumberLabel setFont:[UIFont systemFontOfSize:11]];
    
    [self.myOrderTimeLabel setFrame:CGRectMake(self.myOrderNumberLabel.frame.origin.x+self.myOrderNumberLabel.frame.size.width, 0, ScreenWidth-10-self.myOrderNumberLabel.frame.size.width, 20)];
    [self.myOrderTimeLabel setText:[NSString stringWithFormat:@"%@",detailData.cableOrderTime]];
    
    
    NSString *orderStatus = [NSString stringWithFormat:@"状态: %@",detailData.myStatus];
    NSMutableAttributedString *theOrderStatus = [[NSMutableAttributedString alloc] initWithString:orderStatus];
    [theOrderStatus addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    [theOrderStatus addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, orderStatus.length-3)];
    [self.myOrderStatusLabel setAttributedText:theOrderStatus];
    self.myOrderStatusLabel.backgroundColor = [UIColor whiteColor];

    NSString *orderTotal = [NSString stringWithFormat:@"订单总额: ¥%@",detailData.ordertotal];
    NSMutableAttributedString *theOrderTotal = [[NSMutableAttributedString alloc] initWithString:orderTotal];
    [theOrderTotal addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    [theOrderTotal addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, orderTotal.length-5)];
    [self.myOrderTotalLabel setAttributedText:theOrderTotal];
    self.myOrderTotalLabel.backgroundColor = [UIColor whiteColor];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"电缆订单详情"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    self.topView.backgroundColor = [UIColor whiteColor];
    
    self.sureBtn.layer.cornerRadius = 5.0f;
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
    [self.sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    myCableDetailTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableDetailTableViewController"];
    myCableDetailTableViewController.delegate = self;
    [self addChildViewController:myCableDetailTableViewController];
    myCableDetailTableViewController.myOrderid = _myOrderNumber;
    myCableDetailTableViewController.view.frame = self.tableSubView.bounds;
    [self.tableSubView addSubview:myCableDetailTableViewController.view];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSLog(@"btnIndex=%d",self.btnIndex);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
