//
//  CableSecondAndThirdStepViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-8.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "CableSecondAndThirdStepViewController.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "CableChoosemodelViewController.h"
#import "SearchViewController.h"

@interface CableSecondAndThirdStepViewController ()
{
    CableSecondStepTableViewController *second;
    CableThirdStepViewController *third;
    CableChoosemodelViewController *cableChoosemodelViewController;
}
@end

@implementation CableSecondAndThirdStepViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view tag] == 101)
        {
            [view setHidden:YES];
        }
        if([view isKindOfClass:[UISearchBar class]])
        {
            [view setHidden:YES];
        }
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0,22,22)];
    [btn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void) changeWithTypeId:(NSString *)typeId WithTypeName:(NSString *)typeName
{
    if(third)
    {
        [third changeClassify:typeId WithTitle:typeName];
    }
}

- (void) pushString:(NSString *)string WithTypeId:(NSString *)typeId
{
    [self setHidesBottomBarWhenPushed:YES];
    cableChoosemodelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cableChoosemodelViewController"];
    cableChoosemodelViewController.myTitle = string;
    cableChoosemodelViewController.myTypeId = typeId;
    [self.navigationController pushViewController:cableChoosemodelViewController animated:YES];
}

- (void) searchBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    if ([self.fromPage isEqualToString:@"电缆选购"] || [self.fromPage isEqualToString:@"电缆分类"])
    {
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    else
    {
         [self.navigationController popViewControllerAnimated:YES];
    }
    [self setHidesBottomBarWhenPushed:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"开始询价"];
    top.font = [UIFont systemFontOfSize:19];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    second = [self.storyboard instantiateViewControllerWithIdentifier:@"cableSecondStepTableViewController"];
    second.delegate = self;
    second.title = [NSString stringWithFormat:@"%@>",self.myTitle];
    [self addChildViewController:second];
    second.width = self.secondTypeView.frame.size.width;
    second.height = self.secondTypeView.frame.size.height;
    second.myTypeId = [[NSString alloc] initWithFormat:@"%@",self.typeId];
    second.view.frame = self.secondTypeView.bounds;
    [self.secondTypeView addSubview:second.view];
    
    third = [self.storyboard instantiateViewControllerWithIdentifier:@"cableThirdStepViewController"];
    third.delegate = self;
    [self addChildViewController:third];
    third.width = self.thirdTypeView.frame.size.width;
    third.height = self.thirdTypeView.frame.size.height;
    third.view.frame = self.thirdTypeView.bounds;
    [self.thirdTypeView addSubview:third.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
