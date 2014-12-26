//
//  ModifyLogSecSuccessViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "ModifyLogSecSuccessViewController.h"
#import "MCDefine.h"
#import "DCFTopLabel.h"
#import "AppDelegate.h"

@interface ModifyLogSecSuccessViewController ()
{
    AppDelegate *app;
}
@end

@implementation ModifyLogSecSuccessViewController

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
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"修改登录密码"];
    self.navigationItem.titleView = top;
    
    self.backBtn.layer.borderColor = MYCOLOR.CGColor;
    self.backBtn.layer.borderWidth = 1.0f;
    self.backBtn.layer.cornerRadius = 5.0f;
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.hideNotice = YES;
}

- (IBAction)backBtnClick:(id)sender
{
    [app logOutMethod];
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
