//
//  RegisterAgreementViewController.m
//  B2C_MMB_iOS
//
//  Created by developer on 14-12-8.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "RegisterAgreementViewController.h"
#import "DCFTopLabel.h"

@interface RegisterAgreementViewController ()

@end

@implementation RegisterAgreementViewController

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
    
    DCFTopLabel *TOP = [[DCFTopLabel alloc] initWithTitle:@"服务条款"];
    self.navigationItem.titleView = TOP;
    
    
    UIWebView *register_webview = [[UIWebView alloc] init];
    register_webview.frame = CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height-54);
    [self.view addSubview:register_webview];
    
    NSURL *url = [[NSURL alloc]initWithString:@"http://58.215.20.140:8001/agreement.html"];
    [register_webview loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
