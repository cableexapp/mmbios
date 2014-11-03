//
//  B2BAskPriceCarViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-3.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2BAskPriceCarViewController.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFStringUtil.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "DCFChenMoreCell.h"
#import "AppDelegate.h"

@interface B2BAskPriceCarViewController ()
{
    UIView *buttomView;    //底部view
    UIButton *allChooseBtn;  //底部全选按钮
    UIButton *upBtn;   //底部提交按钮
    UIButton *backToHostBtn; //底部返回首页按钮
    
    AppDelegate *app;
    
    NSMutableArray *headBtnArray;
    NSMutableArray *headArrowArray;
    NSMutableArray *headLabelArray;
}
@end

@implementation B2BAskPriceCarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) rightBtnClick:(UIButton *) sender
{
    NSLog(@"删除");
}

- (void) allChooseBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
}

- (void) upBtnClick:(UIButton *) sender
{
    NSLog(@"上传");
}

- (void) backToHostBtnClick:(UIButton *) sender
{
    NSLog(@"回到首页");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"询价车"];
    self.navigationItem.titleView = top;
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"Set.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    if(!buttomView || !allChooseBtn || !upBtn || !backToHostBtn)
    {
        buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight-60-64, ScreenWidth, 60)];
        [self.view addSubview:buttomView];
        
        allChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [allChooseBtn setFrame:CGRectMake(20, 15, 30, 30)];
        [allChooseBtn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
        [allChooseBtn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
        [allChooseBtn addTarget:self action:@selector(allChooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttomView addSubview:allChooseBtn];
        
        upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [upBtn setTitle:@"提交" forState:UIControlStateNormal];
        [upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [upBtn setBackgroundColor:[UIColor blueColor]];
        [upBtn setFrame:CGRectMake(allChooseBtn.frame.origin.x + allChooseBtn.frame.size.width + 20, allChooseBtn.frame.origin.y, 100, 30)];
        [upBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttomView addSubview:upBtn];
        
        backToHostBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backToHostBtn setTitle:@"返回首页" forState:UIControlStateNormal];
        [backToHostBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [backToHostBtn setFrame:CGRectMake(ScreenWidth-120, allChooseBtn.frame.origin.y, 100, 30)];
        [backToHostBtn addTarget:self action:@selector(backToHostBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttomView addSubview:backToHostBtn];
    }
    
    if(!tv)
    {
        tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-buttomView.frame.size.height-64)];
        [tv setDataSource:self];
        [tv setDelegate:self];
        [tv setShowsHorizontalScrollIndicator:NO];
        [tv setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:tv];
    }
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"InquiryCartList",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    
    NSString *visitorid = [app getUdid];
    
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    NSString *pushString = nil;
    if(hasLogin == YES)
    {
        pushString = [NSString stringWithFormat:@"memberid=%@&token=%@",memberid,token];
    }
    else
    {
        pushString = [NSString stringWithFormat:@"visitorid=%@&token=%@",visitorid,token];
    }

    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLInquiryCartListTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/InquiryCartList.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];

}

- (void) headBtnClick:(UIButton *) sender
{
    NSLog(@"headBtnClick");
    
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
}

- (void) headArrowBtnClick:(UIButton *) sender
{
    NSLog(@"headArrowBtnClick");
    
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLInquiryCartListTag)
    {
        NSLog(@"%@",dicRespon);
        NSLog(@"msg = %@",msg);
        
        headBtnArray = [[NSMutableArray alloc] init];
        headArrowArray = [[NSMutableArray alloc] init];
        headLabelArray = [[NSMutableArray alloc] init];

        UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [headBtn setFrame:CGRectMake(10, 20, 20, 20)];
        [headBtn setBackgroundImage:[UIImage imageNamed:@"Set.png"] forState:UIControlStateNormal];
        [headBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headBtn setTag:0];
        [headBtnArray addObject:headBtn];
        
        UIButton *headArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [headArrowBtn setFrame:CGRectMake(ScreenWidth-30, 20, 20, 20)];
        [headArrowBtn setBackgroundImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
        [headArrowBtn addTarget:self action:@selector(headArrowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headArrowBtn setTag:10];
        [headArrowArray addObject:headArrowBtn];

        NSMutableArray *array = [[NSMutableArray alloc] init];
        UILabel *headModelLabel = [[UILabel alloc] initWithFrame:CGRectMake(headBtn.frame.origin.x + headBtn.frame.size.width+5, 5, ScreenWidth-70, 25)];
        [headModelLabel setText:@"型号: 远东电缆bv线远东电缆bv线远东电缆bv线"];
        [headModelLabel setFont:[UIFont systemFontOfSize:12]];
        [array addObject:headModelLabel];
        
        UILabel *headKindLabel = [[UILabel alloc] initWithFrame:CGRectMake(headBtn.frame.origin.x + headBtn.frame.size.width+5, headModelLabel.frame.origin.y + headModelLabel.frame.size.height, ScreenWidth-80, 25)];
        [headKindLabel setText:@"型号: 电力装备电缆 布电线 B系列"];
        [headKindLabel setFont:[UIFont systemFontOfSize:11]];
        [array addObject:headKindLabel];
        
        [headLabelArray addObject:array];
        
        [tv reloadData];
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    [view setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1.0]];
    
    UIButton *headBtn = [headBtnArray objectAtIndex:section];
    [view addSubview:headBtn];

    UIButton *headArrowBtn = [headArrowArray objectAtIndex:section];
    [view addSubview:headArrowBtn];
    
    for(UIView *subView in [headLabelArray objectAtIndex:section])
    {
        [view addSubview:subView];
    }
    
    return view;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    {
        [(UIView *) CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"cell%d",indexPath.row]];
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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
