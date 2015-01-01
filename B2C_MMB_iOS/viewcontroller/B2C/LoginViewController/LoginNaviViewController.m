//
//  LoginNaviViewController.m
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-5.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import "LoginNaviViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"

@interface LoginNaviViewController ()

@end

@implementation LoginNaviViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) doHasNotLoginViewControllerNoti
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    RegisterViewController *regist = [sb instantiateViewControllerWithIdentifier:@"registerViewController"];
    self.viewControllers = [NSArray arrayWithObjects:regist, nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doHasNotLoginViewControllerNoti) name:@"HasNotLoginViewControllerNoti" object:nil];
    // Do any additional setup after loading the view.
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
