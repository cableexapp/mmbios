//
//  RegisterProvisionViewController.m
//  B2C_MMB_iOS
//
//  Created by developer on 15-1-1.
//  Copyright (c) 2015年 YUANDONG. All rights reserved.
//

#import "RegisterProvisionViewController.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"

@interface RegisterProvisionViewController ()

@end

@implementation RegisterProvisionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    if(HUD)
    {
        [HUD hide:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    DCFTopLabel *TOP = [[DCFTopLabel alloc] initWithTitle:@"服务条款"];
    self.navigationItem.titleView = TOP;
    
    
    UIWebView *register_webview = [[UIWebView alloc] init];
    register_webview.frame = CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height-64);
    register_webview.delegate = self;
    [self.view addSubview:register_webview];
    
//    NSURL *url = [[NSURL alloc]initWithString:@"http://58.215.20.140:8001/agreement.html"];
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/agreement.html"]];

    [register_webview loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void) hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if(!HUD)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setLabelText:@"数据加载中..."];
        [HUD setDelegate:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(HUD)
    {
        [HUD hide:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
