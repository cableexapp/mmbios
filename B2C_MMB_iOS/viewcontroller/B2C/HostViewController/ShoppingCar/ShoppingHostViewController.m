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
#import "AppDelegate.h"
#import "B2CSearchViewController.h"

@interface ShoppingHostViewController ()
{
    UITextField *topTextField;
    
    NSMutableArray *contentArray;
    
    UIStoryboard *sb;
    
    NSArray *useArray;
    
    NSArray *picArray;
    
    NSMutableArray *dataArray;
    
    UILabel *countLabel;
    
    AppDelegate *app;
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
    topTextField.text = nil;
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
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"购物车.png"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"购物车.png"] forState:UIControlStateHighlighted];
    [rightBtn setFrame:CGRectMake(0, 5, 34, 34)];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    countLabel = [[UILabel alloc] init];
    countLabel.frame = CGRectMake(22, 0, 18, 18);
    countLabel.layer.borderWidth = 1;
    countLabel.layer.cornerRadius = 10;
    countLabel.textColor = [UIColor whiteColor];
    countLabel.font = [UIFont systemFontOfSize:11];
    countLabel.textAlignment = 1;
    countLabel.hidden = YES;
    countLabel.layer.borderColor = [[UIColor clearColor] CGColor];
    countLabel.layer.backgroundColor = [[UIColor redColor] CGColor];
    [rightBtn addSubview:countLabel];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    [self loadShopCarCount];
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



#pragma mark - 获取购物车商品数量
-(void)loadShopCarCount
{
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getShoppingCartCount",time];
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
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLShopCarCountTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getShoppingCartCount.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLHotSaleProductTag)
    {        
        [[NSUserDefaults standardUserDefaults] setObject:[[[dicRespon objectForKey:@"items"] objectAtIndex:0] objectForKey:@"describe"] forKey:@"content"];
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
                [contentArray addObject:data.productName];
                [arr addObject:data.p1Path];
            }
        }
        sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 260)];
        sv.backgroundColor = [UIColor clearColor];
        [sv setDelegate:self];
        for(int i = 0; i < arr.count; i++)
        {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10*(i+1) + 145*i-5, 10, 150, 220)];
            view.layer.borderWidth = 0.5f;
            view.layer.borderColor = [[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0]CGColor];
            [sv addSubview:view];
            
            UIImageView *svImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*(i+1) + 145*i-2.5, 10.5, 145, 145)];
            NSURL *url = [NSURL URLWithString:[arr objectAtIndex:i]];
            [svImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cabel.png"]];
            [svImageView setTag:10+i];
            [svImageView setUserInteractionEnabled:YES];
            svImageView.layer.masksToBounds = YES;
            [sv addSubview:svImageView];
            
            UIView *lineView = [[UIView alloc]init];
            lineView.frame = CGRectMake(10*(i+1) + 145*i-5, 156, 150, 0.5);
            lineView.backgroundColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0];
            [sv addSubview:lineView];

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [svImageView addGestureRecognizer:tap];
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [contentLabel setFrame:CGRectMake(svImageView.frame.origin.x, svImageView.frame.origin.y + svImageView.frame.size.height+5, svImageView.frame.size.width, 40)];  //设置该cell的高度
            [contentLabel setFont:[UIFont systemFontOfSize:11]];
            [contentLabel setText:[contentArray objectAtIndex:i]];
            [contentLabel setTextAlignment:NSTextAlignmentLeft];  //文本对齐
            [contentLabel setNumberOfLines:0]; //文本换行
            [sv addSubview:contentLabel];
            
            UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y + contentLabel.frame.size.height+5, contentLabel.frame.size.width, 19.5)];
            [moneyLabel setTextAlignment:NSTextAlignmentLeft];
            [moneyLabel setTextColor:[UIColor redColor]];
            [moneyLabel setFont:[UIFont systemFontOfSize:13]];
            [moneyLabel setText:[NSString stringWithFormat:@"¥ %@",[moneyArray objectAtIndex:i]]];
            [sv addSubview:moneyLabel];
            
            [sv setFrame:CGRectMake(0, 0, ScreenWidth, moneyLabel.frame.origin.y + moneyLabel.frame.size.height + 5)];
        }
        [sv setContentSize:CGSizeMake(145*arr.count + 10*(arr.count+1), 180)];
        [sv setBounces:NO];
        [sv setShowsHorizontalScrollIndicator:NO];
        
        [tv reloadData];
    }
    if (URLTag == URLShopCarCountTag)
    {
        if ([[dicRespon objectForKey:@"total"] intValue] == 0)
        {
            countLabel.hidden = YES;
        }
        else if ([[dicRespon objectForKey:@"total"] intValue] >= 1 && [[dicRespon objectForKey:@"total"] intValue] < 99)
        {
            countLabel.hidden = NO;
            
            countLabel.text = [NSString stringWithFormat:@"%@", [dicRespon objectForKey:@"total"]];
        }
        else if ([[dicRespon objectForKey:@"total"] intValue] > 99)
        {
            countLabel.frame = CGRectMake(46, 2, 21, 19);
            countLabel.hidden = NO;
            countLabel.text = @"99+";
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self pushAndPopStyle];
    [self loadHotSale];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装馆电线频道"];
    [top setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = top;
    
    topTextField = [[UITextField alloc] initWithFrame:CGRectMake(10,10, ScreenWidth-20, 34)];
    topTextField.layer.cornerRadius = 5;
    topTextField.layer.masksToBounds = YES;
    [topTextField setBackgroundColor:[UIColor whiteColor]];
    [topTextField setFont:[UIFont systemFontOfSize:13]];
    [topTextField setDelegate:self];
    [topTextField setReturnKeyType:UIReturnKeyDone];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0,22.0)];//左端缩进
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,2,18, 18)];
    leftImageView.image = [UIImage imageNamed:@"search"];
    [view1 addSubview:leftImageView];
    topTextField.leftView = view1;
    topTextField.leftViewMode = UITextFieldViewModeAlways;
    [topTextField setPlaceholder:@"搜索家装馆内电线型号、电线品牌等"];
    [topTextField setReturnKeyType:UIReturnKeySearch];
    [self.view addSubview:topTextField];

    useArray = [[NSArray alloc] initWithObjects:@"照明",@"插座",@"热水器",@"挂壁空调",@"立式空调",@"中央空调",@"网络",@"电话",@"音/视频",@"电源连接线",@"进户主线",@"装潢明线", nil];
    
    picArray = [[NSArray alloc] initWithObjects:@"0.png",@"1.png",@"2.png",@"3.png",@"4.png",@"5.png",@"6.png",@"7.png",@"8.png",@"9.png",@"10.png",@"11", nil];
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, topTextField.frame.origin.y + topTextField.frame.size.height+5, ScreenWidth, ScreenHeight -78)];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:tv];

    [self loadScrollview];
}

- (void) rightBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    MyShoppingListViewController *shoppingList = [[MyShoppingListViewController alloc] initWithDataArray:nil];
    [self.navigationController pushViewController:shoppingList animated:YES];
//   [self setHidesBottomBarWhenPushed:NO];
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
    GoodsDetailViewController *goodsDetail = [[GoodsDetailViewController alloc] initWithProductId:s];
    [self.navigationController pushViewController:goodsDetail animated:YES];
//  [self setHidesBottomBarWhenPushed:NO];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == topTextField)
    {
        [topTextField resignFirstResponder];
    }
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.text.length != 0)
    {
        [textField setText:@""];
    }
    [textField resignFirstResponder];
    [self setHidesBottomBarWhenPushed:YES];
    B2CSearchViewController *B2CVC = [[B2CSearchViewController alloc] init];
//  B2CVC.tempSearchText = topTextField.text;
    [self.navigationController pushViewController:B2CVC animated:YES];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
        [hotLabel setText:@"  热销商品"];
    }
    else if (section == 1)
    {
        [hotLabel setText:@"  电线用途"];
    }
    [hotLabel setTextAlignment:NSTextAlignmentLeft];
    [hotLabel setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
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
                    return sv.frame.size.height+10;
                }
            }
        }
    }
    return 50;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    [tableView setSeparatorColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT)
    {
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
                [cell.contentView addSubview:view];

                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7.5, 30, 30)];
                [iv setImage:[UIImage imageNamed:[picArray objectAtIndex:indexPath.row*3 + i]]];
                [view addSubview:iv];
          
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x + 34,7.5,60, 30)];
                [label setText:[useArray objectAtIndex:indexPath.row*3 + i]];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont systemFontOfSize:12]];
                label.numberOfLines = 2;
                [view addSubview:label];
                [view.layer setBorderWidth:0.5];   //边框宽度
                 view.layer.borderColor = [[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0]CGColor];
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
    UILabel *label = (UILabel *)[[[sender view] subviews] lastObject];
    [self setHidesBottomBarWhenPushed:YES];
    B2CShoppingListViewController *shoppingList = [[B2CShoppingListViewController alloc] initWithUse:label.text];
    [self.navigationController pushViewController:shoppingList animated:YES];
//    [self setHidesBottomBarWhenPushed:NO];
}

@end
