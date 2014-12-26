//
//  FourthNaviViewController.m
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-8-30.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import "FourthNaviViewController.h"
#import "HasNotLoginViewController.h"
#import "FourMyMMBListTableViewController.h"

@interface FourthNaviViewController ()
{
    BOOL flag;
    UIStoryboard *sb;
    FourMyMMBListTableViewController *fourMyMMBListTableViewController;
    HasNotLoginViewController *hasNotLoginViewController;
}
@end

@implementation FourthNaviViewController

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
}

- (void) dealChangeFourthNaviRootViewController:(NSNotification *) noti
{
    NSLog(@"flag=%d",[[noti object] boolValue]);
    flag = [[noti object] boolValue];
    if(flag == 1)
    {
        fourMyMMBListTableViewController = [sb instantiateViewControllerWithIdentifier:@"fourMyMMBListTableViewController"];
        [self setViewControllers:[NSArray arrayWithObject:fourMyMMBListTableViewController]];
    }
    else
    {
        hasNotLoginViewController = [sb instantiateViewControllerWithIdentifier:@"hasNotLoginViewController"];
        [self setViewControllers:[NSArray arrayWithObject:hasNotLoginViewController]];
    }
}

- (void) dealhasLogOut:(NSNotification *) noti
{
    if([[noti object] boolValue] == 0)
    {
        fourMyMMBListTableViewController = [sb instantiateViewControllerWithIdentifier:@"fourMyMMBListTableViewController"];
        [self setViewControllers:[NSArray arrayWithObject:fourMyMMBListTableViewController]];
        
    }
    else
    {
        hasNotLoginViewController = [sb instantiateViewControllerWithIdentifier:@"hasNotLoginViewController"];
        [self setViewControllers:[NSArray arrayWithObject:hasNotLoginViewController]];
        
    }
}

- (void) awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealChangeFourthNaviRootViewController:) name:@"ChangeFourthNaviRootViewController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealhasLogOut:) name:@"hasLogOut" object:nil];
    
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    sb = [UIStoryboard storyboardWithName:@"FourthSB" bundle:nil];
    if(memberid.length == 0 || [memberid isKindOfClass:[NSNull class]])
    {
        hasNotLoginViewController = [sb instantiateViewControllerWithIdentifier:@"hasNotLoginViewController"];
        [self setViewControllers:[NSArray arrayWithObject:hasNotLoginViewController]];
    }
    else
    {
        fourMyMMBListTableViewController = [sb instantiateViewControllerWithIdentifier:@"fourMyMMBListTableViewController"];
        [self setViewControllers:[NSArray arrayWithObject:fourMyMMBListTableViewController]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
