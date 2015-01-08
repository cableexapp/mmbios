//
//  ManageInvoiceViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-14.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "ManageInvoiceViewController.h"
#import "MCDefine.h"
#import "DCFStringUtil.h"
#import "DCFCustomExtra.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "LoginNaviViewController.h"
#import "ManagerInvoiceSubTableViewController.h"
#import "AddInvoiceViewController.h"


@interface ManageInvoiceViewController ()
{
    ManagerInvoiceSubTableViewController *managerInvoiceSubTableViewController;
    
    BOOL swithStatus;
    
    UIButton *rightBtn;
}
@end

@implementation ManageInvoiceViewController

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
    if(managerInvoiceSubTableViewController)
    {
        
        if([[managerInvoiceSubTableViewController changeChooseArray] count] > 1)
        {
            [DCFStringUtil showNotice:@"对不起,您只能选择一个发票"];
            return;
        }
        if([[managerInvoiceSubTableViewController changeChooseArray] count] <= 0)
        {
            [DCFStringUtil showNotice:@"对不起,您尚未选择发票"];
            return;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) rightBtnclick:(UIButton *) sender
{
    AddInvoiceViewController *addInvoiceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addInvoiceViewController"];
    [self.navigationController pushViewController:addInvoiceViewController animated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"B2BManageBillSwitchStatus"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"B2BManageBillSwitchStatus"];
    }
    
    [self.mySwitch setOn:[[[NSUserDefaults standardUserDefaults] objectForKey:@"B2BManageBillSwitchStatus"] boolValue]];
    
    swithStatus = [[[NSUserDefaults standardUserDefaults] objectForKey:@"B2BManageBillSwitchStatus"] boolValue];
    
    
    if(!rightBtn)
    {
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"新增" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBtn setFrame:CGRectMake(0, 0, 50, 40)];
        [rightBtn addTarget:self action:@selector(rightBtnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = barItem;
    }
    
    
    self.sureBtn.layer.cornerRadius = 5.0f;
    [self.sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:228.0/255.0 green:121.0/255.0 blue:11.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.sureBtn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:173.0/255.0 green:173.0/255.0 blue:173.0/255.0  alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
    [self.sureBtn setEnabled:swithStatus];
    
    if(swithStatus == YES)
    {
        //        [self.sureBtn setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:121.0/255.0 blue:11.0/255.0 alpha:1.0]];
        [rightBtn setHidden:NO];
    }
    else
    {
        //        [self.sureBtn setBackgroundColor:[UIColor colorWithRed:173.0/255.0 green:173.0/255.0 blue:173.0/255.0 alpha:1.0]];
        
        [rightBtn setHidden:YES];
    }
    
    managerInvoiceSubTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"managerInvoiceSubTableViewController"];
    managerInvoiceSubTableViewController.status = swithStatus;
    [self addChildViewController:managerInvoiceSubTableViewController];
    managerInvoiceSubTableViewController.view.frame = self.tableSubView.bounds;
    [self.tableSubView addSubview:managerInvoiceSubTableViewController.view];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"发票信息管理"];
    self.navigationItem.titleView = top;
    
    
    self.sureBtn.layer.cornerRadius = 5.0f;
    self.sureBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
    //    [self.sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mySwitch addTarget:self action:@selector(swithChange:) forControlEvents:UIControlEventValueChanged];
}




- (void) swithChange:(UISwitch *) sender
{
    UISwitch *swith = (UISwitch *)sender;
    BOOL isChange = [swith isOn];
    swithStatus = isChange;
    
    if(isChange == YES)
    {
        [self.sureBtn setEnabled:YES];
        //        [self.sureBtn setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:121.0/255.0 blue:11.0/255.0 alpha:1.0]];
        [rightBtn setHidden:NO];
    }
    else
    {
        [self.sureBtn setEnabled:NO];
        //        [self.sureBtn setBackgroundColor:[UIColor colorWithRed:173.0/255.0 green:173.0/255.0 blue:173.0/255.0 alpha:1.0]];
        [rightBtn setHidden:YES];
    }
    
    managerInvoiceSubTableViewController.status = isChange;
    [managerInvoiceSubTableViewController changeColor];
    
    [[NSUserDefaults standardUserDefaults] setBool:isChange forKey:@"B2BManageBillSwitchStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
