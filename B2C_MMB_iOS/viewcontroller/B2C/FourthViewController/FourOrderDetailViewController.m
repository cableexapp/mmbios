//
//  FourOrderDetailViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-18.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "FourOrderDetailViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "LoginNaviViewController.h"
#import "DCFCustomExtra.h"
#import "B2CGetOrderDetailData.h"
#import "UIImageView+WebCache.h"
#import "GoodsPicFastViewController.h"

@interface FourOrderDetailViewController ()
{
    NSMutableArray *dataArray;
    UITableView *tv;
}
@end

@implementation FourOrderDetailViewController

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
    [super viewWillAppear:YES];
    
    [self.myOederLabel setText:self.myOrderNum];
    [self.myTimeLabel setText:self.myTime];
    
    
}

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if(memberid.length == 0)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装馆订单详情"];
    self.navigationItem.titleView= top;
    
    self.discussBtn.layer.borderColor = [UIColor blueColor].CGColor;
    self.discussBtn.layer.borderWidth = 1.0f;
    self.discussBtn.layer.cornerRadius = 5;
    
    self.tradeBtn.layer.borderColor = [UIColor blueColor].CGColor;
    self.tradeBtn.layer.borderWidth = 1.0f;
    self.tradeBtn.layer.cornerRadius = 5;
    
    NSString *memberid = [self getMemberId];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getOrderDetail",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&ordernum=%@",memberid,token,self.myOrderNum];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetOrderDetailTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getOrderDetail.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.tableBackView.frame.size.width, self.tableBackView.frame.size.height-53) style:0];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [self.tableBackView addSubview:tv];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    if(URLTag == URLGetOrderDetailTag)
    {
        
        if(result == 1)
        {
            dataArray = [[NSMutableArray alloc] initWithArray:[B2CGetOrderDetailData getListArray:[dicRespon objectForKey:@"items"]]];
            [tv reloadData];
        }
    }
}

- (IBAction)discussBtnClick:(id)sender
{
    
}

- (IBAction)tradeBtnClick:(id)sender
{
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 0;
    }
    if(section == 0)
    {
        return [[[dataArray lastObject] myItems] count] + 2;
    }
    else
    {
        return 1;
    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        return 0;
    }
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0 || indexPath.row == [[[dataArray lastObject] myItems] count]+1)
        {
            return 30;
        }
        else
        {
            
            NSString *s = [[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"productItmeTitle"];
            CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:s WithSize:CGSizeMake(ScreenWidth-70-5, MAXFLOAT)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, ScreenWidth-70-5, size.height)];
            [label setText:s];
            [label setFont:[UIFont systemFontOfSize:13]];
            [label setNumberOfLines:0];
            return label.frame.size.height + 60;
        }
    }
    if(indexPath.section == 1)
    {
        NSString *add = [[dataArray lastObject] receiveAddr];
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:add WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, ScreenWidth-20, size.height)];
        [label setText:add];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:13]];
        return label.frame.size.height+45;
    }
    else
    {
        return 30;
    }
    return 30;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-1, 1, ScreenWidth+2, 28)];
    label.layer.borderColor = [UIColor blueColor].CGColor;
    label.layer.borderWidth = 1.0f;
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:[UIColor blueColor]];
    [label setBackgroundColor:[UIColor whiteColor]];
    if(section == 0)
    {
        [label setText:@" 商品信息"];
    }
    if(section == 1)
    {
        [label setText:@" 收货地址"];
    }
    else
    {
        [label setText:@" 发票信息"];
    }
    return label;
}


- (NSString *) dealPic:(NSString *) picString
{
    NSString *pic = picString;
    //.的下标
    int docIndex = pic.length-4;
    if([pic characterAtIndex:docIndex] == '.')
    {
        
        NSString *s1 = [pic substringToIndex:docIndex];
        
        NSString *s2 = [s1 stringByAppendingString:@"_100"];
        
        NSString *pre = [pic substringFromIndex:docIndex];
        
        s2 = [s2 stringByAppendingString:pre];
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,s2];
        
        pic = [NSString stringWithFormat:@"%@",has];
        
    }
    else
    {
        docIndex = pic.length - 5;
        
        NSString *s3 = [pic substringToIndex:docIndex];
        
        NSString *s4 = [s3 stringByAppendingString:@"_100"];
        
        NSString *pre = [pic substringFromIndex:docIndex];
        
        s4 = [s4 stringByAppendingString:pre];
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,s4];
        
        pic = [NSString stringWithFormat:@"%@",has];
    }
    return pic;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:0];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    if(!dataArray || dataArray.count == 0)
    {
        
    }
    else
    {
        if(indexPath.section == 0)
        {
            if(indexPath.row == 0)
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 30)];
                [label setText:[[dataArray lastObject] shopName]];
                [cell.contentView addSubview:label];
            }
            if(indexPath.row == [[[dataArray lastObject] myItems] count]+1)
            {
                NSString *status = [DCFCustomExtra compareStatus:[[dataArray lastObject] status]];
                CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:status WithSize:CGSizeMake(MAXFLOAT, 26)];
                UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, size_1.width, 26)];
                [statusLabel setText:status];
                [statusLabel setFont:[UIFont systemFontOfSize:12]];
                [statusLabel setTextAlignment:NSTextAlignmentLeft];
                [cell.contentView addSubview:statusLabel];
                
                NSString *tradeMoney = [NSString stringWithFormat:@"运费: ¥%@",[[dataArray lastObject] logisticsPrice]];
                CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:tradeMoney WithSize:CGSizeMake(MAXFLOAT, 26)];
                UILabel *tradeMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(statusLabel.frame.origin.x + statusLabel.frame.size.width + 20, 2, size_2.width, 26)];
                [tradeMoneyLabel setTextAlignment:NSTextAlignmentCenter];
                [tradeMoneyLabel setText:tradeMoney];
                [tradeMoneyLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:tradeMoneyLabel];
                
                NSString *orderTotal = [NSString stringWithFormat:@"订单总额: ¥%@",[[dataArray lastObject] orderTotal]];
                CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:orderTotal WithSize:CGSizeMake(MAXFLOAT, 26)];
                UILabel *orderTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-size_3.width, 2, size_3.width, 26)];
                [orderTotalLabel setTextAlignment:NSTextAlignmentRight];
                [orderTotalLabel setText:tradeMoney];
                [orderTotalLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:orderTotalLabel];
            }
            else if(indexPath.row > 0 && indexPath.row <= [[[dataArray lastObject] myItems] count])
            {
                NSString *s = [[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"productItmeTitle"];
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:s WithSize:CGSizeMake(ScreenWidth-70-5, MAXFLOAT)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, ScreenWidth-70-5, size.height)];
                [label setText:s];
                [label setFont:[UIFont systemFontOfSize:13]];
                [label setNumberOfLines:0];
                [cell.contentView addSubview:label];
                
                NSString *color = [[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"colorName"];
                UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, label.frame.origin.y + label.frame.size.height + 5, 150, 20)];
                [colorLabel setTextAlignment:NSTextAlignmentLeft];
                [colorLabel setText:[NSString stringWithFormat:@"颜色: %@",color]];
                [colorLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:colorLabel];
                
                NSString *money = [NSString stringWithFormat:@"¥%@",[[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"price"]];
                CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:money WithSize:CGSizeMake(MAXFLOAT, 20)];
                UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, colorLabel.frame.origin.y + colorLabel.frame.size.height + 5, size_1.width, 20)];
                [moneyLabel setText:money];
                [moneyLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:moneyLabel];
                
                NSString *count = [NSString stringWithFormat:@"*%@",[[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"productNum"]];
                CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:count WithSize:CGSizeMake(MAXFLOAT, 20)];
                UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-size_2.width, colorLabel.frame.origin.y + colorLabel.frame.size.height + 5, size_2.width, 20)];
                [countLabel setText:count];
                [countLabel setTextAlignment:NSTextAlignmentRight];
                [countLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:countLabel];
                
                UIImageView *cellIv = [[UIImageView alloc] initWithFrame:CGRectMake(5, label.frame.size.height/2, 60, 60)];
                NSString *picStr = [[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"productItemPic"];
                picStr = [self dealPic:picStr];
                NSURL *picUrl = [NSURL URLWithString:picStr];
                [cellIv setImageWithURL:picUrl placeholderImage:[UIImage imageNamed:@"cabel.png"]];
                [cell.contentView addSubview:cellIv];
                
            }
        }
        if(indexPath.section == 1)
        {
            NSString *name = [[dataArray lastObject] receiveMember];
            CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:name WithSize:CGSizeMake(MAXFLOAT, 30)];
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size_1.width, 30)];
            [nameLabel setFont:[UIFont systemFontOfSize:13]];
            [nameLabel setText:name];
            [cell.contentView addSubview:nameLabel];
            
            UILabel *tel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 20, 5, 200, 30)];
            [tel setText:[[dataArray lastObject] receivePhone]];
            [tel setFont:[UIFont systemFontOfSize:13]];
            [tel setTextAlignment:NSTextAlignmentCenter];
            [cell.contentView addSubview:tel];
            
            NSString *add = [[dataArray lastObject] receiveAddr];
            CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:add WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, ScreenWidth-20, size.height)];
            [label setText:add];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:13]];
            [cell.contentView addSubview:label];
        }
        if(indexPath.section == 2)
        {
            if(indexPath.row == 0)
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, cell.contentView.frame.size.width-20, 26)];
                NSString *str = [NSString stringWithFormat:@"%@  %@",[[dataArray lastObject] invoiceType],[[dataArray lastObject] nvoiceTitle]];
                [label setTextAlignment:NSTextAlignmentLeft];
                [label setFont:[UIFont systemFontOfSize:12]];
                [label setText:str];
                [cell.contentView addSubview:label];
            }
            
        }
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row > 0 && indexPath.row <= [[[dataArray lastObject] myItems] count])
        {
            GoodsPicFastViewController *goodsPicFastViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"goodsPicFastViewController"];
            
            NSString *snapId = [[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"snapId"];
            
            goodsPicFastViewController.mySnapId = snapId;
            goodsPicFastViewController.myShopName = [[dataArray lastObject] shopName];
            goodsPicFastViewController.myShopId = [[dataArray lastObject] shopId];
            [self.navigationController pushViewController:goodsPicFastViewController animated:YES];
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
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
