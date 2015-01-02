//
//  ChoosePayTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-26.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "ChoosePayTableViewController.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "AliViewController.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"
#import "MyShoppingListViewController.h"
#import "B2CShoppingListViewController.h"
#import "ShoppingHostViewController.h"

@interface ChoosePayTableViewController ()
{
    NSString *myTotal;
    NSString *myValue;
    NSString *myShopName;
    NSString *myProductTitle;
    
    UIView *cellBackView;
    
    UIButton *payBtn;
}
@end

@implementation ChoosePayTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithTotal:(NSString *) total WithValue:(NSString *) value WithShopName:(NSString *) shopName WithProductTitle:(NSString *) productTitle
{
    if(self = [super init])
    {
        myTotal = [NSString stringWithFormat:@"%@",total];
        myValue = [NSString stringWithFormat:@"%@",value];
        myShopName = [NSString stringWithFormat:@"%@",shopName];
        myProductTitle = [NSString stringWithFormat:@"%@",productTitle];
    }
    return self;
}

- (void) back:(id) sender
{
    //  跳转到首页
    NSLog(@"%@",self.navigationController.viewControllers);
    for(UIViewController *vc in self.navigationController.viewControllers)
    {
        if([vc isKindOfClass:[MyShoppingListViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        else if([vc isKindOfClass:[B2CShoppingListViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        else if ([vc isKindOfClass:[ShoppingHostViewController class]])
        {
            [self.navigationController popToViewController:vc
                                                  animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //    [self pushAndPopStyle];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 15, 22)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"选择支付方式"];
    self.navigationItem.titleView = top;
    
    cellBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 110)];
    cellBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cellBackView.layer.borderWidth = 1.0f;
    cellBackView.layer.cornerRadius = 5;
    
    UILabel *chooseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellBackView.frame.size.width, 40)];
    [chooseLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [chooseLabel setText:@" 选择支付方式"];
    [cellBackView addSubview:chooseLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, chooseLabel.frame.origin.y+chooseLabel.frame.size.height, cellBackView.frame.size.width, 1)];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [cellBackView addSubview:lineView];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, lineView.frame.origin.y+10, 50, 50)];
    [iv setImage:[UIImage imageNamed:@"choosePayMent.png"]];
    [cellBackView addSubview:iv];
    
    UILabel *label_1 = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x+iv.frame.size.width+10, iv.frame.origin.y, 150, 25)];
    [label_1 setText:@"支付宝快捷支付"];
    [label_1 setFont:[UIFont systemFontOfSize:14]];
    [cellBackView addSubview:label_1];
    
    UILabel *label_2 = [[UILabel alloc] initWithFrame:CGRectMake(label_1.frame.origin.x, label_1.frame.origin.y+label_1.frame.size.height, 200, 30)];
    [label_2 setFont:[UIFont systemFontOfSize:13]];
    [label_2 setText:@"无需跳转客户端,快捷支付!"];
    [label_2 setTextColor:[UIColor colorWithRed:32.0/255.0 green:82.0/255.0 blue:134.0/255.0 alpha:1.0]];
    [cellBackView addSubview:label_2];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [selectBtn setFrame:CGRectMake(cellBackView.frame.size.width-50, label_1.frame.origin.y+10, 30, 30)];
    [cellBackView addSubview:selectBtn];
    
    payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn setTitle:@"在线支付" forState:UIControlStateNormal];
    payBtn.layer.cornerRadius = 5;
    [payBtn setBackgroundColor:[UIColor colorWithRed:9/255.0 green:99/255.0 blue:189/255.0 alpha:1.0]];
    [payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [payBtn setFrame:CGRectMake(20, 10, ScreenWidth-40, 40)];
}

- (void) payBtnClick:(UIButton *) sender
{
#pragma mark - 支付宝校验
    [self aliValidate:myValue With:myTotal];
}

- (void) selectBtnClick:(UIButton *) sender
{
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 130;
    }
    return 60;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 110;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 110)];
    [view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, 30, 30)];
    [iv setImage:[UIImage imageNamed:@"complete.png"]];
    [view addSubview:iv];
    
    UILabel *label_2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 250, 30)];
    [label_2 setText:[NSString stringWithFormat:@"订单号:%@",myValue]];
    [label_2 setTextAlignment:NSTextAlignmentLeft];
    [label_2 setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:label_2];
    
    UILabel *label_1 = [[UILabel alloc] initWithFrame:CGRectMake(60, label_2.frame.origin.y+label_2.frame.size.height, 250, 30)];
    [label_1 setText:@"您的订单已提交成功"];
    [label_1 setTextAlignment:NSTextAlignmentLeft];
    [label_1 setTextColor:MYCOLOR];
    [label_1 setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:label_1];
    
    
    
    UILabel *label_3 = [[UILabel alloc] initWithFrame:CGRectMake(60, label_1.frame.origin.y + label_1.frame.size.height, 250, 30)];
    NSString *s = [NSString stringWithFormat:@"订单金额:¥ %@",myTotal];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:s];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 8)];
    label_3.font = [UIFont systemFontOfSize:15];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8, s.length-8)];
    [label_3 setAttributedText:str];
    [view addSubview:label_3];
    
    return view;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:0];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    
    if(indexPath.row == 0)
    {
        [cell.contentView addSubview:cellBackView];
    }
    if(indexPath.row == 1)
    {
        [cell.contentView addSubview:payBtn];
    }
    return cell;
}

- (void) aliValidate:(NSString *) order With:(NSString *) price
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"OrderConfirm",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&ordernum=%@&total=%@",token,order,price];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLOrderConfirmTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/OrderConfirm.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}


- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if(URLTag == URLOrderConfirmTag)
    {
        [DCFStringUtil showNotice:msg];
        
        if(result == 1)
        {
            [self setHidesBottomBarWhenPushed:YES];
            AliViewController *ali = [[AliViewController alloc] initWithNibName:@"AliViewController" bundle:nil];
            
            ali.shopName = @"家装馆产品";
            ali.productName = myProductTitle;
            ali.productPrice = myTotal;
            ali.productOrderNum = myValue;
            
            [ali testPay];
            
            //            [self.navigationController pushViewController:ali animated:YES];
        }
        else
        {
            if(result == 2)
            {
                return;
            }
            if(result == 3)
            {
                [self setHidesBottomBarWhenPushed:YES];
                
                AliViewController *ali = [[AliViewController alloc] initWithNibName:@"AliViewController" bundle:nil];
                
                ali.shopName = myShopName;
                ali.productName = myProductTitle;
                ali.productPrice = myTotal;
                ali.productOrderNum = myValue;
                
                [ali testPay];
                
                //                [self.navigationController pushViewController:ali animated:YES];
            }
            
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
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
