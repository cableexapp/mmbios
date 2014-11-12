//
//  HotSecondViewController.m
//  B2C_MMB_iOS
//
//  Created by cyumen on 14-11-12.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "HotSecondViewController.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"

@interface HotSecondViewController ()

@end

@implementation HotSecondViewController

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
    
     //每个界面都要加这句话
    [self pushAndPopStyle];

    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"提交所选分类"];
    self.navigationItem.titleView = top;
    [super viewDidLoad];
}

//点击背景
- (IBAction)onBackgroungHit:(id)sender {
    
    //取消目前是第一回应者（键盘消失）
    [_PhoneNumber resignFirstResponder];
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
