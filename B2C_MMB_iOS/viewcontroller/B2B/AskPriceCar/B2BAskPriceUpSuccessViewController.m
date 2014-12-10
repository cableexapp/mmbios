//
//  B2BAskPriceUpSuccessViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-6.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2BAskPriceUpSuccessViewController.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "MyInquiryListFirstViewController.h"
#import "MCDefine.h"

@interface B2BAskPriceUpSuccessViewController ()

@end

@implementation B2BAskPriceUpSuccessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"提交成功"];
    self.navigationItem.titleView = top;
    
    [self.lookForMyOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.lookForMyOrderBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
    self.lookForMyOrderBtn.layer.cornerRadius = 5.0f;
}

- (IBAction)lookForMyOrderBtnClick:(id)sender
{
    MyInquiryListFirstViewController *myInquiryListFirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myInquiryListFirstViewController"];
    [self.navigationController pushViewController:myInquiryListFirstViewController animated:YES];
}

- (IBAction)telBtnClick:(id)sender
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
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-828-0188"]];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
