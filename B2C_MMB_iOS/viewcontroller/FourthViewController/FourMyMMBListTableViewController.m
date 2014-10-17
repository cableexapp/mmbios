//
//  FourMyMMBListTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-17.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "FourMyMMBListTableViewController.h"
#import "MCDefine.h"

@interface FourMyMMBListTableViewController ()
{
    NSArray *headBtnArray;
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
    NSLog(@"tag = %d",sender.tag);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    headBtnArray = [[NSArray alloc] init];
    for(int i=0;i<5;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        btn.layer.borderColor = [UIColor colorWithRed:216.0/255.0 green:232.0/255.0 blue:249.0/255.0 alpha:1.0].CGColor;
        btn.layer.borderWidth = 1.0f;
        [btn setTag:i];
        [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label_1 = [[UILabel alloc] init];
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
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [headBtnArray objectAtIndex:section];
}

- (IBAction)btn1click:(id)sender {
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

- (IBAction)btn7Click:(id)sender {
}

- (IBAction)btn8Click:(id)sender {
}

- (IBAction)btn9Click:(id)sender {
}

- (IBAction)btn10Click:(id)sender {
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
