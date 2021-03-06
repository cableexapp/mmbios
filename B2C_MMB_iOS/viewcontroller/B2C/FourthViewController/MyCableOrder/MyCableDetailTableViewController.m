//
//  MyCableDetailTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-13.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyCableDetailTableViewController.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "DCFChenMoreCell.h"

@interface MyCableDetailTableViewController ()
{
    DCFChenMoreCell *moreCell;
    NSMutableArray *dataArray;
    B2BMyCableDetailData *b2bMyCableDetailData;
}
@end

@implementation MyCableDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"OrderDetail",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&orderid=%@",token,self.myOrderid];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLOrderDetailTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/OrderDetail.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
}


- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    if(URLTag == URLOrderDetailTag)
    {
        if([[dicRespon allKeys] count] == 0)
        {
            [moreCell noDataAnimation];
        }
        else
        {
            if(result == 1)
            {
                b2bMyCableDetailData = [[B2BMyCableDetailData alloc] init];
                [b2bMyCableDetailData dealData:dicRespon];
                dataArray = [[NSMutableArray alloc] initWithArray:b2bMyCableDetailData.myItems];
                
                status = [[NSString alloc] initWithFormat:@"%@",b2bMyCableDetailData.status];
                
                if([self.delegate respondsToSelector:@selector(requestHasFinished:)])
                {
                    [self.delegate requestHasFinished:b2bMyCableDetailData];
                }
                
                if(dataArray.count == 0)
                {
                    [moreCell noClasses];
                }
            }
            else
            {
                dataArray = [[NSMutableArray alloc] init];
                [moreCell failAcimation];
            }
        }
        
    }
    [self.tableView reloadData];
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
    return 4;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 0;
    }
    BOOL hide = YES;
    NSString *invoceName = nil;
    if([[[b2bMyCableDetailData invoiceDic] allKeys] count] == 0 || [[b2bMyCableDetailData invoiceDic] isKindOfClass:[NSNull class]])
    {
        hide = YES;
        invoceName = @"";
    }
    else
    {
        invoceName = [[b2bMyCableDetailData invoiceDic] objectForKey:@"name"];
    }
    
    if([DCFCustomExtra validateString:invoceName] == NO)
    {
        hide = YES;
    }
    else
    {
        hide = NO;
    }
    
    if(section == 0)
    {
        if(hide == YES)
        {
            return 0;
        }
        else
        {
            return 40;
        }
    }
    if(section == 1)
    {
        if(hide == YES)
        {
            return 0;
        }
        else
        {
            return 40;
        }
    }
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return nil;
    }
    
    BOOL hide = YES;
    NSString *invoceName = nil;
    if([[[b2bMyCableDetailData invoiceDic] allKeys] count] == 0 || [[b2bMyCableDetailData invoiceDic] isKindOfClass:[NSNull class]])
    {
        hide = YES;
        invoceName = @"";
    }
    else
    {
        invoceName = [[b2bMyCableDetailData invoiceDic] objectForKey:@"name"];
    }
    
    if([DCFCustomExtra validateString:invoceName] == NO)
    {
        hide = YES;
    }
    else
    {
        hide = NO;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    [view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 30)];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    if(section == 0)
    {
        [label setText:@"发票信息"];
        if(hide == YES)
        {
            [label setFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        }
    }
    if(section == 1)
    {
        [label setText:@"发票邮寄地址"];
        if(hide == YES)
        {
            [label setFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        }
    }
    if(section == 2)
    {
        [label setText:@"收货地址"];
    }
    if(section == 3)
    {
        [label setText:@"型号信息"];
    }
    //    [label setBackgroundColor:[UIColor whiteColor]];
    //    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:label];
    
    for(int i=0;i<2;i++)
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5*i, ScreenWidth, 0.5)];
        [lineView setBackgroundColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        [view addSubview:lineView];
    }
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 1;
    }
    if(section == 0)
    {
        return 1;
    }
    if(section == 1)
    {
        return 1;
    }
    if(section == 2)
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
    
    BOOL hide = YES;
    NSString *invoceName = nil;
    if([[[b2bMyCableDetailData invoiceDic] allKeys] count] == 0 || [[b2bMyCableDetailData invoiceDic] isKindOfClass:[NSNull class]])
    {
        hide = YES;
        invoceName = @"";
    }
    else
    {
        invoceName = [[b2bMyCableDetailData invoiceDic] objectForKey:@"name"];
    }
    
    if([DCFCustomExtra validateString:invoceName] == NO)
    {
        hide = YES;
    }
    else
    {
        hide = NO;
    }
    
    if(indexPath.section == 0)
    {
        if(hide == YES)
        {
            return 0;
        }
        else
        {
            return 44;
        }
    }
    if(indexPath.section == 1)
    {
        if(hide == YES)
        {
            return 0;
        }
        else
        {
            NSString *receiveAddress = [NSString stringWithFormat:@"收货地址: %@%@%@%@",[[b2bMyCableDetailData invoiceDic] objectForKey:@"province"],[[b2bMyCableDetailData invoiceDic] objectForKey:@"city"],[[b2bMyCableDetailData invoiceDic] objectForKey:@"district"],[[b2bMyCableDetailData invoiceDic] objectForKey:@"address"]];
            receiveAddress = [receiveAddress stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"(null)"]];
            receiveAddress = [receiveAddress stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"null"]];
            
            CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:receiveAddress WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
            
            return size.height+40;
        }
    }
    
    
    
    if(indexPath.section == 2)
    {
        NSString *address = [NSString stringWithFormat:@"收货地址: %@",[b2bMyCableDetailData fullAddress]];
        CGSize size;
        
        size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:address WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
        return size.height+40;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[dataArray objectAtIndex:indexPath.row]];
    
    
    
    //    NSString *theNumber = [NSString stringWithFormat:@"%@",[dic objectForKey:@"num"]];  //数量
    //    NSString *theUnit = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unit"]];   //单位
    //    NSString *thDeliver = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deliver"]];   //交货期
    NSString *theInquirySpec = [NSString stringWithFormat:@"%@",[dic objectForKey:@"spec"]]; //规格
    NSString *theInquiryVoltage = [NSString stringWithFormat:@"%@",[dic objectForKey:@"voltage"]]; //电压
    NSString *theInquiryFeature = [NSString stringWithFormat:@"%@",[dic objectForKey:@"feature"]]; //阻燃
    
    NSString *thePrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"buyerPrice"]]; //价格
    NSString *theRequire = [NSString stringWithFormat:@"%@",[dic objectForKey:@"require"]]; //特殊要求
    
    CGFloat height_1 = 0.0;
    CGFloat height_2 = 0.0;
    CGFloat height_3 = 0.0;
    CGFloat height_4 = 0.0;
    
    if([DCFCustomExtra validateString:theInquiryVoltage] == NO && [DCFCustomExtra validateString:theInquirySpec] == NO)
    {
        height_1 = 0;
    }
    else
    {
        height_1 = 20;
    }
    
    if([DCFCustomExtra validateString:theInquiryFeature] == NO)
    {
        height_2 = 0;
    }
    else
    {
        height_2 = 20;
    }
    
    if([DCFCustomExtra validateString:thePrice] == NO)
    {
        height_3 = 0;
    }
    else
    {
        height_3 = 20;
    }
    
    
    CGSize requestSize;
    if([DCFCustomExtra validateString:theRequire] == NO)
    {
        requestSize = CGSizeMake(ScreenWidth-20, 0);
        height_4 = 0;
    }
    else
    {
        requestSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:theRequire WithSize:CGSizeMake(ScreenWidth-75, MAXFLOAT)];
        height_4 = requestSize.height;
    }
    NSArray *logstics_listArray = [NSArray arrayWithArray:[dic objectForKey:@"logstics_list"]];
    float shippedHasNum = [[dic objectForKey:@"shippedHasNum"] floatValue];
    if(shippedHasNum > 0.00)
    {
        if(logstics_listArray.count != 0 || ![logstics_listArray isKindOfClass:[NSNull class]])
        {
            return 91.5 + 80*logstics_listArray.count+height_1+height_2+height_3+height_4;
        }
    }
    
    return 91.5+height_1+height_2+height_3+height_4;
    
    //    if([status intValue] == 5)
    //    {
    //        NSArray *logstics_listArray = [NSArray arrayWithArray:[dic objectForKey:@"logstics_list"]];
    //
    //        return 95+height_1+height_2+height_3+height_4+20 + 77*logstics_listArray.count;
    //    }
    //    else
    //    {
    //        return 95+height_1+height_2+height_3+height_4+20;
    //    }
    
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
            [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
        }
        return moreCell;
    }
    
    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:0];
        
        BOOL hide = YES;
        NSString *invoceName = nil;
        if([[[b2bMyCableDetailData invoiceDic] allKeys] count] == 0 || [[b2bMyCableDetailData invoiceDic] isKindOfClass:[NSNull class]])
        {
            hide = YES;
            invoceName = @"";
        }
        else
        {
            invoceName = [[b2bMyCableDetailData invoiceDic] objectForKey:@"name"];
        }
        if([DCFCustomExtra validateString:invoceName] == NO)
        {
            hide = YES;
        }
        else
        {
            hide = NO;
        }
        if(indexPath.section == 0)
        {
            if(hide == YES)
            {
                
            }
            else
            {
                NSString *invoiceType = [NSString stringWithFormat:@"%@",[[b2bMyCableDetailData invoiceDic] objectForKey:@"type"]];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 34)];
                NSString *invoiceStr = nil;
                NSMutableAttributedString *myInvoiceName = nil;
                if([invoiceType intValue] == 1)
                {
                    invoiceStr = [NSString stringWithFormat:@"普通发票: %@",invoceName];
                    myInvoiceName = [[NSMutableAttributedString alloc] initWithString:invoiceStr];
                    [myInvoiceName addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
                    [myInvoiceName addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, invoiceStr.length-5)];
                }
                else
                {
                    invoiceStr = [NSString stringWithFormat:@"增值税发票: %@",invoceName];
                    myInvoiceName = [[NSMutableAttributedString alloc] initWithString:invoiceStr];
                    [myInvoiceName addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 6)];
                    [myInvoiceName addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(6, invoiceStr.length-6)];
                }
                [label setFont:[UIFont systemFontOfSize:12]];
                [label setAttributedText:myInvoiceName];
                [cell.contentView addSubview:label];
            }
        }
        else if(indexPath.section == 1)
        {
            if(hide == YES)
            {
                
            }
            else
            {
                NSString *recipient = [NSString stringWithFormat:@"%@",[[b2bMyCableDetailData invoiceDic] objectForKey:@"recipient"]];
                UILabel *recipientLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 30)];
                NSString *invoiceName = nil;
                NSMutableAttributedString *myRecipient = nil;
                
                invoiceName = [NSString stringWithFormat:@"收货人: %@",recipient];
                myRecipient = [[NSMutableAttributedString alloc] initWithString:invoiceName];
                [myRecipient addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
                [myRecipient addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(4, invoiceName.length-4)];
                
                [recipientLabel setAttributedText:myRecipient];
                [recipientLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:recipientLabel];
                
                NSString *receiveTel = [NSString stringWithFormat:@"%@",[[b2bMyCableDetailData invoiceDic] objectForKey:@"receiveTel"]];
                UILabel *receiveTelLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 150, 30)];
                [receiveTelLabel setText:receiveTel];
                [receiveTelLabel setFont:[UIFont systemFontOfSize:12]];
                [receiveTelLabel setTextAlignment:NSTextAlignmentRight];
                [cell.contentView addSubview:receiveTelLabel];
                
                NSString *receiveAddress = [NSString stringWithFormat:@"收货地址: %@%@%@%@",[[b2bMyCableDetailData invoiceDic] objectForKey:@"province"],[[b2bMyCableDetailData invoiceDic] objectForKey:@"city"],[[b2bMyCableDetailData invoiceDic] objectForKey:@"district"],[[b2bMyCableDetailData invoiceDic] objectForKey:@"address"]];
                receiveAddress = [receiveAddress stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"(null)"]];
                receiveAddress = [receiveAddress stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"null"]];
                
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:receiveAddress WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
                
                NSMutableAttributedString *myReceiveAddress = [[NSMutableAttributedString alloc] initWithString:receiveAddress];
                [myReceiveAddress addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
                [myReceiveAddress addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, receiveAddress.length-5)];
                
                UILabel *receiveAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, recipientLabel.frame.origin.y+recipientLabel.frame.size.height, ScreenWidth-20, size.height)];
                [receiveAddressLabel setFont:[UIFont systemFontOfSize:12]];
                [receiveAddressLabel setAttributedText:myReceiveAddress];
                [receiveAddressLabel setFont:[UIFont systemFontOfSize:12]];
                [receiveAddressLabel setNumberOfLines:0];
                [cell.contentView addSubview:receiveAddressLabel];
            }
        }
        else if(indexPath.section == 2)
        {
            if(indexPath.row == 0)
            {
                NSString *name = [NSString stringWithFormat:@"收货人: %@",[b2bMyCableDetailData reciver]];
                NSString *tel = [NSString stringWithFormat:@"联系电话: %@",[b2bMyCableDetailData theTel]];
                
                CGSize nameSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:name WithSize:CGSizeMake(MAXFLOAT, 30)];
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, nameSize.width, 30)];
                [nameLabel setText:name];
                [nameLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:nameLabel];
                
                CGSize telSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:tel WithSize:CGSizeMake(MAXFLOAT, 30)];
                UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-telSize.width, 5, telSize.width, 30)];
                [telLabel setText:tel];
                [telLabel setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:telLabel];
                
                NSString *address = [NSString stringWithFormat:@"收货地址: %@",[b2bMyCableDetailData fullAddress]];
                CGSize addressSize;
                if([DCFCustomExtra validateString:address] == NO)
                {
                    addressSize = CGSizeMake(30, 0);
                }
                else
                {
                    addressSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:address WithSize:CGSizeMake(cell.contentView.frame.size.width-20, MAXFLOAT)];
                }
                UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLabel.frame.origin.y + nameLabel.frame.size.height,ScreenWidth-20,addressSize.height)];
                [addressLabel setText:address];
                [addressLabel setFont:[UIFont systemFontOfSize:12]];
                [addressLabel setNumberOfLines:0];
                [cell.contentView addSubview:addressLabel];
            }
        }
        else
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, 65)];
            [view setBackgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:view];
            
            CGFloat width = cell.contentView.frame.size.width/2;
            
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[dataArray objectAtIndex:indexPath.row]];
            NSString *unit = [dic objectForKey:@"unit"];
            
            CGSize size_model = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"型号:" WithSize:CGSizeMake(MAXFLOAT, 30)];
            UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size_model.width, 30)];
            [modelLabel setText:@"型号:"];
            [modelLabel setFont:[UIFont systemFontOfSize:12]];
            [view addSubview:modelLabel];
            
            UILabel *model_anotherLabel = [[UILabel alloc] initWithFrame:CGRectMake(modelLabel.frame.origin.x + modelLabel.frame.size.width + 5, 5, cell.contentView.frame.size.width-modelLabel.frame.origin.x - modelLabel.frame.size.width - 5 -10, 30)];
            [model_anotherLabel setText:[dic objectForKey:@"model"]];
            [model_anotherLabel setFont:[UIFont systemFontOfSize:12]];
            [view addSubview:model_anotherLabel];
            
            UILabel *fenleiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, modelLabel.frame.origin.y + modelLabel.frame.size.height, modelLabel.frame.size.width, 30)];
            [fenleiLabel setText:@"分类:"];
            [fenleiLabel setFont:[UIFont systemFontOfSize:12]];
            [view addSubview:fenleiLabel];
            
            NSString *firstType = (NSString *)[dic objectForKey:@"firstType"];
            NSString *secondType = (NSString *)[dic objectForKey:@"secondType"];
            NSString *thridType = (NSString *)[dic objectForKey:@"thirdType"];
            NSString *type = [NSString stringWithFormat:@"%@%@%@",firstType,secondType,thridType];
            
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(fenleiLabel.frame.origin.x + fenleiLabel.frame.size.width + 5, fenleiLabel.frame.origin.y, cell.contentView.frame.size.width-modelLabel.frame.origin.x - modelLabel.frame.size.width - 5-10, 30)];
            [typeLabel setText:type];
            [typeLabel setFont:[UIFont systemFontOfSize:12]];
            [typeLabel setNumberOfLines:0];
            [view addSubview:typeLabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.origin.y+view.frame.size.height, cell.contentView.frame.size.width, 0.5)];
            [lineView setBackgroundColor:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0]];
            [cell.contentView addSubview:lineView];
            
            NSString *NumBer = [NSString stringWithFormat:@"%@",[dic objectForKey:@"num"]];
            NSString *testNum = [DCFCustomExtra notRounding:NumBer];
            NSString *theNumber = [NSString stringWithFormat:@"%@",testNum];  //数量
            NSString *theUnit = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unit"]];   //单位
            NSString *thDeliver = [NSString stringWithFormat:@"%@天",[dic objectForKey:@"deliver"]];   //交货期
            NSString *theInquirySpec = [NSString stringWithFormat:@"%@平方",[dic objectForKey:@"spec"]]; //规格
            NSString *theInquiryVoltage = [NSString stringWithFormat:@"%@",[dic objectForKey:@"voltage"]]; //电压
            NSString *theInquiryFeature = [NSString stringWithFormat:@"%@",[dic objectForKey:@"feature"]]; //阻燃
            NSString *thePrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"buyerPrice"]]; //价格
            NSString *theRequire = [NSString stringWithFormat:@"%@",[dic objectForKey:@"require"]]; //特殊要求
            
            CGFloat height_1 = 0.0;
            CGFloat height_2 = 0.0;
            
            for(int i=0;i<5;i++)
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
                        [label setFrame:CGRectMake(10, lineView.frame.origin.y, width, 20)];
                        if([DCFCustomExtra validateString:theNumber] == NO)
                        {
                            [label setText:@"采购数量:"];
                        }
                        else
                        {
                            [label setText:[NSString stringWithFormat:@"采购数量: %@%@",theNumber,theUnit]];
                        }
                        break;
                    }
                    case 1:
                    {
                        if([DCFCustomExtra validateString:thDeliver] == NO)
                        {
                            [label setText:@"交货期:"];
                        }
                        else
                        {
                            [label setText:[NSString stringWithFormat:@"交货期: %@",thDeliver]];
                        }
                        [label setFrame:CGRectMake(10+width, lineView.frame.origin.y, width, 20)];
                        break;
                    }
                    case 2:
                    {
                        if([DCFCustomExtra validateString:[dic objectForKey:@"spec"]] == NO)
                        {
                            //                            [label setText:@"规格:"];
                            [label setFrame:CGRectMake(10, lineView.frame.origin.y+20, width, 0)];
                        }
                        else
                        {
                            [label setText:[NSString stringWithFormat:@"规格: %@",theInquirySpec]];
                            [label setFrame:CGRectMake(10, lineView.frame.origin.y+20, width, 20)];
                        }
                        break;
                    }
                    case 3:
                    {
                        if([DCFCustomExtra validateString:theInquiryVoltage] == NO)
                        {
                            //                            [label setText:[NSString stringWithFormat:@"电压:"]];
                            [label setFrame:CGRectMake(10+width, lineView.frame.origin.y+20, width, 0)];
                        }
                        else
                        {
                            [label setText:[NSString stringWithFormat:@"电压: %@",theInquiryVoltage]];
                            [label setFrame:CGRectMake(10+width, lineView.frame.origin.y+20, width, 20)];
                        }
                        if([DCFCustomExtra validateString:theInquiryVoltage] == NO && [DCFCustomExtra validateString:[dic objectForKey:@"spec"]] == NO)
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
                        if([DCFCustomExtra validateString:theInquiryFeature] == NO)
                        {
                            //                            [label setText:[NSString stringWithFormat:@"阻燃耐火:"]];
                            [label setFrame:CGRectMake(10, lineView.frame.origin.y+20+height_1, width*2-20, 0)];
                            height_2 = 0;
                        }
                        else
                        {
                            [label setText:[NSString stringWithFormat:@"阻燃耐火: %@",theInquiryFeature]];
                            [label setFrame:CGRectMake(10, lineView.frame.origin.y+20+height_1, width*2-20, 20)];
                            height_2 = 20;
                        }
                        break;
                    }
                    default:
                    break;
                }
                [cell.contentView addSubview:label];
            }
            
            CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"询价结果:" WithSize:CGSizeMake(MAXFLOAT, 20)];
            
            UILabel *label_1 = [[UILabel alloc] init];
            
            CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:thePrice WithSize:CGSizeMake(MAXFLOAT, 20)];
            UILabel *pricelabel = [[UILabel alloc] init];
            
            UILabel *label_2 = [[UILabel alloc] init];
            [label_2 setFont:[UIFont systemFontOfSize:12]];
            [label_2 setText:[NSString stringWithFormat:@"元/%@",theUnit]];
            
            
            if([DCFCustomExtra validateString:thePrice] == NO)
            {
                [label_1 setFrame:CGRectMake(10, 85.5+height_1+height_2, size_1.width, 0)];
                
                [pricelabel setFrame:CGRectMake(label_1.frame.origin.x + label_1.frame.size.width+5, lineView.frame.origin.y+35+height_1+height_2, size_2.width, 0)];
                
                [label_2 setFrame:CGRectMake(pricelabel.frame.origin.x + pricelabel.frame.size.width + 10, lineView.frame.origin.y+35+height_1+height_2, 150, 0)];
            }
            else
            {
                [label_1 setFrame:CGRectMake(10, 85.5+height_1+height_2, size_1.width,20)];
                [label_1 setText:@"询价结果:"];
                [label_1 setFont:[UIFont systemFontOfSize:12]];
                
                [pricelabel setFrame:CGRectMake(label_1.frame.origin.x + label_1.frame.size.width+5,label_1.frame.origin.y, size_2.width, 20)];
                [pricelabel setFont:[UIFont systemFontOfSize:12]];
                [pricelabel setText:thePrice];
                [pricelabel setTextColor:[UIColor redColor]];
                
                [label_2 setFrame:CGRectMake(pricelabel.frame.origin.x + pricelabel.frame.size.width+5,label_1.frame.origin.y, 150, 20)];
                [cell.contentView addSubview:label_1];
                [cell.contentView addSubview:label_2];
                [cell.contentView addSubview:pricelabel];
            }
            
            
            UILabel *label_3 = [[UILabel alloc] init];
            UILabel *requestLabel = [[UILabel alloc] init];
            
            
            CGSize requestSize;
            if([DCFCustomExtra validateString:theRequire] == NO)
            {
                requestSize = CGSizeMake(ScreenWidth-20, 0);
                [label_3 setFrame:CGRectMake(10, pricelabel.frame.origin.y+pricelabel.frame.size.height,55,0)];
                [requestLabel setFrame:CGRectMake(65, pricelabel.frame.origin.y+pricelabel.frame.size.height, ScreenWidth-75,0)];
            }
            else
            {
                requestSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:theRequire WithSize:CGSizeMake(ScreenWidth-75, MAXFLOAT)];
                
                [label_3 setText:@"特殊要求:"];
                [label_3 setFont:[UIFont systemFontOfSize:12]];
                
                [requestLabel setFont:[UIFont systemFontOfSize:12]];
                [requestLabel setText:theRequire];
                [requestLabel setNumberOfLines:0];
                [requestLabel setFrame:CGRectMake(65, pricelabel.frame.origin.y+pricelabel.frame.size.height, ScreenWidth-75,requestSize.height)];
                [label_3 setFrame:CGRectMake(10, pricelabel.frame.origin.y+pricelabel.frame.size.height,55, requestSize.height)];
                [cell.contentView addSubview:label_3];
                [cell.contentView addSubview:requestLabel];
            }
            
            
            
            NSArray *logstics_listArray = [NSArray arrayWithArray:[dic objectForKey:@"logstics_list"]];
            float shippedHasNum = [[dic objectForKey:@"shippedHasNum"] floatValue];
            if(shippedHasNum > 0.00)
            {
                if(logstics_listArray.count != 0 || ![logstics_listArray isKindOfClass:[NSNull class]])
                {
                    UIView *seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, requestLabel.frame.origin.y+requestLabel.frame.size.height, ScreenWidth, 1)];
                    [seperateView setBackgroundColor:[UIColor lightGrayColor]];
                    [cell.contentView addSubview:seperateView];
                    
                    NSArray *logstics_listArray = [NSArray arrayWithArray:[dic objectForKey:@"logstics_list"]];
                    for(int i=0;i<logstics_listArray.count;i++)
                    {
                        UIView *logsticsView = [[UIView alloc] initWithFrame:CGRectMake(0, (seperateView.frame.origin.y+0.5)+80*i, ScreenWidth, 80)];
                        [cell.contentView addSubview:logsticsView];
                        
                        NSDictionary *logsticsDic = [NSDictionary dictionaryWithDictionary:[logstics_listArray objectAtIndex:i]];
                        NSString *s1 = @"发货信息";
                        UILabel *s1Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 20)];
                        [s1Label setText:s1];
                        [s1Label setFont:[UIFont boldSystemFontOfSize:13]];
                        [logsticsView addSubview:s1Label];
                        
                        NSString *sendPrice = [NSString stringWithFormat:@"%@",[logsticsDic objectForKey:@"current_num"]];
                        NSString *s2 = [NSString stringWithFormat:@"已发货: %@%@",[DCFCustomExtra testRound:sendPrice],unit];
                        NSMutableAttributedString *current_num = [[NSMutableAttributedString alloc] initWithString:s2];
                        [current_num addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
                        [current_num addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(4, s2.length-4)];
                        UILabel *current_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, ScreenWidth-20, 20)];
                        [current_numLabel setAttributedText:current_num];
                        [current_numLabel setFont:[UIFont systemFontOfSize:12]];
                        [logsticsView addSubview:current_numLabel];
                        
                        NSString *s3 = [NSString stringWithFormat:@"物流公司: %@",[logsticsDic objectForKey:@"logistics_company"]];
                        NSMutableAttributedString *logistics_company = [[NSMutableAttributedString alloc] initWithString:s3];
                        [logistics_company addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
                        [logistics_company addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, s3.length-5)];
                        UILabel *logistics_companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, ScreenWidth-20, 20)];
                        [logistics_companyLabel setAttributedText:logistics_company];
                        [logistics_companyLabel setFont:[UIFont systemFontOfSize:12]];
                        [logsticsView addSubview:logistics_companyLabel];
                        
                        NSString *s4 = [NSString stringWithFormat:@"物流单号: %@",[logsticsDic objectForKey:@"logistics_no"]];
                        NSMutableAttributedString *logistics_no = [[NSMutableAttributedString alloc] initWithString:s4];
                        [logistics_no addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
                        [logistics_no addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, s4.length-5)];
                        UILabel *logistics_noLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, ScreenWidth-20, 20)];
                        [logistics_noLabel setAttributedText:logistics_no];
                        [logistics_noLabel setFont:[UIFont systemFontOfSize:12]];
                        [logsticsView addSubview:logistics_noLabel];
                        
                        if(logstics_listArray.count >= 2)
                        {
                            if(i <= logstics_listArray.count-2)
                            {
                                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, logistics_noLabel.frame.origin.y+logistics_noLabel.frame.size.height, ScreenWidth, 0.5)];
                                [line setBackgroundColor:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0]];
                                [logsticsView addSubview:line];
                            }
                        }
                    }
                }
                else
                {
                    
                }
            }
            
            
        }
    }
    
    return cell;
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
