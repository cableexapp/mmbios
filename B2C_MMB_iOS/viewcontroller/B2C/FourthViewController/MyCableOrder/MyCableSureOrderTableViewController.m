//
//  MyCableSureOrderTableViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyCableSureOrderTableViewController.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "DCFChenMoreCell.h"
#import "ChooseReceiveAddressViewController.h"
#import "B2CAddressData.h"
#import "DCFStringUtil.h"

@interface MyCableSureOrderTableViewController ()
{
    DCFChenMoreCell *moreCell;
    NSMutableArray *dataArray;
    
    UILabel *billMsgTypeLabel;
    UILabel *billMsgNameLabel;
    
    UILabel *billReceiveAddressLabel_1;
    UILabel *billReceiveAddressLabel_2;
    
    NSString *receiveprovince;
    NSString *receivecity;
    NSString *receivedistrict;
    NSString *receiveaddress;
    NSString *receiver;
    NSString *receiveTel;
    NSString *invoiceId;
    NSString *usefp;
    
    CGFloat height_1;
    CGFloat height_2;
    CGFloat height_3;
    CGFloat height_4;
    
}

@end

@implementation MyCableSureOrderTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if(!billMsgTypeLabel)
    {
        billMsgTypeLabel = [[UILabel alloc] init];
        [billMsgTypeLabel setFont:[UIFont systemFontOfSize:13]];
    }
    if(!billMsgNameLabel)
    {
        billMsgNameLabel = [[UILabel alloc] init];
        [billMsgNameLabel setFont:[UIFont systemFontOfSize:13]];
        [billMsgNameLabel setTextAlignment:NSTextAlignmentRight];
        [billMsgNameLabel setNumberOfLines:0];
    }
    
    //确认订单b2b发票信息
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"B2BBillMsg"])
    {
        [billMsgTypeLabel setFrame:CGRectMake(10, 5, ScreenWidth-20, 40)];
        [billMsgTypeLabel setText:@"暂无发票信息"];
        
        [billMsgNameLabel setFrame:CGRectZero];
        
        invoiceId = @"";
    }
    else
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"B2BBillMsg"]];
        invoiceId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"invoiceId"]];
        
        NSString *headType = [dic objectForKey:@"type"];
        if(headType.length == 0 || [headType isKindOfClass:[NSNull class]])
        {
            [billMsgTypeLabel setFrame:CGRectMake(10,5, 0, 30)];
        }
        else
        {
            CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:headType WithSize:CGSizeMake(MAXFLOAT, 30)];
            [billMsgTypeLabel setFrame:CGRectMake(10, 5, size.width, 30)];
        }
        [billMsgTypeLabel setText:headType];
        
        NSString *headName = [dic objectForKey:@"name"];
        if(headName.length == 0 || [headName isKindOfClass:[NSNull class]])
        {
            [billMsgNameLabel setFrame:CGRectMake(billMsgTypeLabel.frame.origin.x + billMsgTypeLabel.frame.size.width + 5, 5, 0, 30)];
        }
        else
        {
            CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:headName WithSize:CGSizeMake(ScreenWidth-25-billMsgTypeLabel.frame.size.width, MAXFLOAT)];
            if(size.height <= 30)
            {
                [billMsgNameLabel setFrame:CGRectMake(billMsgTypeLabel.frame.origin.x + billMsgTypeLabel.frame.size.width + 5, 5,ScreenWidth-25-billMsgTypeLabel.frame.size.width, 30)];
            }
            else
            {
                [billMsgNameLabel setFrame:CGRectMake(billMsgTypeLabel.frame.origin.x + billMsgTypeLabel.frame.size.width + 5, 5, ScreenWidth-25-billMsgTypeLabel.frame.size.width, MAXFLOAT)];
            }
        }
        [billMsgNameLabel setText:headName];
        
        //重设frame
        [billMsgTypeLabel setFrame:CGRectMake(billMsgTypeLabel.frame.origin.x, (billMsgNameLabel.frame.size.height+10-30)/2, billMsgTypeLabel.frame.size.width, 30)];
        
    }
    
    
    if(!billReceiveAddressLabel_1)
    {
        billReceiveAddressLabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 30)];
        [billReceiveAddressLabel_1 setFont:[UIFont systemFontOfSize:13]];
    }
    if(!billReceiveAddressLabel_2)
    {
        billReceiveAddressLabel_2 = [[UILabel alloc] initWithFrame:CGRectMake(10, billReceiveAddressLabel_1.frame.origin.y + billReceiveAddressLabel_1.frame.size.height, ScreenWidth-20, 30)];
        [billReceiveAddressLabel_2 setFont:[UIFont systemFontOfSize:13]];
        [billReceiveAddressLabel_2 setNumberOfLines:0];
    }
    //确认发票收货地址
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"defaultReceiveAddress"])
    {
        [billReceiveAddressLabel_1 setText:@"暂无发票邮寄地址"];
        [billReceiveAddressLabel_2 setFrame:CGRectMake(10, billReceiveAddressLabel_1.frame.origin.y + billReceiveAddressLabel_1.frame.size.height, ScreenWidth-20, 0)];
        
        receiveaddress = @"";
        receivecity = @"";
        receivedistrict = @"";
        receiveprovince = @"";
        receiver = @"";
        receiveTel = @"";
    }
    else
    {
        NSDictionary *receiveDic = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultReceiveAddress"]];
        
        
        receiver = [NSString stringWithFormat:@"%@",[receiveDic objectForKey:@"receiver"]];
        receiveTel = [NSString stringWithFormat:@"%@",[receiveDic objectForKey:@"receiveTel"]];
        receiveprovince = [NSString stringWithFormat:@"%@",[receiveDic objectForKey:@"receiveprovince"]];
        receivecity = [NSString stringWithFormat:@"%@",[receiveDic objectForKey:@"receivecity"]];
        receivedistrict = [NSString stringWithFormat:@"%@",[receiveDic objectForKey:@"receivedistrict"]];
        receiveaddress = [NSString stringWithFormat:@"%@",[receiveDic objectForKey:@"receiveaddress"]];
        
        [billReceiveAddressLabel_1 setText:[NSString stringWithFormat:@"%@    %@",receiver,receiveTel]];
        NSString *fullAddress = [NSString stringWithFormat:@"%@%@%@%@",receiveprovince,receivecity,receivedistrict,receiveaddress];
        if(fullAddress.length == 0 || [fullAddress isKindOfClass:[NSNull class]])
        {
            [billReceiveAddressLabel_2 setFrame:CGRectMake(10, billReceiveAddressLabel_1.frame.origin.y + billReceiveAddressLabel_1.frame.size.height, ScreenWidth-20, 0)];
        }
        else
        {
            CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:fullAddress WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
            [billReceiveAddressLabel_2 setFrame:CGRectMake(10, billReceiveAddressLabel_1.frame.origin.y + billReceiveAddressLabel_1.frame.size.height, ScreenWidth-20, size.height)];
        }
        [billReceiveAddressLabel_2 setText:fullAddress];
        
    }
    
    
    
    //确认是否使用发票
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"B2BManageBillSwitchStatus"])
    {
        usefp = @"2";
    }
    else
    {
        BOOL B2BManageBillSwitchStatus = [[[NSUserDefaults standardUserDefaults] objectForKey:@"B2BManageBillSwitchStatus"] boolValue];
        if(B2BManageBillSwitchStatus == YES)
        {
            usefp = @"1";
        }
        else
        {
            usefp = @"2";
            [billMsgTypeLabel setText:@"不需要发票"];
            [billMsgNameLabel setText:@""];
        }
    }
    [self.tableView reloadData];
    
    
}

- (void) loadRequest
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"ConfirmOrder",time];
    NSString *token = [DCFCustomExtra md5:string];
    
//    loginid,token,ordernum(订单编号),usefp(是否使用发票,1-使用，2-不使用),receiveprovince(收货省),receivecity(收货市),receivedistrict(收货区),receiveaddress(详细地址),receiver(收货人),tel(电话),invoiceid(发票id),invoiceprovince(发票邮寄省）, invoicecity（发票邮寄市）, invoicedistrict（发票邮寄区）, invoiceaddress（发票邮寄具体地址）, invoicetel（发票收获人电话）, invoicereceiver（发票收获人）
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&orderid=%@&usefp=%@&receiveprovince=%@&receivecity=%@&receivedistrict=%@&receiveaddress=%@&receiver=%@&tel=%@&invoiceid=%@&invoiceprovince=%@&invoicecity=%@&invoicedistrict=%@&invoiceaddress=%@&invoicetel=%@&invoicereceiver=%@",token,self.myOrderid,usefp,receiveprovince,receivecity,receivedistrict,receiveaddress,receiver,receiveTel,invoiceId,@"invoiceprovince",@"invoicecity",@"invoicedistrict",@"invoiceaddress",@"invoicetel",@"invoicereceiver"];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLConfirmOrderTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/ConfirmOrder.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLConfirmOrderTag)
    {
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
        }
        else
        {
            if(msg.length == 0 || [msg isKindOfClass:[NSNull class]])
            {
                [DCFStringUtil showNotice:@"确定失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:229.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:229.0/255.0 blue:240.0/255.0 alpha:1.0]];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"OrderDetail",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&orderid=%@",token,self.myOrderid];
    NSLog(@"%@",pushString);
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLOrderDetailTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/OrderDetail.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
    
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        if([usefp intValue] == 1)
        {
            
        }
        else
        {
            return 0;
        }
    }
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    //    [view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth-20, 30)];
    //    [label setTextColor:MYCOLOR];
    //    label.layer.borderColor = MYCOLOR.CGColor;
    //    label.layer.borderWidth = 1.0f;
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    if(section == 0)
    {
        [label setText:@"发票信息"];
    }
    if(section == 1)
    {
        [label setText:@"发票邮寄地址"];
    }
    if(section == 2)
    {
        [label setText:@"收货地址"];
    }
    if(section == 3)
    {
        [label setText:@"型号信息"];
    }
    [label setBackgroundColor:[UIColor whiteColor]];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:label];
    
    for(int i=0;i<2;i++)
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5*i, ScreenWidth, 0.5)];
        [lineView setBackgroundColor:MYCOLOR];
        [view addSubview:lineView];
    }
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0 || section == 1 || section == 2)
    {
        return 1;
    }
    return [_b2bMyCableOrderListData myItems].count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 44;
    }
    if(indexPath.section == 1)
    {
        if([usefp intValue] == 1)
        {
        }
        else
        {
            return 0;
        }
        
        NSDictionary *receiveDic = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultReceiveAddress"]];
        
        
        receiver = [NSString stringWithFormat:@"%@",[receiveDic objectForKey:@"receiver"]];
        receiveTel = [NSString stringWithFormat:@"%@",[receiveDic objectForKey:@"receiveTel"]];
        receiveprovince = [NSString stringWithFormat:@"%@",[receiveDic objectForKey:@"receiveprovince"]];
        receivecity = [NSString stringWithFormat:@"%@",[receiveDic objectForKey:@"receivecity"]];
        receivedistrict = [NSString stringWithFormat:@"%@",[receiveDic objectForKey:@"receivedistrict"]];
        receiveaddress = [NSString stringWithFormat:@"%@",[receiveDic objectForKey:@"receiveaddress"]];
        NSString *fullAddress = [NSString stringWithFormat:@"%@%@%@%@",receiveprovince,receivecity,receivedistrict,receiveaddress];
        NSLog(@"%@",fullAddress);
        if([DCFCustomExtra validateString:receiveprovince] == NO && [DCFCustomExtra validateString:receivecity] == NO && [DCFCustomExtra validateString:receivedistrict] == NO && [DCFCustomExtra validateString:receiveaddress] == NO)
        {
            return 40;
        }
        else
        {
            CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:fullAddress WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
            return size.height+40;
        }
    }
    if(indexPath.section == 2)
    {
        NSString *address = [NSString stringWithFormat:@"%@",[self.addressDic objectForKey:@"fullAddress"]];
        CGSize size;
        if(address.length == 0 || [address isKindOfClass:[NSNull class]])
        {
            size = CGSizeMake(30, 0);
        }
        else
        {
            size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:address WithSize:CGSizeMake(ScreenWidth-40, MAXFLOAT)];
        }
        return size.height+40;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[_b2bMyCableOrderListData.myItems objectAtIndex:indexPath.row]];
    
    NSString *theInquirySpec = [NSString stringWithFormat:@"%@",[dic objectForKey:@"spec"]]; //规格
    NSString *theInquiryVoltage = [NSString stringWithFormat:@"%@",[dic objectForKey:@"voltage"]]; //电压
    NSString *theInquiryFeature = [NSString stringWithFormat:@"%@",[dic objectForKey:@"feature"]]; //阻燃
    NSString *thecolor = [NSString stringWithFormat:@"%@",[dic objectForKey:@"color"]]; //颜色
    
    NSString *thePrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]]; //价格
    NSString *theRequire = [NSString stringWithFormat:@"%@",[dic objectForKey:@"require"]]; //特殊要求
    
    CGFloat h1 = 0.0;
    CGFloat h2 = 0.0;
    CGFloat h3 = 0.0;
    CGFloat h4 = 0.0;
    if([DCFCustomExtra validateString:theInquirySpec] == NO && [DCFCustomExtra validateString:theInquiryVoltage] == NO)
    {
        h1 = 0;
    }
    else
    {
        h1 = 20;
    }
    if([DCFCustomExtra validateString:theInquiryFeature] == NO && [DCFCustomExtra validateString:thecolor] == NO)
    {
        h2 = 0;
    }
    else
    {
        h2 = 20;
    }
    if([DCFCustomExtra validateString:thePrice] == NO || [thePrice intValue] == 0)
    {
        h3 = 0;
    }
    else
    {
        h3 = 20;
    }
    CGSize requestSize;
    if([DCFCustomExtra validateString:theRequire] == NO)
    {
        h4 = 0;
        requestSize = CGSizeMake(ScreenWidth-20, 0);
    }
    else
    {
        requestSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:theRequire WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
        h4 = requestSize.height;
    }
    return 65.5+h1+h2+h3+h4+5;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        //        [cell.contentView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [cell setSelectionStyle:0];
        
        
        if(indexPath.section == 0)
        {
            [cell.contentView addSubview:billMsgTypeLabel];
            [cell.contentView addSubview:billMsgNameLabel];
        }
        if(indexPath.section == 1)
        {
            [cell.contentView addSubview:billReceiveAddressLabel_1];
            [cell.contentView addSubview:billReceiveAddressLabel_2];
        }
        
        if(indexPath.section == 2)
        {
            if(indexPath.row == 0)
            {
                NSString *name = [self.addressDic objectForKey:@"name"];
                NSString *tel = [NSString stringWithFormat:@"%@",[self.addressDic objectForKey:@"tel"]];
                NSString *str = [NSString stringWithFormat:@"%@      %@",name,tel];
                UILabel *nameAndTelLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, cell.contentView.frame.size.width-40, 30)];
                [nameAndTelLabel setText:str];
                [nameAndTelLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:nameAndTelLabel];
                
                NSString *address = [NSString stringWithFormat:@"%@",[self.addressDic objectForKey:@"fullAddress"]];
                CGSize size;
                if(address.length == 0 || [address isKindOfClass:[NSNull class]])
                {
                    size = CGSizeMake(30, 30);
                }
                else
                {
                    size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:address WithSize:CGSizeMake(cell.contentView.frame.size.width-40, MAXFLOAT)];
                }
                UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, nameAndTelLabel.frame.origin.y + nameAndTelLabel.frame.size.height, size.width, size.height)];
                [addressLabel setText:address];
                [addressLabel setFont:[UIFont systemFontOfSize:12]];
                [addressLabel setNumberOfLines:0];
                [cell.contentView addSubview:addressLabel];
            }
        }
        if(indexPath.section == 3)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, 45)];
            [view setBackgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:view];
            
            CGFloat halfWidth = (ScreenWidth-20)/2;
            
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[[_b2bMyCableOrderListData myItems] objectAtIndex:indexPath.row]];
            //型号
            NSString *model = [NSString stringWithFormat:@"型号: %@",[dic objectForKey:@"model"]];
            NSMutableAttributedString *myModel = [[NSMutableAttributedString alloc] initWithString:model];
            [myModel addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
            [myModel addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, model.length-3)];
            
            //分类
            NSString *firstType = (NSString *)[dic objectForKey:@"firstType"];
            NSString *secondType = (NSString *)[dic objectForKey:@"secondType"];
            NSString *thridType = (NSString *)[dic objectForKey:@"thridType"];
            NSString *type = [NSString stringWithFormat:@"分类: %@%@%@",firstType,secondType,thridType];
            type = [type stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            NSMutableAttributedString *myType = [[NSMutableAttributedString alloc] initWithString:type];
            [myType addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
            [myType addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, type.length-3)];
            
            UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 20)];
            [modelLabel setAttributedText:myModel];
            [modelLabel setFont:[UIFont systemFontOfSize:12]];
            [view addSubview:modelLabel];
            
            
            UILabel *fenleiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, modelLabel.frame.origin.y + modelLabel.frame.size.height, modelLabel.frame.size.width, 20)];
            [fenleiLabel setAttributedText:myType];
            [fenleiLabel setFont:[UIFont systemFontOfSize:12]];
            [view addSubview:fenleiLabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.origin.y+view.frame.size.height, cell.contentView.frame.size.width, 0.5)];
            [lineView setBackgroundColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
            [cell.contentView addSubview:lineView];
            
            NSString *unit = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unit"]];
            NSString *theNumber = [NSString stringWithFormat:@"数量: %@%@",[dic objectForKey:@"num"],unit];  //数量
            NSMutableAttributedString *myNumber = [[NSMutableAttributedString alloc] initWithString:theNumber];
            [myNumber addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
            [myNumber addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, theNumber.length-3)];
            
            
            NSString *thDeliver = [NSString stringWithFormat:@"交货期: %@天",[dic objectForKey:@"deliver"]];   //交货期
            NSMutableAttributedString *myDeliver = [[NSMutableAttributedString alloc] initWithString:thDeliver];
            [myDeliver addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [myDeliver addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(4, thDeliver.length-4)];
            
            
            
            NSString *theInquirySpec = [NSString stringWithFormat:@"规格: %@",[dic objectForKey:@"spec"]]; //规格
            NSMutableAttributedString *myInquirySpec = [[NSMutableAttributedString alloc] initWithString:theInquirySpec];
            [myInquirySpec addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
            [myInquirySpec addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, theInquirySpec.length-3)];
            
            
            
            NSString *theInquiryVoltage = [NSString stringWithFormat:@"电压: %@",[dic objectForKey:@"voltage"]]; //电压
            NSMutableAttributedString *myInquiryVoltage = [[NSMutableAttributedString alloc] initWithString:theInquiryVoltage];
            [myInquiryVoltage addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
            [myInquiryVoltage addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, theInquiryVoltage.length-3)];
            
            
            NSString *theInquiryFeature = [NSString stringWithFormat:@"阻燃耐火: %@",[dic objectForKey:@"feature"]]; //阻燃
            NSMutableAttributedString *myInquiryFeature = [[NSMutableAttributedString alloc] initWithString:theInquiryFeature];
            [myInquiryFeature addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
            [myInquiryFeature addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, theInquiryFeature.length-5)];
            
            
            NSString *thecolor = [NSString stringWithFormat:@"颜色: %@",[dic objectForKey:@"color"]]; //颜色
            NSMutableAttributedString *myColor = [[NSMutableAttributedString alloc] initWithString:thecolor];
            [myColor addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
            [myColor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, thecolor.length-3)];
            
            NSString *thePrice = [NSString stringWithFormat:@"询价结果: %@/%@",[dic objectForKey:@"price"],unit]; //价格
            NSMutableAttributedString *myPrice = [[NSMutableAttributedString alloc] initWithString:thePrice];
            [myPrice addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
            [myPrice addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, thePrice.length-5)];
            
            
            NSString *theRequire = [NSString stringWithFormat:@"特殊要求: %@",[dic objectForKey:@"require"]]; //特殊要求
            NSMutableAttributedString *myRequire = [[NSMutableAttributedString alloc] initWithString:theRequire];
            [myRequire addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
            [myRequire addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, theRequire.length-5)];
            
            
            for(int i=0;i<6;i++)
            {
                UILabel *label = [[UILabel alloc] init];
                if(i % 2 != 0)
                {
                    [label setTextAlignment:NSTextAlignmentCenter];
                }
                else
                {
                    [label setTextAlignment:NSTextAlignmentLeft];
                }
                [label setFont:[UIFont systemFontOfSize:12]];
                switch (i) {
                    case 0:
                    {
                        
                        
                        [label setFrame:CGRectMake(10, lineView.frame.origin.y+5.5, halfWidth, 20)];
                        if([[dic objectForKey:@"num"] intValue] == 0)
                        {
                            [label setText:@"采购数量:"];
                        }
                        else
                        {
                            [label setAttributedText:myNumber];
                        }
                        break;
                    }
                    case 1:
                    {
                        [label setFrame:CGRectMake(10+halfWidth, lineView.frame.origin.y+5.5, halfWidth, 20)];
                        if([[dic objectForKey:@"deliver"] intValue] == 0)
                        {
                            [label setText:[NSString stringWithFormat:@"交货期:%@",@""]];
                        }
                        else
                        {
                            [label setAttributedText:myDeliver];
                        }
                        break;
                    }
                        
                    case 2:
                    {
                        if([DCFCustomExtra validateString:[dic objectForKey:@"spec"]] == NO)
                        {
                            [label setFrame:CGRectMake(10, 65.5, halfWidth, 0)];
                        }
                        else
                        {
                            [label setFrame:CGRectMake(10, 65.5, halfWidth, 20)];
                            [label setAttributedText:myInquirySpec];
                        }
                        break;
                    }
                        
                    case 3:
                    {
                        if([DCFCustomExtra validateString:[dic objectForKey:@"voltage"]] == NO)
                        {
                            [label setFrame:CGRectMake(10+halfWidth, 65.5, halfWidth, 0)];
                        }
                        else
                        {
                            [label setAttributedText:myInquiryVoltage];
                            [label setFrame:CGRectMake(10+halfWidth,65.5, halfWidth, 20)];
                        }
                        
                        if([DCFCustomExtra validateString:[dic objectForKey:@"spec"]] == NO && [DCFCustomExtra validateString:[dic objectForKey:@"voltage"]] == NO)
                        {
                            height_1 = 0;
                        }
                        else
                        {
                            height_1 = 20;
                        }
                        
                        break;
                    }
                        
                    case 4:
                    {
                        if([DCFCustomExtra validateString:[dic objectForKey:@"feature"]] == NO)
                        {
                            [label setFrame:CGRectMake(10, 65.5+height_1, halfWidth, 0)];
                        }
                        else
                        {
                            [label setAttributedText:myInquiryFeature];
                            [label setFrame:CGRectMake(10, 65.5+height_1, halfWidth, 20)];
                        }
                        break;
                    }
                        
                    case 5:
                    {
                        if([DCFCustomExtra validateString:[dic objectForKey:@"color"]] == NO)
                        {
                            [label setFrame:CGRectMake(10+halfWidth, 65.5+height_1, halfWidth, 0)];
                        }
                        else
                        {
                            [label setAttributedText:myColor];
                            [label setFrame:CGRectMake(10+halfWidth, 65.5+height_1, halfWidth, 20)];
                        }
                        
                        if([DCFCustomExtra validateString:[dic objectForKey:@"feature"]] == NO && [DCFCustomExtra validateString:[dic objectForKey:@"color"]] == NO)
                        {
                            height_2 = 0;
                        }
                        else
                        {
                            height_2 = 20;
                        }
                        
                        break;
                    }
                        
                    default:
                        break;
                }
                
                [cell.contentView addSubview:label];
            }
            
            
            UILabel *pricelabel = [[UILabel alloc] init];
            [pricelabel setFont:[UIFont systemFontOfSize:12]];
            if([[dic objectForKey:@"price"] intValue] == 0)
            {
                [pricelabel setFrame:CGRectMake(10, 65.5+height_1+height_2,ScreenWidth-20,0)];
                height_3 = 0;
            }
            else
            {
                [pricelabel setFrame:CGRectMake(10, 65.5+height_1+height_2,ScreenWidth-20,20)];
                height_3 = 20;
                [pricelabel setAttributedText:myPrice];
            }
            [cell.contentView addSubview:pricelabel];
            
            
            UILabel *requestLabel = [[UILabel alloc] init];
            [requestLabel setFont:[UIFont systemFontOfSize:12]];
            [requestLabel setNumberOfLines:0];
            
            CGSize requestSize;
            if([DCFCustomExtra validateString:[dic objectForKey:@"require"]] == NO)
            {
                [requestLabel setFrame:CGRectMake(10, 65.5+height_1+height_2+height_3, ScreenWidth-20, 0)];
                requestSize = CGSizeMake(ScreenWidth-20, 0);
                height_4 = 0;
            }
            else
            {
                requestSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:theRequire WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
                [requestLabel setFrame:CGRectMake(10, 65.5+height_1+height_2+height_3, ScreenWidth-20, requestSize.height)];
                [requestLabel setAttributedText:myRequire];
                height_4 = requestSize.height;
            }
            
            [cell.contentView addSubview:requestLabel];
            
            
        }
    }
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        manageInvoiceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"manageInvoiceViewController"];
        [self.navigationController pushViewController:manageInvoiceViewController animated:YES];
    }
    if(indexPath.section == 1)
    {
        ChooseReceiveAddressViewController *chooseAddress = [[ChooseReceiveAddressViewController alloc] init];
        [self.navigationController pushViewController:chooseAddress animated:YES];
    }
    if(indexPath.section == 2)
    {
        
    }
    if(indexPath.section == 3)
    {
        
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

@end
