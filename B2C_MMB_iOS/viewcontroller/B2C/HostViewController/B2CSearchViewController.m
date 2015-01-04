//
//  B2CSearchViewController.m
//  B2C_MMB_iOS
//
//  Created by developer on 15-1-4.
//  Copyright (c) 2015年 YUANDONG. All rights reserved.
//

#import "B2CSearchViewController.h"
#import "DCFTopLabel.h"

@interface B2CSearchViewController ()

@end

@implementation B2CSearchViewController

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
    
    //导航栏标题
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装馆搜索"];
    self.navigationItem.titleView = top;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
