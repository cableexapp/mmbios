//
//  MyCableHostSubTableViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-12.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyCableHostSubTableViewController.h"
#import "MCDefine.h"
#import "DCFStringUtil.h"
#import "DCFChenMoreCell.h"
#import "DCFCustomExtra.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "LoginNaviViewController.h"

@interface MyCableHostSubTableViewController ()
{
    DCFChenMoreCell *moreCell;
    
    //    int intPage; //页数
    int intTotal; //总数
    int pageSize; //每页条数
    BOOL _reloading;
    BOOL flag;
    
    NSMutableArray *dataArray;
    NSMutableArray *lookBtnArray;  //查看按钮数组
    NSMutableArray *upTimeLabelArray;  //提交时间数组
    
    UIStoryboard *sb;
    
    
    int index;  //确认收货时用到
}
@end

@implementation MyCableHostSubTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    lookBtnArray = [[NSMutableArray alloc] init];
    
    dataArray = [[NSMutableArray alloc] init];
    
    upTimeLabelArray = [[NSMutableArray alloc] init];
    
    _intPage = 1;
    
    
    //ADD REFRESH VIEW
    _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -300, 320, 300)];
    [self.refreshView setDelegate:self];
    [self.tableView addSubview:self.refreshView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.refreshView refreshLastUpdatedDate];
    
    //    [self loadRequestWithStatus:_tag];
}

- (void) loadRequestWithStatus:(NSString *) sender
{
    pageSize = 10;
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"OrderList",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *status = [NSString stringWithFormat:@"%@",sender];
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&pagesize=%d&pageindex=%d&status=%@",token,[self getMemberId],pageSize,_intPage,status];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLOrderListTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/OrderList.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
    
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLOrderListTag)
    {
        if(_reloading == YES)
        {
            [self doneLoadingViewData];
        }
        else if(_reloading == NO)
        {
            
        }
        if([[dicRespon allKeys] count] == 0)
        {
//            [moreCell noDataAnimation];
            moreCell.lblContent.text = @"您的电缆订单暂无数据哦~";
            [moreCell.avState stopAnimating];
            moreCell.avState.hidden = YES;
        }
        else
        {
            if(result == 1)
            {
                if(_intPage == 1)
                {
                    [dataArray removeAllObjects];
                }
                [dataArray addObjectsFromArray:[B2BMyCableOrderListData getListArray:[dicRespon objectForKey:@"items"]]];
                intTotal = [[dicRespon objectForKey:@"total"] intValue];
                
                if(intTotal == 0)
                {
//                    [moreCell noDataAnimation];
                    moreCell.lblContent.text = @"您的电缆订单暂无数据哦~";
                    [moreCell.avState stopAnimating];
                    moreCell.avState.hidden = YES;
                }
                else
                {
                    [moreCell stopAnimation];
                }
                _intPage++;
            }
            else
            {
                if([[dicRespon objectForKey:@"items"] count] == 0 || [[dicRespon objectForKey:@"items"] isKindOfClass:[NSNull class]])
                {
                    if(dataArray)
                    {
                        [dataArray removeAllObjects];
                    }
                }
                moreCell.lblContent.text = @"您的电缆订单暂无数据哦~";
                [moreCell.avState stopAnimating];
                moreCell.avState.hidden = YES;
            }
        }
        
        [self.tableView reloadData];
    }
    if(URLTag == URLConfirmReceiveTag)
    {
        
        
        
        if(result == 1)
        {
            //            [self.tableView scrollsToTop] = YES;
            //            [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            _intPage = 1;
            [self loadRequestWithStatus:_statusIndex];
        }
        else
        {
            [DCFStringUtil showNotice:msg];
        }
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!dataArray || dataArray.count == 0)
    {
        return 1;
    }
    return dataArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 1;
    }
    if(section == dataArray.count)
    {
        if ((_intPage-1)*pageSize < intTotal )
        {
            return 1;
        }
        return 0;
    }
    
    return  [[[dataArray objectAtIndex:section] myItems] count] + 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 0;
    }
    if(section == dataArray.count)
    {
        return 0;
    }
    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        return 44;
    }
    if(indexPath.section == dataArray.count)
    {
        return 44;
    }
    
    if(indexPath.row >= [[[dataArray objectAtIndex:indexPath.section] myItems] count])
    {
        return 44;
    }
    
    NSArray *itemArray = [[dataArray objectAtIndex:indexPath.section] myItems];
    
    if(itemArray.count == 0 || [itemArray isKindOfClass:[NSNull class]])
    {
        return 0;
    }
    else
    {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[itemArray objectAtIndex:indexPath.row]];
        if([[dic allKeys] count] == 0 || [dic isKindOfClass:[NSNull class]])
        {
            return 0;
        }
        else
        {
            float height = 0.0f;
            
            NSString *theModel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"model"]];
            NSString *theUnit = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unit"]];
            
            NSString *NumBer = [NSString stringWithFormat:@"%@",[dic objectForKey:@"num"]];
            NSString *testNum = [DCFCustomExtra notRounding:NumBer];
            //            NSString *testNum = nil;
            //            for(int i=0;i<NumBer.length;i++)
            //            {
            //                char c = [NumBer characterAtIndex:i];
            //                if(c == '.')
            //                {
            //                    testNum = [DCFCustomExtra notRounding:[NumBer doubleValue]];
            //                    break;
            //                }
            //                else if(i == NumBer.length-1)
            //                {
            //                    testNum = NumBer;
            //                }
            //            }
            NSString *theNumber = [NSString stringWithFormat:@"%@%@",testNum,theUnit];
            
            NSString *theTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deliver"]];
            
            NSString *thePrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"buyerPrice"]];
            
            NSString *theSpec = [NSString stringWithFormat:@"%@",[dic objectForKey:@"spec"]];
            
            NSString *theVol = [NSString stringWithFormat:@"%@",[dic objectForKey:@"voltage"]];
            
            NSString *theFeature = [NSString stringWithFormat:@"%@",[dic objectForKey:@"feature"]];
            
            NSString *request = [NSString stringWithFormat:@"%@",[dic objectForKey:@"require"]];
            
            if(theModel.length == 0 || [theModel isKindOfClass:[NSNull class]])
            {
                height = 0;
            }
            else
            {
                height = 25;
            }
            
            if(theNumber.length == 0 && theTime.length == 0 && thePrice.length == 0)
            {
                height = height;
            }
            else
            {
                height = height +25;
            }
            
            if(theSpec.length == 0 && theVol.length == 0)
            {
                height = height;
            }
            else
            {
                height = height +25;
            }
            
            if(theFeature.length == 0)
            {
                height = height;
            }
            else
            {
                height = height +25;
            }
            
            if(request.length == 0)
            {
                height = height;
            }
            else
            {
                NSString *s = @"特殊需求: ";
                request = [s stringByAppendingString:request];
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:request WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
                height = height + size.height;
            }
            
            return height + 10;
        }
        
    }
    
    
    return 44;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return nil;
    }
    if(section == dataArray.count)
    {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    [view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    
    CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"询价单号" WithSize:CGSizeMake(MAXFLOAT, 30)];
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size_1.width, 30)];
    [firstLabel setText:@"询价单号"];
    [firstLabel setFont:[UIFont systemFontOfSize:12]];
    [firstLabel setTextAlignment:NSTextAlignmentRight];
    [view addSubview:firstLabel];
    
    NSString *orderNum = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:section] orderserial]];
    UILabel *orderNumLabel = [[UILabel alloc] init];
    if(orderNum.length == 0 || [orderNum isKindOfClass:[NSNull class]])
    {
        [orderNumLabel setFrame:CGRectMake(firstLabel.frame.origin.x + firstLabel.frame.size.width + 5, 5, 30, 30)];
    }
    else
    {
        CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:orderNum WithSize:CGSizeMake(MAXFLOAT, 30)];
        [orderNumLabel setFrame:CGRectMake(firstLabel.frame.origin.x + firstLabel.frame.size.width + 5, 5, size_2.width, 30)];
    }
    [orderNumLabel setFont:[UIFont systemFontOfSize:12]];
    [orderNumLabel setTextAlignment:NSTextAlignmentLeft];
    [orderNumLabel setText:orderNum];
    [view addSubview:orderNumLabel];
    
    NSString *totalPrice = [NSString stringWithFormat:@"¥ %@",[[dataArray objectAtIndex:section] ordertotal]];
    UILabel *totalPriceLabel = [[UILabel alloc] init];
    if(totalPrice.length == 0 || [totalPrice isKindOfClass:[NSNull class]])
    {
        [totalPriceLabel setFrame:CGRectMake(ScreenWidth-40, 5, 30, 30)];
    }
    else
    {
        CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:totalPrice WithSize:CGSizeMake(MAXFLOAT, 30)];
        [totalPriceLabel setFrame:CGRectMake(ScreenWidth-10-size_3.width, 5, size_3.width, 30)];
    }
    [totalPriceLabel setFont:[UIFont systemFontOfSize:12]];
    [totalPriceLabel setTextAlignment:NSTextAlignmentRight];
    [totalPriceLabel setText:totalPrice];
    [totalPriceLabel setTextColor:[UIColor redColor]];
    [view addSubview:totalPriceLabel];
    
    
    CGSize size_4 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"订单总额:" WithSize:CGSizeMake(MAXFLOAT, 30)];
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-totalPriceLabel.frame.size.width-5-size_4.width, 5, size_4.width, 30)];
    [secondLabel setFont:[UIFont systemFontOfSize:12]];
    [secondLabel setText:@"订单总额:"];
    [view addSubview:secondLabel];
    
    return view;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == dataArray.count)
    {
        static NSString *moreCellId = @"moreCell";
        moreCell = (DCFChenMoreCell *)[tableView dequeueReusableCellWithIdentifier:moreCellId];
        
        if(moreCell == nil)
        {
            moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
            [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        }
        return moreCell;
    }
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:0];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
        [cell addSubview:lineView];
        if (indexPath.row == 0)
        {
            //        lineView.frame = CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1);
        }
        else if (indexPath.row == 1)
        {
            lineView.frame = CGRectMake(0, 0, cell.frame.size.width, 0.5);
        }
        else  if (indexPath.row >= 2)
        {
            lineView.frame = CGRectMake(0, 0, cell.frame.size.width, 0.5);
        }
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    {
        [(UIView *) CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    CGFloat cellWidth = cell.contentView.frame.size.width;
    if(indexPath.row < [[[dataArray objectAtIndex:indexPath.section] myItems] count])
    {
        NSArray *itemArray = [[dataArray objectAtIndex:indexPath.section] myItems];
        
        UILabel *orderNumLabel = [[UILabel alloc] init];
        [orderNumLabel setFont:[UIFont systemFontOfSize:12]];
        
        UILabel *numLabel = [[UILabel alloc] init];
        [numLabel setFont:[UIFont systemFontOfSize:12]];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [timeLabel setFont:[UIFont systemFontOfSize:12]];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        [priceLabel setTextAlignment:NSTextAlignmentRight];
        [priceLabel setFont:[UIFont systemFontOfSize:12]];
        
        UILabel *specLabel = [[UILabel alloc] init];
        [specLabel setFont:[UIFont systemFontOfSize:12]];
        
        UILabel *volLabel = [[UILabel alloc] init];
        [volLabel setFont:[UIFont systemFontOfSize:12]];
        
        UILabel *feathLabel = [[UILabel alloc] init];
        [feathLabel setFont:[UIFont systemFontOfSize:12]];
        
        UILabel *requestLabel = [[UILabel alloc] init];
        [requestLabel setFont:[UIFont systemFontOfSize:12]];
        [requestLabel setNumberOfLines:0];
        
        if(itemArray.count == 0 || [itemArray isKindOfClass:[NSNull class]])
        {
            [orderNumLabel setFrame:CGRectMake(10, 5, cellWidth-20, 0)];
            
            [numLabel setFrame:CGRectMake(10, orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height, (cellWidth-20)/3, 0)];
            
            [timeLabel setFrame:CGRectMake(numLabel.frame.origin.x + numLabel.frame.size.width, orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height, (cellWidth-20)/3, 0)];
            
            [priceLabel setFrame:CGRectMake(cellWidth-10-cellWidth/3,  orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height,  (cellWidth-20)/3, 0)];
            
            [specLabel setFrame:CGRectMake(10, numLabel.frame.origin.y + numLabel.frame.size.height, (cellWidth-20)/2, 0)];
            
            [volLabel setFrame:CGRectMake(specLabel.frame.origin.x + specLabel.frame.size.width, timeLabel.frame.origin.y + timeLabel.frame.size.height, (cellWidth-20)/2, 0)];
            
            [feathLabel setFrame:CGRectMake(10, specLabel.frame.origin.y + specLabel.frame.size.height, (cellWidth-20)/2, 0)];
            
            [requestLabel setFrame:CGRectMake(10, feathLabel.frame.origin.y + feathLabel.frame.size.height, cellWidth-20, 0)];
        }
        else
        {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[itemArray objectAtIndex:indexPath.row]];
            if([[dic allKeys] count] == 0 || [dic isKindOfClass:[NSNull class]])
            {
                [orderNumLabel setFrame:CGRectMake(10, 5, cellWidth-20, 0)];
                
                [numLabel setFrame:CGRectMake(10, orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height, (cellWidth-20)/3, 0)];
                
                [timeLabel setFrame:CGRectMake(numLabel.frame.origin.x + numLabel.frame.size.width, orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height, (cellWidth-20)/3, 0)];
                
                [priceLabel setFrame:CGRectMake(cellWidth-10-cellWidth/3,  orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height,  (cellWidth-20)/3, 0)];
                
                [specLabel setFrame:CGRectMake(10, numLabel.frame.origin.y + numLabel.frame.size.height, (cellWidth-20)/2, 0)];
                
                [volLabel setFrame:CGRectMake(specLabel.frame.origin.x + specLabel.frame.size.width, timeLabel.frame.origin.y + timeLabel.frame.size.height, (cellWidth-20)/2, 0)];
                
                [feathLabel setFrame:CGRectMake(10, specLabel.frame.origin.y + specLabel.frame.size.height, (cellWidth-20)/2, 0)];
                
                [requestLabel setFrame:CGRectMake(10, feathLabel.frame.origin.y + feathLabel.frame.size.height, cellWidth-20, 0)];
            }
            else
            {
                NSString *theModel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"model"]];
                NSString *theUnit = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unit"]];
                
                NSString *NumBer = [NSString stringWithFormat:@"%@",[dic objectForKey:@"num"]];
                NSString *testNum = [DCFCustomExtra notRounding:NumBer];
                //                    NSString *testNum = nil;
                //                    for(int i=0;i<NumBer.length;i++)
                //                    {
                //                        char c = [NumBer characterAtIndex:i];
                //                        if(c == '.')
                //                        {
                //                            testNum = [DCFCustomExtra notRounding:[NumBer doubleValue]];
                //                            break;
                //                        }
                //                        else if(i == NumBer.length-1)
                //                        {
                //                            testNum = NumBer;
                //                        }
                //                    }
                NSString *theNumber = [NSString stringWithFormat:@"%@%@",testNum,theUnit];
                
                NSString *theTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deliver"]];
                
                NSString *thePrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"buyerPrice"]];
                
                NSString *theSpec = [NSString stringWithFormat:@"%@",[dic objectForKey:@"spec"]];
                
                NSString *theVol = [NSString stringWithFormat:@"%@",[dic objectForKey:@"voltage"]];
                
                NSString *theFeature = [NSString stringWithFormat:@"%@",[dic objectForKey:@"feature"]];
                
                NSString *request = [NSString stringWithFormat:@"%@",[dic objectForKey:@"require"]];
                //#pragma mark - color字段没有
                //                    NSString *theColor = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                
                if(theModel.length == 0 || [theModel isKindOfClass:[NSNull class]])
                {
                    [orderNumLabel setFrame:CGRectMake(10, 0, cellWidth-20, 0)];
                }
                else
                {
                    [orderNumLabel setFrame:CGRectMake(10, 0, cellWidth-20, 20)];
                    [orderNumLabel setText:[NSString stringWithFormat:@"型号: %@",theModel]];
                }
                
                CGSize priceSize;
                if(thePrice.length == 0 || [thePrice isKindOfClass:[NSNull class]])
                {
                    [priceLabel setFrame:CGRectMake(10,  orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height,  cellWidth-20, 0)];
                }
                else
                {
                    NSString *s = [NSString stringWithFormat:@"价格: %@元/%@",thePrice,theUnit];
                    priceSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s WithSize:CGSizeMake(MAXFLOAT, 20)];
                    [priceLabel setFrame:CGRectMake(10,   orderNumLabel.frame.origin.y + orderNumLabel.frame.size.height,  priceSize.width, 20)];
                    [priceLabel setText:s];
                    //                        priceLabel.backgroundColor = [UIColor redColor];
                }
                
                if(theNumber.length == 0 || [theNumber isKindOfClass:[NSNull class]])
                {
                    [numLabel setFrame:CGRectMake(10, priceLabel.frame.origin.y + priceLabel.frame.size.height, cellWidth-20, 0)];
                    
                }
                else
                {
                    NSString *s = [NSString stringWithFormat:@"数量: %@",theNumber];
                    CGSize numSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s WithSize:CGSizeMake(MAXFLOAT, 20)];
                    [numLabel setFrame:CGRectMake(10, priceLabel.frame.origin.y + priceLabel.frame.size.height,numSize.width, 20)];
                    [numLabel setText:[NSString stringWithFormat:@"%@",s]];
                    //                        numLabel.backgroundColor = [UIColor yellowColor];
                    
                }
                
                
                
                
                if(theTime.length == 0 || [theTime isKindOfClass:[NSNull class]])
                {
                    [timeLabel setFrame:CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.size.width, priceLabel.frame.origin.y + priceLabel.frame.size.height, (cellWidth-20)/3, 0)];
                }
                else
                {
                    NSString *s = [NSString stringWithFormat:@"交货期: %@天",theTime];
                    CGSize timeSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s WithSize:CGSizeMake(MAXFLOAT, 20)];
                    [timeLabel setFrame:CGRectMake(cellWidth-priceSize.width-timeSize.width, priceLabel.frame.origin.y + priceLabel.frame.size.height, timeSize.width, 20)];
                    //                        timeLabel.backgroundColor = [UIColor blueColor];
                    [timeLabel setText:s];
                    
                }
                
                if(theSpec.length == 0 || [theSpec isKindOfClass:[NSNull class]])
                {
                    [specLabel setFrame:CGRectMake(10, numLabel.frame.origin.y + numLabel.frame.size.height, (cellWidth-20)/2, 0)];
                }
                else
                {
                    [specLabel setFrame:CGRectMake(10, numLabel.frame.origin.y + numLabel.frame.size.height, (cellWidth-20)/2, 20)];
                    [specLabel setText:[NSString stringWithFormat:@"规格: %@平方",theSpec]];
                }
                
                if(theVol.length == 0 || [theVol isKindOfClass:[NSNull class]])
                {
                    [volLabel setFrame:CGRectMake(timeLabel.frame.origin.x, timeLabel.frame.origin.y + timeLabel.frame.size.height, (cellWidth-20)/2, 0)];
                }
                else
                {
                    [volLabel setFrame:CGRectMake(timeLabel.frame.origin.x, timeLabel.frame.origin.y + timeLabel.frame.size.height, (cellWidth-20)/2, 20)];
                    [volLabel setText:[NSString stringWithFormat:@"电压: %@",theVol]];
                }
                
                if(theFeature.length == 0 || [theFeature isKindOfClass:[NSNull class]])
                {
                    [feathLabel setFrame:CGRectMake(10, specLabel.frame.origin.y + specLabel.frame.size.height, (cellWidth-20)/2, 0)];
                }
                else
                {
                    [feathLabel setFrame:CGRectMake(10, specLabel.frame.origin.y + specLabel.frame.size.height, (cellWidth-20)/2, 20)];
                    [feathLabel setText:[NSString stringWithFormat:@"阻燃耐火: %@",theFeature]];
                }
                
                if(request.length == 0 || [request isKindOfClass:[NSNull class]])
                {
                    [requestLabel setFrame:CGRectMake(10, feathLabel.frame.origin.y + feathLabel.frame.size.height, cellWidth-20, 0)];
                }
                else
                {
                    NSString *s = @"特殊需求: ";
                    request = [s stringByAppendingString:request];
                    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:request WithSize:CGSizeMake(cellWidth-20, MAXFLOAT)];
                    
                    [requestLabel setFrame:CGRectMake(10, feathLabel.frame.origin.y + feathLabel.frame.size.height, cellWidth-20, size.height)];
                    [requestLabel setText:request];
                }
                
            }
        }
        [cell.contentView addSubview:orderNumLabel];
        [cell.contentView addSubview:numLabel];
        [cell.contentView addSubview:timeLabel];
        [cell.contentView addSubview:priceLabel];
        [cell.contentView addSubview:specLabel];
        [cell.contentView addSubview:volLabel];
        [cell.contentView addSubview:feathLabel];
        [cell.contentView addSubview:requestLabel];
    }
    if(indexPath.row == [[[dataArray objectAtIndex:indexPath.section] myItems] count])
    {
        NSString *time = [NSString stringWithFormat:@"提交时间: %@",[[dataArray objectAtIndex:indexPath.section] cableOrderTime]];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, cellWidth-20, 20)];
        [timeLabel setText:time];
        [timeLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:timeLabel];
    }
    if (indexPath.row == [[[dataArray objectAtIndex:indexPath.section] myItems] count] + 1)
    {
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"状态:" WithSize:CGSizeMake(MAXFLOAT, 30)];
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size.width, 30)];
        [firstLabel setText:@"状态:"];
        [firstLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:firstLabel];
        
        NSString *theStatus = [[dataArray objectAtIndex:indexPath.section] myStatus];
        NSString *status = [[dataArray objectAtIndex:indexPath.section] status];
        
        UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.frame.origin.x + firstLabel.frame.size.width + 10, 5, 100, 30)];
        [secondLabel setTextColor:[UIColor redColor]];
        [secondLabel setText:theStatus];
        [secondLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:secondLabel];
        
        float shippedLastestNum = 0.0;
        NSArray *myItems = [NSArray arrayWithArray:[[dataArray objectAtIndex:indexPath.section] myItems]];
        for(int i=0;i<myItems.count;i++)
        {
            NSDictionary *itemDic = [NSDictionary dictionaryWithDictionary:[myItems objectAtIndex:i]];
            shippedLastestNum = [[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"shippedLastestNum"]] floatValue] + shippedLastestNum;
        }
        if ([status intValue] == 2)
        {
            UILabel *messageLabel = [[UILabel alloc] init];
            messageLabel.frame = CGRectMake(ScreenWidth-175, 5, 170, 30);
            messageLabel.text = @"如果您已打款联系客服进行确认";
            messageLabel.font = [UIFont systemFontOfSize:12];
            [cell.contentView addSubview:messageLabel];
        }
        
        
        if([status intValue] == 0 || [status intValue] == 5)
        {
            UIButton *statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [statusBtn setFrame:CGRectMake(cellWidth-120, 5, 100, 30)];
            [statusBtn setTitleColor:MYCOLOR forState:UIControlStateNormal];
            if([status intValue] == 0)
            {
                [statusBtn setTitle:@"确认订单" forState:UIControlStateNormal];
            }
            if([status intValue] == 5)
            {
                if(shippedLastestNum <= 0.0)
                {
                    [statusBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                }
                else
                {
                    [statusBtn setFrame:CGRectMake(cellWidth-120, 5, 0, 0)];
                    [statusBtn setHidden:YES];
                }
            }
            [statusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            statusBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:144/255.0 blue:1/255.0 alpha:1.0];
            statusBtn.layer.cornerRadius = 5.0f;
            [statusBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [statusBtn addTarget:self action:@selector(statusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [statusBtn setTag:indexPath.section];
            [cell.contentView addSubview:statusBtn];
        }
        
    }
    //    }
    
    return cell;
}



- (void) statusBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    int tag = btn.tag;
    
    NSString *title = [NSString stringWithFormat:@"%@",btn.titleLabel.text];
    if([title isEqualToString:@"确认收货"])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"您确认要收货嘛" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认收货", nil];
        [av show];
        
        index = tag;
        //        [self sureReceiveRequest];
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(pushToDetailVCWithData:WithFlag:)])
        {
            [self.delegate pushToDetailVCWithData:[dataArray objectAtIndex:tag] WithFlag:1];
        }
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        
    }
    else
    {
        //        NSString *status = [[dataArray objectAtIndex:indexPath.section] status];
        
        //        if([status intValue] == 5)
        //        {
        //        }
        //        else
        //        {
        if([self.delegate respondsToSelector:@selector(pushToDetailVCWithData:WithFlag:)])
        {
            [self.delegate pushToDetailVCWithData:[dataArray objectAtIndex:indexPath.section] WithFlag:0];
        }
        //        }
        
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
        {
            [self sureReceiveRequest];
            break;
        }
        default:
            break;
    }
}

- (void) sureReceiveRequest
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"ConfirmReceive",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&orderid=%@",token,[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:index] orderserial]]];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLConfirmReceiveTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/ConfirmReceive.html?"];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    if (self.tableView == (UITableView *)scrollView)
    {
        if (scrollView.contentSize.height > 0 && (scrollView.contentSize.height-scrollView.frame.size.height)>0)
        {
            if (scrollView.contentOffset.y >= scrollView.contentSize.height-scrollView.frame.size.height)
            {
                if ((_intPage-1) * pageSize < intTotal )
                {
                    [self loadRequestWithStatus:_statusIndex];
                }
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.refreshView egoRefreshScrollViewDidScroll:self.tableView];
}
//
#pragma mark -
#pragma mark DATA SOURCE LOADING / RELOADING METHODS
- (void)reloadViewDataSource
{
    
    _reloading = YES;
    _intPage = 1;
    [self loadRequestWithStatus:_statusIndex];
}
//
- (void)doneLoadingViewData
{
    
    _reloading = NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}
//
//#pragma mark -
//#pragma mark REFRESH HEADER DELEGATE METHODS
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    
    [self reloadViewDataSource];
}
//
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    
    return _reloading;
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    
    return [NSDate date];
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
