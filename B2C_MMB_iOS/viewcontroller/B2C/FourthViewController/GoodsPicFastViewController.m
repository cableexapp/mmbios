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
    [tv setBackgroundColor:[UIColor colorWithRed:225.0/255.0 green:222.0/255.0 blue:237.0/255.0 alpha:1.0]];
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
        if(indexPath.row == 2 || indexPath.row == 3 ||indexPath.row == 4 || indexPath.row == 5 )
        {
            return 44;
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
    //    [tableView setSeparatorStyle:0];
    
    
    
    NSString *cellId = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:229.0/255.0 blue:240.0/255.0 alpha:1.0]];
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
            }
            if(indexPath.row == 1)
            {
                if(data.productName.length != 0)
                {
                    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:data.productName WithSize:CGSizeMake(300, MAXFLOAT)];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, size.height)];
                    [label setText:data.productName];
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
                if(data.price.length != 0)
                {
                    CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:@"价格" WithSize:CGSizeMake(MAXFLOAT, 30)];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size_1.width, 30)];
                    [label setText:@"价格"];
                    [label setFont:[UIFont systemFontOfSize:13]];
                    [label setTextAlignment:NSTextAlignmentLeft];
                    [cell.contentView addSubview:label];
                    
                    CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:data.price WithSize:CGSizeMake(MAXFLOAT, 30)];
                    
                    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 20, 5, size_2.width, 30)];
                    [priceLabel setTextAlignment:NSTextAlignmentLeft];
                    [priceLabel setText:data.price];
                    [priceLabel setFont:[UIFont systemFontOfSize:13]];
                    [cell.contentView addSubview:priceLabel];
                    
                    CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:@"运费5元" WithSize:CGSizeMake(MAXFLOAT, 30)];
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
                if(data.color.length != 0)
                {
                    CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:@"颜色分类:" WithSize:CGSizeMake(MAXFLOAT, 30)];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size_1.width, 30)];
                    [label setText:@"颜色分类:"];
                    [label setFont:[UIFont systemFontOfSize:13]];
                    [label setTextAlignment:NSTextAlignmentLeft];
                    [cell.contentView addSubview:label];
                    
                    CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:data.color WithSize:CGSizeMake(MAXFLOAT, 30)];
                    
                    UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 20, 5, size_2.width, 30)];
                    [colorLabel setTextAlignment:NSTextAlignmentLeft];
                    [colorLabel setText:data.color];
                    [colorLabel setFont:[UIFont systemFontOfSize:12]];
                    [cell.contentView addSubview:colorLabel];
                }
                else
                {
                    
                }
            }
            if(indexPath.row == 4)
            {
                if(self.myShopName.length != 0)
                {
                    UIImageView *firstIv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 30, 30)];
                    [firstIv setImage:[UIImage imageNamed:@"Set.png"]];
                    
                    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:self.myShopName WithSize:CGSizeMake(MAXFLOAT,30)];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, size.width, 30)];
                    [label setFont:[UIFont systemFontOfSize:13]];
                    [label setText:self.myShopName];
                    [label setTextAlignment:NSTextAlignmentLeft];
                    [label setTextColor:MYCOLOR];
                    
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
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 140, 30)];
                [label setFont:[UIFont systemFontOfSize:13]];
                [label setText:@"商品详情快照"];
                [label setTextAlignment:NSTextAlignmentLeft];
                [label setTextColor:MYCOLOR];
                [cell.contentView addSubview:label];
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
    ShopHostTableViewController *shopHost = [[ShopHostTableViewController alloc] initWithHeadTitle:self.myShopName WithShopId:self.mySnapId WithUse:@""];
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
