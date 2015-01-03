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
#import "ChatViewController.h"
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
    
    int statrScore;
    
    UIButton *buyOrAddBtn;
    
    UIButton *sureBtn;
    
    UIWebView *cellWebView;
    
    NSString *memberid;
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
    memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    if(memberid.length == 0)
    {
        
    }
    return memberid;
}

- (void) btnClick:(UIButton *) sender
{
    memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    if(sender.tag == 101)
    {
        [self addBuyView:sender.tag];
    }
    else if (sender.tag == 100)
    {
        if([DCFCustomExtra validateString:memberid] == NO)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"您尚未登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            [av show];
        }
        else
        {
            [self addBuyView:sender.tag];
        }
    }
}

- (void) addBuyView:(int) tag
{
    [self.view.window addSubview:[self loadChooseColorAndCount]];
    backView.hidden = NO;
    [self setHidesBottomBarWhenPushed:YES];
    btnTag = tag;
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
//  [self setHidesBottomBarWhenPushed:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController.tabBarController.tabBar setHidden:YES];
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
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"购物车"] forState:UIControlStateNormal];
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
    countLabel.hidden = YES;
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
    
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-50-64, ScreenWidth, 50)];
    [buttomView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:buttomView];
    
    UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatBtn setFrame:CGRectMake(40, 5, 40, 40)];
    [chatBtn setBackgroundImage:[UIImage imageNamed:@"chatBtn"] forState:UIControlStateNormal];
    [chatBtn addTarget:self action:@selector(IMChatClick) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:chatBtn];
    for(int i=0;i<2;i++)
    {
        buyOrAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if(i == 0)
        {
            [buyOrAddBtn setFrame:CGRectMake(self.view.frame.size.width-215, 5, 100, 40)];
            [buyOrAddBtn setTitle:@"立即购买" forState:UIControlStateNormal];
            [buyOrAddBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buyOrAddBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
            buyOrAddBtn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:144.0/255.0 blue:1/255.0 alpha:1.0];
            buyOrAddBtn.layer.cornerRadius = 5;
        }
        if(i == 1)
        {
            [buyOrAddBtn setFrame:CGRectMake(210*i + 5, 5, 100, 40)];
            [buyOrAddBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
            [buyOrAddBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            buyOrAddBtn.backgroundColor = [UIColor colorWithRed:21.0/255.0 green:101.0/255.0 blue:186/255.0 alpha:1.0];
            [buyOrAddBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
            buyOrAddBtn.layer.cornerRadius = 5;
        }
        [buyOrAddBtn setTag:i+100];
        [buyOrAddBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttomView addSubview:buyOrAddBtn];
    }
    
    [self loadRequest];
    
    //    tableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight-50-64)];
    //    [tableView setBackgroundColor:[UIColor redColor]];
    //    [self.view addSubview:tableView];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,  ScreenHeight-50-64) style:0];
    [tv setDataSource:self];
    [tv setDelegate:self];
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tv.showsHorizontalScrollIndicator = NO;
    tv.showsVerticalScrollIndicator = NO;
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
    //    NSString *pushString = [NSString stringWithFormat:@"productid=%@&token=%@",@"1156",token];
    
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
    
    memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
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
        if ([[dicRespon objectForKey:@"score"] count] > 0)
        {
            statrScore = ([[[dicRespon objectForKey:@"score"] objectAtIndex:0] intValue]+[[[dicRespon objectForKey:@"score"] objectAtIndex:1] intValue]+[[[dicRespon objectForKey:@"score"] objectAtIndex:2] intValue]+[[[dicRespon objectForKey:@"score"] objectAtIndex:3] intValue])/4;
            
        }
        int result = [[dicRespon objectForKey:@"result"] intValue];
        NSString *msg = [dicRespon objectForKey:@"msg"];
        producturl = [dicRespon objectForKey:@"producturl"];
        if(result == 1)
        {
            detailData = [[B2CGoodsDetailData alloc] init];
            [detailData dealData:dicRespon];
//            detailData.phoneDescribe = @"<p>远东买卖宝</p>";
            
            //测试字段
            detailData.phoneDescribe = [[NSUserDefaults standardUserDefaults] objectForKey:@"content"];
            
            [self loadWebView];
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
            
            //            if (btn.tag == 100)
            //            {
            //                [btn becomeFirstResponder];
            //
            //            }
            //            if (btn.tag == 101)
            //            {
            //                [btn becomeFirstResponder];
            //            }
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
                //                [self loadShopCarCount];
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
        return 9;
    }
    return 8 + detailData.ctems.count;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 170;
    }
    if(indexPath.row == 1)
    {
        if([DCFCustomExtra validateString:detailData.goodsName] == NO)
        {
            return 0;
        }
        else
        {
            CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:detailData.goodsName WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, size.height)];
            [label setText:detailData.goodsName];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:15]];
            return label.frame.size.height + 10;
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
                if(size_3.height <= 30)
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
        //        NSString *discuss = detailData.score;
        //        if(discuss.length == 0)
        //        {
        //            return 0;
        //        }
        //        else
        //        {
        return 40;
        //        }
    }
    if (indexPath.row == 5)
    {
        if([detailData.isShowparam isEqualToString:@"1"])
        {
            
        }
        else if(![detailData.isShowparam isEqualToString:@"1"])
        {
            return 0;
        }
        if(showCell == YES)
        {
            return 160;
        }
        else
        {
            return 0;
        }
    }
    
    if(detailData.ctems.count == 0)
    {
        if(indexPath.row == 6)
        {
            if(showCell == YES)
            {
                return 0;
            }
            return 54;
        }
        else if(indexPath.row > 6)
        {
            if(indexPath.row == 7)
            {
                NSString *discuss = detailData.score;
                if(discuss.length != 0)
                {
                    return 54;
                }
                return 0;
                
            }
            if(indexPath.row == 8)
            {
                if([DCFCustomExtra validateString:detailData.phoneDescribe] == NO)
                {
                    return 0;
                }
                else
                {
                    if(!cellWebView)
                    {
                        return 0;
                    }
                    NSLog(@"cellWebView.frame.size.height = %f",cellWebView.frame.size.height);
                    return cellWebView.frame.size.height;
//                    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:detailData.phoneDescribe WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
//                    return size.height+15;
                }
            }
        }
    }
    else if(detailData.ctems.count != 0)
    {
        if(indexPath.row >= 6 && indexPath.row <detailData.ctems.count+6)
        {
            if(showCell == YES)
            {
                return 0;
            }
            else
            {
                
                NSString *s4 = [[detailData.ctems objectAtIndex:indexPath.row-6] objectForKey:@"loginName"];
                NSString *s5 = [[detailData.ctems objectAtIndex:indexPath.row-6] objectForKey:@"judgementContent"];
                
                CGSize nameSize;
                CGSize contentSize;
                UILabel *nameLabel = nil;
                if([DCFCustomExtra validateString:s4] == NO)
                {
                    nameSize = CGSizeMake(30, 0);
                    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, nameSize.width, 0)];
                }
                else
                {
                    nameSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:s4 WithSize:CGSizeMake(MAXFLOAT, 30)];
                    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, nameSize.width, 30)];
                    [nameLabel setText:s4];
                    [nameLabel setFont:[UIFont systemFontOfSize:13]];
                    
                }
                
                UILabel *contentLabel = nil;
                if([DCFCustomExtra validateString:s5] == NO)
                {
                    contentSize = CGSizeMake(30, 0);
                    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLabel.frame.origin.y+nameLabel.frame.size.height, ScreenWidth-20, 0)];
                }
                else
                {
                    contentSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s5 WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
                    
                    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLabel.frame.origin.y+nameLabel.frame.size.height, ScreenWidth-20, contentSize.height)];
                    [contentLabel setText:s5];
                    [contentLabel setFont:[UIFont systemFontOfSize:12]];
                    [contentLabel setNumberOfLines:0];
                }
                if([DCFCustomExtra validateString:s4] == NO && [DCFCustomExtra validateString:s5] == NO)
                {
                    return 0;
                }
                return nameLabel.frame.size.height+contentLabel.frame.size.height+10;
            }
        }
        else if(indexPath.row == detailData.ctems.count+7 || indexPath.row == detailData.ctems.count+6)
        {
            if(indexPath.row == detailData.ctems.count + 6)
            {
                NSString *discuss = detailData.score;
                if(discuss.length != 0)
                {
                    return 54;
                }
                return 0;
            }
            if(indexPath.row == detailData.ctems.count + 7)
            {
                if([DCFCustomExtra validateString:detailData.phoneDescribe] == NO)
                {
                    return 0;
                }
                else
                {
                    if(!cellWebView)
                    {
                        return 0;
                    }
                    return cellWebView.frame.size.height;
                    //                    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:detailData.phoneDescribe WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
                    //                    return size.height+15;
                }
                
//                if([DCFCustomExtra validateString:detailData.phoneDescribe] == NO)
//                {
//                    return 0;
//                }
//                else
//                {
//                    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:detailData.phoneDescribe WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
//                    return size.height+15;
//                }
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
                
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:detailData.goodsName WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, size.height)];
                [label setText:detailData.goodsName];
                [label setNumberOfLines:0];
                [label setFont:[UIFont systemFontOfSize:15]];
                [label setTextAlignment:NSTextAlignmentLeft];
                [label setTextColor:[UIColor blackColor]];
                [cell.contentView addSubview:label];
                [cell.contentView setBackgroundColor:[UIColor whiteColor]];
                UIView *lineView = [[UIView alloc] init];
                lineView.frame = CGRectMake(10, label.frame.origin.y+label.frame.size.height+4.5, cell.frame.size.width-20, 0.5);
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
                    [label setFrame:CGRectMake(10, (size_3.height+20-30)/2, size_1.width, 30)];
                    
                    tradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width+10, 10, ScreenWidth-25-label.frame.size.width, size_3.height)];
                }
                [tradeLabel setText:string];
                [tradeLabel setTextAlignment:NSTextAlignmentLeft];
                [tradeLabel setTextColor:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0]];
                [tradeLabel setFont:[UIFont systemFontOfSize:13]];
                [tradeLabel setNumberOfLines:2];
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
                    if (detailData.ctems.count == 0)
                    {
                        [btn setTitle:@"商品评价(0)" forState:UIControlStateNormal];
                    }
                    else
                    {
                        [btn setTitle:[NSString stringWithFormat:@"商品评价(%d)",detailData.ctems.count] forState:UIControlStateNormal];
                    }
                    
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
        //商品参数
        if(indexPath.row == 5)
        {
            if([detailData.isShowparam isEqualToString:@"1"])
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
            else
            {
                
            }
        }
        //评价
        if([detailData.ctems isKindOfClass:[NSNull class]] || detailData.ctems.count == 0)
        {
            if(indexPath.row == 6)
            {
                static NSString *moreCellId = @"moreCell";
                moreCell = (DCFChenMoreCell *)[tableView dequeueReusableCellWithIdentifier:moreCellId];
                if(moreCell == nil)
                {
                    moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
                    [moreCell.lblContent setText:@"暂无评论哦~~"];
                    moreCell.lblContent.font = [UIFont systemFontOfSize:13];
                    [moreCell.contentView setBackgroundColor:[UIColor whiteColor]];
                    //                    [moreCell noDataAnimation];
                }
                return moreCell;
                
            }
            if(indexPath.row == 7)
            {
                return   [self loadShopName:indexPath WithTableView:tableView];
                
            }
            if(indexPath.row == 8)
            {
                if([DCFCustomExtra validateString:detailData.phoneDescribe] == NO)
                {
                    
                }
                else
                {
                    return  [self loadCustomCell:indexPath WithTableView:tableView];
                }
            }
        }
        else
        {
            if(indexPath.row >= 6 && indexPath.row < detailData.ctems.count+6)
            {
                if(showCell == YES)
                {
                }
                else
                {
                    NSString *finalName = nil;
                    NSString *isAnonymous = [NSString stringWithFormat:@"%@",[[detailData.ctems objectAtIndex:indexPath.row-6] objectForKey:@"isAnonymous"]];
                    NSString *s1 = [[detailData.ctems objectAtIndex:indexPath.row-6] objectForKey:@"loginName"];
                    NSString *discusserName = [s1 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

                    //1匿名  0本名
                    if([isAnonymous intValue] == 1)
                    {
                        NSMutableString *discussName = [[NSMutableString alloc] init];
                        for(int i=0;i<discusserName.length-2;i++)
                        {
                            NSString *s = @"*";
                            [discussName appendString:s];
                        }
                        NSRange range_1;
                        range_1 = NSMakeRange(0, 1);
                        NSString *firstStr = [discusserName substringWithRange:range_1];
                        
                        NSRange range_2;
                        range_2 = NSMakeRange(discusserName.length-1, 1);
                        NSString *lastStr = [discusserName substringWithRange:range_2];
                        
                        finalName = [NSString stringWithFormat:@"%@%@%@",firstStr,discussName,lastStr];
                    }
                    else
                    {
                        finalName = discusserName;
                    }
    
                    
                    CGSize nameSize;
                    
                    UILabel *nameLabel = nil;
                    if([DCFCustomExtra validateString:finalName] == NO)
                    {
                        nameSize = CGSizeMake(30, 0);
                        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, nameSize.width, 0)];
                    }
                    else
                    {
                        nameSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:finalName WithSize:CGSizeMake(MAXFLOAT, 30)];
                        
                        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, nameSize.width, 30)];
                        [nameLabel setText:finalName];
                        [nameLabel setTextAlignment:NSTextAlignmentLeft];
                        [nameLabel setFont:[UIFont systemFontOfSize:13]];
                        [nameLabel setTextColor:[UIColor blackColor]];
                        [cell.contentView addSubview:nameLabel];
                        

                        NSString *color = [[detailData.ctems objectAtIndex:indexPath.row-6] objectForKey:@"colorName"];
                        NSString *colorStr = [NSString stringWithFormat:@"颜色分类:%@",color];
                        CGSize colorSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:10] WithText:colorStr WithSize:CGSizeMake(MAXFLOAT, 30)];
                        UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-colorSize.width, 5, colorSize.width, 30)];
                        [colorLabel setText:colorStr];
                        [colorLabel setTextAlignment:NSTextAlignmentLeft];
                        [colorLabel setFont:[UIFont systemFontOfSize:10]];
                        [cell.contentView addSubview:colorLabel];
                        
                        
                        NSString *time = [[[detailData.ctems objectAtIndex:indexPath.row-6] objectForKey:@"createDate"] objectForKey:@"time"];
                        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000];
                        NSString *finalTime = [DCFCustomExtra nsdateToString:confromTimesp];
                        NSString *dateStr = [NSString stringWithFormat:@"%@",finalTime];
                        CGSize dateSize;
                        if([DCFCustomExtra validateString:dateStr] == NO)
                        {
                            dateSize = CGSizeMake(0, 30);
                        }
                        else
                        {
                            NSArray *composeArr = [dateStr componentsSeparatedByString:@" "];
                            dateStr = [composeArr objectAtIndex:0];
                            dateSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:10] WithText:dateStr WithSize:CGSizeMake(MAXFLOAT, 30)];
                        }
                        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-20-colorLabel.frame.size.width-dateSize.width, 5, dateSize.width, 30)];
                        [dateLabel setTextAlignment:NSTextAlignmentRight];
                        [dateLabel setText:dateStr];
                        [dateLabel setFont:[UIFont systemFontOfSize:10]];
                        [cell.contentView addSubview:dateLabel];
                    }
                    
                    UILabel *contentLabel  = nil;
                    NSString *judgementContent = [[detailData.ctems objectAtIndex:indexPath.row-6] objectForKey:@"judgementContent"];
                    if([DCFCustomExtra validateString:judgementContent] == YES)
                    {
                        
                        CGSize judgementContentSize;
                        
                        judgementContentSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:judgementContent WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
                        
                        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLabel.frame.origin.y+nameLabel.frame.size.height, ScreenWidth-20, judgementContentSize.height)];
                        [contentLabel setTextAlignment:NSTextAlignmentLeft];
                        [contentLabel setText:judgementContent];
                        [contentLabel setFont:[UIFont systemFontOfSize:12]];
                        [contentLabel setNumberOfLines:0];
                        [cell.contentView addSubview:contentLabel];
                        
                    }
                    else
                    {
                        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,nameLabel.frame.origin.y+nameLabel.frame.size.height, ScreenWidth-20, 0)];
                    }
                    UIView *lineView = [[UIView alloc] init];
                    lineView.frame = CGRectMake(10, contentLabel.frame.origin.y+contentLabel.frame.size.height+4,ScreenWidth-20, 1);
                    lineView.backgroundColor = [UIColor lightGrayColor];
                    [cell.contentView addSubview:lineView];
                    
                }
            }
            else if (indexPath.row == detailData.ctems.count +6)
            {
                return   [self loadShopName:indexPath WithTableView:tableView];
            }
            else if(indexPath.row > detailData.ctems.count + 6)
            {
                if([DCFCustomExtra validateString:detailData.phoneDescribe] == NO)
                {
                    
                }
                else
                {
                    return  [self loadCustomCell:indexPath WithTableView:tableView];
                }
            }
        }
    }
    return cell;
}

#pragma mark - 去除html标签
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

- (void) loadWebView
{
    if([DCFCustomExtra validateString:detailData.phoneDescribe] == NO)
    {
        [tv reloadData];
    }
    else
    {
        cellWebView = [[UIWebView alloc] init];
        cellWebView.delegate = self;
        cellWebView.opaque = NO;
        [cellWebView setScalesPageToFit:YES];
        cellWebView.scrollView.bounces = NO;
        [(UIScrollView *)[[cellWebView subviews] objectAtIndex:0] setBounces:NO];
        [cellWebView setBackgroundColor:[UIColor clearColor]];
//        NSString *jsString = [NSString stringWithFormat:@"<html> "
//                              "<head> "
//                              "<style type=\"text/css\"> "
//                              "body {font-size: %d;color:%@}"
//                              "</style> "
//                              "</head> "
//                              "<body>%@</body> "
//                              "</html>", 13, @"#000000",detailData.phoneDescribe];
        [cellWebView loadHTMLString:detailData.phoneDescribe baseURL:nil];
        
    }
}


//- (void) webViewDidFinishLoad:(UIWebView *)webView
//{
//    const CGFloat defaultWebViewHeight = 22.0;
//    //reset webview size
//    CGRect originalFrame = webView.frame;
//    webView.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, ScreenWidth, defaultWebViewHeight);
//    
//    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
//    
//    if (actualSize.height <= defaultWebViewHeight)
//    {
//        actualSize.height = defaultWebViewHeight;
//    }
//    CGRect webViewFrame = webView.frame;
//    webViewFrame.size.height = actualSize.height;
//    webView.frame = webViewFrame;
//    [tv reloadData];
//}



//webview 自适应高度
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    
    int height = [height_str intValue];
    
    webView.frame = CGRectMake(0,0,ScreenWidth,height-ScreenHeight+20);

    NSLog(@"height: %@", [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]);
    
    [tv reloadData];
}


#pragma mark - 商家自定义内容
- (UITableViewCell *) loadCustomCell:(NSIndexPath *) path WithTableView:(UITableView *) tableview
{
    static NSString *cellId = @"customCellId";
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:0];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
//    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:[self filterHTML:detailData.phoneDescribe] WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size.width, size.height)];
//    [label setFont:[UIFont systemFontOfSize:14]];
//    [label setNumberOfLines:0];
//    [label setText:[self filterHTML:detailData.phoneDescribe]];
//    [cell.contentView addSubview:label];
    
    [cell.contentView addSubview:cellWebView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, cellWebView.frame.origin.y + cellWebView.frame.size.height, cell.frame.size.width, 10);
    lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    [cell.contentView addSubview:lineView];
    return cell;
}


#pragma mark - 商铺名字
- (UITableViewCell *) loadShopName:(NSIndexPath *) path WithTableView:(UITableView *) tableview
{
    static NSString *cellId = @"shopNameCell";
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:0];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    NSString *discuss = detailData.score;
    if(discuss.length != 0)
    {
        UIImageView *firstIv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 30, 30)];
        [firstIv setImage:[UIImage imageNamed:@"shopPic"]];
        
        CGSize size;
        if([DCFCustomExtra validateString:detailData.shopName] == NO)
        {
            size = CGSizeMake(100, 30);
        }
        else
        {
            size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:[detailData shopName] WithSize:CGSizeMake(MAXFLOAT,40)];
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45,0,ScreenWidth-150, 45)];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setText:[detailData shopName]];
        label.numberOfLines = 2;
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:[UIColor blackColor]];
        
        UIImageView *starImageView;
        for (int i = 0; i < 5; i++)
        {
            starImageView = [[UIImageView alloc] init];
            starImageView.frame =CGRectMake((ScreenWidth-103)+20*i, 13, 18, 18);
            starImageView.tag = i;
            [cell.contentView addSubview:starImageView];
            if (statrScore == 5)
            {
                if (starImageView.tag == i)
                {
                    starImageView.image = [UIImage imageNamed:@"star_selected"];
                }
            }
            if (statrScore == 4)
            {
                if (starImageView.tag == 4)
                {
                    starImageView.image = [UIImage imageNamed:@"star_unselect"];
                }
                else
                {
                    starImageView.image = [UIImage imageNamed:@"star_selected"];
                }
            }
            if (statrScore == 3)
            {
                if (starImageView.tag == 3 || starImageView.tag == 4)
                {
                    starImageView.image = [UIImage imageNamed:@"star_unselect"];
                }
                else
                {
                    starImageView.image = [UIImage imageNamed:@"star_selected"];
                }
            }
            if (statrScore == 2)
            {
                if (starImageView.tag == 2 || starImageView.tag == 3 || starImageView.tag == 4)
                {
                    starImageView.image = [UIImage imageNamed:@"star_unselect"];
                }
                else
                {
                    starImageView.image = [UIImage imageNamed:@"star_selected"];
                }
            }
            if (statrScore == 1)
            {
                if (starImageView.tag == 1 || starImageView.tag == 2 || starImageView.tag == 3 || starImageView.tag == 4)
                {
                    starImageView.image = [UIImage imageNamed:@"star_unselect"];
                }
                else
                {
                    starImageView.image = [UIImage imageNamed:@"star_selected"];
                }
            }
            if (statrScore == 0)
            {
                if (starImageView.tag == i)
                {
                    starImageView.image = [UIImage imageNamed:@"star_unselect"];
                }
            }
        }
        
        UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        [firstView addSubview:firstIv];
        [firstView addSubview:label];
        [cell.contentView addSubview:firstView];
        
        UITapGestureRecognizer *tap_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstTap:)];
        [firstView addGestureRecognizer:tap_1];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, firstView.frame.origin.y + firstView.frame.size.height, cell.frame.size.width, 10);
        lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        [cell.contentView addSubview:lineView];
    }
    else
    {
        
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

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - 在线客服
-(void)IMChatClick
{
    if ([self.appDelegate.isConnect isEqualToString:@"连接"])
    {
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        NSString *urlString = [NSString stringWithFormat:@"%@%@@%@",GoodsDetail_URL,producturl,@"家装线商品详情"];
        chatVC.fromStringFlag = urlString;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        transition.type =  kCATransitionMoveIn;
        transition.subtype =  kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:chatVC animated:NO];
    }
    else
    {
        ChatListViewController *chatListVC = [[ChatListViewController alloc] init];
        NSString *urlString = [NSString stringWithFormat:@"%@%@@%@",GoodsDetail_URL,producturl,@"家装线商品详情"];
        chatListVC.fromString = urlString;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        transition.type =  kCATransitionMoveIn;
        transition.subtype =  kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:chatListVC animated:NO];
    }
}

- (void) cellBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    
    if(btn.tag == 1000)
    {
        //        if(btn.selected == YES)
        //        {
        showCell = YES;
        //
        //        }
        //        else
        //        {
        //            showCell = NO;
        //        }
    }
    if(btn.tag == 1001)
    {
        //        if(btn.selected == YES)
        //        {
        showCell = NO;
        //        }
        //        else
        //        {
        //            showCell = YES;
        //        }
    }
    
    //    for(UIButton *btn in cellBtnArray)
    //    {
    //        if(btn.tag == [sender tag])
    //        {
    //
    //        }
    //        else
    //        {
    //            [btn setSelected:NO];
    //        }
    //    }
    
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
            NSString *theColorName = [[detailData.coloritems objectAtIndex:i] objectForKey:@"colorName"];
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
            [btn setTitle:theColorName forState:UIControlStateNormal];
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
                [btn setTitle:@"1" forState:UIControlStateNormal];
                num = @"1";
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
            [btn setEnabled:NO];
            [btn addTarget:self action:@selector(chooseCountClick:) forControlEvents:UIControlEventTouchUpInside];
            [chooseColorAndCountView addSubview:btn];
            [chooseCountBtnArray addObject:btn];
        }
        
        
        sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setFrame:CGRectMake((self.view.frame.size.width-140)/2, 240, 140, 40)];
        [sureBtn setTitle:@"确 认" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:141/255.0 blue:1/255.0 alpha:1];
        [sureBtn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:255/255.0 green:141/255.0 blue:1/255.0 alpha:1] size:CGSizeMake(sureBtn.frame.size.width, sureBtn.frame.size.height)] forState:UIControlStateNormal];
        [sureBtn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(sureBtn.frame.size.width, sureBtn.frame.size.height)] forState:UIControlStateDisabled];
        sureBtn.layer.cornerRadius = 5;
        //        sureBtn.layer.borderColor = [UIColor colorWithRed:255/255.0 green:141/255.0 blue:1/255.0 alpha:1].CGColor;
        //        sureBtn.layer.borderWidth = 1.0f;
        sureBtn.layer.masksToBounds = YES;
        sureBtn.enabled = NO;
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
        for(UIButton *b in chooseCountBtnArray)
        {
            [b setEnabled:YES];
        }
        [sureBtn setEnabled:YES];
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
        for(UIButton *b in chooseCountBtnArray)
        {
            [b setEnabled:NO];
        }
        
        [sureBtn setEnabled:NO];
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

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int index = buttonIndex;
    if(index == 0)
    {
        
    }
    else
    {
        sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
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
            
            memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];

                NSString *time = [DCFCustomExtra getFirstRunTime];
                
                NSString *string = [NSString stringWithFormat:@"%@%@",@"DirectBuy",time];
                
                NSString *token = [DCFCustomExtra md5:string];
                
                
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
            
            memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
            
            BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
            
            conn = [[DCFConnectionUtil alloc] initWithURLTag:URLAddToShopCatTag delegate:self];
            
            NSString *pushString = nil;
            
            if(hasLogin == YES)
            {
                arr = [[NSArray alloc] initWithObjects:shopid,productid,itemid,num,token,memberid, nil];
                pushString = [NSString stringWithFormat:@"shopid=%@&productid=%@&itemid=%@&num=%@&token=%@&memberid=%@",shopid,productid,itemid,num,token,memberid];
            }
            else
            {
                arr = [[NSArray alloc] initWithObjects:shopid,productid,itemid,num,token,visitorid, nil];
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
        [self loadShopCarCount];
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
