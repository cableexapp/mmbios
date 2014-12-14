//
//  B2BAskPriceInquirySheetViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-6.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2BAskPriceInquirySheetViewController.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFStringUtil.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "DCFChenMoreCell.h"
#import "LoginNaviViewController.h"
#import "AddReceiveAddressViewController.h"
#import "B2BAddressData.h"
#import "B2BAskPriceDetailData.h"
#import "ChooseReceiveAddressViewController.h"
#import "B2BAskPriceUpSuccessViewController.h"
#import "DCFColorUtil.h"


@interface B2BAskPriceInquirySheetViewController ()
{
    UIView *buttomView;    //底部view
    
    UIButton *upBtn;   //底部提交按钮
    
    DCFChenMoreCell *moreCell;
    
    NSMutableArray *addressArray;
    
    B2BAddressData *addressData;
    
    BOOL flag; //判断收货地址
    
    CGFloat labelOrigin;  //label显示起点
    CGFloat labelOrigin_1;  //label显示起点
    CGFloat labelOrigin_2;  //label显示起点
}
@end

@implementation B2BAskPriceInquirySheetViewController

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
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
    if(HUD)
    {
        [HUD hide:YES];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"AddressList",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@",token,[self getMemberId]];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLAddressListTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/AddressList.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(HUD)
    {
        [HUD hide:YES];
    }
    
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if(URLTag == URLAddressListTag)
    {
        if(result == 1)
        {
            addressArray = [[NSMutableArray alloc] initWithArray:[B2BAddressData getListArray:[dicRespon objectForKey:@"items"]]];
            
            if(addressArray.count != 0)
            {
                for(B2BAddressData *data in addressArray)
                {
                    if([data.isDefault intValue] == 1)
                    {
                        addressData = data;
                    }
                }
            }
        }
        if(result == 0)
        {
            addressArray = [[NSMutableArray alloc] init];
        }
    }
    
    [tv reloadData];
    if(URLTag == URLSubInquiryTag)
    {
        [upBtn setEnabled:YES];
        if(result == 1)
        {
            B2BAskPriceUpSuccessViewController *b2bAskPriceUpSuccessViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"b2bAskPriceUpSuccessViewController"];
            [self.navigationController pushViewController:b2bAskPriceUpSuccessViewController animated:YES];
        }
        else
        {
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"提交失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
}

- (void) hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"提交询价单"];
    self.navigationItem.titleView = top;
    
    if(!buttomView || !upBtn)
    {
        buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-60-64, ScreenWidth, 60)];
        [self.view addSubview:buttomView];
        
        upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [upBtn setTitle:@"提交" forState:UIControlStateNormal];
        [upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [upBtn setBackgroundColor:[UIColor colorWithRed:237.0/225.0 green:142.0/255.0 blue:0/255.0 alpha:1.0]];
        upBtn.layer.cornerRadius = 5.0f;
        [upBtn setFrame:CGRectMake(15,10, ScreenWidth-30, 40)];
        [upBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttomView addSubview:upBtn];
    }
    
    if(!tv)
    {
        tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-buttomView.frame.size.height-64)];
        [tv setDataSource:self];
        [tv setDelegate:self];
        [tv setShowsHorizontalScrollIndicator:NO];
        [tv setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:tv];
    }
    [tv reloadData];
}

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if([DCFCustomExtra validateString:memberid] == NO)
    {
        //        LoginNaviViewController *loginNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        //        [self presentViewController:loginNavi animated:YES completion:nil];
        memberid = @"";
    }
    return memberid;
}

- (void) upBtnClick:(UIButton *) sender
{
    if(self.dataArray.count == 0)
    {
        [DCFStringUtil showNotice:@"暂无商品信息"];
        return;
    }
    if(addressData.addressId.length == 0 || [addressData.addressId isKindOfClass:[NSNull class]])
    {
        [DCFStringUtil showNotice:@"收货地址不能为空"];
        return;
    }
    
    if(!HUD)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setLabelText:@"正在提交..."];
        [HUD setDelegate:self];
    }
    
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"SubInquiry",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&addressid=%@&type=%@",token,[self getMemberId],addressData.addressId,@"7"];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSubInquiryTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/SubInquiry.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [upBtn setEnabled:NO];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    if(section == 1)
    {
        if(!self.dataArray || self.dataArray.count == 0)
        {
            return 1;
        }
        else
        {
            return self.dataArray.count;
        }
    }
    return 1;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-15, 40)];
    [headLabel setTextColor:[UIColor blackColor]];
    headLabel.font = [UIFont systemFontOfSize:15];
    [headLabel setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
    
    if(section == 0)
    {
        //        [headLabel setText:@" 收货人信息"];
    }
    if(section == 1)
    {
        [headLabel setText:@" 待询价型号信息"];
    }
    return headLabel;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height;
    if (section == 0)
    {
        height = 0.01;
    }
    else
    {
        height = 40;
    }
    return height;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(!addressArray || addressArray.count == 0)
        {
            return 44;
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",addressData.fullAddress];
        if(str.length == 0 || [str isKindOfClass:[NSNull class]])
        {
            return 44;
        }
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(260, MAXFLOAT)];
        
        return size.height + 70;
    }
    
    
    
    if(!self.dataArray || self.dataArray.count == 0)
    {
        return 0;
    }
    B2BAskPriceDetailData *data = [self.dataArray objectAtIndex:indexPath.row];
    
    NSString *require = [NSString stringWithFormat:@"特殊要求: %@",data.require];
    
    CGSize   size_7 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:require WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
    CGFloat height_1 = 0.0;
    if([DCFCustomExtra validateString:data.cartSpec] == NO && [DCFCustomExtra validateString:data.cartVoltage] == NO)
    {
        height_1 = 0;
    }
    else
    {
        height_1 = 20;
    }
    CGFloat height_2 = 0.0;
    if([DCFCustomExtra validateString:data.cartColor] == NO && [DCFCustomExtra validateString:data.featureone] == NO)
    {
        height_2 = 0;
    }
    else
    {
        height_2 = 20;
    }
    if(size_7.height <= 20)
    {
        return 90+height_1+height_2;
    }
    return size_7.height+70+height_1+height_2;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setSeparatorColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            if(!addressArray || addressArray.count == 0)
            {
                [cell.textLabel setText:@"暂无收货地址"];
                flag = NO;
            }
            else
            {
                [cell.textLabel setText:@""];
                
                flag = YES;
                
                NSString *name = [[addressArray lastObject] receiver];
                CGSize size_name = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:name WithSize:CGSizeMake(MAXFLOAT, 30)];
                
                UILabel *nameLabel = nil;
                if(name.length == 0 || [name isKindOfClass:[NSNull class]])
                {
                    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 50, 30)];
                }
                else
                {
                    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, size_name.width, 30)];
                }
                [nameLabel setText:name];
                nameLabel.textColor = [DCFColorUtil colorFromHexRGB:@"#ba7d04"];
                [nameLabel setTextAlignment:NSTextAlignmentLeft];
                [nameLabel setFont:[UIFont systemFontOfSize:14]];
                
                NSString *tel = [[addressArray lastObject] mobile];
                CGSize size_tel = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:tel WithSize:CGSizeMake(MAXFLOAT, 30)];
                
                UILabel *telLabel = nil;
                if(tel.length == 0 || [tel isKindOfClass:[NSNull class]])
                {
                    telLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 20, 5, 100, 30)];
                }
                else
                {
                    telLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-70-size_tel.width, 10, size_tel.width, 30)];
                }
                [telLabel setText:tel];
                telLabel.textColor = [DCFColorUtil colorFromHexRGB:@"#ba7d04"];
                [telLabel setFont:[UIFont systemFontOfSize:14]];
                [telLabel setTextAlignment:NSTextAlignmentRight];
                
                
                NSString *address = [[addressArray lastObject] fullAddress];
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:address WithSize:CGSizeMake(260, MAXFLOAT)];
                
                UILabel *addressLabel = nil;
                if(address.length == 0 || [address isKindOfClass:[NSNull class]])
                {
                    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, nameLabel.frame.origin.y + nameLabel.frame.size.height+5, ScreenWidth-90, 30)];
                }
                else
                {
                    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, nameLabel.frame.origin.y + nameLabel.frame.size.height+5, ScreenWidth-90, size.height)];
                }
                [addressLabel setText:address];
                [addressLabel setFont:[UIFont systemFontOfSize:12]];
                addressLabel.textColor = [DCFColorUtil colorFromHexRGB:@"#ba7d04"];
                [addressLabel setNumberOfLines:2];
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35+size.height+5)];
                [view setBackgroundColor:[UIColor clearColor]];
                
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, cell.frame.size.height/2, 40, 40)];
                [iv setImage:[UIImage imageNamed:@"location"]];
                
                UIImageView *arrowImageView = [[UIImageView alloc] init];
                arrowImageView.frame = CGRectMake(ScreenWidth-30, (cell.frame.size.height-20)/2+20, 20, 20);
                arrowImageView.image = [UIImage imageNamed:@"location_arrow"];
                [cell addSubview:arrowImageView];
                
                cell.backgroundColor = [DCFColorUtil colorFromHexRGB:@"#f8e9cb"];
                
                //                [cell.contentView addSubview:view];
                [cell.contentView addSubview:iv];
                [cell.contentView addSubview:nameLabel];
                [cell.contentView addSubview:telLabel];
                [cell.contentView addSubview:addressLabel];
            }
        }
        else
        {
            
        }
        
    }
    if(indexPath.section == 1)
    {
        if(!self.dataArray || self.dataArray.count == 0)
        {
            static NSString *moreCellId = @"moreCell";
            moreCell = (DCFChenMoreCell *)[tv dequeueReusableCellWithIdentifier:moreCellId];
            
            if(moreCell == nil)
            {
                moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
                [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
                [moreCell noDataAnimation];
            }
            return moreCell;
        }
        else
        {
            B2BAskPriceDetailData *data = [self.dataArray objectAtIndex:indexPath.row];
            
            
            UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 20)];
            [modelLabel setText:[NSString stringWithFormat:@"型号:%@",data.cartModel]];
            [modelLabel setFont:[UIFont systemFontOfSize:13]];
            [cell.contentView addSubview:modelLabel];
            
            UILabel *kindLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, modelLabel.frame.origin.y+modelLabel.frame.size.height, ScreenWidth-20, 20)];
            [kindLabel setFont:[UIFont systemFontOfSize:13]];
            [kindLabel setText:[NSString stringWithFormat:@"分类:%@",data.chooseKind]];
            [cell.contentView addSubview:kindLabel];
            
            CGFloat halfWidth = cell.contentView.frame.size.width/2+10;
            
            
            NSString *num = [NSString stringWithFormat:@"数量: %@",data.num];
            NSString *deliver = [NSString stringWithFormat:@"交货期: %@",data.deliver];
            NSString *cartSpec = [NSString stringWithFormat:@"规格: %@",data.cartSpec];  //规格
            NSString *cartVoltage = [NSString stringWithFormat:@"电压: %@",data.cartVoltage];
            NSString *color = [NSString stringWithFormat:@"颜色: %@", data.cartColor];
            NSString *featureone = [NSString stringWithFormat:@"阻燃特性: %@",data.featureone];  //阻燃特性
            NSString *require = [NSString stringWithFormat:@"特殊要求: %@",data.require];
            
            NSMutableAttributedString *myNum = [[NSMutableAttributedString alloc] initWithString:num];
            [myNum addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 1)];
            [myNum addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, num.length-3)];
            
            NSMutableAttributedString *myDeliver = [[NSMutableAttributedString alloc] initWithString:deliver];
            [myDeliver addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
            [myDeliver addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(4, deliver.length-4)];
            
            NSMutableAttributedString *myCartSpec = [[NSMutableAttributedString alloc] initWithString:cartSpec];
            [myCartSpec addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 1)];
            [myCartSpec addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, cartSpec.length-3)];
            
            NSMutableAttributedString *myCartVoltage = [[NSMutableAttributedString alloc] initWithString:cartVoltage];
            [myCartVoltage addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 1)];
            [myCartVoltage addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, cartVoltage.length-3)];
            
            NSMutableAttributedString *myColor = [[NSMutableAttributedString alloc] initWithString:color];
            [myColor addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 1)];
            [myColor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, color.length-3)];
            
            NSMutableAttributedString *myFeatureone = [[NSMutableAttributedString alloc] initWithString:featureone];
            [myFeatureone addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [myFeatureone addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, featureone.length-5)];
            
            NSMutableAttributedString *myRequire = [[NSMutableAttributedString alloc] initWithString:require];
            [myRequire addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [myRequire addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, require.length-5)];
            
            CGSize size_1;
            if([DCFCustomExtra validateString:num] == NO ||[num intValue] == 0)
            {
                size_1 = CGSizeMake(100, 20);
            }
            else
            {
                size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:num WithSize:CGSizeMake(MAXFLOAT, 20)];
                
            }
            
            CGSize size_2;
            if([DCFCustomExtra validateString:deliver] == NO || [deliver intValue] == 0)
            {
                size_2 = CGSizeMake(100, 20);
            }
            else
            {
                size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:deliver WithSize:CGSizeMake(MAXFLOAT, 20)];
                
            }
            
            CGSize size_3;
            if([DCFCustomExtra validateString:cartSpec] == NO)
            {
                size_3 = CGSizeMake(100, 20);
            }
            else
            {
                size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:cartSpec WithSize:CGSizeMake(MAXFLOAT, 20)];
                
            }
            
            CGSize size_4;
            if([DCFCustomExtra validateString:cartVoltage] == NO)
            {
                size_4 = CGSizeMake(100, 20);
            }
            else
            {
                size_4 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:cartVoltage WithSize:CGSizeMake(MAXFLOAT, 20)];
                
            }
            
            CGSize size_5;
            if([DCFCustomExtra validateString:color] == NO)
            {
                size_5 = CGSizeMake(100, 20);
            }
            else
            {
                size_5 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:color WithSize:CGSizeMake(MAXFLOAT, 20)];
            }
            
            CGSize size_6;
            if([DCFCustomExtra validateString:featureone] == NO)
            {
                size_6 = CGSizeMake(100, 20);
            }
            else
            {
                size_6 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:featureone WithSize:CGSizeMake(MAXFLOAT, 20)];
            }
            
            CGSize size_7;
            if([DCFCustomExtra validateString:data.require] == NO)
            {
                size_7 = CGSizeMake(cell.contentView.frame.size.width-20, 20);
            }
            else
            {
                size_7 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:require WithSize:CGSizeMake(cell.contentView.frame.size.width-20, MAXFLOAT)];
            }
            
            
            
            for(int i=0;i<7;i++)
            {
                UILabel *cellLabel = [[UILabel alloc] init];
                [cellLabel setFont:[UIFont systemFontOfSize:13]];
                if(i == 0)
                {
                    [cellLabel setFrame:CGRectMake(10, kindLabel.frame.origin.y+kindLabel.frame.size.height, size_1.width, 20)];
                    if([DCFCustomExtra validateString:data.num] == NO || [data.num intValue] == 0)
                    {
                        [cellLabel setText:@"数量:"];
                    }
                    else
                    {
                        [cellLabel setAttributedText:myNum];
                    }
                }
                if(i == 1)
                {
                    [cellLabel setFrame:CGRectMake(halfWidth, kindLabel.frame.origin.y+kindLabel.frame.size.height, size_2.width, 20)];
                    if([DCFCustomExtra validateString:data.deliver] == NO || [data.deliver intValue] == 0)
                    {
                        [cellLabel setText:@"交货期:"];
                    }
                    else
                    {
                        [cellLabel setAttributedText:myDeliver];
                    }
                }
                if(i == 2)
                {
                    if([DCFCustomExtra validateString:data.cartSpec] == NO)
                    {
                        [cellLabel setFrame:CGRectMake(10, 65, size_3.width, 0)];
                    }
                    else
                    {
                        [cellLabel setFrame:CGRectMake(10, 65, size_3.width, 20)];
                        [cellLabel setAttributedText:myCartSpec];
                    }
                    
                }
                if(i == 3)
                {
                    if([DCFCustomExtra validateString:data.cartVoltage] == NO)
                    {
                        [cellLabel setFrame:CGRectMake(10, 65, size_4.width, 0)];
                    }
                    else
                    {
                        [cellLabel setFrame:CGRectMake(halfWidth, 65, size_4.width, 20)];
                        [cellLabel setAttributedText:myCartVoltage];
                    }
                }
                if(i == 4)
                {
                    if([DCFCustomExtra validateString:data.cartSpec] == NO && [DCFCustomExtra validateString:data.cartVoltage] == NO)
                    {
                        if([DCFCustomExtra validateString:data.cartColor] == NO)
                        {
                            [cellLabel setFrame:CGRectMake(10, 65, size_5.width, 0)];
                        }
                        else
                        {
                            [cellLabel setFrame:CGRectMake(10, 65, size_5.width, 20)];
                        }
                    }
                    else
                    {
                        if([DCFCustomExtra validateString:data.cartColor] == NO)
                        {
                            [cellLabel setFrame:CGRectMake(10, 85, size_5.width, 0)];
                        }
                        else
                        {
                            [cellLabel setFrame:CGRectMake(10, 85, size_5.width, 20)];
                        }
                    }
                    [cellLabel setAttributedText:myColor];
                    labelOrigin_1 = cellLabel.frame.origin.y+cellLabel.frame.size.height;
                }
                if(i == 5)
                {
                    if([DCFCustomExtra validateString:data.cartSpec] == NO && [DCFCustomExtra validateString:data.cartVoltage] == NO)
                    {
                        if([DCFCustomExtra validateString:data.featureone] == NO)
                        {
                            [cellLabel setFrame:CGRectMake(10, 65, size_6.width, 0)];
                        }
                        else
                        {
                            [cellLabel setFrame:CGRectMake(halfWidth, 65, size_6.width, 20)];
                        }
                    }
                    else
                    {
                        if([DCFCustomExtra validateString:data.featureone] == NO)
                        {
                            [cellLabel setFrame:CGRectMake(10, 85, size_6.width, 0)];
                        }
                        else
                        {
                            [cellLabel setFrame:CGRectMake(halfWidth, 85, size_6.width, 20)];
                        }
                    }
                    [cellLabel setAttributedText:myFeatureone];
                    labelOrigin_2 = cellLabel.frame.origin.y+cellLabel.frame.size.height;
                }
                if(i == 6)
                {
                    labelOrigin = labelOrigin_1>=labelOrigin_2 ? labelOrigin_1 : labelOrigin_2;
                    [cellLabel setFrame:CGRectMake(10, labelOrigin, cell.contentView.frame.size.width-20, size_7.height)];
                    if([DCFCustomExtra validateString:data.require] == NO)
                    {
                        [cellLabel setText:@"特殊需求:"];
                    }
                    else
                    {
                        [cellLabel setAttributedText:myRequire];
                    }
                    
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellLabel.frame.origin.y+cellLabel.frame.size.height+4.5, ScreenWidth, 0.5)];
                    [lineView setBackgroundColor:[UIColor lightGrayColor]];
                    [cell.contentView addSubview:lineView];
                }
                
                [cellLabel setFont:[UIFont systemFontOfSize:12]];
                [cellLabel setNumberOfLines:0];
                
                [cell.contentView addSubview:cellLabel];
                
                
            }
            
            
        }
        
        
    }
    //    [cell.textLabel setText:[NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        [self setHidesBottomBarWhenPushed:YES];
        if(flag == NO)
        {
            AddReceiveAddressViewController *add = [[AddReceiveAddressViewController alloc] init];
            [self.navigationController pushViewController:add animated:YES];
        }
        else
        {
            ChooseReceiveAddressViewController *chooseAddress = [[ChooseReceiveAddressViewController alloc] init];
            [self.navigationController pushViewController:chooseAddress animated:YES];
        }
        [self setHidesBottomBarWhenPushed:NO];
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
