//
//  GoodsPicFastViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-24.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "GoodsPicFastViewController.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "UIImageView+WebCache.h"
#import "DCFStringUtil.h"
#import "DCFCustomExtra.h"
#import "B2CGoodsFastPicData.h"
#import "DCFChenMoreCell.h"
#import "DCFTopLabel.h"
#import "GoodsFastPicTableViewCell.h"
#import "ShopHostTableViewController.h"
#import "ChatListViewController.h"
#import "GoodsDetailViewController.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "GoodsDetailTableViewCell.h"
#import "B2CGoodsDetailData.h"

#define GoodsDetail_URL @"http://mmb.fgame.com:8083/"

@interface GoodsPicFastViewController ()
{
    NSMutableArray *dataArray;
    B2CGoodsFastPicData *data;
    
    DCFChenMoreCell *moreCell;
    
    B2CGoodsDetailData *detailData;
    
    NSString *producturl;//商品链接地址
    
    int statrScore;
}
@end

@implementation GoodsPicFastViewController

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
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-50-64)];
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tv setDataSource:self];
    [tv setDelegate:self];
    //    tv.backgroundColor = [UIColor greenColor];
    [tv setShowsHorizontalScrollIndicator:NO];
    [tv setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:tv];
    
    self.buttomBtn.layer.cornerRadius = 5;
    [self.buttomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装线商品快照"];
    self.navigationItem.titleView = top;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    [self getProductSnap];
    [self getProductDetail];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
}

-(void)getProductSnap
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductSnap",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&snapid=%@",token,self.mySnapId];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetProductSnapTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getProductSnap.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
}

-(void)getProductDetail
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductDetail",time];
    
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"productid=%@&token=%@",_myProductId,token];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getProductDetail.html?"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2CProductDetailTag delegate:self];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    if(URLTag == URLGetProductSnapTag)
    {
        if(result == 1)
        {
            if([[dicRespon objectForKey:@"items"] isKindOfClass:[NSNull class]] || [[dicRespon objectForKey:@"items"] count] == 0)
            {
                [moreCell noDataAnimation];
            }
            else
            {
                [moreCell stopAnimation];
                dataArray = [[NSMutableArray alloc] initWithArray:[B2CGoodsFastPicData getListArray:[dicRespon objectForKey:@"items"]]];
                data = [dataArray lastObject];
                
            }
            [tv reloadData];
        }
        else
        {
            [moreCell failAcimation];
        }
        
        //        NSString *time = [DCFCustomExtra getFirstRunTime];
        //
        //        NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductDetail",time];
        //
        //        NSString *token = [DCFCustomExtra md5:string];
        //
        //        NSString *pushString = [NSString stringWithFormat:@"productid=%@&token=%@",_myProductId,token];
        //
        //        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getProductDetail.html?"];
        //        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2CProductDetailTag delegate:self];
        //        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    }
    else if(URLTag == URLB2CProductDetailTag)
    {
        int totalProductNumber = 0;
        int isSale = 0;
        
        if(result == 1)
        {
            detailData = [[B2CGoodsDetailData alloc] init];
            [detailData dealData:dicRespon];
            
            
            if ([[dicRespon objectForKey:@"score"] count] > 0)
            {
                statrScore = ([[[dicRespon objectForKey:@"score"] objectAtIndex:0] intValue]+[[[dicRespon objectForKey:@"score"] objectAtIndex:1] intValue]+[[[dicRespon objectForKey:@"score"] objectAtIndex:2] intValue]+[[[dicRespon objectForKey:@"score"] objectAtIndex:3] intValue])/4;
                
            }
            
            producturl = [dicRespon objectForKey:@"producturl"];
            
            [tv reloadData];
            
            NSArray *coloritems = [NSArray arrayWithArray:[dicRespon objectForKey:@"coloritems"]];
            if(coloritems.count == 0 || [coloritems isKindOfClass:[NSNull class]])
            {
                totalProductNumber = 0;
            }
            else
            {
                for(NSDictionary *dic in coloritems)
                {
                    int productNum = [[dic objectForKey:@"productNum"] intValue];
                    totalProductNumber = totalProductNumber + productNum;
                }
            }
            
            NSArray *itemsArray = [NSArray arrayWithArray:[dicRespon objectForKey:@"items"]];
            if(itemsArray.count == 0 || [itemsArray isKindOfClass:[NSNull class]])
            {
                isSale = 0;
            }
            else
            {
                NSDictionary *itemsDic = [itemsArray objectAtIndex:0];
                //1表示上架，其余表示下架
                if([[itemsDic objectForKey:@"isSale"] intValue] == 1)
                {
                    isSale = 1;
                }
                else
                {
                    isSale = 0;
                }
            }
        }
        else
        {
            
        }
        [self changeButtomBtnWithNumber:totalProductNumber WithSale:isSale];
        
    }
}

- (void) changeButtomBtnWithNumber:(int) number WithSale:(int) sale
{
    if(sale != 1)
    {
        [self.buttomBtn setTitle:@"该商品已下架" forState:UIControlStateNormal];
        [self.buttomBtn setEnabled:NO];
        return;
    }
    if(number == 0)
    {
        [self.buttomBtn setTitle:@"该商品已售罄" forState:UIControlStateNormal];
        [self.buttomBtn setEnabled:NO];
        return;
    }
    [self.buttomBtn setTitle:@"查看最新商品详情" forState:UIControlStateNormal];
    [self.buttomBtn setEnabled:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 1;
    }
    return 7;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        return 44;
    }
    else
    {
        if(indexPath.row == 0)
        {
            return 160;
        }
        if(indexPath.row == 1)
        {
            if([data.productName length] == 0)
            {
                return 0;
            }
            else
            {
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:data.productName WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
                return size.height + 10;
            }
            
        }
        if(indexPath.row == 2  || indexPath.row == 4 )
        {
            return 44;
        }
        if (indexPath.row == 3 ||indexPath.row == 6 )
        {
            return 54;
        }
        if(indexPath.row == 5)
        {
            return 160;
        }
    }
    return 0;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellId = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        [cell setSelectionStyle:0];
        
        if(!dataArray || dataArray.count == 0)
        {
            
        }
        else
        {
            if(indexPath.row == 0)
            {
                UIImageView *cellIv = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-140)/2, 10, 140, 140)];
                NSString *picStr = [data productItemPic];
                NSURL *picUrl = [NSURL URLWithString:picStr];
                [cellIv setImageWithURL:picUrl placeholderImage:[UIImage imageNamed:@"cabel.png"]];
                [cell.contentView addSubview:cellIv];
                
                UIView *lineView = [[UIView alloc] init];
                lineView.frame = CGRectMake(0, 155, ScreenWidth, 0.5);
                lineView.backgroundColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:lineView];
            }
            if(indexPath.row == 1)
            {
                if(data.productName.length != 0)
                {
                    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:data.productName WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, ScreenWidth-20, size.height)];
                    [label setText:data.productName];
                    [label setNumberOfLines:0];
                    [label setFont:[UIFont systemFontOfSize:15]];
                    [label setTextAlignment:NSTextAlignmentLeft];
                    [label setTextColor:[UIColor blackColor]];
                    [cell.contentView addSubview:label];
                    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
                    
                    UIView *lineView = [[UIView alloc] init];
                    lineView.frame = CGRectMake(10, size.height+20, ScreenWidth-20, 0.5);
                    lineView.backgroundColor = [UIColor lightGrayColor];
                    [cell.contentView addSubview:lineView];
                }
                else
                {
                    
                }
            }
            if(indexPath.row == 2)
            {
                if(data.price.length != 0)
                {
                    CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:data.price WithSize:CGSizeMake(MAXFLOAT, 30)];
                    
                    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 13.5,ScreenWidth-25, 30)];
                    [priceLabel setTextAlignment:NSTextAlignmentLeft];
                    [priceLabel setText:[NSString stringWithFormat:@"¥ %@",data.price]];
                    priceLabel.textColor = [UIColor redColor];
                    [priceLabel setFont:[UIFont systemFontOfSize:15]];
                    [cell.contentView addSubview:priceLabel];
                    
                    CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:@"运费5元" WithSize:CGSizeMake(MAXFLOAT, 30)];
                    UILabel *tradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-size_3.width-10, 5, size_3.width, 30)];
                    [tradeLabel setText:@"运费5元"];
                    [tradeLabel setTextAlignment:NSTextAlignmentRight];
                    [tradeLabel setTextColor:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0]];
                    [tradeLabel setFont:[UIFont systemFontOfSize:12]];
                    //            [cell.contentView addSubview:tradeLabel];
                    
                    UIView *lineView = [[UIView alloc] init];
                    lineView.frame = CGRectMake(0, size_2.height+30, ScreenWidth, 0.5);
                    lineView.backgroundColor = [UIColor lightGrayColor];
                    [cell.contentView addSubview:lineView];
                }
                else
                {
                    
                }
            }
            if(indexPath.row == 3)
            {
                if(data.color.length != 0)
                {
                    
                    CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:data.color WithSize:CGSizeMake(MAXFLOAT, 30)];
                    
                    UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 13.5,ScreenWidth-25, 30)];
                    [colorLabel setTextAlignment:NSTextAlignmentLeft];
                    colorLabel.text = [NSString stringWithFormat:@"颜色分类:%@",data.color];
                    [colorLabel setFont:[UIFont systemFontOfSize:15]];
                    [cell.contentView addSubview:colorLabel];
                    
                    UIView *lineView = [[UIView alloc] init];
                    lineView.frame = CGRectMake(0, size_2.height+30, ScreenWidth, 10);
                    lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
                    [cell.contentView addSubview:lineView];
                }
                else
                {
                    
                }
            }
            if(indexPath.row == 6)
            {
                if(self.myShopName.length != 0)
                {
                    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:self.myShopName WithSize:CGSizeMake(MAXFLOAT,40)];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45,5,ScreenWidth-150, 44)];
                    [label setFont:[UIFont systemFontOfSize:14]];
                    [label setText:self.myShopName];
                    label.numberOfLines = 2;
                    [label setTextAlignment:NSTextAlignmentLeft];
                    [label setTextColor:[UIColor blackColor]];
                    
                    UIImageView *starImageView;
                    for (int i = 0; i < 5; i++)
                    {
                        starImageView = [[UIImageView alloc] init];
                        starImageView.frame =CGRectMake((ScreenWidth-103)+20*i, 18.5, 18, 18);
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
                    
                    
                    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,cell.frame.size.height)];
                    [cell.contentView addSubview:firstView];
                    
                    UIImageView *firstIv = [[UIImageView alloc] initWithFrame:CGRectMake(12, (cell.frame.size.height-14)/2, 30, 30)];
                    [firstIv setImage:[UIImage imageNamed:@"shopPic"]];
                    
                    
                    [firstView addSubview:firstIv];
                    [firstView addSubview:label];
                    
                    
                    UITapGestureRecognizer *tap_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstTap:)];
                    [firstView addGestureRecognizer:tap_1];
                    
                    
                    //                    UIImageView *chatIv = [[UIImageView alloc] initWithFrame:CGRectMake(320-40, 7, 30, 30)];
                    //                    [chatIv setUserInteractionEnabled:YES];
                    //                    [chatIv setImage:[UIImage imageNamed:@"magnifying glass.png"]];
                    //
                    //                    UITapGestureRecognizer *chatTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatTap:)];
                    //                    [chatIv addGestureRecognizer:chatTap];
                    //                    [cell.contentView addSubview:chatIv];
                    
                    UIView *lineView = [[UIView alloc] init];
                    lineView.frame = CGRectMake(0, size.height+30, ScreenWidth, 10);
                    lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
                    [cell.contentView addSubview:lineView];
                }
                else
                {
                    
                }
                
            }
            if(indexPath.row == 4)
            {
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 140, 30)];
                [label setFont:[UIFont systemFontOfSize:15]];
                [label setText:@"商品参数"];
                [label setTextAlignment:NSTextAlignmentLeft];
                [label setTextColor:[UIColor blackColor]];
                [cell.contentView addSubview:label];
                
                UIView *lineView = [[UIView alloc] init];
                lineView.frame = CGRectMake(0, 43.5, ScreenWidth, 0.5);
                lineView.backgroundColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:lineView];
            }
            if(indexPath.row == 5)
            {
                //                GoodsFastPicTableViewCell *customCell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsFastPicTableViewCell" owner:self options:nil] lastObject];
                //
                //                [customCell.brandLabel setText:data.brand];
                //
                //                [customCell.colorLabel setText:data.color];
                //
                //                [customCell.freightPriceLabel setText:data.freightPrice];
                //
                //                [customCell.modelLabel setText:data.model];
                //
                //                [customCell.useLabel setText:data.range];
                //
                //                [customCell.specLabel setText:data.spec];
                //
                //                [customCell.voltageLabel setText:data.voltage];
                
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
                
                customCell.contentView.backgroundColor = [UIColor whiteColor];
                
                UIView *lineView = [[UIView alloc] init];
                lineView.frame = CGRectMake(0, customCell.frame.size.height, ScreenWidth, 10);
                lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
                [customCell.contentView addSubview:lineView];
                
                return customCell;
            }
            else
            {
                
            }
        }
    }
    return cell;
}


- (void) firstTap:(UITapGestureRecognizer *) sender
{
    //    UILabel *label = (UILabel *)[[[sender view] subviews] lastObject];
    //
    //   [self setHidesBottomBarWhenPushed:YES];
    ShopHostTableViewController *shopHost = [[ShopHostTableViewController alloc] initWithHeadTitle:self.myShopName WithShopId:self.myShopId WithUse:@""];
    [self.navigationController pushViewController:shopHost animated:YES];
}


- (void) chatTap:(UITapGestureRecognizer *) sender
{
    
}


- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)buttomBtn:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    GoodsDetailViewController *detail = [[GoodsDetailViewController alloc] initWithProductId:self.myProductId];
    [self.navigationController pushViewController:detail animated:YES];
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - 在线客服
- (IBAction)chatBtn:(id)sender
{
    if ([self.appDelegate.isConnect isEqualToString:@"连接"])
    {
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        NSString *urlString = [NSString stringWithFormat:@"%@%@@%@",GoodsDetail_URL,producturl,@"商品快照在线客服"];
        chatVC.fromStringFlag = urlString;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        transition.type =  kCATransitionMoveIn;
        transition.subtype =  kCATransitionFromTop;
        transition.delegate = self;
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:chatVC animated:NO];
    }
    else
    {
        ChatListViewController *chatVC = [[ChatListViewController alloc] init];
        NSString *urlString = [NSString stringWithFormat:@"%@%@@%@",GoodsDetail_URL,producturl,@"商品快照在线客服"];
        chatVC.fromString = urlString;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type =  kCATransitionMoveIn;
        transition.subtype =  kCATransitionFromTop;
        transition.delegate = self;
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:chatVC animated:NO];
    }
    [self setHidesBottomBarWhenPushed:NO];
}

@end
