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

@interface FourMyMMBListTableViewController ()
{
    NSMutableArray *headBtnArray;
    
    NSMutableArray *cellBtnArray;
    
    NSMutableArray *badgeArray;
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
    NSLog(@"tag = %d",tag);
    
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
    
    if(memberid.length == 0)
    {
        LoginNaviViewController *loginNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
//    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLGetCountNumTag)
    {
        NSLog(@"%@",dicRespon);
        
        
        if(result == 1)
        {
            badgeArray = [[NSMutableArray alloc] initWithArray:[dicRespon objectForKey:@"items"]];
            
            for(int i =0;i<badgeArray.count;i++)
            {
                NSString *s = [NSString stringWithFormat:@"%@",[badgeArray objectAtIndex:i]];
                if(s.intValue == 0)
                {
                    
                }
                else
                {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    if(s.intValue < 99 && s.intValue > 0)
                    {
                        [btn setBackgroundImage:[UIImage imageNamed:@"msg_bq.png"] forState:UIControlStateNormal];
                        [btn setTitle:s forState:UIControlStateNormal];
                    }
                    else if (s.intValue >= 99)
                    {
                        [btn setBackgroundImage:[UIImage imageNamed:@"msg_bqy.png"] forState:UIControlStateNormal];
                        [btn setTitle:@"99+" forState:UIControlStateNormal];
                    }
                    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                    if(i == 0)
                    {
                        if(s.intValue < 99 && s.intValue > 0)
                        {
                            [btn setFrame:CGRectMake(self.btn_8.frame.size.width-5, self.btn_8.frame.origin.y-10, 20, 20)];
                        }
                        else
                        {
                            [btn setFrame:CGRectMake(self.btn_8.frame.size.width-5, self.btn_8.frame.origin.y-10, 40, 20)];
                        }
                        [self.btn_8 addSubview:btn];
                    }
                    if(i == 1)
                    {
                        if(s.intValue < 99 && s.intValue > 0)
                        {
                            [btn setFrame:CGRectMake(self.btn_11.frame.size.width-5, self.btn_11.frame.origin.y-10, 20, 20)];

                        }
                        else
                        {
                            [btn setFrame:CGRectMake(self.btn_11.frame.size.width-5, self.btn_11.frame.origin.y-10, 40, 20)];
                        }
                        [self.btn_11 addSubview:btn];
                    }
                    if(i == 2)
                    {
                        if(s.intValue < 99 && s.intValue > 0)
                        {
                            [btn setFrame:CGRectMake(self.btn_10.frame.size.width-5, self.btn_10.frame.origin.y-10, 20, 20)];

                        }
                        else
                        {
                            [btn setFrame:CGRectMake(self.btn_10.frame.size.width-5, self.btn_10.frame.origin.y-10, 40, 20)];
                        }
                        [self.btn_10 addSubview:btn];
                    }
                    if(i == 3)
                    {
                        if(s.intValue < 99 && s.intValue > 0)
                        {
                            [btn setFrame:CGRectMake(self.btn_9.frame.size.width-5, self.btn_9.frame.origin.y-10, 20, 20)];
                            
                        }
                        else
                        {
                            [btn setFrame:CGRectMake(self.btn_9.frame.size.width-5, self.btn_9.frame.origin.y-10, 40, 20)];
                        }
                        [self.btn_9 addSubview:btn];
                    }
                }
            
            }
        }
        else
        {
            
        }
    }
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    headBtnArray = [[NSMutableArray alloc] init];
    for(int i=0;i<5;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(-1, 0, ScreenWidth+1, 40)];
//        btn.layer.borderColor = [UIColor colorWithRed:216.0/255.0 green:232.0/255.0 blue:249.0/255.0 alpha:1.0].CGColor;
//        btn.layer.borderColor = [UIColor redColor].CGColor;
//        btn.layer.borderWidth = 1.0f;
//        btn.layer.masksToBounds = YES;
        [btn setTag:i];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:237.0/255.0 blue:253.0/255.0 alpha:1.0]];
        
        UILabel *label_1 = [[UILabel alloc] init];
        [label_1 setTextColor:[UIColor colorWithRed:44.0/255.0 green:122.0/255.0 blue:250.0/255.0 alpha:1.0]];
        if(i <= 2)
        {
            [label_1 setFrame:CGRectMake(10, 5, 200, 30)];
        }
        else
        {
            [label_1 setFrame:CGRectMake(50, 5, 150, 30)];
        }
        [label_1 setTextAlignment:NSTextAlignmentLeft];
        
        UILabel *label_2 = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width-140, 5, 100, 30)];
        [label_2 setTextColor:[UIColor colorWithRed:44.0/255.0 green:122.0/255.0 blue:250.0/255.0 alpha:1.0]];
        [label_2 setTextAlignment:NSTextAlignmentRight];
        [label_2 setText:@"查看全部"];

        if(i == 0)
        {
            [label_1 setText:@"我的买卖宝询价单"];
            [btn addSubview:label_2];
        }
        if(i == 1)
        {
            [label_1 setText:@"我的电缆采购订单"];
            [btn addSubview:label_2];
        }
        if(i == 2)
        {
            [label_1 setText:@"我的家装馆订单"];
            [btn addSubview:label_2];
        }
        if(i == 3)
        {
            [label_1 setText:@"账户信息"];
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
            [iv setImage:[UIImage imageNamed:@"Set.png"]];
            [btn addSubview:iv];
        }
        if(i == 4)
        {
            [label_1 setText:@"收货地址"];
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
            [iv setImage:[UIImage imageNamed:@"Set.png"]];
            [btn addSubview:iv];
        }
        [btn addSubview:label_1];
        
        UIImageView *arrowIv = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-40, 5, 30, 30)];
        [arrowIv setImage:[UIImage imageNamed:@"Set.png"]];
        [btn addSubview:arrowIv];
        
        [headBtnArray addObject:btn];
    }
    
    cellBtnArray = [[NSMutableArray alloc] initWithObjects:_btn_1,_btn_2,_btn_3,_btn_4,_btn_5,_btn_6,_btn_7,_btn_8,_btn_9,_btn_10,_btn_11, nil];
    
    for(int i=0;i<cellBtnArray.count;i++)
    {
        UIButton *btn = (UIButton *)[cellBtnArray objectAtIndex:i];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((btn.frame.size.width-30)/2, 5, 30, 20)];
        [imageView setImage:[UIImage imageNamed:@"Set.png"]];
        [btn addSubview:imageView];

    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 50;
    }
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [iv setImage:[UIImage imageNamed:@"Set.png"]];
        [view addSubview:iv];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-200)/2, 10, 200, 30)];
        [label setText:@"米奇米奇"];
        [label setFont:[UIFont boldSystemFontOfSize:20]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor colorWithRed:44.0/255.0 green:122.0/255.0 blue:250.0/255.0 alpha:1.0]];
        [view addSubview:label];
        
        return view;
    }
    UIButton *btn = [headBtnArray objectAtIndex:section-1];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, 1)];
    [topView setBackgroundColor:[UIColor colorWithRed:65.0/255.0 green:98.0/255.0 blue:127.0/255.0 alpha:1.0]];
    [btn addSubview:topView];
    
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height, btn.frame.size.width, 1)];
    [buttomView setBackgroundColor:[UIColor colorWithRed:65.0/255.0 green:98.0/255.0 blue:127.0/255.0 alpha:1.0]];
    if(section != 4)
    {
        [btn addSubview:buttomView];
    }
    return btn;
}

- (IBAction)btn1click:(id)sender
{
    
}

- (IBAction)btn2Click:(id)sender {
}


- (IBAction)btn3Click:(id)sender {
}

- (IBAction)btn4Click:(id)sender {
}

- (IBAction)btn5Click:(id)sender {
}

- (IBAction)btn6Click:(id)sender {
}

- (IBAction)btn7Click:(id)sender
{
    
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
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
