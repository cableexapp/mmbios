//
//  FindBack_ThirdViewController.m
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-9.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import "FindBack_ThirdViewController.h"
#import "DCFTopLabel.h"
#import "DCFStringUtil.h"
#import "LoginNaviViewController.h"

@interface FindBack_ThirdViewController ()
{
    UIStoryboard *sb;
}
@end

@implementation FindBack_ThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) sure:(UIButton *) sender
{
    [_tf_newSec resignFirstResponder];
    
    NSString *string = [_tf_newSec.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if(string.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入密码"];
        return;
    }
    if(string.length < 6)
    {
        [DCFStringUtil showNotice:@"密码长度不能小于6位"];
        return;
    }
    if(string.length > 18)
    {
        [DCFStringUtil showNotice:@"密码长度不能大于18位"];
        return;
    }
    BOOL isAllNum = [self isAllNum:string];
    if(isAllNum == 1)
    {
        [DCFStringUtil showNotice:@"密码不能为纯数字"];
        return;
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - 判断是不是纯数字
- (BOOL)isAllNum:(NSString *)string
{
    unichar c;
    for (int i=0; i<string.length; i++)
    {
        c=[string characterAtIndex:i];
        if (!isdigit(c))
        {
            return NO;
        }
    }
    return YES;
}
    
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"确认" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor colorWithRed:21.0/255.0 green:100.0/255.0 blue:249.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [nextBtn setFrame:CGRectMake(100, 0, 50, 30)];
    [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [nextBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"找回密码"];
    self.navigationItem.titleView = top;
    
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    [_tf_newSec resignFirstResponder];
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
