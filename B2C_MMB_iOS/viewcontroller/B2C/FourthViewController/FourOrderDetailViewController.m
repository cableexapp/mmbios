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
#import "logisticsTrackingViewController.h"
#import "DiscussViewController.h"
#import "ShopHostTableViewController.h"

@interface FourOrderDetailViewController ()
{
    NSMutableArray *dataArray;
    UITableView *tv;
    
    UIButton *nameBtn;
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
    
    self.myOederLabel.backgroundColor = [UIColor redColor];
    self.myTimeLabel.backgroundColor = [UIColor greenColor];
    
   
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装线订单详情"];
    self.navigationItem.titleView= top;
    
    self.discussBtn.layer.borderColor = MYCOLOR.CGColor;
    self.discussBtn.layer.borderWidth = 1.0f;
    self.discussBtn.layer.cornerRadius = 5;
    
    self.tradeBtn.layer.borderColor = MYCOLOR.CGColor;
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
    
    tv = [[UITableView alloc] init];
    if(self.showOrHideDisCussBtn == YES || self.showOrHideTradeBtn == YES)
    {
        [self.buttomView setHidden:NO];
        
        [self.discussBtn setHidden:!self.showOrHideDisCussBtn];
        
        [self.tradeBtn setHidden:!self.showOrHideTradeBtn];
        
        //        for(UIButton *btn in self.buttomView.subviews)
        //        {
        //            [btn setHidden: NO];
        //        }
        [self.tableBackView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-self.buttomView.frame.size.height-64)];
        [tv setFrame:CGRectMake(0, 0, self.tableBackView.frame.size.width, self.tableBackView.frame.size.height)];
    }
    else
    {
        [self.buttomView setHidden:YES];
        [self.buttomView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 0)];
        for(UIButton *btn in self.buttomView.subviews)
        {
            [btn setHidden:YES];
            [btn setFrame:CGRectMake(btn.frame.origin.x, ScreenHeight, btn.frame.size.width, 0)];
        }
        [self.tableBackView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [tv setFrame:CGRectMake(0, 0, self.tableBackView.frame.size.width, self.tableBackView.frame.size.height)];
    }
    [tv setDataSource:self];
    [tv setDelegate:self];
    tv.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
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
            
            NSString *shopName = [[dataArray lastObject] shopName];
   
            nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [nameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [nameBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            if([DCFCustomExtra validateString:shopName] == NO)
            {
                [nameBtn setFrame:CGRectMake(10, 0, 100, 30)];
            }
            else
            {
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:shopName WithSize:CGSizeMake(MAXFLOAT, 30)];
                [nameBtn setFrame:CGRectMake(10, 0, size.width, 30)];
            }
            [nameBtn setTitle:[[dataArray lastObject] shopName] forState:UIControlStateNormal];
            [nameBtn addTarget:self action:@selector(nameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
//            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 30)];
//            [nameLabel setTextColor:[UIColor blackColor]];
//            [nameLabel setFont:[UIFont systemFontOfSize:13]];
//            [nameLabel setText:[[dataArray lastObject] shopName]];
//            [nameLabel setTextAlignment:NSTextAlignmentLeft];
//            
//            UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
//            [nameLabel addGestureRecognizer:labelTap];
            
            [tv reloadData];
        }
    }
}

- (IBAction)discussBtnClick:(id)sender
{
    DiscussViewController *disCuss = [self.storyboard instantiateViewControllerWithIdentifier:@"discussViewController"];
    
    disCuss.itemArray = [[NSMutableArray alloc] initWithArray:self.theLogiArray];
    disCuss.shopId = [NSString stringWithFormat:@"%@",self.theShopId];
    disCuss.orderNum = [NSString stringWithFormat:@"%@",self.theOrderNum];
    disCuss.subDateDic = [[NSDictionary alloc] initWithDictionary:self.theDic];
    
    [self.navigationController pushViewController:disCuss animated:YES];
}

- (IBAction)tradeBtnClick:(id)sender
{
    logisticsTrackingViewController *logisticsTrackingView = [self.storyboard instantiateViewControllerWithIdentifier:@"logisticsTrackingView"];
    logisticsTrackingView.mylogisticsId = self.theLogiId;
    logisticsTrackingView.mylogisticsNum = self.theLogiNum;
    NSLog(@"mylogisticsId＝%@  mylogisticsNum＝%@",logisticsTrackingView.mylogisticsId,logisticsTrackingView.mylogisticsNum);
    [self.navigationController pushViewController:logisticsTrackingView animated:YES];
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
    CGFloat height;
    if (section == 0)
    {
        height = 98;
    }
    else
    {
        height = 45;
    }
    return height;
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
        return label.frame.size.height+70;
    }
    else
    {
        return 30;
    }
    return 30;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label;
    UILabel *titleLabel;
    if (section == 0)
    {
        NSLog(@"myOederLabel = %@",self.myOrderNum);
        NSLog(@"myTimeLabel = %@",self.myTime);
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 98)];

        UILabel *orderNumLabel = [[UILabel alloc] init];
        orderNumLabel.frame = CGRectMake(0, 0, 75, 25);
        orderNumLabel.font = [UIFont systemFontOfSize:15];
        orderNumLabel.text = @"  订单编号:";
        [label addSubview:orderNumLabel];
        
        UILabel *tempOrderNumLabel = [[UILabel alloc] init];
        tempOrderNumLabel.frame = CGRectMake(75, 0, ScreenWidth-75, 25);
        tempOrderNumLabel.font = [UIFont systemFontOfSize:13];
        tempOrderNumLabel.text = [NSString stringWithFormat:@" %@",self.myOrderNum];
        [label addSubview:tempOrderNumLabel];
        
        UILabel *upTimeLabel = [[UILabel alloc] init];
        upTimeLabel.frame = CGRectMake(0, 25,75, 25);
        upTimeLabel.font = [UIFont systemFontOfSize:15];
        upTimeLabel.text = @"  提交时间:";
        [label addSubview:upTimeLabel];
        
        UILabel *tempUpTimeLabel = [[UILabel alloc] init];
        tempUpTimeLabel.frame = CGRectMake(75, 25, ScreenWidth-75, 25);
        tempUpTimeLabel.font = [UIFont systemFontOfSize:13];
        tempUpTimeLabel.text = [NSString stringWithFormat:@" %@",self.myTime];
        [label addSubview:tempUpTimeLabel];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(0, 53, ScreenHeight, 45);
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        [label addSubview:titleLabel];
    }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth+2, 28)];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:[UIColor blackColor]];
        label.font = [UIFont systemFontOfSize:15];
        [label setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
    }
    
    if(section == 0)
    {
        [titleLabel setText:@"  商品信息"];
    }
    if(section == 1)
    {
        [label setText:@"  收货地址"];
    }
    if(section == 2)
    {
        [label setText:@"  发票信息"];
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
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_PIC_DEV,s2];
        
        pic = [NSString stringWithFormat:@"%@",has];
        
    }
    else
    {
        docIndex = pic.length - 5;
        
        NSString *s3 = [pic substringToIndex:docIndex];
        
        NSString *s4 = [s3 stringByAppendingString:@"_100"];
        
        NSString *pre = [pic substringFromIndex:docIndex];
        
        s4 = [s4 stringByAppendingString:pre];
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_PIC_DEV,s4];
        
        pic = [NSString stringWithFormat:@"%@",has];
    }
    return pic;
}

- (void) nameBtnClick:(UIButton *) sender
{    
    ShopHostTableViewController *shopHost = [[ShopHostTableViewController alloc] initWithHeadTitle:[[dataArray lastObject] shopName] WithShopId:[[dataArray lastObject] shopId] WithUse:@""];
    [self.navigationController pushViewController:shopHost animated:YES];
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
            UILabel *statusLabel;
            if(indexPath.row == 0)
            {
                [cell.contentView addSubview:nameBtn];
                
                NSString *status = [DCFCustomExtra compareStatus:[[dataArray lastObject] status]];
                CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:status WithSize:CGSizeMake(MAXFLOAT, 26)];
                
                UILabel *tempStatusLabel = [[UILabel alloc] init];
                tempStatusLabel.frame = CGRectMake(ScreenWidth-10-size_1.width-35, 0, 40, 26);
                tempStatusLabel.text = @"状态:";
                tempStatusLabel.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:tempStatusLabel];
                statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-size_1.width, 0, size_1.width, 26)];
                [statusLabel setText:status];
                [statusLabel setFont:[UIFont systemFontOfSize:13]];
                statusLabel.textColor = [UIColor redColor];
                [statusLabel setTextAlignment:NSTextAlignmentRight];
                [cell.contentView addSubview:statusLabel];
            }
            if(indexPath.row == [[[dataArray lastObject] myItems] count]+1)
            {
                
                
                NSString *tradeMoney = [NSString stringWithFormat:@"运费: ¥%@",[[dataArray lastObject] logisticsPrice]];
                CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:tradeMoney WithSize:CGSizeMake(MAXFLOAT, 26)];
                UILabel *tradeMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(statusLabel.frame.origin.x + statusLabel.frame.size.width + 20, 2, size_2.width, 26)];
                [tradeMoneyLabel setTextAlignment:NSTextAlignmentCenter];
                [tradeMoneyLabel setText:tradeMoney];
                tradeMoneyLabel.textColor = [UIColor lightGrayColor];
                [tradeMoneyLabel setFont:[UIFont systemFontOfSize:13]];
                [cell.contentView addSubview:tradeMoneyLabel];
                
                NSString *orderTotal = [NSString stringWithFormat:@" ¥%@",[[dataArray lastObject] orderTotal]];
                CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:orderTotal WithSize:CGSizeMake(MAXFLOAT, 26)];
                
                UILabel *tempOrderTotal = [[UILabel alloc] init];
                tempOrderTotal.frame = CGRectMake(ScreenWidth-10-size_3.width-60, 2, 60, 26);
                tempOrderTotal.text = @"订单总额:";
                tempOrderTotal.font = [UIFont systemFontOfSize:13];
                [cell.contentView addSubview:tempOrderTotal];
                
                UILabel *orderTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-size_3.width, 2, size_3.width, 26)];
                [orderTotalLabel setTextAlignment:NSTextAlignmentRight];
                [orderTotalLabel setText:orderTotal];
                orderTotalLabel.textColor = [UIColor redColor];
                [orderTotalLabel setFont:[UIFont systemFontOfSize:13]];
                [cell.contentView addSubview:orderTotalLabel];
            }
            else if(indexPath.row > 0 && indexPath.row <= [[[dataArray lastObject] myItems] count])
            {
                NSString *s = [[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"productItmeTitle"];
//                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:s WithSize:CGSizeMake(ScreenWidth-70-5, MAXFLOAT)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 8, ScreenWidth-190, 60)];
                [label setText:s];
                [label setFont:[UIFont systemFontOfSize:13]];
                label.backgroundColor = [UIColor whiteColor];
                [label setNumberOfLines:0];
                [cell.contentView addSubview:label];
                
                NSString *color = [[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"colorName"];
                UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-110, 31, 100, 20)];
                [colorLabel setTextAlignment:NSTextAlignmentRight];
                colorLabel.backgroundColor = [UIColor whiteColor];
                [colorLabel setText:[NSString stringWithFormat:@"颜色: %@",color]];
                colorLabel.textColor = [UIColor lightGrayColor];
                [colorLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:colorLabel];
                
                NSString *money = [NSString stringWithFormat:@"¥%@",[[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"price"]];
                CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:money WithSize:CGSizeMake(MAXFLOAT, 20)];
                UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-(size_1.width+10), 8, size_1.width, 20)];
                [moneyLabel setText:money];
                [moneyLabel setFont:[UIFont systemFontOfSize:12]];
                moneyLabel.textColor = [UIColor redColor];
                [cell.contentView addSubview:moneyLabel];
                
                NSString *count = [NSString stringWithFormat:@"×%@",[[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"productNum"]];
                CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:count WithSize:CGSizeMake(MAXFLOAT, 20)];
                UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-size_2.width, colorLabel.frame.origin.y + colorLabel.frame.size.height + 5, size_2.width, 20)];
                [countLabel setText:count];
                [countLabel setTextAlignment:NSTextAlignmentRight];
                [countLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:countLabel];
                
                UIImageView *cellIv = [[UIImageView alloc] initWithFrame:CGRectMake(10,8, 60, 60)];
                NSString *picStr = [[[[dataArray lastObject] myItems] objectAtIndex:indexPath.row-1] objectForKey:@"productItemPic"];
                picStr = [self dealPic:picStr];
//                cellIv.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//                cellIv.layer.borderWidth = 0.5;
                NSURL *picUrl = [NSURL URLWithString:picStr];
                [cellIv setImageWithURL:picUrl placeholderImage:[UIImage imageNamed:@"cabel.png"]];
                [cell.contentView addSubview:cellIv];
                
            }
        }
        if(indexPath.section == 1)
        {
            NSString *name = [NSString stringWithFormat:@"收货人: %@",[[dataArray lastObject] receiveMember]];
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
            
            NSString *add = [NSString stringWithFormat:@"收货地址: %@",[[dataArray lastObject] receiveAddr]];
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
