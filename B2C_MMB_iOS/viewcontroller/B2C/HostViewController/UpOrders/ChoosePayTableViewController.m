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

@interface ChoosePayTableViewController ()
{
    NSString *myTotal;
    NSString *myValue;
    NSString *myShopName;
    NSString *myProductTitle;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"选择支付方式"];
    self.navigationItem.titleView = top;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];

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
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 110;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 110)];
    [view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];

    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, 30, 30)];
    [iv setImage:[UIImage imageNamed:@"choose.png"]];
    [view addSubview:iv];
    
    UILabel *label_1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 250, 30)];
    [label_1 setText:@"您的订单已提交成功"];
    [label_1 setTextAlignment:NSTextAlignmentLeft];
    [label_1 setTextColor:MYCOLOR];
    [label_1 setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:label_1];
    
    UILabel *label_2 = [[UILabel alloc] initWithFrame:CGRectMake(60, label_1.frame.origin.y + label_1.frame.size.height, 250, 30)];
    [label_2 setText:[NSString stringWithFormat:@"订单号:%@",myValue]];
    [label_2 setTextAlignment:NSTextAlignmentLeft];
    [label_2 setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:label_2];
    
    UILabel *label_3 = [[UILabel alloc] initWithFrame:CGRectMake(60, label_2.frame.origin.y + label_2.frame.size.height, 250, 30)];
    NSString *s = [NSString stringWithFormat:@"订单金额:¥  %@",myTotal];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:s];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 8)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8, s.length-8)];
    [label_3 setAttributedText:str];
    [self.view addSubview:label_3];
    
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
    [cell.textLabel setText:@"支付宝支付"];
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
#pragma mark - 支付宝校验
    [self aliValidate:myValue With:myTotal];


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

            [self.navigationController pushViewController:ali animated:YES];
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
                
                [self.navigationController pushViewController:ali animated:YES];
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
