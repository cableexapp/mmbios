//
//  ManagerInvoiceSubTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-14.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "ManagerInvoiceSubTableViewController.h"
#import "MCDefine.h"
#import "DCFStringUtil.h"
#import "DCFCustomExtra.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "LoginNaviViewController.h"
#import "DCFChenMoreCell.h"
#import "B2BManagBillData.h"

@interface ManagerInvoiceSubTableViewController ()
{
    DCFChenMoreCell *moreCell;
    NSMutableArray *dataArray;
    
    NSMutableArray *cellImageArray;
    NSMutableArray *cellLabelArray;
    NSMutableArray *cellAnotherLabelArray;
    
    NSMutableArray *selectedArray;
    
    NSMutableArray *chooseArray;
}
@end

@implementation ManagerInvoiceSubTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    selectedArray = [[NSMutableArray alloc] init];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"InvoiceList",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@",token,[self getMemberId]];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLInvoiceListTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/InvoiceList.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
}


- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    if(URLTag == URLInvoiceListTag)
    {
        dataArray = [[NSMutableArray alloc] init];
        cellImageArray = [[NSMutableArray alloc] init];
        cellLabelArray = [[NSMutableArray alloc] init];
        cellAnotherLabelArray = [[NSMutableArray alloc] init];
        
        chooseArray = [[NSMutableArray alloc] init];
        
        if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            [moreCell failAcimation];
        }
        else
        {
            if(result == 0)
            {
                [moreCell noB2BInvoice];
            }
            else
            {
                [dataArray addObjectsFromArray:[B2BManagBillData getListArray:[dicRespon objectForKey:@"items"]]];

                NSString *invoiceId = nil;
                if(![[NSUserDefaults standardUserDefaults] objectForKey:@"B2BBillMsg"])
                {
                    invoiceId = @"";
                }
                else
                {
                    invoiceId = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"B2BBillMsg"] objectForKey:@"invoiceId"]];
                }
                
                for(int i=0;i<dataArray.count;i++)
                {
                    NSString *dataInvoiceId = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] invoiceId]];
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
                    if(self.status == YES)
                    {
                        if([invoiceId isEqualToString:dataInvoiceId])
                        {
                            [iv setImage:[UIImage imageNamed:@"choose.png"]];
                        }
                        else
                        {
                            [iv setImage:[UIImage imageNamed:@"unchoose.png"]];
                        }
                    }
                    else
                    {
                        [iv setImage:[UIImage imageNamed:@"unchoose.png"]];
                    }
                    [cellImageArray addObject:iv];
                    
                    UILabel *firstLabel = [[UILabel alloc] init];
                    NSString *headType = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] headType]];
                    if(headType.length == 0 || [headType isKindOfClass:[NSNull class]])
                    {
                        [firstLabel setFrame:CGRectMake(iv.frame.origin.x + iv.frame.size.width + 10, iv.frame.origin.y, 0, 30)];
                    }
                    else
                    {
                        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:headType WithSize:CGSizeMake(MAXFLOAT, 30)];
                        [firstLabel setFrame:CGRectMake(iv.frame.origin.x + iv.frame.size.width + 10, iv.frame.origin.y, size.width, 30)];
                    }
                    [firstLabel setText:headType];
                    [firstLabel setFont:[UIFont systemFontOfSize:13]];
                    [cellLabelArray addObject:firstLabel];
                    
                    UILabel *secondLabel = [[UILabel alloc] init];
                    NSString *headName = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] headName]];
                    if(headName.length == 0 || [headName isKindOfClass:[NSNull class]])
                    {
                        [secondLabel setFrame:CGRectMake(firstLabel.frame.origin.x + firstLabel.frame.size.width + 5, 5, 0, 30)];
                    }
                    else
                    {
                        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:headName WithSize:CGSizeMake(ScreenWidth-35-iv.frame.size.width-firstLabel.frame.size.width, MAXFLOAT)];
                        if(size.height <= 30)
                        {
                            [secondLabel setFrame:CGRectMake(firstLabel.frame.origin.x + firstLabel.frame.size.width + 5, 5, ScreenWidth-35-iv.frame.size.width-firstLabel.frame.size.width, 30)];
                        }
                        else
                        {
                            [secondLabel setFrame:CGRectMake(firstLabel.frame.origin.x + firstLabel.frame.size.width + 5, 5, ScreenWidth-35-iv.frame.size.width-firstLabel.frame.size.width, MAXFLOAT)];
                        }
                    }
                    [secondLabel setText:headName];
                    [secondLabel setFont:[UIFont systemFontOfSize:13]];
                    [secondLabel setNumberOfLines:0];
                    [secondLabel setTextAlignment:NSTextAlignmentRight];
                    [cellAnotherLabelArray addObject:secondLabel];
                    
                    //重设frame
                    [iv setFrame:CGRectMake(iv.frame.origin.x, (secondLabel.frame.size.height+10-30)/2, iv.frame.size.width, 30)];
                    [firstLabel setFrame:CGRectMake(firstLabel.frame.origin.x, (secondLabel.frame.size.height+10-30)/2, firstLabel.frame.size.width, 30)];
                    
                    
                    if(self.status == YES)
                    {
                        //                        [cellBtn setEnabled:YES];
                        [firstLabel setTextColor:[UIColor blackColor]];
                        [secondLabel setTextColor:[UIColor blackColor]];
                    }
                    else if (self.status == NO)
                    {
                        [firstLabel setTextColor:[UIColor lightGrayColor]];
                        [secondLabel setTextColor:[UIColor lightGrayColor]];
                    }
                }
            }
        }
        [self.tableView reloadData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
    if(cellAnotherLabelArray)
    {
        UILabel *label = (UILabel *)[cellAnotherLabelArray objectAtIndex:indexPath.row];
        return label.frame.size.height + 10;
    }
    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        if(moreCell == nil)
        {
            moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
            [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        }
        return moreCell;
    }
    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:0];
        
        UIImageView *iv = (UIImageView *)[cellImageArray objectAtIndex:indexPath.row];
        [cell.contentView addSubview:iv];
        
        UILabel *firstLabel = (UILabel *)[cellLabelArray objectAtIndex:indexPath.row];
        [cell.contentView addSubview:firstLabel];
        
        UILabel *secondLabel = (UILabel *)[cellAnotherLabelArray objectAtIndex:indexPath.row];
        [cell.contentView addSubview:secondLabel];
    }
    return cell;
}

- (void) changeColor
{
    if(dataArray)
    {
        
        
        for(UILabel *label in cellLabelArray)
        {
            if(self.status == YES)
            {
                [label setTextColor:[UIColor blackColor]];
            }
            else if (self.status == NO)
            {
                [label setTextColor:[UIColor lightGrayColor]];
            }
        }
        for(UILabel *label in cellAnotherLabelArray)
        {
            if(self.status == YES)
            {
                [label setTextColor:[UIColor blackColor]];
            }
            else if (self.status == NO)
            {
                [label setTextColor:[UIColor lightGrayColor]];
            }
        }
        
        NSString *invoiceId = nil;
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"B2BBillMsg"])
        {
            invoiceId = @"";
        }
        else
        {
            invoiceId = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"B2BBillMsg"] objectForKey:@"invoiceId"]];
        }
        for(int i = 0;i<cellImageArray.count;i++)
        {
            UIImageView *iv = (UIImageView *)[cellImageArray objectAtIndex:i];
            if(self.status == YES)
            {
                    NSString *dataInvoiceId = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] invoiceId]];
                    if([invoiceId isEqualToString:dataInvoiceId])
                    {
                        [iv setImage:[UIImage imageNamed:@"choose.png"]];
                    }
                    else
                    {
                        [iv setImage:[UIImage imageNamed:@"unchoose.png"]];
                    }
            }
            else
            {
                [iv setImage:[UIImage imageNamed:@"unchoose.png"]];
            }
        }
        [self.tableView reloadData];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_status == YES)
    {
        if(!dataArray || dataArray.count == 0)
        {
            
        }
        else
        {
            B2BManagBillData *data = [dataArray objectAtIndex:indexPath.row];
            
            if(cellImageArray)
            {
                UIImageView *iv = (UIImageView *)[cellImageArray objectAtIndex:indexPath.row];
                if([selectedArray containsObject:indexPath])
                {
                    [selectedArray removeObject:indexPath];
                    [iv setImage:[UIImage imageNamed:@"unchoose.png"]];
                    
                    [chooseArray removeObject:data];
                }
                else
                {
                    [selectedArray addObject:indexPath];
                    [iv setImage:[UIImage imageNamed:@"choose.png"]];
                    
                    [chooseArray addObject:data];
                }
            }
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:data.headType,@"type",data.headName,@"name",data.invoiceId,@"invoiceId", nil];
            NSLog(@"dic = %@",dic);
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"B2BBillMsg"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
        //        NSLog(@"arr = %@",chooseArray);
        //        [self changeChooseArray];
    }
    else
    {
    }
}

- (NSMutableArray *) changeChooseArray
{
    return chooseArray;
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
