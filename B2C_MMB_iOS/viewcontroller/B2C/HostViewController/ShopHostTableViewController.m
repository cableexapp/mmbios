//
//  ShopHostTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-26.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "ShopHostTableViewController.h"
#import "ShopHostPreTableViewController.h"
#import "DCFTopLabel.h"
#import "DCFConnectionUtil.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "UIImageView+WebCache.h"
#import "DCFCustomExtra.h"
#import "B2CGoodsListData.h"
#import "DCFCustomExtra.h"
#import "GoodsDetailViewController.h"
#import "DCFStringUtil.h"
#import "AppDelegate.h"
#import "MyShoppingListViewController.h"

@interface ShopHostTableViewController ()
{
    NSMutableArray *dataArray;
    
    DCFChenMoreCell *moreCell;
    int intPage; //页数
    int intTotal; //总数
    int pageSize; //每页条数
    
    BOOL _reloading;
    
    NSArray *scoreArray;
    NSMutableArray *discussArray;
    UIView * shadowView;
    
    NSArray *typeArray;
    
    ShopHostPreTableViewController *preVC;
    
    UIButton *rightBtn;
    UIBarButtonItem *right;
    UILabel *countLabel;
    AppDelegate *app;
    MyShoppingListViewController *shop;
    
    UIView *headView;
}
@end

@implementation ShopHostTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithHeadTitle:(NSString *) title WithShopId:(NSString *) shopId WithUse:(NSString *) use
{
    if(self = [super init])
    {
        _myTitle = title;
        _shopId = shopId;
        
        shopUse = use;
    }
    return self;
}

// 返回时调用此方法
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
    if(moreCell)
    {
        [moreCell stopAnimation];
    }
    
    //   点击调转控制器事件
    [shadowView setHidden:YES];
    if(preVC)
    {
        [preVC.view removeFromSuperview];
        preVC.view = nil;
        
        [preVC removeFromParentViewController];
        preVC = nil;
    }
    if(preView)
    {
        [preView removeFromSuperview];
        preView = nil;
    }
    if(right)
    {
        right = nil;
    }
    if(rightBtn)
    {
        [rightBtn removeFromSuperview];
        rightBtn = nil;
    }
    if(countLabel)
    {
        [countLabel removeFromSuperview];
        countLabel = nil;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    if(!rightBtn)
//    {
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"购物车"] forState:UIControlStateNormal];
        [rightBtn setFrame:CGRectMake(0, 0, 34,34)];
        [rightBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
//    if(!right)
//    {
        right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    }
    
//    if(!countLabel)
//    {
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
//    }
    
    self.navigationItem.rightBarButtonItem = right;
    
    [self loadShopCarCount];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装馆频道"];
    self.navigationItem.titleView = top;
    intPage = 1;
    dataArray = [[NSMutableArray alloc] init];
    //ADD REFRESH VIEW
    _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -300, 320, 300)];
    [self.refreshView setDelegate:self];
    [self.tableView addSubview:self.refreshView];
    [self.refreshView refreshLastUpdatedDate];
    [self loadRequest:_shopId WithUse:shopUse];
    

    
}

- (void)rightItemClick:(id) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    shop = [[MyShoppingListViewController alloc] initWithDataArray:nil];
    [self.navigationController pushViewController:shop animated:YES];
}

//获取购物车商品数量
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    if([NSStringFromClass([touch.view class]) isEqualToString:@"DCFNavigationBar"])
    {
        [self preViewTap];
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    //    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITabBarButton"])
    //    {
    //        return NO;
    //    }
    return  YES;
}

//   点击调转控制器事件
- (void) preViewTap
{
    [shadowView setHidden:YES];
    if(preVC)
    {
        [preVC.view removeFromSuperview];
        preVC.view = nil;
        
        [preVC removeFromParentViewController];
        preVC = nil;
    }
    if(preView)
    {
        [preView removeFromSuperview];
        preView = nil;
    }
}

- (void) loadRequest:(NSString *) shopId WithUse:(NSString *) use
{
    //    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    [HUD setDelegate:self];
    //    [HUD setLabelText:@"正在登陆....."];
    
    pageSize = 10;
    //    intPage = 1;
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductList",time];
    
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"use=%@&seq=%@&model=%@&brand=%@&shopid=%@&token=%@&pagesize=%d&pageindex=%d",use,@"",@"",@"",_shopId,token,pageSize,intPage];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getProductList.html?"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2CGoodsListTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.row == 0)
    {
        if(!discussArray || discussArray.count == 0)
        {
            return 0;
        }
        return 170;
    }
    
    //    if(dataArray.count == 0)
    //    {
    //        return 43;
    //    }
    int row = dataArray.count%2 + dataArray.count/2;
    
    if(indexPath.row == row+1)
    {
        return 43;
    }
    
    
    //    if(indexPath.row <= row - 1)
    if(indexPath.row >= 1 && indexPath.row < row + 1)
    {
        return 200;
        //        for(int i=0;i<2;i++)
        //        {
        //            int n = (indexPath.row-1)*2 + i;
        //            if(n <= dataArray.count-1)
        //            {
        //                NSString *str_1 = [[dataArray objectAtIndex:n] productName];
        //                CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str_1 WithSize:CGSizeMake(125, MAXFLOAT)];
        //                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, 125, size_1.height)];
        //                [nameLabel setText:str_1];
        //                [nameLabel setFont:[UIFont systemFontOfSize:12]];
        //                [nameLabel setNumberOfLines:0];
        //
        //                NSString *str_2 = [[dataArray objectAtIndex:n] productPrice];
        //                CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:str_2 WithSize:CGSizeMake(125, MAXFLOAT)];
        //                UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.frame.origin.y+nameLabel.frame.size.height+10, 125, size_2.height)];
        //                [priceLabel setText:str_2];
        //                [priceLabel setFont:[UIFont systemFontOfSize:13]];
        //
        //                return 125+size_1.height+size_2.height+5+20;
        //            }
        //        }
    }
    return 43;
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    
    if(URLTag == URLB2CGoodsListTag)
    {
        if(_reloading == YES)
        {
            [self doneLoadingViewData];
        }
        else if(_reloading == NO)
        {
            
        }
        if([[dicRespon allKeys] count] == 0)
        {
            [moreCell noDataAnimation];
        }
        else
        {
            if(result == 1)
            {
                
                if(intPage == 1)
                {
                    [dataArray removeAllObjects];
                }
                [dataArray addObjectsFromArray:[B2CGoodsListData getListArray:[dicRespon objectForKey:@"items"]]];
                
                scoreArray = [[NSArray alloc] initWithArray:[dicRespon objectForKey:@"score"]];
                
                [self loadHeadView];
                
                intTotal = [[dicRespon objectForKey:@"total"] intValue];
                if(intTotal == 0)
                {
                    [moreCell noDataAnimation];
                }
                else
                {
                    [moreCell stopAnimation];
                }
                intPage++;
                
                NSString *time = [DCFCustomExtra getFirstRunTime];
                
                NSString *string = [NSString stringWithFormat:@"%@%@",@"getShopProductType",time];
                
                NSString *token = [DCFCustomExtra md5:string];
                
                NSString *pushString = [NSString stringWithFormat:@"token=%@&shopid=%@",token,_shopId];
                
                NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getShopProductType.html?"];
                
                conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2CGetShopProductTypeTag delegate:self];
                [conn getResultFromUrlString:urlString postBody:pushString method:POST];
            }
            else
            {
                [moreCell failAcimation];
            }
        }
        
        [self.tableView reloadData];
        
    }
    if(URLTag == URLB2CGetShopProductTypeTag)
    {
        
        if(result == 1)
        {
            typeArray = [[NSArray alloc] initWithArray:[dicRespon objectForKey:@"types"]];
        }
        else
        {
            
        }
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

- (void) loadHeadView
{
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    [headView setUserInteractionEnabled:YES];
//    [cell.contentView addSubview:headView];
    
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, ScreenWidth, 10)];
    [sepView setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
    [headView addSubview:sepView];
    
    UIView *sepView_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, 1)];
    [sepView_1 setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
    [headView addSubview:sepView_1];
    
    UIView *sepView_2 = [[UIView alloc] initWithFrame:CGRectMake(230, 10, 1, 40)];
    [sepView_2 setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
    [headView addSubview:sepView_2];
    
    UIView *sepView_3 = [[UIView alloc] initWithFrame:CGRectMake(80, 70, 1, 40)];
    [sepView_3 setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
    [headView addSubview:sepView_3];
    UIView *sepView_4 = [[UIView alloc] initWithFrame:CGRectMake(160, 70, 1, 40)];
    [sepView_4 setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
    [headView addSubview:sepView_4];
    UIView *sepView_5 = [[UIView alloc] initWithFrame:CGRectMake(240, 70, 1, 40)];
    [sepView_5 setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
    [headView addSubview:sepView_5];
    
    
    
    
    UILabel *scoreLabel =[[UILabel alloc] initWithFrame:CGRectMake(245, 0, 80, 30)];
    [scoreLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [scoreLabel setText:@"综合评分"];
    [scoreLabel setTextColor:[UIColor grayColor]];
    [headView addSubview:scoreLabel];
    
    UILabel *scoreLabel_1 =[[UILabel alloc] initWithFrame:CGRectMake(247, 22, 50, 30)];
    [scoreLabel_1 setFont:[UIFont boldSystemFontOfSize:15]];
    //    取scoreArray里的前4位元素
    discussArray = [[NSMutableArray alloc] init];
    if(scoreArray.count != 0)
    {
        for(int i=0;i<4;i++)
        {
            [discussArray addObject:[scoreArray objectAtIndex:i]];
        }
    }
    float avg = [[discussArray valueForKeyPath:@"@avg.floatValue"] floatValue]; //取平均数
    [scoreLabel_1 setText:[DCFCustomExtra notRounding:avg afterPoint:1 WithBackIndex:1]];
    [scoreLabel_1 setTextColor:[UIColor colorWithRed:251.0/255.0 green:61.0/255.0 blue:9.0/255.0 alpha:1.0]];
    [headView addSubview:scoreLabel_1];
    UIButton *scoreLabel_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [scoreLabel_2 setFrame:CGRectMake(ScreenWidth-40, 25, 25, 25)];
    [scoreLabel_2 setBackgroundColor:[UIColor orangeColor]];
    [scoreLabel_2 setTitle:@"高" forState:UIControlStateNormal];
    [scoreLabel_2.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [scoreLabel_2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scoreLabel_2.layer setCornerRadius:5.0]; //设置矩圆角半径
    [headView addSubview:scoreLabel_2];
    
    UILabel *describeLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 60, 80, 30)];
    [describeLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [describeLabel setText:@"描述相符"];
    [describeLabel setTextColor:[UIColor grayColor]];
    [headView addSubview:describeLabel];
    UILabel *describeLabel_1 =[[UILabel alloc] initWithFrame:CGRectMake(15, 82, 30, 30)];
    [describeLabel_1 setFont:[UIFont boldSystemFontOfSize:15]];
    //    [describeLabel_1 setText:@"5.0"];
    [describeLabel_1 setText:[scoreArray objectAtIndex:0]];//取出数组里面第0个元素
    [describeLabel_1 setTextColor:[UIColor colorWithRed:251.0/255.0 green:61.0/255.0 blue:9.0/255.0 alpha:1.0]];
    [headView addSubview:describeLabel_1];
    UIButton *describeLabel_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [describeLabel_2 setFrame:CGRectMake(40, 85, 25, 25)];
    [describeLabel_2 setBackgroundColor:[UIColor orangeColor]];
    [describeLabel_2 setTitle:@"高" forState:UIControlStateNormal];
    [describeLabel_2.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [describeLabel_2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [describeLabel_2.layer setCornerRadius:5.0]; //设置矩圆角半径
    [headView addSubview:describeLabel_2];
    
    UILabel *serviceLabel =[[UILabel alloc] initWithFrame:CGRectMake(90, 60, 80, 30)];
    [serviceLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [serviceLabel setText:@"服务态度"];
    [serviceLabel setTextColor:[UIColor grayColor]];
    [headView addSubview:serviceLabel];
    UILabel *serviceLabel_1 =[[UILabel alloc] initWithFrame:CGRectMake(95, 82, 30, 30)];
    [serviceLabel_1 setFont:[UIFont boldSystemFontOfSize:15]];
    //   [serviceLabel_1 setText:@"5.0"];
    [serviceLabel_1 setText:[scoreArray objectAtIndex:1]];//取出数组里面第1个元素
    [serviceLabel_1 setTextColor:[UIColor colorWithRed:251.0/255.0 green:61.0/255.0 blue:9.0/255.0 alpha:1.0]];
    [headView addSubview:serviceLabel_1];
    UIButton *serviceLabel_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [serviceLabel_2 setFrame:CGRectMake(120, 85, 25, 25)];
    [serviceLabel_2 setBackgroundColor:[UIColor orangeColor]];
    [serviceLabel_2 setTitle:@"高" forState:UIControlStateNormal];
    [serviceLabel_2.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [serviceLabel_2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [serviceLabel_2.layer setCornerRadius:5.0]; //设置矩圆角半径
    [headView addSubview:serviceLabel_2];
    
    UILabel *deliveryLabel =[[UILabel alloc] initWithFrame:CGRectMake(170, 60, 80, 30)];
    [deliveryLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [deliveryLabel setText:@"发货速度"];
    [deliveryLabel setTextColor:[UIColor grayColor]];
    [headView addSubview:deliveryLabel];
    UILabel *deliveryLabel_1 =[[UILabel alloc] initWithFrame:CGRectMake(175, 82, 30, 30)];
    [deliveryLabel_1 setFont:[UIFont boldSystemFontOfSize:15]];
    //    [deliveryLabel_1 setText:@"5.0"];
    [deliveryLabel_1 setText:[scoreArray objectAtIndex:2]];//取出数组里面第2个元素
    [deliveryLabel_1 setTextColor:[UIColor colorWithRed:251.0/255.0 green:61.0/255.0 blue:9.0/255.0 alpha:1.0]];
    [headView addSubview:deliveryLabel_1];
    UIButton *deliveryLabel_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [deliveryLabel_2 setFrame:CGRectMake(200, 85, 25, 25)];
    [deliveryLabel_2 setBackgroundColor:[UIColor orangeColor]];
    [deliveryLabel_2 setTitle:@"高" forState:UIControlStateNormal];
    [deliveryLabel_2.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [deliveryLabel_2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deliveryLabel_2.layer setCornerRadius:5.0]; //设置矩圆角半径
    [headView addSubview:deliveryLabel_2];
    
    UILabel *qualityLabel =[[UILabel alloc] initWithFrame:CGRectMake(250, 60, 80, 30)];
    [qualityLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [qualityLabel setText:@"商品质量"];
    [qualityLabel setTextColor:[UIColor grayColor]];
    [headView addSubview:qualityLabel];
    UILabel *qualityLabel_1 =[[UILabel alloc] initWithFrame:CGRectMake(255, 82, 30, 30)];
    [qualityLabel_1 setFont:[UIFont boldSystemFontOfSize:15]];
    //    [qualityLabel_1 setText:@"5.0"];
    [qualityLabel_1 setText:[scoreArray objectAtIndex:3]];//取出数组里面第3个元素
    [qualityLabel_1 setTextColor:[UIColor colorWithRed:251.0/255.0 green:61.0/255.0 blue:9.0/255.0 alpha:1.0]];
    [headView addSubview:qualityLabel_1];
    UIButton *qualityLabel_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [qualityLabel_2 setFrame:CGRectMake(280, 85, 25, 25)];
    [qualityLabel_2 setBackgroundColor:[UIColor orangeColor]];
    [qualityLabel_2 setTitle:@"高" forState:UIControlStateNormal];
    [qualityLabel_2.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [qualityLabel_2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qualityLabel_2.layer setCornerRadius:5.0]; //设置矩圆角半径
    [headView addSubview:qualityLabel_2];
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 250, 30)];
    [headLabel setText:[NSString stringWithFormat:@"%@",_myTitle]];
    [headLabel setTextColor:[UIColor blackColor]];
    [headLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [headView addSubview:headLabel];
    UILabel *headLabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(8, 25, 250, 30)];
    [headLabel_1 setText:[NSString stringWithFormat:@"(公司：%@)",_myTitle]];
    [headLabel_1 setTextColor:[UIColor grayColor]];
    [headLabel_1 setFont:[UIFont boldSystemFontOfSize:13]];
    //            [headView addSubview:headLabel_1];
    
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [preBtn setFrame:CGRectMake((ScreenWidth-100)/2, 125, 100, 25)];
    [preBtn setTitle:@"查看用途分类" forState:UIControlStateNormal];
    [preBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [preBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [preBtn.layer setCornerRadius:5.0]; //设置矩圆角半径
    [preBtn.layer setBorderWidth:1.0];   //边框宽度
    preBtn.layer.borderColor = [[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]CGColor];
    [preBtn addTarget:self action:@selector(preBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [preBtn setBackgroundColor:[UIColor clearColor]];
    [headView addSubview:preBtn];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
    //    return headView;
}

- (void) preBtnClick:(UIButton *) sender
{
    if(!scoreArray || scoreArray.count == 0 || !typeArray || typeArray.count == 0)
    {
        [DCFStringUtil showNotice:@"数据正在读取中"];
        return;
    }
    else
    {
        intPage = 1;
        
        
        preView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
        [preView setBackgroundColor:[UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:0.6]];
        [self.view.window addSubview:preView];
        
        preVC = [[ShopHostPreTableViewController alloc] initWithScoreArray:scoreArray WithListArray:typeArray WithTitle:_myTitle];
        preVC.delegate = self;
        
        [preVC.view setFrame:CGRectMake(preView.frame.size.width-200, 0, 200, preView.frame.size.height)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preViewTap)];
        [tap setDelegate:self];
        [self.view addGestureRecognizer:tap];
        [preView addSubview:preVC.view];
        [self addChildViewController:preVC];
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        label.text = [NSString stringWithFormat:@"   %@",_myTitle];
        label.frame = CGRectMake(preView.frame.size.width-200, 0, 200, 50);
        [preView insertSubview:label aboveSubview:preVC.view];
        
        // 点击阴影部分时关闭视图
        shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 120, 416)];
        [shadowView setBackgroundColor:[UIColor clearColor]];
        [self.view.window addSubview:shadowView];
        UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePreViewTap)];
        [closeTap setDelegate:self];
        [shadowView addGestureRecognizer:closeTap];
    }
}

//   点击调转控制器事件
-(void)closePreViewTap
{
    [shadowView setHidden:YES];
    if(preVC)
    {
        [preVC.view removeFromSuperview];
        preVC.view = nil;
        
        [preVC removeFromParentViewController];
        preVC = nil;
    }
    if(preView)
    {
        [preView removeFromSuperview];
        preView = nil;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    preView.hidden = YES;
    
}


#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray.count == 0)
    {
        return 1;
    }
    else
    {
        int row = dataArray.count%2 + dataArray.count/2;
        //        if ((intPage-1)*(pageSize/2) < intTotal )
        if(dataArray.count < intTotal)
        {
            return row+2;
        }
        return row+1;
    }
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = dataArray.count%2 + dataArray.count/2;
    
    if(indexPath.row == row+1)
    {
        static NSString *moreCellId = @"moreCell";
        moreCell = (DCFChenMoreCell *)[tableView dequeueReusableCellWithIdentifier:moreCellId];
        if(moreCell == nil)
        {
            moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
            [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        }
        return moreCell;
    }
    else
    {
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
            if(!discussArray || discussArray.count == 0)
            {
                
            }
            else
            {
                [cell.contentView addSubview:headView];
            }
        }
        else
        {
            for(int i=0;i<2;i++)
            {
                int n = (indexPath.row-1)*2 + i;
                if(n <= dataArray.count-1)
                {
                    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(20+155*i, 10, 125, 125)];
                    [cellView setTag:n];
                    [cell.contentView addSubview:cellView];
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                    [cellView addGestureRecognizer:tap];
                    
                    NSString *picUrl = [[dataArray objectAtIndex:n] p1Path];
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
                    [iv setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"cabel.png"]];
                    [cellView addSubview:iv];
                    
                    NSString *str_1 = [[dataArray objectAtIndex:n] productName];
                    //                    CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str_1 WithSize:CGSizeMake(125, MAXFLOAT)];
                    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iv.frame.origin.y+iv.frame.size.height, 125, 35)];
                    [nameLabel setText:str_1];
                    [nameLabel setFont:[UIFont systemFontOfSize:11]];
                    [nameLabel setNumberOfLines:0];
                    [cellView addSubview:nameLabel];
                    
                    NSString *str_2 = [[dataArray objectAtIndex:n] productPrice];
                    //                    CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:str_2 WithSize:CGSizeMake(125, MAXFLOAT)];
                    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.frame.origin.y+nameLabel.frame.size.height, 125, 20)];
                    [priceLabel setText:[NSString stringWithFormat:@"¥ %@",str_2]];
                    [priceLabel setFont:[UIFont systemFontOfSize:11]];
                    [priceLabel setTextColor:[UIColor redColor]];
                    [cellView addSubview:priceLabel];
                }
            } 
            
        }
        
        
        return cell;
    }
    return nil;
}

#pragma mark - 筛选代理
- (void) pushText:(NSString *)text
{
    shopUse = text;
    if(text.length == 0)
    {
        
    }
    else
    {
        if(dataArray && dataArray.count != 0)
        {
            [dataArray removeAllObjects];
        }
        [self.tableView reloadData];
        [self loadRequest:_shopId WithUse:shopUse];
    }
    [self preViewTap];
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    int tag = [[sender view] tag];
    
    NSString *productId = [[dataArray objectAtIndex:tag] productId];
    GoodsDetailViewController *detail = [[GoodsDetailViewController alloc] initWithProductId:productId];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    if (self.tableView == (UITableView *)scrollView)
    {
        if (scrollView.contentSize.height > 0 && (scrollView.contentSize.height-scrollView.frame.size.height)>0)
        {
            if (scrollView.contentOffset.y >= scrollView.contentSize.height-scrollView.frame.size.height)
            {
                if ((intPage-1) * (pageSize/2) < intTotal )
                {
                    [self loadRequest:_shopId WithUse:shopUse];
                }
            }
        }
    }
}
//
//
//
//#pragma mark -
//#pragma mark SCROLLVIEW DELEGATE METHODS
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.refreshView egoRefreshScrollViewDidScroll:self.tableView];
}
//
#pragma mark -
#pragma mark DATA SOURCE LOADING / RELOADING METHODS
- (void)reloadViewDataSource
{
    
    _reloading = YES;
    intPage = 1;
    [self loadRequest:_shopId WithUse:shopUse];
}
//
- (void)doneLoadingViewData
{
    
    _reloading = NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}
//
//#pragma mark -
//#pragma mark REFRESH HEADER DELEGATE METHODS
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    
    [self reloadViewDataSource];
}
//
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    
    return _reloading;
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    
    return [NSDate date];
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
