//
//  BangDingWithMobileOrEmailViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "BangDingWithMobileOrEmailViewController.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "LoginNaviViewController.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"

@interface BangDingWithMobileOrEmailViewController ()

@end

@implementation BangDingWithMobileOrEmailViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"修改登录密码"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    self.validateBtn.layer.borderColor = MYCOLOR.CGColor;
    self.validateBtn.layer.borderWidth = 1.0f;
    self.validateBtn.layer.cornerRadius = 5.0f;
    
    [self.validateTf setDelegate:self];

}

- (IBAction)chooseBtnClick:(id)sender {
}

- (IBAction)validateBtnClick:(id)sender {
}

- (IBAction)nextStep:(id)sender {
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
