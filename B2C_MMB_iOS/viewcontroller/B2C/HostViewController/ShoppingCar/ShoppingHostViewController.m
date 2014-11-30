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
#import "SearchViewController.h"
#import "OneStepViewController.h"
#import "B2CHotSaleData.h"
#import "UIImageView+WebCache.h"

@interface ShoppingHostViewController ()
{
    UITextField *topTextField;
    
    NSMutableArray *contentArray;
    
    UIStoryboard *sb;
    
    NSArray *useArray;
    
    NSArray *picArray;
    
    NSMutableArray *dataArray;
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

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view tag] == 101 )
        {
            [view setHidden:YES];
        }
    }
}

#pragma mark - 查看热销商品
- (void) loadHotSale
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"HotSaleProduct",time];
    
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@",token];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/HotSaleProduct.html?"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLHotSaleProductTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLHotSaleProductTag)
    {
        NSLog(@"%@",dicRespon);
        NSMutableArray *moneyArray = nil;
        NSMutableArray *arr = nil;
        
        if([[dicRespon allKeys] copy] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            moneyArray = [[NSMutableArray alloc] init];
            contentArray = [[NSMutableArray alloc] init];
            arr = [[NSMutableArray alloc] init];
            
            dataArray = [[NSMutableArray alloc] init];
        }
        if([[dicRespon objectForKey:@"items"] count] == 0 || [[dicRespon objectForKey:@"items"] isKindOfClass:[NSNull class]])
        {
            moneyArray = [[NSMutableArray alloc] init];
            contentArray = [[NSMutableArray alloc] init];
            arr = [[NSMutableArray alloc] init];
            dataArray = [[NSMutableArray alloc] init];
        }
        if([[dicRespon objectForKey:@"items"] count] != 0 || ![[dicRespon objectForKey:@"items"] isKindOfClass:[NSNull class]])
        {
            moneyArray = [[NSMutableArray alloc] init];
            contentArray = [[NSMutableArray alloc] init];
            arr = [[NSMutableArray alloc] init];
            
            dataArray = [[NSMutableArray alloc] initWithArray:[B2CHotSaleData getListArray:[dicRespon objectForKey:@"items"]]];
            for(int i=0;i<dataArray.count;i++)
            {
                B2CHotSaleData *data = (B2CHotSaleData *)[dataArray objectAtIndex:i];
                [moneyArray addObject:data.productPrice];
                [contentArray addObject:data.productTitle];
                [arr addObject:data.p1Path];
            }
        }
        sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 260)];
        sv.backgroundColor = [UIColor clearColor];
        [sv setDelegate:self];
        for(int i = 0; i < arr.count; i++)
        {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10*(i+1) + 145*i-5, 10, 150, 220)];
            [view.layer setCornerRadius:3]; //设置矩圆角半径
            view.layer.borderWidth = 1.0f;
            view.layer.borderColor = [[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]CGColor];
            [view setBackgroundColor:[UIColor clearColor]];
            [sv addSubview:view];
            
            
            UIImageView *svImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*(i+1) + 145*i-2, 12, 145, 145)];
            NSURL *url = [NSURL URLWithString:[arr objectAtIndex:i]];
            [svImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cabel.png"]];
            [svImageView setTag:10+i];
            [svImageView setUserInteractionEnabled:YES];
            svImageView.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
            svImageView.layer.masksToBounds = YES;
            [sv addSubview:svImageView];
            
            
            UIView *lineView = [[UIView alloc]init];
            lineView.frame = CGRectMake(10*(i+1) + 145*i+5, 200, 120, 0.7);
            lineView.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
            [sv addSubview:lineView];
            
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [svImageView addGestureRecognizer:tap];
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//            CGSize size;
//            NSString *s = [contentArray objectAtIndex:i];
//            if([DCFCustomExtra validateString:s] == NO)
//            {
//                size = CGSizeMake(svImageView.frame.size.width, 0);
//            }
//            else
//            {
//                size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:[contentArray objectAtIndex:i] WithSize:CGSizeMake(svImageView.frame.size.width, MAXFLOAT)];//获取视图大小
//            }
            
            [contentLabel setFrame:CGRectMake(svImageView.frame.origin.x, svImageView.frame.origin.y + svImageView.frame.size.height, svImageView.frame.size.width, 35)];  //设置该cell的高度
            [contentLabel setFont:[UIFont systemFontOfSize:11]];
            [contentLabel setText:[contentArray objectAtIndex:i]];
            [contentLabel setBackgroundColor:[UIColor clearColor]];
            [contentLabel setTextAlignment:NSTextAlignmentLeft];  //文本对齐
            [contentLabel setNumberOfLines:0]; //文本换行
            [sv addSubview:contentLabel];
            
            UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y + contentLabel.frame.size.height+5, contentLabel.frame.size.width, 20)];
            [moneyLabel setTextAlignment:NSTextAlignmentLeft];
            [moneyLabel setBackgroundColor:[UIColor clearColor]];
            [moneyLabel setTextColor:[UIColor redColor]];
            [moneyLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [moneyLabel setText:[moneyArray objectAtIndex:i]];
            [sv addSubview:moneyLabel];
            
            [sv setFrame:CGRectMake(0, 0, ScreenWidth, moneyLabel.frame.origin.y + moneyLabel.frame.size.height + 5)];
        }
        [sv setContentSize:CGSizeMake(145*arr.count + 10*(arr.count+1), 180)];
        [sv setBounces:NO];
        [sv setShowsHorizontalScrollIndicator:NO];
        
        [tv reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self pushAndPopStyle];
    
    [self loadHotSale];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装馆频道"];
//    [top setTextColor:[UIColor colorWithRed:18.0/255.0 green:104.0/255.0 blue:253.0/255.0 alpha:1.0]];
    [top setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = top;
    
    topTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 34)];
    topTextField.layer.borderWidth = 0.3;
    topTextField.layer.cornerRadius = 5;
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
    picArray = [[NSArray alloc] initWithObjects:@"0.png",@"1.png",@"2.png",@"3.png",@"4.png",@"5.png",@"6.png",@"7.png",@"8.png", nil];
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, topTextField.frame.origin.y + topTextField.frame.size.height, 320, ScreenHeight - topTextField.frame.size.height+10)];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:tv];

    [self loadScrollview];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"shoppingCar.png"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"shoppingCar.png"] forState:UIControlStateHighlighted];
    [rightBtn setFrame:CGRectMake(0, 5, 37, 34)];
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

}

- (void) tap:(UITapGestureRecognizer *) sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *) sender;
    int tag = [[tap view] tag]-10;
    NSString *s = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:tag] myProductId]];
    [self setHidesBottomBarWhenPushed:YES];
//    GoodsDetailViewController *goodsDetail = [sb instantiateViewControllerWithIdentifier:@"goodsDetailViewController"];
    GoodsDetailViewController *goodsDetail = [[GoodsDetailViewController alloc] initWithProductId:s];
    [self.navigationController pushViewController:goodsDetail animated:YES];
//    [self setHidesBottomBarWhenPushed:NO];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == topTextField)
    {
        [topTextField resignFirstResponder];
    }
    
//    OneStepViewController *one = [[OneStepViewController alloc] init];
//    [self.navigationController pushViewController:one animated:YES];
    if (topTextField.text.length > 0)
    {
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.searchFlag = [NSString stringWithFormat:@"B2C+%@",topTextField.text];
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    
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
        if(!dataArray || dataArray.count == 0)
        {
            return nil;
        }
        [hotLabel setText:@"  热卖商品"];
 
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
    if(section == 0)
    {
        if(!dataArray || dataArray.count == 0)
        {
            return 0;
        }
    }
    return 30;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            if(!dataArray || dataArray.count == 0)
            {
                return 0;
            }
            else
            {
                if(sv)
                {
                    return sv.frame.size.height;
                }
            }
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
//        [cell.contentView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];

        
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
        [tableView setSeparatorStyle:0];
        for(int i = 0;i < 3;i++)
        {
            if(indexPath.row*3 + i < useArray.count)
            {
                UIView * view = [[UIView alloc] initWithFrame:CGRectMake(2+103*i+5, 10, 100, 45)];
                [view setBackgroundColor:[UIColor clearColor]];
                [cell.contentView addSubview:view];

                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 40, 40)];
                [iv setImage:[UIImage imageNamed:[picArray objectAtIndex:indexPath.row*3 + i]]];
                [view addSubview:iv];
          
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x + 44, iv.frame.origin.y-2.5,60, 45)];
                [label setText:[useArray objectAtIndex:indexPath.row*3 + i]];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setTextColor:[UIColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0]];
                [label setFont:[UIFont systemFontOfSize:13]];
                label.numberOfLines = 2;
//                label.textAlignment = 1; 
                [view addSubview:label];
                [view.layer setBorderWidth:1.0];   //边框宽度
                 view.layer.borderColor = [[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]CGColor];

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

@end
