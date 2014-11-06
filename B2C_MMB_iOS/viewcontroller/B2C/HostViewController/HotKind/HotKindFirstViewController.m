//
//  HotKindFirstViewController.m
//  B2C_MMB_iOS
//
//  Created by cyumen on 14-11-5.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "HotKindFirstViewController.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFCustomExtra.h"
#import "MCDefine.h"

@interface HotKindFirstViewController ()

@end

@implementation HotKindFirstViewController

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
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"热门分类"];
    self.navigationItem.titleView = top;
    
    
    
    [self pushAndPopStyle];
    
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductType",time];
    NSString *token = [DCFCustomExtra md5:string];
    
#pragma mark - 一级分类
    NSString *pushString = [NSString stringWithFormat:@"token=%@&type=%@",token,@"1"];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetProductTypeTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/getProductType.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];

}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLGetProductTypeTag)
    {
        NSLog(@"%@",dicRespon);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)commitbtn:(UIButton *)sender
{
    NSLog(@"monmit");
    UIButton *comBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, 300, 30)];
    
    comBtn.layer.cornerRadius = 5.0;
    //comBtn.layer.borderColor = [JLCTool lineColor].CGColor;
    comBtn.layer.borderWidth = 1;
    comBtn.layer.masksToBounds = YES;
 
    
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
