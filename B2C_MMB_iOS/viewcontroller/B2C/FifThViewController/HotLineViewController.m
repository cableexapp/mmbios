//
//  HotLineViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-10.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "HotLineViewController.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"

@interface HotLineViewController ()

@end

@implementation HotLineViewController

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
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"客服热线"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    UIButton *hotLineButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    hotLineButton.frame = CGRectMake(30, 65, 50, 50);
    [hotLineButton setBackgroundImage:[UIImage imageNamed:@"电话服务"] forState:UIControlStateNormal];
    [hotLineButton addTarget:self action:@selector(callHotLine) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hotLineButton];
    
    [self.hotBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 30)];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)callHotLine
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"您确定要拨打热线电话么"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"呼叫", nil];
    [av show];
}

- (IBAction)hotBtnClick:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"您确定要拨打热线电话么"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"呼叫", nil];
    [av show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
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
