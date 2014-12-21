//
//  ChooseReceiveAddressViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-24.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "ChooseReceiveAddressViewController.h"
#import "DCFCustomExtra.h"
#import "AddReceiveAddressViewController.h"
#import "AddReceiveFinalViewController.h"
#import "DCFChenMoreCell.h"
#import "B2CAddressData.h"
#import "LoginNaviViewController.h"
#import "DCFStringUtil.h"
#import "ManagReceiveAddressViewController.h"

@interface ChooseReceiveAddressViewController ()
{
    NSMutableArray *cellBtnArray;
    
    UIButton *rightItemBtn;
    
    UIStoryboard *sb;
    
    NSMutableArray *addressListDataArray;
    
    DCFChenMoreCell *moreCell;
}
@end

@implementation ChooseReceiveAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)buttomBtnClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    ManagReceiveAddressViewController *managReceiveAddressViewController = [[ManagReceiveAddressViewController alloc] init];
    [self.navigationController pushViewController:managReceiveAddressViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void) rightItemClick:(UIButton *) sender
{
//    [self showButtomView];
    
    
    AddReceiveAddressViewController *add = [[AddReceiveAddressViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}


//- (void) showButtomView
//{
//    rightItemBtnHasClick = NO;
//    
//    [self.buttomView setHidden:NO];
//    [self.tvBackView setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-64-49)];
//    [tv setFrame:CGRectMake(0, 0, self.tvBackView.frame.size.width, self.tvBackView.frame.size.height)];
//    
//
//}

//- (void) hideButtomView
//{
//    rightItemBtnHasClick = YES;
//    
//    [self.buttomView setHidden:YES];
//    [self.tvBackView setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-64)];
//    [tv setFrame:CGRectMake(0, 0, self.tvBackView.frame.size.width, self.tvBackView.frame.size.height)];
//    
//    [rightItemBtn setHidden:NO];
//    
//    for(UIButton *btn in cellBtnArray)
//    {
//        [btn setHidden:YES];
//    }
//}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self cancelRequest];
}
- (void) cancelRequest
{
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
}

- (void) loadRequest
{
#pragma mark - 收货地址
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getMemberAddressList",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@",token,[self getMemberId]];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLReceiveAddressTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getMemberAddressList.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if(tv)
    {
        self.tvBackView.frame = tv.frame;
    }

    
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
    [self loadRequest];
    
}

- (NSString *) getMemberId
{
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if(memberid.length == 0)
    {
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if (URLTag == URLReceiveAddressTag)
    {
        NSLog(@"%@",dicRespon);
        int result= [[dicRespon objectForKey:@"result"] intValue];
        NSString *msg = [dicRespon objectForKey:@"msg"];
        
        NSDictionary *receiveDic = nil;
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
            receiveDic = [[NSDictionary alloc] init];
            if([self.delegate respondsToSelector:@selector(receveAddress:)])
            {
                [self.delegate receveAddress:receiveDic];
            }
        }
        else if (result == 1)
        {
            addressListDataArray = [[NSMutableArray alloc] initWithArray:[B2CAddressData getListArray:[dicRespon objectForKey:@"items"]]];
            
            
            cellBtnArray = [[NSMutableArray alloc] init];
            
            if(!addressListDataArray || addressListDataArray.count == 0)
            {
                receiveDic = [[NSDictionary alloc] init];
                if([self.delegate respondsToSelector:@selector(receveAddress:)])
                {
                    [self.delegate receveAddress:receiveDic];
                }
            }
            
            for(int i=0;i<addressListDataArray.count;i++)
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
                [btn setSelected:NO];
                [btn setTag:i];
                [btn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cellBtnArray addObject:btn];
                
                B2CAddressData *data = (B2CAddressData *)[addressListDataArray objectAtIndex:i];
                if([[data isDefault] isEqualToString:@"1"])
                {
                    [btn setSelected:YES];
                    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"defaultReceiveAddress"])
                    {
                        
                    }
                    receiveDic = [NSDictionary dictionaryWithObjectsAndKeys:data.addressName,@"receiveaddress",data.city,@"receivecity",data.area,@"receivedistrict",data.province,@"receiveprovince",data.receiver,@"receiver",data.mobile,@"receiveTel",data.addressId,@"receiveAddressId", nil];
                    if([self.delegate respondsToSelector:@selector(receveAddress:)])
                    {
                        [self.delegate receveAddress:receiveDic];
                    }
                }
                else
                {
                    [btn setSelected:NO];
                }
            }
            
        }
        if(tv)
        {
            [tv reloadData];
        }
    }
}

- (void) doSomething:(NSNotification *) noti
{
    AddReceiveFinalViewController *notiAddReceiveFinalViewController = [[noti object] objectAtIndex:1];
    NSString *notiStr = [[noti object] objectAtIndex:0];
    
    if(!addressListDataArray || addressListDataArray.count == 0)
    {
        [notiAddReceiveFinalViewController validateAddress:0];
        return;
    }
    NSLog(@"%@",addressListDataArray);
    
    
    NSMutableArray *testArray = [[NSMutableArray alloc] init];
    for(int i=0;i<addressListDataArray.count;i++)
    {
        B2CAddressData *addressData = [addressListDataArray objectAtIndex:i];
        NSString *province = addressData.province;
        NSString *city = addressData.city;
        NSString *area = addressData.area;
        NSString *str = [NSString stringWithFormat:@"%@%@%@",province,city,area];
        
        NSString *address = addressData.addressName;
        
        NSString *myStr = [NSString stringWithFormat:@"%@%@",str,address];
        [testArray addObject:myStr];

    }
    
    if([testArray containsObject:notiStr] == YES)
    {
        [notiAddReceiveFinalViewController validateAddress:1];
    }
    else
    {
        [notiAddReceiveFinalViewController validateAddress:0];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSomething:) name:@"addressListDataArray" object:nil];
    
    /*丁瑞修改*/
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"选择收货地址"];
    self.navigationItem.titleView = top;
    
    /*陈晓修改*/
    
    _tvBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, MainScreenHeight-50-64)];
    [self.view addSubview:_tvBackView];
    
    _buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, _tvBackView.frame.origin.y+_tvBackView.frame.size.height, ScreenWidth, 50)];
    [self.view addSubview:_buttomView];
    
    _buttomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttomBtn setFrame:CGRectMake(10, 5, ScreenWidth-20, 40)];
    [_buttomBtn addTarget:self action:@selector(buttomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _buttomBtn.layer.cornerRadius = 5.0f;
    _buttomBtn.layer.borderWidth = 1.0f;
    _buttomBtn.layer.borderColor = [UIColor colorWithRed:228.0/255.0 green:121.0/255.0 blue:11.0/255.0 alpha:1.0].CGColor;
    [_buttomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttomBtn setTitle:@"管理收货地址" forState:UIControlStateNormal];
    [_buttomBtn setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:121.0/255.0 blue:11.0/255.0 alpha:1.0]];
    [_buttomView addSubview:_buttomBtn];

    
    [self pushAndPopStyle];
    

    
    moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
    [moreCell startAnimation];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.tvBackView.frame.size.width, self.tvBackView.frame.size.height) style:0];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setShowsVerticalScrollIndicator:NO];
    [self.tvBackView addSubview:tv];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(addressListDataArray.count == 0 || !addressListDataArray)
    {
        return 1;
    }
    return addressListDataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(addressListDataArray.count == 0)
    {
        return 44;
    }
    else
    {
        B2CAddressData *addressData = [addressListDataArray objectAtIndex:indexPath.row];
        NSString *address = addressData.addressName;
        CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:address WithSize:CGSizeMake(280, MAXFLOAT)];

        return size_3.height + 80;
        
    }
    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:0];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    
    if(indexPath.row == addressListDataArray.count)
    {
        [moreCell noDataAnimation];
        [moreCell.lblContent setText:@"暂无收货地址"];
        return moreCell;
    }
    else
    {
        B2CAddressData *addressData = [addressListDataArray objectAtIndex:indexPath.row];
        
        NSString *name = addressData.receiver;
//        CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:name WithSize:CGSizeMake(MAXFLOAT, 30)];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, ScreenWidth-60, 40)];
        [nameLabel setText:name];
        nameLabel.numberOfLines = 2;
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.contentView addSubview:nameLabel];
        
        NSString *tel = addressData.tel;
        CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:tel WithSize:CGSizeMake(MAXFLOAT, 30)];
        UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-size_2.width, 5, size_2.width, 30)];
        [telLabel setTextAlignment:NSTextAlignmentRight];
        [telLabel setText:tel];
        [telLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.contentView addSubview:telLabel];
        
        NSString *province = addressData.province;
        NSString *city = addressData.city;
        NSString *area = addressData.area;
        NSString *str = [NSString stringWithFormat:@"%@%@%@",province,city,area];
        UILabel *provinceLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height, 270, 30)];
        [provinceLabel setText:str];
        [provinceLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.contentView addSubview:provinceLabel];
        
        
        NSString *address = addressData.addressName;
        CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:address WithSize:CGSizeMake(280, MAXFLOAT)];
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, provinceLabel.frame.origin.y + provinceLabel.frame.size.height, 270, size_3.height)];
        [addressLabel setText:address];
        [addressLabel setFont:[UIFont systemFontOfSize:13]];
        [addressLabel setNumberOfLines:0];
        [cell.contentView addSubview:addressLabel];
        
//        if(rightItemBtnHasClick == NO)
//        {
            UIButton *btn = [cellBtnArray objectAtIndex:indexPath.row];
            [btn setFrame:CGRectMake(10, (size_3.height + 70 - 30)/2, 30, 30)];
            [cell.contentView addSubview:btn];
//        }
//        else
//        {
//            
//        }
        
        
        return cell;
        
    }
    return nil;
}

- (void) cellBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    int tag = btn.tag;
    
    
    for(UIButton *btn in cellBtnArray)
    {
        if(btn.tag == tag)
        {
            
        }
        else
        {
            [btn setSelected:NO];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    B2CAddressData *data = (B2CAddressData *)[addressListDataArray objectAtIndex:tag];
    NSDictionary *receiveDic = [NSDictionary dictionaryWithObjectsAndKeys:data.addressName,@"receiveaddress",data.city,@"receivecity",data.area,@"receivedistrict",data.province,@"receiveprovince",data.receiver,@"receiver",data.mobile,@"receiveTel",data.addressId,@"receiveAddressId", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"B2CReceiveAddressHasChange" object:receiveDic userInfo:nil];
//    [[NSUserDefaults standardUserDefaults] setObject:receiveDic forKey:@"defaultReceiveAddress"];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIButton *btn = [cellBtnArray objectAtIndex:indexPath.row];
    [self cellBtnClick:btn];
  
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

@end
