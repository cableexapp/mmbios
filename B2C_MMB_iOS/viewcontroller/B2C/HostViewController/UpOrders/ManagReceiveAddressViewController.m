//
//  ManagReceiveAddressViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-12-11.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "ManagReceiveAddressViewController.h"
#import "DCFCustomExtra.h"
#import "AddReceiveAddressViewController.h"
#import "AddReceiveFinalViewController.h"
#import "DCFChenMoreCell.h"
#import "B2CAddressData.h"
#import "LoginNaviViewController.h"
#import "DCFStringUtil.h"

@interface ManagReceiveAddressViewController ()
{
    UIStoryboard *sb;
    
    NSMutableArray *addressListDataArray;
    
    DCFChenMoreCell *moreCell;
}
@end

@implementation ManagReceiveAddressViewController

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
    AddReceiveAddressViewController *add = [[AddReceiveAddressViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
    //    [self hideButtomView];
    
}

- (void) rightItemClick:(UIButton *) sender
{
    //    [self showButtomView];
}



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
    int result= [[dicRespon objectForKey:@"result"] intValue];
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
            addressListDataArray = [[NSMutableArray alloc] initWithArray:[B2CAddressData getListArray:[dicRespon objectForKey:@"items"]]];
            
        }

    }
    if(URLTag == URLDeleteMemberAddressTag)
    {
        NSLog(@"%@",dicRespon);
        if(result == 1)
        {
            [self loadRequest];
        }
        else
        {
            if([DCFCustomExtra validateString:msg] == NO)
            {
                [DCFStringUtil showNotice:@"删除地址失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
    if(tv)
    {
        [tv reloadData];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*丁瑞修改*/
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"管理收货地址"];
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
    [_buttomBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
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
        if([DCFCustomExtra validateString:address]  == NO)
        {
            return 70;
        }
        CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:address WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
        //    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 270, size_3.height)];
        //    [addressLabel setText:address];
        //    [addressLabel setFont:[UIFont systemFontOfSize:13]];
        //    [addressLabel setNumberOfLines:0];
        return size_3.height + 70;
        
    }
    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setSeparatorStyle:0];
    
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
        return moreCell;
    }
    else
    {
        B2CAddressData *addressData = [addressListDataArray objectAtIndex:indexPath.row];
        
        NSString *name = addressData.receiver;
//        CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:name WithSize:CGSizeMake(MAXFLOAT, 30)];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5,ScreenWidth-25, 30)];
        [nameLabel setText:name];
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
        UILabel *provinceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLabel.frame.origin.y + nameLabel.frame.size.height, 295, 30)];
        [provinceLabel setText:str];
        [provinceLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.contentView addSubview:provinceLabel];
        
        
        NSString *address = addressData.addressName;
        CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:address WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, provinceLabel.frame.origin.y + provinceLabel.frame.size.height, ScreenWidth-20, size_3.height)];
        [addressLabel setText:address];
        [addressLabel setFont:[UIFont systemFontOfSize:13]];
        [addressLabel setNumberOfLines:0];
        [cell.contentView addSubview:addressLabel];
        

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, addressLabel.frame.origin.y+addressLabel.frame.size.height+4, ScreenWidth, 0.3)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:lineView];
        
        return cell;
        
    }
    return nil;
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    B2CAddressData *data = (B2CAddressData *)[addressListDataArray objectAtIndex:indexPath.row];
    
//    NSDictionary *receiveDic = [NSDictionary dictionaryWithObjectsAndKeys:data.addressName,@"receiveaddress",data.city,@"receivecity",data.area,@"receivedistrict",data.province,@"receiveprovince",data.receiver,@"receiver",data.mobile,@"receiveTel",data.addressId,@"receiveAddressId", nil];

    AddReceiveFinalViewController *final = [[AddReceiveFinalViewController alloc] initWithAddressData:data];
    [self.navigationController pushViewController:final animated:YES];
    
}


#pragma mark - 陈晓新增tableview删除功能
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
- (NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        B2CAddressData *data = (B2CAddressData *)[addressListDataArray objectAtIndex:indexPath.row];
        NSString *addressId = [NSString stringWithFormat:@"%@",data.addressId];
        [self deleteRow:addressId];
        //        [addressListDataArray removeObjectAtIndex:indexPath.row];
        //        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
    }
}

- (void) deleteRow:(NSString *) sender
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"deleteMemberAddress",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&addressid=%@",token,[self getMemberId],sender];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLDeleteMemberAddressTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/deleteMemberAddress.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
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
