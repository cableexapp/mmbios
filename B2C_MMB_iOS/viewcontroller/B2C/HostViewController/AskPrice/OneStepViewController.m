//
//  OneStepViewController.m
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-18.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import "OneStepViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "SecondStepViewController.h"

@interface OneStepViewController ()
{
    NSArray *dataArray;
}
@end

@implementation OneStepViewController

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
    
    [self pushAndPopStyle];
    
    dataArray = [[NSArray alloc] initWithObjects:
                 @"电器装备电缆",
                 @"电力电缆",
                 @"通信、光缆",
                 @"裸线类",
                 @"绕组线",nil];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight) style:0];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [self.view addSubview:tv];
    [tv setShowsVerticalScrollIndicator:NO];
    
    
    [tv setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255 blue:242.0/255.0 alpha:1.0]];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 30)];
    [iv setImage:[UIImage imageNamed:@"askPrice.png"]];
    [headView addSubview:iv];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x + iv.frame.size.width, iv.frame.origin.y, 80, 30)];
    [label setText:@"询价单"];
    [label setTextAlignment:NSTextAlignmentLeft];
    [headView addSubview:label];
    
    UILabel *chooselabel = [[UILabel alloc] initWithFrame:CGRectMake((320-200)/2, 5, 200, 40)];
    [chooselabel setTextAlignment:NSTextAlignmentCenter];
    [chooselabel setText:@"一级分类选择"];
    [chooselabel setTextColor:MYCOLOR];
    [chooselabel setFont:[UIFont systemFontOfSize:15]];
    [headView addSubview:chooselabel];
    
    return headView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == dataArray.count)
    {
        return 171;
    }
    return 44;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count+1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255 blue:242.0/255.0 alpha:1.0]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if(indexPath.row == dataArray.count)
        {
            OneStepCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"OneStepCell" owner:self options:nil] lastObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.delegate = self;
            return cell;
        }
        else
        {
            UIView  *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
            [cellView setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255 blue:242.0/255.0 alpha:1.0]];
            [cell.contentView addSubview:cellView];

            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell.textLabel setText:[dataArray objectAtIndex:indexPath.row]];

        }
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondStepViewController *secondStep = [[SecondStepViewController alloc] initWithHeadTitle:[dataArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:secondStep animated:YES];
}

- (void) askDelegate
{
//    NSLog(@"咨询");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-828-0188"]];
}

- (void) onLineDelegate
{
//    NSLog(@"客服");
}

- (void) upDelegate
{
//    NSLog(@"下单");
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
