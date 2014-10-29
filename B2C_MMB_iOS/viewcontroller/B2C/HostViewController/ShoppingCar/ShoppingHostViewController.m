//
//  ShoppingHostViewController.m
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-1.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import "ShoppingHostViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "MyShoppingListViewController.h"
#import "DCFCustomExtra.h"
#import "GoodsDetailViewController.h"
#import "B2CShoppingListViewController.h"


#import "OneStepViewController.h"

@interface ShoppingHostViewController ()
{
    UITextField *topTextField;
    
    NSArray *contentArray;
    
    UIStoryboard *sb;
    
    NSArray *useArray;
}
@end

@implementation ShoppingHostViewController

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
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view tag] == 101 )
        {
            [view setHidden:YES];
        }
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pushAndPopStyle];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装馆频道"];
    [top setTextColor:[UIColor colorWithRed:18.0/255.0 green:104.0/255.0 blue:253.0/255.0 alpha:1.0]];
    self.navigationItem.titleView = top;
    
    topTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 320, 34)];
    topTextField.layer.borderWidth = 1.0;
    topTextField.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
    topTextField.layer.masksToBounds = YES;
    [topTextField setBackgroundColor:[UIColor whiteColor]];
    [topTextField setFont:[UIFont systemFontOfSize:13]];
    [topTextField setDelegate:self];
    [topTextField setReturnKeyType:UIReturnKeyDone];
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 34)];
    [leftImageView setImage:[UIImage imageNamed:@"magnifying glass.png"]];
    [topTextField setLeftView:leftImageView];
    [topTextField setLeftViewMode:UITextFieldViewModeAlways];
    [topTextField setPlaceholder:@"搜索家装馆内电线型号、电线品牌等信息"];
    [self.view addSubview:topTextField];
    
    useArray = [[NSArray alloc] initWithObjects:@"照明用线",@"挂壁空调",@"热水器",@"插座用线",@"立式空调",@"进户主线",@"中央空调",@"装潢明线",@"电源连接线", nil];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, topTextField.frame.origin.y + topTextField.frame.size.height, 320, ScreenHeight - topTextField.frame.size.height-44-20)];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:tv];
    
    
    
    [self loadScrollview];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"shoppingCar.png"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"shoppingCar.png"] forState:UIControlStateHighlighted];
    [rightBtn setFrame:CGRectMake(0, 5, 34, 34)];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
}

- (void) rightBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    MyShoppingListViewController *shoppingList = [[MyShoppingListViewController alloc] initWithDataArray:nil];
    [self.navigationController pushViewController:shoppingList animated:YES];
//    [self setHidesBottomBarWhenPushed:NO];
}

- (void) loadScrollview
{
    NSArray *moneyArray = [[NSArray alloc] initWithObjects:@" ¥ 500.00",@" ¥ 500.00",@" ¥ 500.00",@" ¥ 500.00", nil];
    
    contentArray = [[NSArray alloc] initWithObjects:@"远东电缆zc-bv4平方国际铜芯阻燃电线100米",@"远东电缆zc-bv4平方国际铜芯阻燃电线100米远东电缆zc-bv4平方国际铜芯阻燃电",@"远东电缆zc-bv4平方国际铜芯阻燃电线100米",@"远东电缆zc-bv4平方国际铜芯阻燃电线100米远东电缆zc-bv4平方国际铜芯阻燃电", nil];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"cabel.png",@"cabel.png",@"cabel.png",@"cabel.png", nil];
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 230)];
    [sv setDelegate:self];
    for(int i = 0; i < arr.count; i++)
    {
        UIImageView *svImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*(i+1) + 145*i, 10, 145, 145)];
        [svImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[arr objectAtIndex:i]]]];
        [svImageView setTag:10+i];
        [svImageView setUserInteractionEnabled:YES];
        svImageView.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
        svImageView.layer.borderWidth = 1.0f;
        svImageView.layer.masksToBounds = YES;
        [sv addSubview:svImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [svImageView addGestureRecognizer:tap];
        
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:[contentArray objectAtIndex:i] WithSize:CGSizeMake(svImageView.frame.size.width, MAXFLOAT)];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [contentLabel setBackgroundColor:[UIColor purpleColor]];
        [contentLabel setFrame:CGRectMake(svImageView.frame.origin.x, svImageView.frame.origin.y + svImageView.frame.size.height, svImageView.frame.size.width, size.height)];
        [contentLabel setFont:[UIFont systemFontOfSize:12]];
        [contentLabel setText:[contentArray objectAtIndex:i]];
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        [contentLabel setTextAlignment:NSTextAlignmentLeft];
        [contentLabel setNumberOfLines:0];
        [sv addSubview:contentLabel];
        
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y + contentLabel.frame.size.height, contentLabel.frame.size.width, 20)];
        [moneyLabel setTextAlignment:NSTextAlignmentLeft];
        [moneyLabel setBackgroundColor:[UIColor clearColor]];
        [moneyLabel setTextColor:[UIColor redColor]];
        [moneyLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [moneyLabel setText:[moneyArray objectAtIndex:i]];
        [sv addSubview:moneyLabel];
        
        [sv setFrame:CGRectMake(0, 0, 320, moneyLabel.frame.origin.y + moneyLabel.frame.size.height + 5)];
    }
    [sv setContentSize:CGSizeMake(145*arr.count + 10*(arr.count+1), 180)];
    [sv setBounces:NO];
    [sv setShowsHorizontalScrollIndicator:NO];
    
    [tv reloadData];
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
//    GoodsDetailViewController *goodsDetail = [sb instantiateViewControllerWithIdentifier:@"goodsDetailViewController"];
    GoodsDetailViewController *goodsDetail = [[GoodsDetailViewController alloc] initWithProductId:@""];
    [self.navigationController pushViewController:goodsDetail animated:YES];
//    [self setHidesBottomBarWhenPushed:NO];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == topTextField)
    {
        [topTextField resignFirstResponder];
    }
    
    OneStepViewController *one = [[OneStepViewController alloc] init];
    [self.navigationController pushViewController:one animated:YES];
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.text.length != 0)
    {
        [textField setText:@""];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 320, 30)];

    if(section == 0)
    {
        [hotLabel setText:@"  热销商品"];
 
    }
    else if (section == 1)
    {
        [hotLabel setText:@"  家装线主题馆"];
    }
    [hotLabel setTextAlignment:NSTextAlignmentLeft];
    [hotLabel setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [hotLabel setFont:[UIFont boldSystemFontOfSize:14]];
    return hotLabel;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            if(sv)
            {
                return sv.frame.size.height;
            }
            return 0;
        }
    }

    
    return 50;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    [tableView setSeparatorColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
    //    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];

        
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT) {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        if(sv)
        {
            [cell.contentView addSubview:sv];
        }
    }
    else
    {
        for(int i = 0;i < 2;i++)
        {
            if(indexPath.row*2 + i < useArray.count)
            {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(1+160*i, 0, 159, 50)];
                [view setBackgroundColor:[UIColor whiteColor]];
                [cell.contentView addSubview:view];
                
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 35, 30)];
                [iv setImage:[UIImage imageNamed:@"sun.png"]];
                [view addSubview:iv];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x + iv.frame.size.width + 10, iv.frame.origin.y, 100, 30)];
                [label setText:[useArray objectAtIndex:indexPath.row*2 + i]];
                [label setTextColor:[UIColor blueColor]];
                [label setBackgroundColor:[UIColor clearColor]];
                [view addSubview:label];
                
                [view setTag:indexPath.row*2 + i];
                UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
                [view addGestureRecognizer:viewTap];
            }
       
        }
    }
    
    return cell;
}

- (void) viewTap:(UITapGestureRecognizer *) sender
{
    int tag = [[sender view] tag];

    UILabel *label = (UILabel *)[[[sender view] subviews] lastObject];
    NSString *str = nil;
    if(tag == 0)
    {
        str = @"照明";
    }
    if(tag == 3)
    {
        str = @"插座";
    }
    else if(tag != 0 && tag != 3)
    {
        str = label.text;
    }
    [self setHidesBottomBarWhenPushed:YES];
    B2CShoppingListViewController *shoppingList = [[B2CShoppingListViewController alloc] initWithUse:str];
    [self.navigationController pushViewController:shoppingList animated:YES];
//    [self setHidesBottomBarWhenPushed:NO];
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
