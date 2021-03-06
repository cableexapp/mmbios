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
#import "B2BAskPriceUpSuccessViewController.h"
#import "DCFColorUtil.h"


@interface B2BAskPriceInquirySheetViewController ()
{
    UIView *buttomView;    //底部view
    
    UIButton *upBtn;   //底部提交按钮
    
    DCFChenMoreCell *moreCell;
    
    
    BOOL flag; //判断收货地址
    
//    CGFloat labelOrigin;  //label显示起点
//    CGFloat labelOrigin_1;  //label显示起点
//    CGFloat labelOrigin_2;  //label显示起点
    
    CGFloat height_1;
    CGFloat height_2;
    CGFloat height_3;
    
    ChooseReceiveAddressViewController *chooseAddress;
    
    NSString *receiveAddressId;
    NSString *receiveTel;
    NSString *receiveaddress;
    NSString *receivecity;
    NSString *receivedistrict;
    NSString *receiveprovince;
    NSString *detailAddress;
    NSString *receiver;
    NSString *fullAddress;

    NSDictionary *receiverDic;
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
//    [chooseAddress cancelRequest];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    

    
//    NSString *time = [DCFCustomExtra getFirstRunTime];
//    NSString *string = [NSString stringWithFormat:@"%@%@",@"AddressList",time];
//    NSString *token = [DCFCustomExtra md5:string];
//    
//    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@",token,[self getMemberId]];
//    
//    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLAddressListTag delegate:self];
//    
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/AddressList.html?"];
//    
//    
//    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) B2BReceveAddress:(NSDictionary *)dic
{
    receiverDic = [[NSDictionary alloc] initWithDictionary:dic];
    receiveAddressId = [NSString stringWithFormat:@"%@",[receiverDic objectForKey:@"receiveAddressId"]];
    receiveTel = [NSString stringWithFormat:@"%@",[receiverDic objectForKey:@"receiveTel"]];
    receiveaddress = [NSString stringWithFormat:@"%@",[receiverDic objectForKey:@"receiveaddress"]];
    receivecity = [NSString stringWithFormat:@"%@",[receiverDic objectForKey:@"receivecity"]];
    receivedistrict = [NSString stringWithFormat:@"%@",[receiverDic objectForKey:@"receivedistrict"]];
    receiveprovince = [NSString stringWithFormat:@"%@",[receiverDic objectForKey:@"receiveprovince"]];
    receiver = [NSString stringWithFormat:@"%@",[receiverDic objectForKey:@"receiver"]];
    fullAddress = [NSString stringWithFormat:@"%@%@%@%@%@",receiveprovince,receivecity,receivedistrict,receiveaddress,[receiverDic objectForKey:@"fullAddress"]];
    fullAddress = [fullAddress stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    [tv reloadData];
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
//        if(result == 1)
//        {
//            addressArray = [[NSMutableArray alloc] initWithArray:[B2BAddressData getListArray:[dicRespon objectForKey:@"items"]]];
//            
//            if(addressArray.count != 0)
//            {
//                for(B2BAddressData *data in addressArray)
//                {
//                    if([data.isDefault intValue] == 1)
//                    {
//                        addressData = data;
//                    }
//                }
//            }
//        }
//        if(result == 0)
//        {
//            addressArray = [[NSMutableArray alloc] init];
//        }
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
            if([DCFCustomExtra validateString:msg] == NO)
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

- (void) doBCReceiveAddressHasChange:(NSNotification *) noti
{
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[noti object]];
    [self changeReceiveAddress:dic];
}

- (void) changeReceiveAddress:(NSDictionary *) dic
{
    if([[dic allKeys] count] == 0 || [dic isKindOfClass:[NSNull class]])
    {
        
    }
    else
    {
        receiveAddressId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveAddressId"]];
        receiveTel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveTel"]];
        
        receiveprovince = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveprovince"]];
        receivecity = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receivecity"]];
        receivedistrict = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receivedistrict"]];
        receiveaddress = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiveaddress"]];
        detailAddress = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fullAddress"]];
        receiver = [NSString stringWithFormat:@"%@",[dic objectForKey:@"receiver"]];
        fullAddress = [NSString stringWithFormat:@"%@%@%@%@%@",receiveprovince,receivecity,receivedistrict,receiveaddress,detailAddress];
        fullAddress = [fullAddress stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    }
    [tv reloadData];
}

- (void) addAddressSuccessForB2B:(NSNotification *) noti
{
//    addSuccessDic = [[NSDictionary alloc] initWithObjectsAndKeys:receiveFullAddress,@"receiveFullAddress",receiver,@"receiver",mobile,@"mobile",addressid_b2b,@"addressid_b2b",addressid_b2c,@"addressid_b2c", nil];
    receiverDic = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)[noti object]];
    receiveAddressId = [receiverDic objectForKey:@"addressid_b2b"];
    receiver = [receiverDic objectForKey:@"receiver"];
    receiveTel = [receiverDic objectForKey:@"mobile"];
    fullAddress = [receiverDic objectForKey:@"receiveFullAddress"];
    [tv reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"提交询价单"];
    self.navigationItem.titleView = top;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doBCReceiveAddressHasChange:) name:@"B2CReceiveAddressHasChange" object:nil];

    chooseAddress = [[ChooseReceiveAddressViewController alloc] init];
    chooseAddress.delegate_1 = self;
    chooseAddress.B2COrB2B = NO;
    [chooseAddress loadRequest];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddAddressSuccessForB2B" object:addSuccessDic];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAddressSuccessForB2B:) name:@"AddAddressSuccessForB2B" object:nil];
    
    
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
    if([DCFCustomExtra validateString:fullAddress] == NO)
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
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&addressid=%@&type=%@",token,[self getMemberId],receiveAddressId,@"7"];
    
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
    
    
    if(section == 0)
    {
        //        [headLabel setText:@" 收货人信息"];
        return nil;
    }
    if(section == 1)
    {
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-15, 40)];
        [headLabel setTextColor:[UIColor blackColor]];
        headLabel.font = [UIFont systemFontOfSize:15];
        [headLabel setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
        [headLabel setText:@" 待询价型号信息"];
        return headLabel;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height;
    if (section == 0)
    {
        height = 0;
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
        if([DCFCustomExtra validateString:fullAddress] == NO)
        {
            return 44;
        }
        
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:fullAddress WithSize:CGSizeMake(ScreenWidth-80, MAXFLOAT)];
        
        return size.height + 55;
    }
    
    
    
    if(!self.dataArray || self.dataArray.count == 0)
    {
        return 0;
    }
    B2BAskPriceDetailData *data = [self.dataArray objectAtIndex:indexPath.row];
    
    CGFloat h1 = 0.0;
    CGFloat h2 = 0.0;
    CGFloat h3 = 0.0;

    if([DCFCustomExtra validateString:data.cartSpec] == NO && [DCFCustomExtra validateString:data.cartVoltage] == NO)
    {
        h1 = 0;
    }
    else
    {
        h1 = 20;
    }
    
    if([DCFCustomExtra validateString:data.cartColor] == NO && [DCFCustomExtra validateString:data.featureone] == NO)
    {
        h2 = 0;
    }
    else
    {
        h2 = 20;
    }
   
    NSString *require = [NSString stringWithFormat:@"特殊要求: %@",data.require];
    CGSize size_Requie = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:require WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
    if([DCFCustomExtra validateString:data.require] == NO)
    {
        h3 = 0;
    }
    else
    {
        h3 = size_Requie.height;
    }
    return 65+h1+h2+h3+5.5;
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
            if([[receiverDic allKeys] count] == 0 || [receiverDic isKindOfClass:[NSNull class]])
            {
                [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.textLabel setText:@"您还没有添加收货地址哦，去添加一个吧~"];
                flag = NO;
            }
            else
            {
                [cell.textLabel setText:@""];
                
                flag = YES;
                
          
                
                UILabel *nameLabel = nil;
                if([DCFCustomExtra validateString:receiver] == NO)
                {
                    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 50, 30)];
                }
                else
                {
                    CGSize size_name = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:receiver WithSize:CGSizeMake(MAXFLOAT, 30)];
                    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, size_name.width, 30)];
                }
                [nameLabel setText:receiver];
                nameLabel.textColor = [DCFColorUtil colorFromHexRGB:@"#ba7d04"];
                [nameLabel setTextAlignment:NSTextAlignmentLeft];
                [nameLabel setFont:[UIFont systemFontOfSize:14]];
                

                
                UILabel *telLabel = nil;
                if([DCFCustomExtra validateString:receiveTel] == NO)
                {
                    telLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 20, 10, 100, 30)];
                }
                else
                {
                    CGSize size_tel = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:receiveTel WithSize:CGSizeMake(MAXFLOAT, 30)];
                    telLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-70-size_tel.width, 10, size_tel.width, 30)];
                }
                [telLabel setText:receiveTel];
                telLabel.textColor = [DCFColorUtil colorFromHexRGB:@"#ba7d04"];
                [telLabel setFont:[UIFont systemFontOfSize:14]];
                [telLabel setTextAlignment:NSTextAlignmentRight];
                
                
                CGSize size;
                UILabel *addressLabel = nil;
                if([DCFCustomExtra validateString:fullAddress] == NO)
                {
                    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, nameLabel.frame.origin.y + nameLabel.frame.size.height+5, ScreenWidth-80, 30)];
                }
                else
                {
                    size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:fullAddress WithSize:CGSizeMake(ScreenWidth-80, MAXFLOAT)];
                    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, nameLabel.frame.origin.y + nameLabel.frame.size.height+5, ScreenWidth-80, size.height)];
                }
                [addressLabel setText:fullAddress];
                [addressLabel setFont:[UIFont systemFontOfSize:12]];
                addressLabel.textColor = [DCFColorUtil colorFromHexRGB:@"#ba7d04"];
                [addressLabel setNumberOfLines:0];
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35+size.height+5)];
                [view setBackgroundColor:[UIColor clearColor]];
                
                CGFloat cellHeight = 0.0;
                cellHeight = size.height + 55;
                
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, (cellHeight-40)/2, 40, 40)];
                [iv setImage:[UIImage imageNamed:@"location"]];
                
                UIImageView *arrowImageView = [[UIImageView alloc] init];
                arrowImageView.frame = CGRectMake(ScreenWidth-30, (cellHeight-20)/2, 20, 20);
                arrowImageView.image = [UIImage imageNamed:@"location_arrow"];
                [cell.contentView addSubview:arrowImageView];
                
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
            
            CGFloat halfWidth = (ScreenWidth-20)/2;
            
            NSString *uintString = [[NSUserDefaults standardUserDefaults] objectForKey:@"unit"];
            if([DCFCustomExtra validateString:uintString] == NO)
            {
                uintString = @"";
            }
            NSString *num = [NSString stringWithFormat:@"数量: %@%@",data.num,uintString];
            if([DCFCustomExtra validateString:data.deliver] == NO || [data.deliver isEqualToString:@"0"])
            {
                data.deliver = @"";
            }
            NSString *deliver = [NSString stringWithFormat:@"交货期: %@天",data.deliver];
            NSString *cartSpec = [NSString stringWithFormat:@"规格: %@平方",data.cartSpec];  //规格
            NSString *cartVoltage = [NSString stringWithFormat:@"电压: %@",data.cartVoltage];
            NSString *color = [NSString stringWithFormat:@"颜色: %@", data.cartColor];
            NSString *featureone = [NSString stringWithFormat:@"阻燃特性: %@",data.featureone];  //阻燃特性
            NSString *require = [NSString stringWithFormat:@"特殊要求: %@",data.require];
            
            NSMutableAttributedString *myNum = [[NSMutableAttributedString alloc] initWithString:num];
            [myNum addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [myNum addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, num.length-3)];
            
            NSMutableAttributedString *myDeliver = [[NSMutableAttributedString alloc] initWithString:deliver];
            [myDeliver addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
            [myDeliver addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(4, deliver.length-4)];
            
            NSMutableAttributedString *myCartSpec = [[NSMutableAttributedString alloc] initWithString:cartSpec];
            [myCartSpec addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [myCartSpec addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, cartSpec.length-3)];
            
            NSMutableAttributedString *myCartVoltage = [[NSMutableAttributedString alloc] initWithString:cartVoltage];
            [myCartVoltage addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [myCartVoltage addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, cartVoltage.length-3)];
            
            NSMutableAttributedString *myColor = [[NSMutableAttributedString alloc] initWithString:color];
            [myColor addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [myColor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, color.length-3)];
            
            NSMutableAttributedString *myFeatureone = [[NSMutableAttributedString alloc] initWithString:featureone];
            [myFeatureone addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
            [myFeatureone addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, featureone.length-5)];
            
            NSMutableAttributedString *myRequire = [[NSMutableAttributedString alloc] initWithString:require];
            [myRequire addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
            [myRequire addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, require.length-5)];
   
            for(int i=0;i<7;i++)
            {
                UILabel *cellLabel = [[UILabel alloc] init];
                [cellLabel setFont:[UIFont systemFontOfSize:12]];
                [cellLabel setNumberOfLines:0];
                if(i == 0)
                {
                    [cellLabel setFrame:CGRectMake(10, kindLabel.frame.origin.y+kindLabel.frame.size.height, halfWidth, 20)];
                    if([DCFCustomExtra validateString:data.num] == NO || [data.num floatValue] <= 0.0)
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
                    [cellLabel setFrame:CGRectMake(10+halfWidth, kindLabel.frame.origin.y+kindLabel.frame.size.height, halfWidth, 20)];
                    if([DCFCustomExtra validateString:data.deliver] == NO)
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
                        [cellLabel setFrame:CGRectMake(10, 65, halfWidth, 0)];
                    }
                    else
                    {
                        [cellLabel setFrame:CGRectMake(10, 65, halfWidth, 20)];
                        [cellLabel setAttributedText:myCartSpec];
                    }
                    
                }
                if(i == 3)
                {
                    if([DCFCustomExtra validateString:data.cartVoltage] == NO)
                    {
                        [cellLabel setFrame:CGRectMake(10+halfWidth, 65, halfWidth, 0)];
                    }
                    else
                    {
                        [cellLabel setFrame:CGRectMake(10+halfWidth, 65, halfWidth, 20)];
                        [cellLabel setAttributedText:myCartVoltage];
                    }
                    
                    if([DCFCustomExtra validateString:data.cartSpec] == NO && [DCFCustomExtra validateString:data.cartVoltage] == NO)
                    {
                        height_1 = 0;
                    }
                    else
                    {
                        height_1 = 20;
                    }
                }
                if(i == 4)
                {
                    if([DCFCustomExtra validateString:data.cartColor] == NO)
                    {
                        [cellLabel setFrame:CGRectMake(10, 65+height_1, halfWidth, 0)];
                    }
                    else
                    {
                        [cellLabel setFrame:CGRectMake(10, 65+height_1, halfWidth, 20)];
                        [cellLabel setAttributedText:myColor];
                    }
                }
                if(i == 5)
                {
                    if([DCFCustomExtra validateString:data.featureone] == NO)
                    {
                        [cellLabel setFrame:CGRectMake(10+halfWidth, 65+height_1, halfWidth, 0)];
                    }
                    else
                    {
                        [cellLabel setFrame:CGRectMake(10+halfWidth, 65+height_1, halfWidth, 20)];
                        [cellLabel setAttributedText:myFeatureone];
                    }
                    
                    if([DCFCustomExtra validateString:data.cartColor] == NO && [DCFCustomExtra validateString:data.featureone] == NO)
                    {
                        height_2 = 0;
                    }
                    else
                    {
                        height_2 = 20;
                    }
                }
  

                CGSize size_Requie;
                size_Requie = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:require WithSize:CGSizeMake(cell.contentView.frame.size.width-20, MAXFLOAT)];
                if(i == 6)
                {
                    if([DCFCustomExtra validateString:data.require] == NO)
                    {
                        height_3 = 0;
                        [cellLabel setFrame:CGRectMake(10, 65+height_1+height_2, size_Requie.width, 0)];
//                        [cellLabel setText:@"特殊需求:"];
                    }
                    else
                    {
                        height_3 = size_Requie.height;
                        [cellLabel setFrame:CGRectMake(10, 65+height_1+height_2, size_Requie.width, size_Requie.height)];
                        [cellLabel setAttributedText:myRequire];
                    }
                }

                [cell.contentView addSubview:cellLabel];
            }
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 65+height_1+height_2+height_3+4.5, ScreenWidth, 0.5)];
            [lineView setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:lineView];
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
}

@end
