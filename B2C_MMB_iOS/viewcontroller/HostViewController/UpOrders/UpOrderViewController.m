//
//  UpOrderViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-9-23.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "UpOrderViewController.h"
#import "DCFCustomExtra.h"
#import "DCFTopLabel.h"
#import "ChooseReceiveAddressViewController.h"
#import "BillMsgManagerViewController.h"
#import "ChoosePayTableViewController.h"
#import "LoginNaviViewController.h"
#import "DCFStringUtil.h"
#import "B2CAddressData.h"


@interface UpOrderViewController ()
{
    UIView *buttomView;
    
    DCFPickerView *pickerView;
    
    NSMutableArray *contentArray;
    
    NSString *sendMethod;
    
    NSString *billMsg;
    
    UIStoryboard *sb;

    NSMutableArray *addressListDataArray;   //收货地址数组
    
    
    NSString *myAddressId;
}
@end

@implementation UpOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) upBtnClick:(UIButton *) sender
{
    
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"SubOrder",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSDictionary *pushDic = [[NSDictionary alloc] initWithObjectsAndKeys:myAddressId,@"address", nil];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@",token,[self getMemberId]];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSubOrderTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/SubOrder.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
//    ChoosePayTableViewController *pay = [[ChoosePayTableViewController alloc] init];
//    [self.navigationController pushViewController:pay animated:YES];
}


- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if(memberid.length == 0)
    {
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    
//    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
//    
//    if(memberid.length == 0 || memberid == nil || [memberid isKindOfClass:[NSNull class]])
//    {
//        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
//        [self presentViewController:loginNavi animated:YES completion:nil];
//        
//    }
//    else
//    {
    
        NSString *time = [DCFCustomExtra getFirstRunTime];
        NSString *string = [NSString stringWithFormat:@"%@%@",@"getMemberAddressList",time];
        NSString *token = [DCFCustomExtra md5:string];
        
        NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@",token,[self getMemberId]];
    
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLReceiveAddressTag delegate:self];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getMemberAddressList.html?"];
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
        
//    }
    
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"BillMsg"])
    {
        billMsg = @"不需要发票";
    }
    else
    {
        NSMutableArray *billMsgArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"BillMsg"];
        billMsg = [billMsgArray objectAtIndex:0];
    }
    NSLog(@"billMsg=%@",billMsg);
    
//    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"receiveAddress"])
//    {
//        addressDic = [[NSDictionary alloc] init];
//    }
//    else
//    {
//        addressArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"receiveAddress"];
//        addressDic = [addressArray lastObject];
//    }
    
    if(tv)
    {
        [tv reloadData];
    }
    
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

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if (URLTag == URLReceiveAddressTag)
    {
        if(result == 0)
        {
            if(msg.length != 0)
            {
                [DCFStringUtil showNotice:msg];
            }
            else
            {
                [DCFStringUtil showNotice:@"获取收货地址失败"];
            }
        }
        else if (result == 1)
        {
            [DCFStringUtil showNotice:msg];
            
            addressListDataArray = [[NSMutableArray alloc] initWithArray:[B2CAddressData getListArray:[dicRespon objectForKey:@"items"]]];
            
            [tv reloadData];
        }
    }
    if(URLTag == URLSubOrderTag)
    {
        NSLog(@"%@",dicRespon);
        if(result == 1)
        {
            
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    
    
    contentArray = [[NSMutableArray alloc] initWithObjects:@"快递:¥8.00",@"平邮:¥5.00",@"物流:¥7.00 ", nil];
    sendMethod = [contentArray objectAtIndex:0];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装线订单提交"];
    self.navigationItem.titleView = top;
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight - 64 - 50)];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setShowsVerticalScrollIndicator:NO];
    [tv setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
    [self.view addSubview:tv];
    
    buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-50-64, 320, 50)];
    [buttomView setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
    [self.view addSubview:buttomView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 50)];
    [label setText:@"总计(连运费):¥2500.88"];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [buttomView addSubview:label];
    
    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [upBtn setTitle:@"提交" forState:UIControlStateNormal];
    [upBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [upBtn setFrame:CGRectMake(320-100, 5, 80, 40)];
    [upBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    upBtn.layer.borderColor = [UIColor blueColor].CGColor;
    upBtn.layer.borderWidth = 1.0f;
    upBtn.layer.cornerRadius = 5.0f;
    [buttomView addSubview:upBtn];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if(!addressListDataArray || addressListDataArray.count == 0)
        {
            return 1;
        }
        else
        {
            return addressListDataArray.count;
        }
    }
    if(section == 1)
    {
        return 1;
    }
    return 3;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
//        if(indexPath.row == 0)
//        {
            if(!addressListDataArray || addressListDataArray.count == 0)
            {
                return 44;
            }
            else
            {
                NSString *s1 = [[addressListDataArray objectAtIndex:indexPath.row] province];
                NSString  *s2 = [[addressListDataArray objectAtIndex:indexPath.row] city];
                NSString *s3 = [[addressListDataArray objectAtIndex:indexPath.row] area];
                NSString *s4 = [[addressListDataArray objectAtIndex:indexPath.row] addressName];
                NSString *str = [NSString stringWithFormat:@"%@%@%@\n%@",s1,s2,s3,s4];
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(260, MAXFLOAT)];
                UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 35, 260, size.height)];
                [addressLabel setText:str];
                [addressLabel setFont:[UIFont systemFontOfSize:12]];
                [addressLabel setNumberOfLines:0];
                
                
                return 30+size.height + 10;
                
            }
//        }
    }
    if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            NSString *str = @"［五月团购］远东电缆BV2.5平方搭配套餐300米";
            CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(220, MAXFLOAT)];
            
            
            CGSize size_4 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"¥500" WithSize:CGSizeMake(MAXFLOAT, 20)];
            
            
            CGFloat height = size_3.height+size_4.height;
            if(height <= 40)
            {
                return 85;
            }
            else
            {
                return 35+height+10;
                
            }
        }
        
        return 44;
    }
    return 44;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-1, 0, 322, 30)];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setBackgroundColor:[UIColor whiteColor]];
    if(section == 0)
    {
        [label setText:@"  收货地址"];
    }
    if(section == 1)
    {
        [label setText:@"  发票信息"];
    }
    if(section == 2)
    {
        [label setText:@"  商品信息"];
    }
    [label setTextColor:[UIColor blueColor]];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    label.layer.borderColor = [UIColor blueColor].CGColor;
    label.layer.borderWidth = 1.5f;
    return label;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [cell setSelectionStyle:0];
        
        if(indexPath.section == 0)
        {
            
            if(!addressListDataArray || [addressListDataArray count] == 0)
            {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
                [view setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
                [cell.contentView addSubview:view];
                
                [cell.textLabel setText:@"暂无收货人信息"];
            }
            else
            {
                //                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                //                                     chooseProvince,@"province",
                //                                     chooseCity,@"city",
                //                                     chooseAddress,@"town",
                //                                     chooseAddressName,@"detailAddress",
                //                                     chooseCode,@"code",
                //                                     [NSNumber numberWithBool:swith.isOn],@"swithStatus",
                //                                     receiverTf.text,@"name",
                //                                     zipTf.text,@"zip",
                //                                     mobileTf.text,@"mobile",
                //                                     nil];
                
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 30)];
                [iv setImage:[UIImage imageNamed:@"magnifying glass.png"]];
                
       
                
                NSString *name = [[addressListDataArray objectAtIndex:indexPath.row] receiver];
                CGSize size_name = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:name WithSize:CGSizeMake(MAXFLOAT, 30)];
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, size_name.width, 30)];
                [nameLabel setText:name];
                [nameLabel setTextAlignment:NSTextAlignmentLeft];
                [nameLabel setFont:[UIFont systemFontOfSize:13]];
                
                
                NSString *tel = [[addressListDataArray objectAtIndex:indexPath.row] tel];
                CGSize size_tel = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:tel WithSize:CGSizeMake(MAXFLOAT, 30)];
                UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-20-size_tel.width, 5, size_tel.width, 30)];
                [telLabel setText:tel];
                [telLabel setFont:[UIFont systemFontOfSize:13]];
                [telLabel setTextAlignment:NSTextAlignmentRight];
                [cell.contentView addSubview:telLabel];
                
                NSLog(@"**********%@",[[addressListDataArray objectAtIndex:indexPath.row] addressId]);
                
                NSString *s1 = [[addressListDataArray objectAtIndex:indexPath.row] province];
                NSString  *s2 = [[addressListDataArray objectAtIndex:indexPath.row] city];
                NSString *s3 = [[addressListDataArray objectAtIndex:indexPath.row] area];
                NSString *s4 = [[addressListDataArray objectAtIndex:indexPath.row] addressName];
                NSString *str = [NSString stringWithFormat:@"%@%@%@\n%@",s1,s2,s3,s4];
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(260, MAXFLOAT)];
                UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, nameLabel.frame.origin.y + nameLabel.frame.size.height, 260, size.height)];
                [addressLabel setText:str];
                [addressLabel setFont:[UIFont systemFontOfSize:12]];
                [addressLabel setNumberOfLines:0];
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35+size.height+5)];
                [view setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
                [cell.contentView addSubview:view];
                [cell.contentView addSubview:iv];
                [cell.contentView addSubview:nameLabel];
                [cell.contentView addSubview:addressLabel];
            }
            
        }
        if(indexPath.section == 1)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
            [view setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
            [cell.contentView addSubview:view];
            [cell.textLabel setText:billMsg];
        }
        if(indexPath.section == 2)
        {
            if(indexPath.row == 0)
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
                [label setText:@"远东电缆旗舰店"];
                [label setFont:[UIFont systemFontOfSize:12]];
                
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(20, label.frame.origin.y + label.frame.size.height + 10, 40, 40)];
                [iv setImage:[UIImage imageNamed:@"magnifying glass.png"]];
                
                NSString *str = @"［五月团购］远东电缆BV2.5平方搭配套餐300米";
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(220, MAXFLOAT)];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, iv.frame.origin.y, 220, size.height)];
                [titleLabel setText:str];
                [titleLabel setFont:[UIFont systemFontOfSize:12]];
                [titleLabel setNumberOfLines:0];
                
                CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"¥500" WithSize:CGSizeMake(MAXFLOAT, 20)];
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, titleLabel.frame.origin.y + titleLabel.frame.size.height, size_1.width, 20)];
                [priceLabel setText:@"¥500"];
                [priceLabel setFont:[UIFont systemFontOfSize:12]];
                
                CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"*5" WithSize:CGSizeMake(MAXFLOAT, 20)];
                UILabel *countlabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.size.width + 20, priceLabel.frame.origin.y, size_2.width, 20)];
                [countlabel setText:@"*5"];
                [countlabel setFont:[UIFont systemFontOfSize:12]];
                
                CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"小计: ¥2500" WithSize:CGSizeMake(MAXFLOAT, 20)];
                UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-30-size_3.width, countlabel.frame.origin.y, size_3.width, 20)];
                [totalLabel setText:@"小计: ¥2500"];
                [totalLabel setFont:[UIFont systemFontOfSize:12]];
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
                [view setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
                CGFloat height = size.height+size_1.height;
                if(height <= 40)
                {
                    [view setFrame:CGRectMake(0, 0, 320, 85)];
                }
                else
                {
                    [view setFrame:CGRectMake(0, 0, 320, 35+height+10)];
                }
                [cell.contentView addSubview:view];
                [cell.contentView addSubview:label];
                [cell.contentView addSubview:iv];
                [cell.contentView addSubview:titleLabel];
                [cell.contentView addSubview:priceLabel];
                [cell.contentView addSubview:countlabel];
                [cell.contentView addSubview:totalLabel];
            }
            if(indexPath.row == 1)
            {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
                [view setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
                [cell.contentView addSubview:view];
                [cell.textLabel setText:@"商品备注"];
                [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            }
            if(indexPath.row == 2)
            {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
                [view setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
                [cell.contentView addSubview:view];
                
                NSString *str = [NSString stringWithFormat:@"配送费:%@",sendMethod];
                
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(MAXFLOAT,20)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(320-30-size.width, 7, size.width, 30)];
                [label setText:str];
                [label setTextAlignment:NSTextAlignmentRight];
                [label setFont:[UIFont systemFontOfSize:12]];
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
        if(!addressListDataArray || addressListDataArray.count == 0)
        {
            
        }
        else
        {
            myAddressId = [[addressListDataArray objectAtIndex:indexPath.row] addressId];
            
            ChooseReceiveAddressViewController *chooseAddress = [[ChooseReceiveAddressViewController alloc] initWithDataArray:addressListDataArray];
            [self.navigationController pushViewController:chooseAddress animated:YES];
        }

    }
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        BillMsgManagerViewController *billManager = [[BillMsgManagerViewController alloc] init];
        
        NSString *invoId = nil;
        NSString *headTag = nil;
        
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"BillMsg"])
        {
            billMsg = @"请输入个人名称";
            invoId = @"";
            headTag = @"0";
            billManager.editOrAddBill = NO;
            billManager.naviTitle = @"新增发票";
        }
        else
        {
            NSMutableArray *billMsgArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"BillMsg"];
            billMsg = [billMsgArray objectAtIndex:0];
            invoId = [billMsgArray objectAtIndex:1];
            headTag = [billMsgArray objectAtIndex:2];
            billManager.editOrAddBill = YES;
            billManager.naviTitle = @"编辑发票";

        }
 
        
        billManager.tfContent = billMsg;
        billManager.invoiceid = invoId;
        billManager.billHeadTag = [headTag intValue];
        
        [self.navigationController pushViewController:billManager animated:YES];
    }
    if(indexPath.section == 2 && indexPath.row == 2)
    {
        pickerView = [[DCFPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.window.frame.size.height) WithArray:contentArray];
        pickerView.delegate = self;
        [self.view.window setBackgroundColor:[UIColor blackColor]];
        [self.view.window addSubview:pickerView];
    }
}

- (void) pickerView:(NSString *)title
{
    sendMethod = title;
    [tv reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
