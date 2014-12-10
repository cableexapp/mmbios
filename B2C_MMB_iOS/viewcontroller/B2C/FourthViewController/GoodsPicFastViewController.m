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

@interface GoodsPicFastViewController ()
{
    NSMutableArray *dataArray;
    B2CGoodsFastPicData *data;
    
    DCFChenMoreCell *moreCell;
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
    [tv setShowsHorizontalScrollIndicator:NO];
    [tv setShowsVerticalScrollIndicator:NO];
    [self.tableBackView addSubview:tv];
    
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装线快照"];
    self.navigationItem.titleView = top;
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductSnap",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&snapid=%@",token,self.mySnapId];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetProductSnapTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getProductSnap.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    // Do any additional setup after loading the view.
    
    [moreCell startAnimation];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLGetProductSnapTag)
    {
        int result = [[dicRespon objectForKey:@"result"] intValue];
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
                
                NSLog(@"商品快照 = %@",dicRespon);
                
                NSLog(@"商品快照data = %@",data);
            }
            [tv reloadData];
        }
        else
        {
            [moreCell failAcimation];
        }
    }
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
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:data.productName WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
                return size.height + 10;
            }
            
        }
        if(indexPath.row == 2  || indexPath.row == 5 )
        {
            return 44;
        }
        if (indexPath.row == 3 ||indexPath.row == 4 )
        {
            return 54;
        }
        if(indexPath.row == 6)
        {
            return 117;
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
                    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:data.productName WithSize:CGSizeMake(300, MAXFLOAT)];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, ScreenWidth-20, size.height)];
                    [label setText:data.productName];
                    [label setNumberOfLines:0];
                    [label setFont:[UIFont systemFontOfSize:15]];
                    [label setTextAlignment:NSTextAlignmentLeft];
                    [label setTextColor:[UIColor blackColor]];
                    [cell.contentView addSubview:label];
                    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
                    
                    UIView *lineView = [[UIView alloc] init];
                    lineView.frame = CGRectMake(10, size.height+13, ScreenWidth-20, 0.5);
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
                    [priceLabel setText:[NSString stringWithFormat:@"¥%@",data.price]];
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
            if(indexPath.row == 4)
            {
                if(self.myShopName.length != 0)
                {
                    
                    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:self.myShopName WithSize:CGSizeMake(MAXFLOAT,34)];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(47, 10, size.width,34)];
                    [label setFont:[UIFont systemFontOfSize:15]];
                    [label setText:self.myShopName];
                    [label setTextAlignment:NSTextAlignmentLeft];
                    [label setTextColor:[UIColor blackColor]];
                    
                    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,cell.frame.size.height)];
                    [cell.contentView addSubview:firstView];
                    
                    UIImageView *firstIv = [[UIImageView alloc] initWithFrame:CGRectMake(12, (cell.frame.size.height-20)/2, 30, 30)];
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
            if(indexPath.row == 5)
            {
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 140, 30)];
                [label setFont:[UIFont systemFontOfSize:15]];
                [label setText:@"商品详情快照"];
                [label setTextAlignment:NSTextAlignmentLeft];
                [label setTextColor:[UIColor blackColor]];
                [cell.contentView addSubview:label];
                
                UIView *lineView = [[UIView alloc] init];
                lineView.frame = CGRectMake(0, 43.5, ScreenWidth, 0.5);
                lineView.backgroundColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:lineView];
            }
            if(indexPath.row == 6)
            {
                GoodsFastPicTableViewCell *customCell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsFastPicTableViewCell" owner:self options:nil] lastObject];
                
                [customCell.brandLabel setText:data.brand];
                
                [customCell.colorLabel setText:data.color];
                
                [customCell.freightPriceLabel setText:data.freightPrice];
                
                [customCell.modelLabel setText:data.model];
                
                [customCell.useLabel setText:data.range];
                
                [customCell.specLabel setText:data.spec];
                
                [customCell.voltageLabel setText:data.voltage];
                
                customCell.contentView.backgroundColor = [UIColor whiteColor];
                
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

@end
