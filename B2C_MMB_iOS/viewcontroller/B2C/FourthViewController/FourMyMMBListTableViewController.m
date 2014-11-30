//
//  FourMyMMBListTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-17.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "FourMyMMBListTableViewController.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "FourthHostViewController.h"
#import "AccountManagerTableViewController.h"
#import "LoginNaviViewController.h"
#import "DCFCustomExtra.h"
#import "MyInquiryListFirstViewController.h"
#import "MyCableOrderHostViewController.h"
#import "LoginViewController.h"

@interface FourMyMMBListTableViewController ()
{
    NSMutableArray *headBtnArray;
    
    NSMutableArray *cellBtnArray;
    
    NSMutableArray *badgeArray;
    
    UIStoryboard *sb;
}
@end

@implementation FourMyMMBListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) headBtnClick:(UIButton *) sender
{
    int tag = sender.tag;
//    if (tag == 0)
//    {
//        [self setHidesBottomBarWhenPushed:YES];
//        MyInquiryListFirstViewController *myInquiryListFirstViewController = [sb instantiateViewControllerWithIdentifier:@"myInquiryListFirstViewController"];
//        [self.navigationController pushViewController:myInquiryListFirstViewController animated:YES];
//        [self setHidesBottomBarWhenPushed:NO];
//    }
    if(tag == 1)
    {
        [self setHidesBottomBarWhenPushed:YES];
        MyCableOrderHostViewController *myCableOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableOrderHostViewController"];
        myCableOrder.btnIndex = tag;
        [self.navigationController pushViewController:myCableOrder animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }
    if(tag == 2)
    {
        [self pushToOrderListViewControllerWithBtn:sender];
    }
    if(tag == 3)
    {
        [self setHidesBottomBarWhenPushed:YES];
        AccountManagerTableViewController *accountManagerTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"accountManagerTableViewController"];
        [self.navigationController pushViewController:accountManagerTableViewController animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
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
    if(badgeArray)
    {
        [badgeArray removeAllObjects];
        badgeArray = nil;
    }
}

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    if(memberid.length == 0 || [memberid isKindOfClass:[NSNull class]])
    {
    }
    return memberid;
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
//    NSLog(@"dicRespon = %@",dicRespon);
    if(URLTag == URLGetCountNumTag)
    {
        
        if(result == 1)
        {
            badgeArray = [[NSMutableArray alloc] initWithArray:[dicRespon objectForKey:@"items"]];
            NSLog(@"badge = %@",badgeArray);
            
            for(int i =0;i<badgeArray.count;i++)
            {
                UIButton *cellBtn = (UIButton *)[cellBtnArray objectAtIndex:i];
              
                NSString *s = [NSString stringWithFormat:@"%@",[badgeArray objectAtIndex:i]];
                //                if(s.intValue == 0)
                //                {
                //
                //                }
                //                else
                //                {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                if(s.intValue < 99 && s.intValue > 0)
                {
                    if (cellBtn.frame.size.width >= 153)
                    {
                        NSLog(@"1 = %d",cellBtn.titleLabel.text.length);
                        [btn setFrame:CGRectMake(cellBtn.frame.size.width-63, 13, 18, 18)];
                    }
                    else if (cellBtn.frame.size.width >= 100 && cellBtn.frame.size.width < 153)
                    {
                        NSLog(@"2= %d",cellBtn.titleLabel.text.length);
                        if (cellBtn.titleLabel.text.length == 5)
                        {
                            [btn setFrame:CGRectMake(cellBtn.frame.size.width-48, 13, 18, 18)];
                        }
                        else
                        {
                            [btn setFrame:CGRectMake(cellBtn.frame.size.width-38, 13, 18, 18)];
                        }
                    }
                    else if (cellBtn.frame.size.width >= 70 && cellBtn.frame.size.width < 100)
                    {
                        NSLog(@"3= %d",cellBtn.titleLabel.text.length);
                        [btn setFrame:CGRectMake(cellBtn.frame.size.width-22, 13, 18, 18)];
                    }
                    [btn setBackgroundImage:[UIImage imageNamed:@"msg_bq.png"] forState:UIControlStateNormal];
                    [btn setTitle:s forState:UIControlStateNormal];
                }
                else if (s.intValue >= 99)
                {
//                    [btn setFrame:CGRectMake(cellBtn.frame.size.width-22, 13, 24, 18)];
                    if (cellBtn.frame.size.width >= 153)
                    {
                        NSLog(@"1 = %d",cellBtn.titleLabel.text.length);
                        [btn setFrame:CGRectMake(cellBtn.frame.size.width-63, 13, 18, 18)];
                    }
                    else if (cellBtn.frame.size.width >= 100 && cellBtn.frame.size.width < 153)
                    {
                        NSLog(@"2= %d",cellBtn.titleLabel.text.length);
                        if (cellBtn.titleLabel.text.length == 5)
                        {
                            [btn setFrame:CGRectMake(cellBtn.frame.size.width-48, 13, 18, 18)];
                        }
                        else
                        {
                            [btn setFrame:CGRectMake(cellBtn.frame.size.width-38, 13, 18, 18)];
                        }
                    }
                    else if (cellBtn.frame.size.width >= 70 && cellBtn.frame.size.width < 100)
                    {
                        NSLog(@"3= %d",cellBtn.titleLabel.text.length);
                        [btn setFrame:CGRectMake(cellBtn.frame.size.width-22, 13, 18, 18)];
                    }

                    [btn setBackgroundImage:[UIImage imageNamed:@"msg_bqy.png"] forState:UIControlStateNormal];
                    [btn setTitle:@"99+" forState:UIControlStateNormal];
                }
                
                [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                
                if(s.intValue == 0)
                {
                    
                }
                else
                {
                    [cellBtn addSubview:btn];
                }
                //                    if(i == 0)
                //                    {
                //                        if(s.intValue < 99 && s.intValue > 0)
                //                        {
                //                            [btn setFrame:CGRectMake(self.btn_8.frame.size.width-5, self.btn_8.frame.origin.y-10, 20, 20)];
                //                        }
                //                        else
                //                        {
                //                            [btn setFrame:CGRectMake(self.btn_8.frame.size.width-5, self.btn_8.frame.origin.y-10, 40, 20)];
                //                        }
                //                        [self.btn_8 addSubview:btn];
                //                    }
                //                    if(i == 1)
                //                    {
                //                        if(s.intValue < 99 && s.intValue > 0)
                //                        {
                //                            [btn setFrame:CGRectMake(self.btn_11.frame.size.width-5, self.btn_11.frame.origin.y-10, 20, 20)];
                //
                //                        }
                //                        else
                //                        {
                //                            [btn setFrame:CGRectMake(self.btn_11.frame.size.width-5, self.btn_11.frame.origin.y-10, 40, 20)];
                //                        }
                //                        [self.btn_11 addSubview:btn];
                //                    }
                //                    if(i == 2)
                //                    {
                //                        if(s.intValue < 99 && s.intValue > 0)
                //                        {
                //                            [btn setFrame:CGRectMake(self.btn_10.frame.size.width-5, self.btn_10.frame.origin.y-10, 20, 20)];
                //
                //                        }
                //                        else
                //                        {
                //                            [btn setFrame:CGRectMake(self.btn_10.frame.size.width-5, self.btn_10.frame.origin.y-10, 40, 20)];
                //                        }
                //                        [self.btn_10 addSubview:btn];
                //                    }
                //                    if(i == 3)
                //                    {
                //                        if(s.intValue < 99 && s.intValue > 0)
                //                        {
                //                            [btn setFrame:CGRectMake(self.btn_9.frame.size.width-5, self.btn_9.frame.origin.y-10, 20, 20)];
                //
                //                        }
                //                        else
                //                        {
                //                            [btn setFrame:CGRectMake(self.btn_9.frame.size.width-5, self.btn_9.frame.origin.y-10, 40, 20)];
                //                        }
                //                        [self.btn_9 addSubview:btn];
                //                    }
                //                }
                
            }
        }
        else
        {
            
        }
        [self.tableView reloadData];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    NSString *memberid = [self getMemberId];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getCountNum",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@",memberid,token];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetCountNumTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getCountNum.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self pushAndPopStyle];
    
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"我的买卖宝"];
    self.navigationItem.titleView = top;
    
    headBtnArray = [[NSMutableArray alloc] init];
    for(int i=0;i<4;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(-1, 0, ScreenWidth+1, 45)];
        [btn setTag:i];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *label_1 = [[UILabel alloc] init];
        [label_1 setTextColor:[UIColor blackColor]];
        [label_1 setFont:[UIFont systemFontOfSize:15]];
        if(i <= 2)
        {
            [label_1 setFrame:CGRectMake(45, 5, 200, 35)];
        }
        else
        {
            [label_1 setFrame:CGRectMake(45, 5, 150, 35)];
        }
        [label_1 setTextAlignment:NSTextAlignmentLeft];
        
        UILabel *label_2 = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width-140, 5, 100, 35)];
        [label_2 setTextColor:[UIColor lightGrayColor]];
        [label_2 setFont:[UIFont systemFontOfSize:14]];
        [label_2 setTextAlignment:NSTextAlignmentRight];
        [label_2 setText:@"查看全部订单"];
        
        if(i == 0)
        {
            [label_1 setText:@"我的买卖宝询价单"];
//            [btn addSubview:label_2];
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 35, 35)];
            [iv setImage:[UIImage imageNamed:@"mmbOrder.png"]];
            [btn addSubview:iv];
        }
        if(i == 1)
        {
            [label_1 setText:@"我的电缆采购订单"];
            [btn addSubview:label_2];
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 35, 35)];
            [iv setImage:[UIImage imageNamed:@"dlOrder.png"]];
            [btn addSubview:iv];
        }
        if(i == 2)
        {
            [label_1 setText:@"我的家装馆订单"];
            [btn addSubview:label_2];
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 35, 35)];
            [iv setImage:[UIImage imageNamed:@"homeOrder.png"]];
            [btn addSubview:iv];
        }
        if(i == 3)
        {
            [label_1 setText:@"账户信息"];
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 35, 35)];
            [iv setImage:[UIImage imageNamed:@"count.png"]];
            [btn addSubview:iv];
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [btn addSubview:lineView];
        }
        //        if(i == 4)
        //        {
        //            [label_1 setText:@"收货地址"];
        //
        //            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 35, 35)];
        //            [iv setImage:[UIImage imageNamed:@"getAddress.png"]];
        //            [btn addSubview:iv];
        //        }
        [btn addSubview:label_1];
        if (i != 0)
        {
            UIImageView *arrowIv = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-40, 5, 35, 35)];
            [arrowIv setImage:[UIImage imageNamed:@"set_clear.png"]];
            [btn addSubview:arrowIv];
        }
        [headBtnArray addObject:btn];
    }
    
    cellBtnArray = [[NSMutableArray alloc] initWithObjects:_btn_8,_btn_9,_btn_10,_btn_11,_btn_2,_btn_3,_btn_5,_btn_6,_btn_7, nil];
    
    for(int i=0;i<cellBtnArray.count;i++)
    {
        UIButton *btn = (UIButton *)[cellBtnArray objectAtIndex:i];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 95;
    }
    return 45;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 95)];
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-50)/2, 10, 50, 50)];
        [iv setImage:[UIImage imageNamed:@"headPic.png"]];
        [view addSubview:iv];
        
        UIImageView *backView = [[UIImageView alloc] init];
        backView.frame = CGRectMake(0, 0, ScreenWidth, 95);
        backView.image = [UIImage imageNamed:@"headView.png"];
        [view insertSubview:backView belowSubview:iv];
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, 70, 200, 20)];
        if(userName.length == 0 || [userName isKindOfClass:[NSNull class]] || userName == NULL || userName == nil)
        {
            [label setText:@""];
        }
        else
        {
            [label setText:userName];
        }
        [label setFont:[UIFont boldSystemFontOfSize:16]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor blackColor]];
        [view addSubview:label];
        
        return view;
    }
    UIButton *btn = [headBtnArray objectAtIndex:section-1];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, 1)];
    [topView setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
    [btn addSubview:topView];
    
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height, btn.frame.size.width, 1)];
    [buttomView setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
    if(section != 4)
    {
        [btn addSubview:buttomView];
    }
    return btn;
}


- (IBAction)btn2Click:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    MyInquiryListFirstViewController *myInquiryListFirstViewController = [sb instantiateViewControllerWithIdentifier:@"myInquiryListFirstViewController"];
    [self.navigationController pushViewController:myInquiryListFirstViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}


- (IBAction)btn3Click:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    MyInquiryListFirstViewController *myInquiryListFirstViewController = [sb instantiateViewControllerWithIdentifier:@"myInquiryListFirstViewController"];
    [self.navigationController pushViewController:myInquiryListFirstViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void) pushToMyCableWithTag:(int) tag
{
    [self setHidesBottomBarWhenPushed:YES];
    MyCableOrderHostViewController *myCableOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableOrderHostViewController"];
    myCableOrder.btnIndex = tag;
    [self.navigationController pushViewController:myCableOrder animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (IBAction)btn5Click:(id)sender
{
    [self pushToMyCableWithTag:1];
}

- (IBAction)btn6Click:(id)sender
{
    [self pushToMyCableWithTag:2];
}

- (IBAction)btn7Click:(id)sender
{
    [self pushToMyCableWithTag:3];
}

- (IBAction)btn8Click:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    for(UIView *subview in btn.subviews)
    {
        if([subview isKindOfClass:[UIButton class]])
        {
            [subview removeFromSuperview];
        }
    }
    [self pushToOrderListViewControllerWithBtn:(UIButton *)sender];
}

- (IBAction)btn9Click:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    for(UIView *subview in btn.subviews)
    {
        if([subview isKindOfClass:[UIButton class]])
        {
            [subview removeFromSuperview];
        }
    }
    [self pushToOrderListViewControllerWithBtn:(UIButton *)sender];
}

- (IBAction)btn10Click:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    for(UIView *subview in btn.subviews)
    {
        if([subview isKindOfClass:[UIButton class]])
        {
            [subview removeFromSuperview];
        }
    }
    [self pushToOrderListViewControllerWithBtn:(UIButton *)sender];
}

- (IBAction)btn11Click:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    for(UIView *subview in btn.subviews)
    {
        if([subview isKindOfClass:[UIButton class]])
        {
            [subview removeFromSuperview];
        }
    }
    [self pushToOrderListViewControllerWithBtn:(UIButton *)sender];
}


- (void) pushToOrderListViewControllerWithBtn:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    NSString *text = btn.titleLabel.text;
    
    [self setHidesBottomBarWhenPushed:YES];
    FourthHostViewController *fourthHostViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fourthHostViewController"];
    fourthHostViewController.myStatus = text;
    [self.navigationController pushViewController:fourthHostViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


@end
