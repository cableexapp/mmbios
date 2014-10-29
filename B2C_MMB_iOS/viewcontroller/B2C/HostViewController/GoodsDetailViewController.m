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
    
    float chooseColorPrice;
}
@end

@implementation GoodsDetailViewController

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
    if(num.length == 0 || [num intValue] == 0)
    {
        [DCFStringUtil showNotice:@"请选择数量"];
        return;
    }
    if(itemid.length == 0)
    {
        [DCFStringUtil showNotice:@"请选择颜色"];
        return;
    }
    
    [self setHidesBottomBarWhenPushed:YES];
    int tag = [sender tag];

    
    if(tag == 100)
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
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    num = @"0";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    showCell = YES;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:227.0/255.0 blue:235.0/255.0 alpha:1.0]];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装线商品详情"];
    self.navigationItem.titleView = top;
    
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-50-64, 320, 50)];
    [buttomView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:buttomView];
    
    for(int i=0;i<2;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(210*i + 5, 5, 100, 40)];
        if(i == 0)
        {
            [btn setTitle:@"立即购买" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor blueColor].CGColor;
            btn.layer.borderWidth = 1.0f;
            btn.layer.cornerRadius = 5;
        }
        if(i == 1)
        {
            [btn setTitle:@"加入购物车" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor redColor].CGColor;
            btn.layer.borderWidth = 1.0f;
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
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320,  ScreenHeight-50-64) style:0];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:227.0/255.0 blue:235.0/255.0 alpha:1.0]];
    [self.view addSubview:tv];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"shoppingCar.png"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"shoppingCar.png"] forState:UIControlStateHighlighted];
    [rightBtn setFrame:CGRectMake(0, 5, 34, 34)];
    [rightBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    
    
    cellBtnArray = [[NSMutableArray alloc] init];
    
    
    
    
}


- (void) loadRequest
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductDetail",time];
    
    NSString *token = [DCFCustomExtra md5:string];
    
    //    NSString *pushString = [NSString stringWithFormat:@"productid=%@&token=%@",_productid,token];
    NSString *pushString = [NSString stringWithFormat:@"productid=%@&token=%@",@"144",token];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getProductDetail.html?"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2CProductDetailTag delegate:self];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLB2CProductDetailTag)
    {
        int result = [[dicRespon objectForKey:@"result"] intValue];
        NSString *msg = [dicRespon objectForKey:@"msg"];
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
        NSLog(@"%@",dicRespon);
        
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            
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

            float totalMoney = [num intValue]*chooseColorPrice;
            UpOrderViewController *order = [[UpOrderViewController alloc] initWithDataArray:chooseGoodsArray WithMoney:totalMoney WithOrderData:orderData WithTag:0];
            [self.navigationController pushViewController:order animated:YES];

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
        return 160;
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
            return label.frame.size.height + 10;
        }
        
    }
    if(indexPath.row == 2 || indexPath.row == 3 ||indexPath.row == 5 )
    {
        return 44;
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
            return 44;
        }
    }
    if(indexPath.row == 6)
    {
        if(showCell == YES)
        {
            return 169;
        }
        else
        {
            return 0;
        }
        
    }
    if (indexPath.row > 6)
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
                    CGSize size_4 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s4 WithSize:CGSizeMake(320, MAXFLOAT)];
                    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, size_4.height)];
                    [contentLabel setText:s4];
                    [contentLabel setFont:[UIFont systemFontOfSize:12]];
                    [contentLabel setNumberOfLines:0];
                    return contentLabel.frame.size.height+30;
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
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:229.0/255.0 blue:240.0/255.0 alpha:1.0]];
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
            es = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, 320, 160) ImageArray:imageArray TitleArray:nil WithTag:1];
            es.delegate = self;
            [cell.contentView addSubview:es];
        }
        if(indexPath.row == 1)
        {
            if(detailData.goodsName.length != 0)
            {
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:detailData.goodsName WithSize:CGSizeMake(300, MAXFLOAT)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, size.height)];
                [label setText:detailData.goodsName];
                [label setNumberOfLines:0];
                [label setFont:[UIFont systemFontOfSize:13]];
                [label setTextAlignment:NSTextAlignmentLeft];
                [label setTextColor:[UIColor blackColor]];
                [cell.contentView addSubview:label];
                [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            }
            else
            {
                
            }
            
            
        }
        if(indexPath.row == 2)
        {
            if(detailData.productPrice.length != 0)
            {
                CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"价格" WithSize:CGSizeMake(MAXFLOAT, 30)];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size_1.width, 30)];
                [label setText:@"价格"];
                [label setFont:[UIFont systemFontOfSize:12]];
                [label setTextAlignment:NSTextAlignmentLeft];
                [cell.contentView addSubview:label];
                
                CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:detailData.productPrice WithSize:CGSizeMake(MAXFLOAT, 30)];
                
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 20, 5, size_2.width, 30)];
                [priceLabel setTextAlignment:NSTextAlignmentLeft];
                [priceLabel setText:detailData.productPrice];
                [priceLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:priceLabel];
                
                CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"运费5元" WithSize:CGSizeMake(MAXFLOAT, 30)];
                UILabel *tradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-size_3.width-10, 5, size_3.width, 30)];
                [tradeLabel setText:@"运费5元"];
                [tradeLabel setTextAlignment:NSTextAlignmentRight];
                [tradeLabel setTextColor:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0]];
                [tradeLabel setFont:[UIFont systemFontOfSize:12]];
                //            [cell.contentView addSubview:tradeLabel];
            }
            else
            {
                
            }
            
            
        }
        if(indexPath.row == 3)
        {
            [cell.textLabel setText:@"颜色分类"];
            [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
        }
        if(indexPath.row == 4)
        {
            NSString *discuss = detailData.score;
            if(discuss.length != 0)
            {
                UIImageView *firstIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                [firstIv setImage:[UIImage imageNamed:@"magnifying glass.png"]];
                
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:[detailData shopName] WithSize:CGSizeMake(MAXFLOAT,30)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, size.width, 30)];
                [label setFont:[UIFont systemFontOfSize:12]];
                [label setText:[detailData shopName]];
                [label setTextAlignment:NSTextAlignmentLeft];
                [label setTextColor:[UIColor blueColor]];
                
                UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, label.frame.size.width+40, 30)];
                [firstView addSubview:firstIv];
                [firstView addSubview:label];
                [cell.contentView addSubview:firstView];
                
                UITapGestureRecognizer *tap_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstTap:)];
                [firstView addGestureRecognizer:tap_1];
                
                
                UIImageView *chatIv = [[UIImageView alloc] initWithFrame:CGRectMake(320-40, 7, 30, 30)];
                [chatIv setUserInteractionEnabled:YES];
                [chatIv setImage:[UIImage imageNamed:@"magnifying glass.png"]];
                
                UITapGestureRecognizer *chatTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatTap:)];
                [chatIv addGestureRecognizer:chatTap];
                [cell.contentView addSubview:chatIv];
            }
            else
            {
                
            }
            
            
            
        }
        if(indexPath.row == 5)
        {
            for(int i = 0;i < 2;i++)
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(10+100*i, 5, 100, 34)];
                if(i == 0)
                {
                    if(showCell == YES)
                    {
                        [btn setSelected:YES];
                    }
                    else
                    {
                        [btn setSelected:NO];
                    }
                    [btn setTitle:@"商品详情" forState:UIControlStateNormal];
                }
                else if (i == 1)
                {
                    if(showCell == YES)
                    {
                        [btn setSelected:NO];
                    }
                    else
                    {
                        [btn setSelected:YES];
                    }
                    [btn setTitle:@"商品评价" forState:UIControlStateNormal];
                }
                [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                
                [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor blueColor] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
                
                [btn setTag:1000+i];
                
                [btn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                [cellBtnArray addObject:btn];
                
                [cell.contentView addSubview:btn];
                
            }
        }
        if(indexPath.row == 6)
        {
            
            if(showCell == YES)
            {
                GoodsDetailTableViewCell *customCell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsDetailTableViewCell" owner:self options:nil] lastObject];
                
                [customCell.barndLabel setText:detailData.goodsBrand];
                [customCell.kindLabel setText:detailData.goodsModel];
                [customCell.voltageLabel setText:detailData.goodsVoltage];
                [customCell.surfaceLabel setText:detailData.spec];
                [customCell.useLabel setText:detailData.use];
                [customCell.threadLabel setText:detailData.coreNum];
                [customCell.standLabel setText:detailData.standard];
                [customCell.unitLabel setText:detailData.unit];
                [customCell.thicknessLabel setText:detailData.insulationThickness];
                [customCell.lengthLabel setText:detailData.avgLength];
                [customCell.topLabel setText:detailData.avgDiameter];
                [customCell.weightLabel setText:detailData.weight];
                
                return customCell;
                
            }
            else
            {
                
            }
            
            
        }
        if(indexPath.row > 6)
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
                        [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
                        [moreCell noDataAnimation];
                    }
                    return moreCell;
                }
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
                [view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
                [cell.contentView addSubview:view];
                
                NSString *s1 = [[detailData.ctems objectAtIndex:indexPath.row-7] objectForKey:@"loginName"];
                if(s1.length != 0)
                {
                    CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s1 WithSize:CGSizeMake(MAXFLOAT, 30)];
                    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, size_1.width, 30)];
                    [nameLabel setText:s1];
                    [nameLabel setTextAlignment:NSTextAlignmentLeft];
                    [nameLabel setFont:[UIFont systemFontOfSize:12]];
                    [nameLabel setTextColor:[UIColor colorWithRed:147.0/255.0 green:140.0/255.0 blue:154.0/255.0 alpha:1.0]];
                    [view addSubview:nameLabel];
                    
                    NSString *month = [[[detailData.ctems objectAtIndex:indexPath.row-7] objectForKey:@"createDate"] objectForKey:@"month"];
                    NSString *finalMonth = [NSString stringWithFormat:@"%d",[month intValue] + 1];
                    NSString *date = [[[detailData.ctems objectAtIndex:indexPath.row-7] objectForKey:@"createDate"] objectForKey:@"date"];
                    NSString *s2 = [NSString stringWithFormat:@"评价日期:%@.%@",finalMonth,date];
                    CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s2 WithSize:CGSizeMake(MAXFLOAT, 30)];
                    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 20, 0, size_2.width, 30)];
                    [dateLabel setTextAlignment:NSTextAlignmentCenter];
                    [dateLabel setText:s2];
                    [dateLabel setFont:[UIFont systemFontOfSize:12]];
                    [view addSubview:dateLabel];
                    
                    NSString *color = [[detailData.ctems objectAtIndex:indexPath.row-7] objectForKey:@"colorName"];
                    NSString *s3 = [NSString stringWithFormat:@"颜色分类:%@",color];
                    CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s3 WithSize:CGSizeMake(MAXFLOAT, 30)];
                    UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-10-size_3.width, 0, size_3.width, 30)];
                    [colorLabel setText:s3];
                    [colorLabel setTextAlignment:NSTextAlignmentLeft];
                    [colorLabel setFont:[UIFont systemFontOfSize:12]];
                    [view addSubview:colorLabel];
                    
                    NSString *s4 = [[detailData.ctems objectAtIndex:indexPath.row-7] objectForKey:@"judgementContent"];
                    CGSize size_4 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s4 WithSize:CGSizeMake(320, MAXFLOAT)];
                    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, size_4.height)];
                    [contentLabel setTextAlignment:NSTextAlignmentLeft];
                    [contentLabel setText:s4];
                    [contentLabel setFont:[UIFont systemFontOfSize:12]];
                    [contentLabel setNumberOfLines:0];
                    [contentLabel setBackgroundColor:[UIColor whiteColor]];
                    [cell.contentView addSubview:contentLabel];
                }
                
                else
                {
                    
                }
                
            }
        }
    }
    //    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
    //        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    //    }
    
    
    return cell;
}

- (void) firstTap:(UITapGestureRecognizer *) sender
{
    UILabel *label = (UILabel *)[[[sender view] subviews] lastObject];
    
//    ShopHostTableViewController *shopHost = [[ShopHostTableViewController alloc] initWithHeadTitle:label.text];
    [self setHidesBottomBarWhenPushed:YES];
    ShopHostTableViewController *shopHost = [[ShopHostTableViewController alloc] initWithHeadTitle:detailData.shopName WithShopId:detailData.shopId WithUse:@""];

    [self.navigationController pushViewController:shopHost animated:YES];
}

- (void) starViewTap:(UITapGestureRecognizer *) sender
{
}

- (void) chatTap:(UITapGestureRecognizer *) sender
{
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
    //    [tv setContentSize:CGSizeMake(320, MAXFLOAT)];
    //    [tv setFrame:CGRectMake(0, 0, 320, ScreenHeight - 64)];
    //    [tv setFrame:tableView.bounds];
    //    NSLog(@"%f  %f",tv.frame.origin.y,tv.frame.size.height);
    [tv reloadData];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3)
    {
        //        [self.view.window setBackgroundColor:[UIColor blackColor]];
        //        [self.view.window setAlpha:0.4];
        [self.view.window addSubview:[self loadChooseColorAndCount]];
        //        [self loadChooseColorAndCount];
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
        colorLabelArray = [[NSMutableArray alloc] init];
        
        chooseColorBtnArray = [[NSMutableArray alloc] init];
        
        chooseCountBtnArray = [[NSMutableArray alloc] init];
        
        chooseColorAndCountView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-220, 320, 290)];
        [chooseColorAndCountView setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        //        [iv setImage:[UIImage imageNamed:@"cabel.png"]];
        [iv setImage:cabelImage];
        [chooseColorAndCountView addSubview:iv];
        
        
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setFrame:CGRectMake(320-10-50, 30, 50, 50)];
        [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [closeBtn setTitle:@"关闭x" forState:UIControlStateNormal];
        [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [chooseColorAndCountView addSubview:closeBtn];
        
        UILabel *colorKindLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, iv.frame.origin.y+iv.frame.size.height+20, 200, 20)];
        [colorKindLabel setText:@"颜色分类"];
        [colorKindLabel setFont:[UIFont systemFontOfSize:12]];
        [colorKindLabel setBackgroundColor:[UIColor clearColor]];
        [colorKindLabel setTextAlignment:NSTextAlignmentLeft];
        [chooseColorAndCountView addSubview:colorKindLabel];
        
        for(int i = 0;i < detailData.coloritems.count;i++)
        {
            NSString *colorName = [[detailData.coloritems objectAtIndex:i] objectForKey:@"colorName"];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
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
                [btn setSelected:YES];
            }
            [btn setTitle:colorName forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor blueColor] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
            
            btn.layer.borderColor = [UIColor blueColor].CGColor;
            btn.layer.borderWidth = 0.5f;
            btn.layer.masksToBounds = YES;
            
            [btn setTag:i];
            
            [btn addTarget:self action:@selector(chooseColorClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [chooseColorBtnArray addObject:btn];
            
            [chooseColorAndCountView addSubview:btn];
            
        }
        
        for(int i=0;i<3;i++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x +iv.frame.size.width + 10, 5 + 25*i, 160, 20)];
            [label setFont:[UIFont systemFontOfSize:12]];
            switch (i) {
                case 0:
                {
                    NSString *colorName = [[detailData.coloritems objectAtIndex:0] objectForKey:@"colorName"];
                    [label setText:[NSString stringWithFormat:@"已选颜色:%@",colorName]];
                    break;
                }
                case 1:
                {
                    NSString *colorPrice = [[detailData.coloritems objectAtIndex:0] objectForKey:@"colorPrice"];
                    NSString *s = [NSString stringWithFormat:@"价格:¥%@",colorPrice];
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:s];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, s.length-3)];
                    [label setAttributedText:str];
                    break;
                }
                case 2:
                {
                    NSString *productNum = [NSString stringWithFormat:@"%@",[[detailData.coloritems objectAtIndex:0] objectForKey:@"productNum"]];
                    [label setText:[NSString stringWithFormat:@"库存%@",productNum]];
                    [label setTextColor:[UIColor lightGrayColor]];
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
        
        itemid = [NSString stringWithFormat:@"%@",[[detailData.coloritems objectAtIndex:0] objectForKey:@"recordId"]];
        
        UILabel *chooseCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 80, 20)];
        [chooseCountLabel setText:@"购买数量"];
        [chooseCountLabel setTextAlignment:NSTextAlignmentLeft];
        [chooseCountLabel setBackgroundColor:[UIColor clearColor]];
        [chooseCountLabel setFont:[UIFont systemFontOfSize:12]];
        [chooseColorAndCountView addSubview:chooseCountLabel];
        
        for(int i=0;i<3;i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if(i == 0)
            {
                [btn setFrame:CGRectMake(150, chooseCountLabel.frame.origin.y, 20, 20)];
                [btn setTitle:@"-" forState:UIControlStateNormal];
            }
            if(i == 1)
            {
                [btn setFrame:CGRectMake(180, chooseCountLabel.frame.origin.y, 60, 20)];
                [btn setTitle:@"0" forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:10]];
                [btn setUserInteractionEnabled:NO];
            }
            if(i == 2)
            {
                [btn setFrame:CGRectMake(250, chooseCountLabel.frame.origin.y, 20, 20)];
                [btn setTitle:@"+" forState:UIControlStateNormal];
            }
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.layer.borderWidth = 0.5f;
            btn.layer.borderColor = [UIColor blackColor].CGColor;
            [btn setTag:10+i];
            [btn addTarget:self action:@selector(chooseCountClick:) forControlEvents:UIControlEventTouchUpInside];
            [chooseColorAndCountView addSubview:btn];
            [chooseCountBtnArray addObject:btn];
        }
        
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setFrame:CGRectMake((320-120)/2, 240, 120, 40)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.layer.borderColor = [UIColor blueColor].CGColor;
        sureBtn.layer.borderWidth = 1.0f;
        sureBtn.layer.cornerRadius = 5;
        [chooseColorAndCountView addSubview:sureBtn];
        
        NSString *colorPrice = [NSString stringWithFormat:@"%@",[[detailData.coloritems objectAtIndex:0] objectForKey:@"colorPrice"]];
        chooseColorPrice = [colorPrice floatValue];
        return chooseColorAndCountView;
    }
    
    return nil;
}

- (void) closeBtnClick:(UIButton *) sender
{
    if(chooseColorAndCountView)
    {
        [chooseColorAndCountView removeFromSuperview];
        chooseColorAndCountView = nil;
    }
}

- (void) chooseColorClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    
    int tag = btn.tag;
    NSString *colorName = [[detailData.coloritems objectAtIndex:tag] objectForKey:@"colorName"];
    NSString *colorPrice = [NSString stringWithFormat:@"%@",[[detailData.coloritems objectAtIndex:tag] objectForKey:@"colorPrice"]];
    NSString *productNum = [NSString stringWithFormat:@"%@",[[detailData.coloritems objectAtIndex:tag] objectForKey:@"productNum"]];
    
    for(int i=0; i< 3; i++)
    {
        UILabel *label = (UILabel *)[colorLabelArray objectAtIndex:i];
        if(i == 0)
        {
            [label setText:[NSString stringWithFormat:@"已选颜色:%@",colorName]];
        }
        if(i == 1)
        {
            NSString *s = [NSString stringWithFormat:@"价格:¥%@",colorPrice];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:s];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, s.length-3)];
            [label setAttributedText:str];
        }
        if(i == 2)
        {
            [label setText:[NSString stringWithFormat:@"库存%@",productNum]];
        }
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
    
    itemid = [NSString stringWithFormat:@"%@",[[detailData.coloritems objectAtIndex:tag] objectForKey:@"recordId"]];
    
    chooseColorPrice = [colorPrice floatValue];
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
}

- (void) sureBtnClick:(UIButton *) sender
{
    if(chooseColorAndCountView)
    {
        [chooseColorAndCountView removeFromSuperview];
        chooseColorAndCountView = nil;
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
