//
//  LookForCustomViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-14.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "LookForCustomViewController.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFCustomExtra.h"
#import "LoginNaviViewController.h"
#import "MCDefine.h"
#import "DCFStringUtil.h"
#import "B2CAfterSaleData.h"
#import "DCFChenMoreCell.h"

@interface LookForCustomViewController ()
{
    NSMutableArray *labelArray;    //前面的label
    
    NSMutableArray *anotherLabelArray; //后面的label
    
    NSMutableArray *dataArray;
    
    NSDictionary *dataDic;
    
    DCFChenMoreCell *moreCell;
}
@end

@implementation LookForCustomViewController

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
    [super viewWillDisappear:YES];
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

- (void) hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"查看售后"];
    self.navigationItem.titleView = top;
    
    labelArray = [[NSMutableArray alloc] init];
    
    for(int i=0;i<8;i++)
    {
        NSString *str = nil;
        switch (i) {
            case 0:
                str = @"售后单号:";
                break;
            case 1:
                str = @"申请时间:";
                break;
            case 2:
                str = @"售后方式:";
                break;
            case 3:
                str = @"售后状态:";
                break;
            case 4:
                str = @"售后商品:";
                break;
            case 5:
                str = @"退款金额:";
                break;
            case 6:
                str = @"售后原因:";
                break;
            case 7:
                str = @"售后留言:";
                break;
                
            default:
                break;
        }
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(MAXFLOAT, 20)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10+25*i, size.width, 20)];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setText:str];
        [self.view addSubview:label];
        
        [labelArray addObject:label];
    }
    
    
    //    NSString *memberid = [self getMemberId];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getAfterSaleInfo",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&ordernum=%@",token,self.orderNum];
    
    //    NSString *pushString = [NSString stringWithFormat:@"token=%@&ordernum=%@",@"bc2e98e1423b9fbac5119fa438812cb3",@"201404258079343759"];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetAfterSaleInfoTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getAfterSaleInfo.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    if(!HUD)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setLabelText:@"正在请求数据"];
        [HUD setDelegate:self];
    }
    
    [moreCell startAnimation];
}

- (void) refreshView
{
    if(labelArray)
    {
        anotherLabelArray = [[NSMutableArray alloc] init];
        
        for(int i=0;i<labelArray.count;i++)
        {
            UILabel *label = (UILabel *)[labelArray objectAtIndex:i];
            
            UILabel *anotherLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 5, label.frame.origin.y, ScreenWidth-20-label.frame.size.width-10,20)];
            [anotherLabel setFont:[UIFont systemFontOfSize:12]];
            [anotherLabel setNumberOfLines:0];
            
            if(i == 0)
            {
                NSString *s1 = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"aftersalenum"]];
                [anotherLabel setText:s1];
            }
            if(i == 1)
            {
                if([[dataDic objectForKey:@"createdate"] isKindOfClass:[NSNull class]])
                {
                }
                else
                {
                    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[[dataDic objectForKey:@"createdate"] objectForKey:@"time"] doubleValue]/1000];
                    NSString *time = [DCFCustomExtra nsdateToString:confromTimesp];
                    [anotherLabel setText:time];
                }
                
            }
            if(i == 2)
            {
                NSString *aftersalemode = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"aftersalemode"]];
                NSString *s2 = nil;
                if([aftersalemode intValue] == 0)
                {
                    s2 = @"退货";
                }
                if([aftersalemode intValue] == 1)
                {
                    s2 = @"换货";
                }
                if([aftersalemode intValue] == 2)
                {
                    s2 = @"申请退款";
                }
                [anotherLabel setText:s2];
            }
            if(i == 3)
            {
                NSString *status = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"status"]];
                int statusInt = [status intValue];
                switch (statusInt) {
                    case 0:
                        status = @"买家提交售后申请";
                        break;
                    case 1:
                        status = @"卖家不同意";
                        break;
                    case 2:
                        status = @"卖家同意";
                        break;
                    case 4:
                        status = @"买家已发货";
                        break;
                    case 5:
                        status = @"卖家确认收货";
                        break;
                    case 6:
                        status = @"卖家未收到货";
                        break;
                    case 7:
                        status = @"卖家已发货";
                        break;
                    case 8:
                        status = @"买家确认收货";
                        break;
                    case 9:
                        status = @"买家未收到货";
                        break;
                    case 10:
                        status = @"赔付中";
                        break;
                    default:
                        break;
                }
                [anotherLabel setText:status];
                [anotherLabel setTextColor:[UIColor redColor]];
            }
            if(i == 4)
            {
                NSString *productItmeTitle = [[[dataDic objectForKey:@"productlist"] lastObject] objectForKey:@"productItmeTitle"];
                if(productItmeTitle.length == 0)
                {
                    
                }
                else
                {
                    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:productItmeTitle WithSize:CGSizeMake(ScreenWidth-20-label.frame.size.width-10, MAXFLOAT)];
                    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 5, label.frame.origin.y, ScreenWidth-20-label.frame.size.width-10,size.height)];
                    [testLabel setNumberOfLines:0];
                    [testLabel setFont:[UIFont systemFontOfSize:12]];
                    
                    [anotherLabel setFrame:testLabel.frame];
                    [anotherLabel setText:productItmeTitle];
                }
                
            }
            if(i == 5)
            {
                NSString *money = [NSString stringWithFormat:@"%@元",[dataDic objectForKey:@"total"]];
                [anotherLabel setText:money];
                [anotherLabel setTextColor:[UIColor redColor]];
            }
            if(i == 6)
            {
                NSString *reanson = [dataDic objectForKey:@"reanson"];
                [anotherLabel setText:reanson];
            }
            if(i == 7)
            {
                NSString *afterwords = [dataDic objectForKey:@"afterwords"];
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:afterwords WithSize:CGSizeMake(ScreenWidth-20-label.frame.size.width-10, MAXFLOAT)];
                UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 5, label.frame.origin.y, ScreenWidth-20-label.frame.size.width-10,size.height)];
                [testLabel setNumberOfLines:0];
                [testLabel setFont:[UIFont systemFontOfSize:12]];
                
                [anotherLabel setFrame:CGRectMake(testLabel.frame.origin.x, testLabel.frame.origin.y+3, testLabel.frame.size.width, testLabel.frame.size.height)];
                [anotherLabel setText:afterwords];
            }
            [anotherLabelArray addObject:anotherLabel];
            [self.view addSubview:anotherLabel];
        }
    }
    
    if(!_tv)
    {
        CGFloat height_1 = [(UILabel *)[labelArray lastObject] frame].size.height;
        CGFloat height_2 = [(UILabel *)[anotherLabelArray lastObject] frame].size.height;
        
        UILabel *label_1 = [labelArray lastObject];
        UILabel *label_2 = [anotherLabelArray lastObject];
        
        _tv = [[UITableView alloc] initWithFrame:CGRectZero];
        if(height_1 <= height_2)
        {
            [_tv setFrame:CGRectMake(10, label_2.frame.origin.y+label_2.frame.size.height+5, ScreenWidth-20, 100)];
        }
        else
        {
            [_tv setFrame:CGRectMake(10, label_1.frame.origin.y+label_1.frame.size.height+5, ScreenWidth-20, 100)];
        }
        _tv.delegate = self;
        _tv.dataSource = self;
        [_tv setShowsHorizontalScrollIndicator:NO];
        [_tv setShowsVerticalScrollIndicator:NO];
         _tv.layer.cornerRadius = 5;
        _tv.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
        _tv.layer.borderWidth = 1.0f;
        [self.view addSubview:_tv];
    }
    [_tv reloadData];
    
    UILabel *buttomLabel = [[UILabel alloc] initWithFrame:CGRectMake(_tv.frame.origin.x, _tv.frame.size.height+_tv.frame.origin.y + 5,_tv.frame.size.width, 30)];
    [buttomLabel setText:@"详细操作以及凭证请登录电脑后查看"];
    [buttomLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:buttomLabel];
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
    return dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        return 44;
    }
    else
    {
        B2CAfterSaleData *data = [dataArray objectAtIndex:indexPath.row];
        NSString *remark = [data remark];
        if(remark.length == 0)
        {
            return 35;
        }
        else
        {
            CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:remark WithSize:CGSizeMake(ScreenWidth-40, MAXFLOAT)];
            return size.height+35;
        }
        
    }
    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        static NSString *moreCellId = @"moreCell";
        moreCell = (DCFChenMoreCell *)[tableView dequeueReusableCellWithIdentifier:moreCellId];
        if(moreCell == nil)
        {
            moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
            [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        }
        if(!dataArray || dataArray.count == 0)
        {
            [moreCell noDataAnimation];
        }
        return moreCell;
    }
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        [cell setSelectionStyle:0];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
        [(UIView *) CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    
    B2CAfterSaleData *data = [dataArray objectAtIndex:indexPath.row];
    
    NSString *name = [data operateUsername];
    if(name.length == 0)
    {
        
    }
    else
    {
        CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:name WithSize:CGSizeMake(MAXFLOAT, 20)];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, size_1.width, 20)];
        [nameLabel setText:name];
        [nameLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:nameLabel];
    }
    
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[[data operateDate] objectForKey:@"time"] doubleValue]/1000];
    NSString *time = [DCFCustomExtra nsdateToString:confromTimesp];
    CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:time WithSize:CGSizeMake(MAXFLOAT, 20)];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-size_2.width-5, 5, size_2.width, 20)];
    [timeLabel setText:time];
    [timeLabel setFont:[UIFont systemFontOfSize:12]];
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    [cell.contentView addSubview:timeLabel];
    
    NSString *remark = [data remark];
    if(remark.length == 0)
    {
        
    }
    else
    {
        CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:remark WithSize:CGSizeMake(cell.contentView.frame.size.width-10, MAXFLOAT)];
        UILabel *remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, timeLabel.frame.origin.y+timeLabel.frame.size.height+5, size_3.width, size_3.height)];
        [remarkLabel setText:remark];
        [remarkLabel setFont:[UIFont systemFontOfSize:12]];
        [remarkLabel setNumberOfLines:0];
        [cell.contentView addSubview:remarkLabel];
    }
    
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(HUD)
    {
        [HUD hide:YES];
    }
    
    dataDic = [[NSDictionary alloc] initWithDictionary:dicRespon];
    
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLGetAfterSaleInfoTag)
    {
        [moreCell stopAnimation];
        
        if(result == 1)
        {
            dataArray = [[NSMutableArray alloc] initWithArray:[B2CAfterSaleData getListArray:[dicRespon objectForKey:@"loglist"]]];
            if(!dataArray || dataArray.count == 0)
            {
                [moreCell noDataAnimation];
            }
            [self refreshView];
        }
        else
        {
            [moreCell stopAnimation];
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"查看售后信息失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
        [self.tv reloadData];
    }
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
