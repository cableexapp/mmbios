//
//  GoodsDetailViewController.m
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-9.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "DCFTopLabel.h"
#import "DCFStringUtil.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "GoodsDetailTableViewCell.h"
#import "MyShoppingListViewController.h"
#import "ShopHostTableViewController.h"
#import "B2CGoodsDetailData.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "DCFChenMoreCell.h"
#import "LoginNaviViewController.h"
#import "UpOrderViewController.h"
#import "B2CUpOrderData.h"
#import "ChatListViewController.h"
#define GoodsDetail_URL @"http://mmb.fgame.com:8083/"

@interface GoodsDetailViewController ()
{
    UIStoryboard *sb;
    
    AppDelegate *app;
    
    NSMutableArray *cellBtnArray;
    
    BOOL showCell;
    
    NSMutableArray *chooseColorBtnArray;
    NSMutableArray *chooseCountBtnArray;
    
    UIView *chooseColorAndCountView; //选择颜色和数量的试图
    
    MyShoppingListViewController *shop;
    
    B2CGoodsDetailData *detailData;
    
    UIImage *cabelImage;
    
    
    NSMutableArray *colorLabelArray;
    
    NSString *itemid;
    NSString *num;
    
    NSString *colorItemId;
    
    NSArray *arr;   //传到购物车列表页的数组
    
    DCFChenMoreCell *moreCell;
    
    
    B2CUpOrderData *orderData;
    
    double chooseColorPrice;
    
    
    NSString *productNum;  //库存数量
    
    UIView *backView;
    
    NSString *producturl;//商品链接地址
    
    UIButton *rightBtn;
    
    UIBarButtonItem *right;
    
    UILabel *countLabel;
    
    int btnTag;
    
    NSString *colorName;
    
    int scoreNum;
}
@end

@implementation GoodsDetailViewController

@synthesize GoodsDetailUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    if(memberid.length == 0)
    {
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}

- (void) btnClick:(UIButton *) sender
{
    [self.view.window addSubview:[self loadChooseColorAndCount]];
    backView.hidden = NO;
    [self setHidesBottomBarWhenPushed:YES];
    int tag = [sender tag];
    btnTag = tag;
    
//    if(num.length == 0 || [num intValue] == 0)
//    {
//        [DCFStringUtil showNotice:@"请选择数量"];
//        return;
//    }
//    if(itemid.length == 0)
//    {
//        [DCFStringUtil showNotice:@"请选择颜色"];
//        return;
//    }
//    //    [self.view.window addSubview:[self loadChooseColorAndCount]];
//    //    backView.hidden = NO;
//    [self setHidesBottomBarWhenPushed:YES];
//    int tag = [sender tag];
//    
//    
//    if(tag == 100)
//    {
//#pragma mark - 立即购买
//        
//        NSString *time = [DCFCustomExtra getFirstRunTime];
//        
//        NSString *string = [NSString stringWithFormat:@"%@%@",@"DirectBuy",time];
//        
//        NSString *token = [DCFCustomExtra md5:string];
//        
//        //        NSString *pushString = [NSString stringWithFormat:@"productid=%@&token=%@&memberid=%@&itemid=%@&num=%@",@"144",token,[self getMemberId],itemid,num];
//        NSString *pushString = [NSString stringWithFormat:@"productid=%@&token=%@&memberid=%@&itemid=%@&num=%@",_productid,token,[self getMemberId],itemid,num];
//        
//        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/DirectBuy.html?"];
//        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLDirectBuyTag delegate:self];
//        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
//        
//        
//    }
//    else
//    {
//        
//#pragma mark - 加入购物车
//        [self setHidesBottomBarWhenPushed:YES];
//        
//        NSString *shopid = [NSString stringWithFormat:@"%@",detailData.shopId];
//        NSString *productid = [NSString stringWithFormat:@"%@",detailData.productId];
//        
//        NSString *time = [DCFCustomExtra getFirstRunTime];
//        NSString *string = [NSString stringWithFormat:@"%@%@",@"addToCart",time];
//        NSString *token = [DCFCustomExtra md5:string];
//        
//        NSString *visitorid = [app getUdid];
//        
//        NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
//        
//        
//        BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
//        
//        
//        
//        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLAddToShopCatTag delegate:self];
//        
//        NSString *pushString = nil;
//        
//        if(hasLogin == YES)
//        {
//            arr = [[NSArray alloc] initWithObjects:shopid,productid,itemid,num,token,memberid, nil];
//            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"shopCar" object:arr];
//            pushString = [NSString stringWithFormat:@"shopid=%@&productid=%@&itemid=%@&num=%@&token=%@&memberid=%@",shopid,productid,itemid,num,token,memberid];
//        }
//        else
//        {
//            arr = [[NSArray alloc] initWithObjects:shopid,productid,itemid,num,token,visitorid, nil];
//            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"shopCar" object:arr];
//            pushString = [NSString stringWithFormat:@"shopid=%@&productid=%@&itemid=%@&num=%@&token=%@&visitorid=%@",shopid,productid,itemid,num,token,visitorid];
//        }
//        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/addToCart.html?"];
//        
//        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
//        
//        num = @"0";
//    }
}

- (void)rightItemClick:(id) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    shop = [[MyShoppingListViewController alloc] initWithDataArray:arr];
    [self.navigationController pushViewController:shop animated:YES];
}

- (id) initWithProductId:(NSString *)productid
{
    if(self = [super init])
    {
        _productid = productid;
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
    if(chooseColorAndCountView)
    {
        [chooseColorAndCountView removeFromSuperview];
        chooseColorAndCountView = nil;
    }
    backView.hidden = YES;
    //    [self setHidesBottomBarWhenPushed:NO];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    [self setHidesBottomBarWhenPushed:YES];
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view isKindOfClass:[UIButton class]] || [view tag] == 101)
        {
            [view setHidden:YES];
        }
    }
    num = @"0";
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"shoppingCar.png"] forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(0, 0, 34,34)];
    [rightBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    countLabel = [[UILabel alloc] init];
    countLabel.frame = CGRectMake(22, 0, 18, 18);
    countLabel.layer.borderWidth = 1;
    countLabel.layer.cornerRadius = 10;
    countLabel.textColor = [UIColor whiteColor];
    countLabel.font = [UIFont systemFontOfSize:11];
    countLabel.textAlignment = 1;
    countLabel.hidden = NO;
    countLabel.layer.borderColor = [[UIColor clearColor] CGColor];
    countLabel.layer.backgroundColor = [[UIColor redColor] CGColor];
    [rightBtn addSubview:countLabel];
    self.navigationItem.rightBarButtonItem = right;
    [self loadShopCarCount];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    showCell = YES;
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装线商品详情"];
    self.navigationItem.titleView = top;
    
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-50-64, 320, 50)];
    [buttomView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:buttomView];
    
    UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatBtn setFrame:CGRectMake(40, 5, 40, 40)];
    [chatBtn setBackgroundImage:[UIImage imageNamed:@"chatBtn"] forState:UIControlStateNormal];
    [chatBtn addTarget:self action:@selector(IMChatClick) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:chatBtn];
    for(int i=0;i<2;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if(i == 0)
        {
            [btn setFrame:CGRectMake(self.view.frame.size.width-215, 5, 100, 40)];
            [btn setTitle:@"立即购买" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
            btn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:144.0/255.0 blue:1/255.0 alpha:1.0];
            btn.layer.cornerRadius = 5;
        }
        if(i == 1)
        {
            [btn setFrame:CGRectMake(210*i + 5, 5, 100, 40)];
            [btn setTitle:@"加入购物车" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithRed:21.0/255.0 green:101.0/255.0 blue:186/255.0 alpha:1.0];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
            btn.layer.cornerRadius = 5;
        }
        [btn setTag:i+100];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttomView addSubview:btn];
    }
    
    [self loadRequest];
    
    //    tableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight-50-64)];
    //    [tableView setBackgroundColor:[UIColor redColor]];
    //    [self.view addSubview:tableView];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,  ScreenHeight-50-64) style:0];
    [tv setDataSource:self];
    [tv setDelegate:self];
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tv setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tv];
    
    backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    backView.backgroundColor = [UIColor lightGrayColor];
    backView.hidden = YES;
    backView.alpha = 0.8;
    [self.view insertSubview:backView aboveSubview:tv];
    
    
    
    cellBtnArray = [[NSMutableArray alloc] init];
}

- (void) loadRequest
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductDetail",time];
    
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"productid=%@&token=%@",_productid,token];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getProductDetail.html?"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2CProductDetailTag delegate:self];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

//获取购物车商品数量
-(void)loadShopCarCount
{
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
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLB2CProductDetailTag)
    {
        NSLog(@"dicRespon------ = %@",[dicRespon objectForKey:@"items"]);
        
        scoreNum = ([[[dicRespon objectForKey:@"score"] objectAtIndex:0] intValue] + [[[dicRespon objectForKey:@"score"] objectAtIndex:1] intValue] + [[[dicRespon objectForKey:@"score"] objectAtIndex:2] intValue] +[[[dicRespon objectForKey:@"score"] objectAtIndex:3] intValue])/4;
        NSLog(@"scoreNum = %d",scoreNum);
        
        int result = [[dicRespon objectForKey:@"result"] intValue];
        NSString *msg = [dicRespon objectForKey:@"msg"];
        producturl = [dicRespon objectForKey:@"producturl"];
        if(result == 1)
        {
            detailData = [[B2CGoodsDetailData alloc] init];
            [detailData dealData:dicRespon];
            [tv reloadData];
        }
        else
        {
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"暂无数据"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
    if(URLTag == URLAddToShopCatTag)
    {
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            num = @"0";
            itemid = @"";
            [self loadShopCarCount];
        }
        else
        {
            
            if(msg.length != 0)
            {
                [DCFStringUtil showNotice:msg];
                
            }
            else
            {
                [DCFStringUtil showNotice:@"加入购物车失败,请重试"];
            }
        }
        
    }
    if(URLTag == URLDirectBuyTag)
    {
        if(result == 1)
        {
            orderData = [[B2CUpOrderData alloc] initWithDataDic:dicRespon];
            NSMutableArray *chooseGoodsArray = [[NSMutableArray alloc] initWithObjects:orderData, nil];
            
            double totalMoney = [num intValue]*chooseColorPrice;
            UpOrderViewController *order = [[UpOrderViewController alloc] initWithDataArray:chooseGoodsArray WithMoney:totalMoney WithOrderData:orderData WithTag:0];
            [self.navigationController pushViewController:order animated:YES];
            num = @"0";
            itemid = @"";
            
        }
        else
        {
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"立即购买失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( [detailData.ctems isKindOfClass:[NSNull class]] ||  detailData.ctems.count == 0)
    {
        return 8;
    }
    return 7 + detailData.ctems.count;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 170;
    }
    if(indexPath.row == 1)
    {
        if(detailData.goodsName.length == 0)
        {
            return 0;
        }
        else
        {
            CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:detailData.goodsName WithSize:CGSizeMake(300, MAXFLOAT)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, size.height)];
            [label setText:detailData.goodsName];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:13]];
            return label.frame.size.height + 30;
        }
    }
    if(indexPath.row == 2 || indexPath.row == 3)
    {
        if(indexPath.row == 2)
        {
            if(detailData)
            {
                CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:[NSString stringWithFormat:@"%@ %@",@"¥",detailData.productPrice] WithSize:CGSizeMake(MAXFLOAT, 30)];
                
                
                NSString *FreightType = detailData.freightType;
                NSString *string = nil;
                if([FreightType isEqualToString:@"0"])
                {
                    string = [NSString stringWithFormat:@"商品运费:物流%@元,快递%@元,EMS%@元",detailData.surfaceFreightPrice,detailData.expressFreightPrice,detailData.emsFreightPrice];
                }
                if([FreightType isEqualToString:@"1"])
                {
                    string = @"卖家承担运费";
                }
                if([FreightType isEqualToString:@"2"])
                {
                    if([detailData.minString isEqualToString:@"0"])
                    {
                        string = @"商品运:结算时根据配送地区具体计算";
                    }
                    else
                    {
                        string = [NSString stringWithFormat:@"商品运费:参考运费%@元,结算时根据配送地区具体计算",detailData.minString];
                    }
                }
                CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:string WithSize:CGSizeMake(ScreenWidth-20-size_1.width, MAXFLOAT)];
                if(size_3.height < 30)
                {
                    return 50;
                }
                else
                {
                    return size_3.height + 20;
                }
            }
            else
            {
                
            }
        }
        
        return 50;
    }
    if(indexPath.row == 4)
    {
        NSString *discuss = detailData.score;
        if(discuss.length == 0)
        {
            return 0;
        }
        else
        {
            return 40;
        }
    }
    if (indexPath.row == 5)
    {
        if(showCell == YES)
        {
            return 179;
        }
        else
        {
            return 54;
        }
    }

    if(indexPath.row == 6)
    {
        return 54;
    }
    if (indexPath.row > 5)
    {
        if(showCell == YES)
        {
            return 0;
        }
        else
        {
            if([detailData.ctems isKindOfClass:[NSNull class]] || detailData.ctems.count == 0)
            {
                return 44;
            }
            else
            {
                NSString *s4 = [[detailData.ctems objectAtIndex:indexPath.row-7] objectForKey:@"judgementContent"];
                
                if(s4.length == 0)
                {
                    return 0;
                }
                else
                {
                    CGSize size_4 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s4 WithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT)];
                    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, size_4.height)];
                    [contentLabel setText:s4];
                    [contentLabel setFont:[UIFont systemFontOfSize:12]];
                    [contentLabel setNumberOfLines:0];
                    return contentLabel.frame.size.height;
                }
            }
        }
    }
    return 0;
}

-(void)EScrollerViewDidClicked:(NSUInteger)index
{
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView setSeparatorStyle:0];
    
    NSString *cellId = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        [cell setSelectionStyle:0];
        
        if(indexPath.row == 0)
        {
            NSArray *imageArray = nil;
            
            if(detailData.picArray.count != 0)
            {
                imageArray = [[NSArray alloc] initWithArray:detailData.picArray];
            }
            else
            {
                imageArray = [[NSArray alloc] initWithObjects:@"cabel.png",@"cabel.png",@"cabel.png", nil];
            }
            es = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, ScreenWidth, 160) ImageArray:imageArray TitleArray:nil WithTag:1];
            es.delegate = self;
            [cell.contentView addSubview:es];
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(0, 169.5, cell.frame.size.width, 0.5);
            lineView.backgroundColor = [UIColor lightGrayColor];
            [cell addSubview:lineView];
        }
        if(indexPath.row == 1)
        {
            if(detailData.goodsName.length != 0)
            {
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:detailData.goodsName WithSize:CGSizeMake(300, MAXFLOAT)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, size.height+15)];
                [label setText:detailData.goodsName];
                [label setNumberOfLines:0];
                [label setFont:[UIFont systemFontOfSize:15]];
                [label setTextAlignment:NSTextAlignmentLeft];
                [label setTextColor:[UIColor blackColor]];
                [cell.contentView addSubview:label];
                [cell.contentView setBackgroundColor:[UIColor whiteColor]];
                UIView *lineView = [[UIView alloc] init];
                lineView.frame = CGRectMake(10, size.height+30, cell.frame.size.width-20, 0.5);
                lineView.backgroundColor = [UIColor lightGrayColor];
                [cell addSubview:lineView];
            }
            else
            {
                
            }
        }
        if(indexPath.row == 2)
        {
            if(detailData.productPrice.length != 0)
            {
                CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:[NSString stringWithFormat:@"%@ %@",@"¥",detailData.productPrice] WithSize:CGSizeMake(MAXFLOAT, 30)];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                [label setText:[NSString stringWithFormat:@"%@%@",@"¥",detailData.productPrice]];
                [label setTextColor:[UIColor redColor]];
                [label setFont:[UIFont systemFontOfSize:14]];
                [label setTextAlignment:NSTextAlignmentLeft];
                [cell.contentView addSubview:label];
                
                NSString *FreightType = detailData.freightType;
                NSString *string = nil;
                if([FreightType isEqualToString:@"0"])
                {
                    string = [NSString stringWithFormat:@"商品运费:物流%@元,快递%@元,EMS%@元",detailData.surfaceFreightPrice,detailData.expressFreightPrice,detailData.emsFreightPrice];
                }
                if([FreightType isEqualToString:@"1"])
                {
                    string = @"卖家承担运费";
                }
                if([FreightType isEqualToString:@"2"])
                {
                    if([detailData.minString isEqualToString:@"0"])
                    {
                        string = @"商品运:结算时根据配送地区具体计算";
                    }
                    else
                    {
                        string = [NSString stringWithFormat:@"商品运费:参考运费%@元,结算时根据配送地区具体计算",detailData.minString];
                    }
                }
                CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:string WithSize:CGSizeMake(ScreenWidth-20-size_1.width, MAXFLOAT)];
                UILabel *tradeLabel = nil;
                if(size_3.height < 30)
                {
                    [label setFrame:CGRectMake(10, 10, size_1.width, 30)];
                    
                    tradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width, 10, ScreenWidth-20-label.frame.size.width, 30)];
                }
                else
                {
                    [label setFrame:CGRectMake(10, (size_3.height-30)/2, size_1.width, 30)];
                    
                    tradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width, 10, ScreenWidth-20-label.frame.size.width, size_3.height)];
                }
                [tradeLabel setText:string];
                [tradeLabel setTextAlignment:NSTextAlignmentRight];
                [tradeLabel setTextColor:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0]];
                [tradeLabel setFont:[UIFont systemFontOfSize:13]];
                [tradeLabel setNumberOfLines:0];
                [cell.contentView addSubview:tradeLabel];
                
                UIView *lineView = [[UIView alloc] init];
                lineView.frame = CGRectMake(0, cell.contentView.frame.size.height-0.5, cell.contentView.frame.size.width, 0.5);
                lineView.backgroundColor = [UIColor lightGrayColor];
                [cell addSubview:lineView];
            }
            else
            {
                
            }
        }
        if(indexPath.row == 3)
        {
            CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:@"选择颜色分类" WithSize:CGSizeMake(MAXFLOAT, 30)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, size_1.width, 30)];
            [label setText:@"选择颜色分类"];
            [label setFont:[UIFont systemFontOfSize:15]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [cell.contentView addSubview:label];
            UIImageView *cellAccessoryDisclosureIndicator = [[UIImageView alloc] init];
            cellAccessoryDisclosureIndicator.frame = CGRectMake(self.view.frame.size.width-40, 0, 30, 30);
            cellAccessoryDisclosureIndicator.image = [UIImage imageNamed:@"set_clear"];
            [cell.contentView addSubview:cellAccessoryDisclosureIndicator];
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(0, cell.frame.size.height-10, cell.frame.size.width, 10);
            lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
            [cell addSubview:lineView];
            
        }
        if(indexPath.row == 6)
        {
            NSString *discuss = detailData.score;
            if(discuss.length != 0)
            {
                UIImageView *firstIv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
                [firstIv setImage:[UIImage imageNamed:@"shopPic"]];
                
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:[detailData shopName] WithSize:CGSizeMake(MAXFLOAT,30)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45,0, size.width, 30)];
                [label setFont:[UIFont systemFontOfSize:15]];
                [label setText:[detailData shopName]];
                [label setTextAlignment:NSTextAlignmentLeft];
                [label setTextColor:[UIColor blackColor]];
                
                UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, label.frame.size.width+40, 44)];
                [firstView addSubview:firstIv];
                [firstView addSubview:label];
                [cell.contentView addSubview:firstView];
                
                UITapGestureRecognizer *tap_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstTap:)];
                [firstView addGestureRecognizer:tap_1];
                
                UIView *lineView = [[UIView alloc] init];
                lineView.frame = CGRectMake(0, cell.frame.size.height-10, cell.frame.size.width, 10);
                lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
                [cell addSubview:lineView];
            }
            else
            {
                
            }
        }
        if(indexPath.row == 4)
        {
            
            for(int i = 0;i < 2;i++)
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                //                [btn setFrame:CGRectMake(10+100*i, 5, 100, 34)];
                UIView *selectView = [[UIView alloc] init];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                if(i == 0)
                {
                    selectView.frame = CGRectMake(0, 38.5, self.view.frame.size.width/2, 1.5);
                    [btn setFrame:CGRectMake((self.view.frame.size.width/2)*i, 0, self.view.frame.size.width/2-0.25, 40)];
                    if(showCell == YES)
                    {
                        [btn setSelected:YES];
                        selectView.backgroundColor = [UIColor colorWithRed:19/255.0 green:90.0/255.0 blue:168/255.0 alpha:1.0];
                    }
                    else
                    {
                        [btn setSelected:NO];
                        selectView.backgroundColor = [UIColor clearColor];
                    }
                    [btn setTitle:@"商品详情" forState:UIControlStateNormal];
                }
                else if (i == 1)
                {
                    selectView.frame = CGRectMake(self.view.frame.size.width/2, 38.5, self.view.frame.size.width/2, 1.5);
                    [btn setFrame:CGRectMake((self.view.frame.size.width/2)*i+0.25, 0, self.view.frame.size.width/2-0.25, 40)];
                    if(showCell == YES)
                    {
                        [btn setSelected:NO];
                        selectView.backgroundColor = [UIColor clearColor];
                    }
                    else
                    {
                        [btn setSelected:YES];
                        selectView.backgroundColor = [UIColor colorWithRed:19/255.0 green:90.0/255.0 blue:168/255.0 alpha:1.0];
                    }
                    [btn setTitle:@"商品评价" forState:UIControlStateNormal];
                }
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                [btn setTag:1000+i];
                
                [btn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [cellBtnArray addObject:btn];
                UIView *lineView = [[UIView alloc] init];
                lineView.frame = CGRectMake(self.view.frame.size.width/2-0.25, 0, 0.5, 34);
                lineView.backgroundColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:lineView];
                [cell.contentView addSubview:btn];
                [cell.contentView insertSubview:selectView aboveSubview:btn];
            }
        }
        if(indexPath.row == 5)
        {
            
            if(showCell == YES)
            {
                GoodsDetailTableViewCell *customCell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsDetailTableViewCell" owner:self options:nil] lastObject];
                
                [customCell.barndLabel setText:detailData.goodsBrand];
                [customCell.kindLabel setText:detailData.goodsModel];
                [customCell.voltageLabel setText:detailData.goodsVoltage];
                [customCell.surfaceLabel setText:[NSString stringWithFormat:@"%@平方",detailData.spec]];
                [customCell.useLabel setText:detailData.use];
                [customCell.threadLabel setText:detailData.coreNum];
                [customCell.standLabel setText:detailData.standard];
                [customCell.unitLabel setText:detailData.unit];
                [customCell.thicknessLabel setText:[NSString stringWithFormat:@"%@mm",detailData.insulationThickness]];
                [customCell.lengthLabel setText:[NSString stringWithFormat:@"%@米",detailData.avgLength]];
                [customCell.topLabel setText:[NSString stringWithFormat:@"%@mm",detailData.avgDiameter]];
                [customCell.weightLabel setText:[NSString stringWithFormat:@"%@KG",detailData.weight]];
                [customCell.contentView setBackgroundColor:[UIColor whiteColor]];
                
                UIView *lineView = [[UIView alloc] init];
                lineView.frame = CGRectMake(0, customCell.frame.size.height-10,self.view.frame.size.width, 10);
                lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
                [customCell.contentView addSubview:lineView];
                return customCell;
            }
            else
            {
                
            }
        }
        //        if(indexPath.row > 5 && indexPath.row < 6)
        if(indexPath.row == 5 )
        {
            if(showCell == YES)
            {
            }
            else
            {
                if([detailData.ctems isKindOfClass:[NSNull class]] || detailData.ctems.count == 0)
                {
                    static NSString *moreCellId = @"moreCell";
                    moreCell = (DCFChenMoreCell *)[tableView dequeueReusableCellWithIdentifier:moreCellId];
                    if(moreCell == nil)
                    {
                        moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
                        [moreCell.contentView setBackgroundColor:[UIColor whiteColor]];
                        [moreCell noDataAnimation];
                    }
                    return moreCell;
                }
                NSString *s1 = [[detailData.ctems objectAtIndex:indexPath.row-5] objectForKey:@"loginName"];
                if(s1.length != 0)
                {
                    CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:10] WithText:s1 WithSize:CGSizeMake(MAXFLOAT, 30)];
                    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size_1.width+10, 15)];
                    [nameLabel setText:s1];
                    [nameLabel setTextAlignment:NSTextAlignmentLeft];
                    [nameLabel setFont:[UIFont systemFontOfSize:10]];
                    [nameLabel setTextColor:[UIColor blackColor]];
                    [cell.contentView addSubview:nameLabel];
                    
                    NSString *month = [[[detailData.ctems objectAtIndex:indexPath.row-5] objectForKey:@"createDate"] objectForKey:@"month"];
                    NSString *finalMonth = [NSString stringWithFormat:@"%d",[month intValue] + 1];
                    NSString *date = [[[detailData.ctems objectAtIndex:indexPath.row-5] objectForKey:@"createDate"] objectForKey:@"date"];
                    NSString *s2 = [NSString stringWithFormat:@"评价日期:%@.%@",finalMonth,date];
                    CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:10] WithText:s2 WithSize:CGSizeMake(MAXFLOAT, 30)];
                    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 30, 5, size_2.width, 15)];
                    [dateLabel setTextAlignment:NSTextAlignmentCenter];
                    [dateLabel setText:s2];
                    [dateLabel setFont:[UIFont systemFontOfSize:10]];
                    [cell.contentView addSubview:dateLabel];
                    
                    NSString *color = [[detailData.ctems objectAtIndex:indexPath.row-5] objectForKey:@"colorName"];
                    NSString *s3 = [NSString stringWithFormat:@"颜色分类:%@",color];
                    CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:10] WithText:s3 WithSize:CGSizeMake(MAXFLOAT, 30)];
                    UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-size_3.width, 5, size_3.width, 15)];
                    [colorLabel setText:s3];
                    [colorLabel setTextAlignment:NSTextAlignmentLeft];
                    [colorLabel setFont:[UIFont systemFontOfSize:10]];
                    [cell.contentView addSubview:colorLabel];
                    
                    NSString *s4 = [[detailData.ctems objectAtIndex:indexPath.row-5] objectForKey:@"judgementContent"];
                    CGSize size_4 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s4 WithSize:CGSizeMake(320, MAXFLOAT)];
                    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, ScreenWidth-10, size_4.height)];
                    [contentLabel setTextAlignment:NSTextAlignmentLeft];
                    [contentLabel setText:s4];
                    [contentLabel setFont:[UIFont systemFontOfSize:12]];
                    [contentLabel setNumberOfLines:0];
                    [cell.contentView addSubview:contentLabel];
                    
                    UIView *lineView = [[UIView alloc] init];
                    lineView.frame = CGRectMake(10, cell.frame.size.height-0.5,self.view.frame.size.width-20, 0.5);
                    lineView.backgroundColor = [UIColor lightGrayColor];
                    [cell.contentView addSubview:lineView];
                }
                else
                {
                    
                }
            }
        }
    }
    return cell;
}

- (void) firstTap:(UITapGestureRecognizer *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    ShopHostTableViewController *shopHost = [[ShopHostTableViewController alloc] initWithHeadTitle:detailData.shopName WithShopId:detailData.shopId WithUse:@""];
    [self.navigationController pushViewController:shopHost animated:YES];
}

- (void) starViewTap:(UITapGestureRecognizer *) sender
{
    
}

-(void)IMChatClick
{
    ChatListViewController *chatVC = [[ChatListViewController alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"%@%@@%@",GoodsDetail_URL,producturl,@"家装线商品详情"];
    chatVC.fromString = urlString;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void) cellBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    
    if(btn.tag == 1000)
    {
        if(btn.selected == YES)
        {
            showCell = YES;
            
        }
        else
        {
            showCell = NO;
        }
    }
    if(btn.tag == 1001)
    {
        if(btn.selected == YES)
        {
            showCell = NO;
        }
        else
        {
            showCell = YES;
        }
    }
    
    for(UIButton *btn in cellBtnArray)
    {
        if(btn.tag == [sender tag])
        {
            
        }
        else
        {
            [btn setSelected:NO];
        }
    }
    
    [tv reloadData];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3)
    {
        [self.view.window addSubview:[self loadChooseColorAndCount]];
        backView.hidden = NO;
    }
}

#pragma mark - 加载选择颜色和数量界面
- (UIView *) loadChooseColorAndCount
{
    if(detailData.coloritems.count == 0)
    {
        [DCFStringUtil showNotice:@"数据请求失败"];
    }
    else
    {
        num = @"0";
        itemid = @"";
        
        colorLabelArray = [[NSMutableArray alloc] init];
        
        chooseColorBtnArray = [[NSMutableArray alloc] init];
        
        chooseCountBtnArray = [[NSMutableArray alloc] init];
        
        chooseColorAndCountView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-220, ScreenWidth, 290)];
        [chooseColorAndCountView setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        if(detailData.picArray.count != 0)
        {
            NSURL *url = [NSURL URLWithString:[detailData.picArray objectAtIndex:0]];
            [iv setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cabel.png"]];
        }
        else
        {
            [iv setImage:[UIImage imageNamed:@"cabel.png"]];
        }
        [chooseColorAndCountView addSubview:iv];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setFrame:CGRectMake(ScreenWidth-45, 15, 35, 30)];
        [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [chooseColorAndCountView addSubview:closeBtn];
        
        UIView *closeView = [[UIView alloc] init];
        closeView.frame = CGRectMake(ScreenWidth-50, 0, 60, 50);
        closeView.backgroundColor = [UIColor clearColor];
        [chooseColorAndCountView addSubview:closeView];
        
        UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap:)];
        [closeView addGestureRecognizer:closeTap];
        
        UILabel *colorKindLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, iv.frame.origin.y+iv.frame.size.height+10, 200, 20)];
        [colorKindLabel setText:@"颜色"];
        [colorKindLabel setFont:[UIFont systemFontOfSize:15]];
        [colorKindLabel setBackgroundColor:[UIColor clearColor]];
        [colorKindLabel setTextAlignment:NSTextAlignmentLeft];
        [chooseColorAndCountView addSubview:colorKindLabel];
        
        for(int i = 0;i < detailData.coloritems.count;i++)
        {
            NSString *colorName = [[detailData.coloritems objectAtIndex:i] objectForKey:@"colorName"];
            productNum = [NSString stringWithFormat:@"%@",[[detailData.coloritems objectAtIndex:i] objectForKey:@"productNum"]];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
            if(i >= 4)
            {
                [btn setFrame:CGRectMake(10+80*(i-4), colorKindLabel.frame.origin.y + colorKindLabel.frame.size.height + 50, 60, 30)];
                
            }
            else
            {
                [btn setFrame:CGRectMake(10+80*i, colorKindLabel.frame.origin.y + colorKindLabel.frame.size.height + 10, 60, 30)];
            }
            if(i == 0)
            {
                //                [btn setSelected:YES];
            }
            [btn setTitle:colorName forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"color_select"] forState:UIControlStateSelected];
            btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            btn.layer.borderWidth = 0.5;
            btn.layer.cornerRadius = 4;
            btn.layer.masksToBounds = YES;
            [btn setTag:i];
            [btn addTarget:self action:@selector(chooseColorClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if([DCFCustomExtra validateString:productNum] == NO || [productNum isEqualToString:@"0"])
            {
                [btn setEnabled:NO];
            }
            else
            {
                [btn setEnabled:YES];
            }
            [chooseColorBtnArray addObject:btn];
            [chooseColorAndCountView addSubview:btn];
            
        }
        
        for(int i=0;i<3;i++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x +iv.frame.size.width + 10, 5 + 25*i, 160, 20)];
            [label setFont:[UIFont systemFontOfSize:14]];
            switch (i) {
                case 2:
                {
                    [label setHidden:YES];
                    break;
                }
                case 0:
                {
                    [label setHidden:YES];
                    break;
                }
                case 1:
                {
                    [label setText:@"请选择颜色:"];
                    break;
                }
                default:
                    break;
            }
            
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setBackgroundColor:[UIColor clearColor]];
            [chooseColorAndCountView addSubview:label];
            [colorLabelArray addObject:label];
        }
        
        
        
        UILabel *chooseCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 80, 20)];
        [chooseCountLabel setText:@"购买数量"];
        [chooseCountLabel setTextAlignment:NSTextAlignmentLeft];
        [chooseCountLabel setBackgroundColor:[UIColor clearColor]];
        [chooseCountLabel setFont:[UIFont systemFontOfSize:15]];
        [chooseColorAndCountView addSubview:chooseCountLabel];
        
        for(int i=0;i<3;i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if(i == 0)
            {
                [btn setFrame:CGRectMake(self.view.frame.size.width-160, chooseCountLabel.frame.origin.y, 30, 30)];
                [btn setBackgroundImage:[UIImage imageNamed:@"deleat"] forState:UIControlStateNormal];
            }
            if(i == 1)
            {
                [btn setFrame:CGRectMake(self.view.frame.size.width-120, chooseCountLabel.frame.origin.y, 60, 30)];
                [btn setTitle:@"0" forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor whiteColor];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
                [btn setUserInteractionEnabled:NO];
            }
            if(i == 2)
            {
                [btn setFrame:CGRectMake(self.view.frame.size.width-50, chooseCountLabel.frame.origin.y, 30, 30)];
                [btn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
            }
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.layer.borderWidth = 0.5f;
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [btn setTag:10+i];
            [btn addTarget:self action:@selector(chooseCountClick:) forControlEvents:UIControlEventTouchUpInside];
            [chooseColorAndCountView addSubview:btn];
            [chooseCountBtnArray addObject:btn];
        }
        
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setFrame:CGRectMake((self.view.frame.size.width-140)/2, 240, 140, 40)];
        [sureBtn setTitle:@"确 认" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:141/255.0 blue:1/255.0 alpha:1];
        sureBtn.layer.cornerRadius = 5;
        [chooseColorAndCountView addSubview:sureBtn];
        
        NSString *colorPrice = [NSString stringWithFormat:@"%@",[[detailData.coloritems objectAtIndex:0] objectForKey:@"colorPrice"]];
        chooseColorPrice = [colorPrice doubleValue];
        
        UIView *back = [[UIView alloc] init];
        back.frame = CGRectMake(0, 80, ScreenWidth, 157);
        back.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [chooseColorAndCountView insertSubview:back atIndex:0];
        return chooseColorAndCountView;
    }
    
    return nil;
}

-(void)closeTap:(UIGestureRecognizer *)sender
{
    if(chooseColorAndCountView)
    {
        backView.hidden = YES;
        [chooseColorAndCountView removeFromSuperview];
        chooseColorAndCountView = nil;
    }
}

- (void) chooseColorClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    
    int tag = btn.tag;
    
    colorName = nil;
    NSString *colorPrice = nil;
    if(btn.selected == YES)
    {
        colorName = [[detailData.coloritems objectAtIndex:tag] objectForKey:@"colorName"];
        colorPrice = [NSString stringWithFormat:@"%@",[[detailData.coloritems objectAtIndex:tag] objectForKey:@"colorPrice"]];
        productNum = [NSString stringWithFormat:@"%@",[[detailData.coloritems objectAtIndex:tag] objectForKey:@"productNum"]];
        
        itemid = [NSString stringWithFormat:@"%@",[[detailData.coloritems objectAtIndex:tag] objectForKey:@"recordId"]];
        
        if(detailData.coloritems.count == 0 || [detailData.coloritems isKindOfClass:[NSNull class]])
        {
            
        }
        else
        {
            for(int j=0;j<[detailData.coloritems count];j++)
            {
                for(int i=0; i< 3; i++)
                {
                    //                NSString *colorPrice = [[detailData.coloritems objectAtIndex:j] objectForKey:@"colorPrice"];
                    UILabel *label = (UILabel *)[colorLabelArray objectAtIndex:i];
                    [label setHidden:NO];
                    if(i == 2)
                    {
                        [label setText:[NSString stringWithFormat:@"已选颜色:%@",colorName]];
                    }
                    if(i == 0)
                    {
                        NSString *s = [NSString stringWithFormat:@"¥ %@",colorPrice];
                        
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:s];
                        label.textColor = [UIColor redColor];
                        [label setAttributedText:str];
                    }
                    if(i == 1)
                    {
                        [label setText:[NSString stringWithFormat:@"库存:%@",productNum]];
                    }
                }
            }
            
        }
        chooseColorPrice = [colorPrice doubleValue];
        
    }
    else
    {
        colorName = @"";
        colorPrice = @"";
        productNum = @"";
        
        itemid = @"";
        
        if(detailData.coloritems.count == 0 || [detailData.coloritems isKindOfClass:[NSNull class]])
        {
            
        }
        else
        {
            for(int j=0;j<[detailData.coloritems count];j++)
            {
                for(int i=0; i< 3; i++)
                {
                    //                NSString *colorPrice = [[detailData.coloritems objectAtIndex:j] objectForKey:@"colorPrice"];
                    UILabel *label = (UILabel *)[colorLabelArray objectAtIndex:i];
                    switch (i) {
                        case 2:
                        {
                            [label setHidden:YES];
                            break;
                        }
                        case 0:
                        {
                            [label setHidden:YES];
                            break;
                        }
                        case 1:
                        {
                            [label setText:@"请选择颜色:"];
                            break;
                        }
                        default:
                            break;
                    }
                }
            }
            
        }
        chooseColorPrice = 0.00;
    }
    
    
    for(UIButton *b in chooseColorBtnArray)
    {
        if(b.tag == tag)
        {
            
        }
        else
        {
            [b setSelected:NO];
        }
    }
    
    
}

- (void) chooseCountClick:(UIButton *) sender
{
    
    int tag = [sender tag];
    
    UIButton *middleBtn = (UIButton *)[chooseCountBtnArray objectAtIndex:1];
    NSString *title = middleBtn.titleLabel.text;
    //    UIButton *leftBtn = (UIButton *)[chooseCountBtnArray objectAtIndex:0];
    //    UIButton *rightBtn = (UIButton *)[chooseCountBtnArray lastObject];
    
    if(tag == 10)
    {
        if([title isEqualToString:@"0"])
        {
            [middleBtn setTitle:@"0" forState:UIControlStateNormal];
        }
        else
        {
            NSString *s = [NSString stringWithFormat:@"%d",[title intValue] - 1];
            [middleBtn setTitle:s forState:UIControlStateNormal];
        }
    }
    else if (tag == 12)
    {
        NSString *s = [NSString stringWithFormat:@"%d",[title intValue] + 1];
        [middleBtn setTitle:s forState:UIControlStateNormal];
    }
    
    num = middleBtn.titleLabel.text;
    if([num intValue] > [productNum intValue])
    {
        num = productNum;
        [middleBtn setTitle:num forState:UIControlStateNormal];
        [DCFStringUtil showNotice:@"选择数目不能超过库存"];
        return;
    }
}

- (void) sureBtnClick:(UIButton *) sender
{

    if(colorName.length == 0)
    {
        [DCFStringUtil showNotice:@"请选择颜色"];
        return;
    }
    if(num.length == 0 || [num intValue] == 0)
    {
        [DCFStringUtil showNotice:@"请选择数量"];
        return;
    }
    if (colorName.length > 0 && num.length >0)
    {
        
        
        if(btnTag == 100)
        {
#pragma mark - 立即购买
            
            NSString *time = [DCFCustomExtra getFirstRunTime];
            
            NSString *string = [NSString stringWithFormat:@"%@%@",@"DirectBuy",time];
            
            NSString *token = [DCFCustomExtra md5:string];
            
            //        NSString *pushString = [NSString stringWithFormat:@"productid=%@&token=%@&memberid=%@&itemid=%@&num=%@",@"144",token,[self getMemberId],itemid,num];
            NSString *pushString = [NSString stringWithFormat:@"productid=%@&token=%@&memberid=%@&itemid=%@&num=%@",_productid,token,[self getMemberId],itemid,num];
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/DirectBuy.html?"];
            conn = [[DCFConnectionUtil alloc] initWithURLTag:URLDirectBuyTag delegate:self];
            [conn getResultFromUrlString:urlString postBody:pushString method:POST];
        }
        else
        {
            
#pragma mark - 加入购物车
            [self setHidesBottomBarWhenPushed:YES];
            
            NSString *shopid = [NSString stringWithFormat:@"%@",detailData.shopId];
            NSString *productid = [NSString stringWithFormat:@"%@",detailData.productId];
            
            NSString *time = [DCFCustomExtra getFirstRunTime];
            NSString *string = [NSString stringWithFormat:@"%@%@",@"addToCart",time];
            NSString *token = [DCFCustomExtra md5:string];
            
            NSString *visitorid = [app getUdid];
            
            NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
            
            BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
            
            conn = [[DCFConnectionUtil alloc] initWithURLTag:URLAddToShopCatTag delegate:self];
            
            NSString *pushString = nil;
            
            if(hasLogin == YES)
            {
                arr = [[NSArray alloc] initWithObjects:shopid,productid,itemid,num,token,memberid, nil];
                //            [[NSNotificationCenter defaultCenter] postNotificationName:@"shopCar" object:arr];
                pushString = [NSString stringWithFormat:@"shopid=%@&productid=%@&itemid=%@&num=%@&token=%@&memberid=%@",shopid,productid,itemid,num,token,memberid];
            }
            else
            {
                arr = [[NSArray alloc] initWithObjects:shopid,productid,itemid,num,token,visitorid, nil];
                //            [[NSNotificationCenter defaultCenter] postNotificationName:@"shopCar" object:arr];
                pushString = [NSString stringWithFormat:@"shopid=%@&productid=%@&itemid=%@&num=%@&token=%@&visitorid=%@",shopid,productid,itemid,num,token,visitorid];
            }
            NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/addToCart.html?"];
            
            [conn getResultFromUrlString:urlString postBody:pushString method:POST];
            
            num = @"0";
            
            
        }
        if(chooseColorAndCountView)
        {
            backView.hidden = YES;
            [chooseColorAndCountView removeFromSuperview];
            chooseColorAndCountView = nil;
        }
//        [self loadShopCarCount];
    }

}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void) hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
