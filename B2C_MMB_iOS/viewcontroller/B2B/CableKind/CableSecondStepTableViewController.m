//
//  CableSecondStepTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-8.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "CableSecondStepTableViewController.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "DCFChenMoreCell.h"
//#import "CableThirdStepTableViewController.h"
#import "CableThirdStepViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"

@interface CableSecondStepTableViewController ()
{
    CableThirdStepViewController *third;
    
    DCFChenMoreCell *moreCell;

    NSMutableArray *dataArray;
    
    NSString *theTypeiD;
    
    NSMutableArray *cellIvArray;
    NSMutableArray *cellLabelArray;

}
@end

@implementation CableSecondStepTableViewController

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
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(conn)
    {
        [conn stopConnection];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    third = [self.storyboard instantiateViewControllerWithIdentifier:@"cableThirdStepViewController"];

    [self.view setFrame:CGRectMake(0, 0, self.width, self.height)];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = [UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0];
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductTypeByid",time];
    NSString *token = [DCFCustomExtra md5:string];
    
#pragma mark - 一级分类
    NSString *pushString = [NSString stringWithFormat:@"token=%@&typeid=%@",token,self.myTypeId];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetProductTypeByidTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/getProductTypeByid.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    
    if(URLTag == URLGetProductTypeByidTag)
    {
        cellIvArray = [[NSMutableArray alloc] init];
        cellLabelArray = [[NSMutableArray alloc] init];
        
        if([[dicRespon allKeys] count] == 0)
        {
            [moreCell failAcimation];
        }
        else
        {
            if(result == 1)
            {

                dataArray = [[NSMutableArray alloc] initWithArray:[dicRespon objectForKey:@"items"]];

                if(dataArray.count == 0)
                {
                    [moreCell noClasses];
                }
                else
                {
                    [moreCell stopAnimation];
                }
            }
            else
            {
                dataArray = [[NSMutableArray alloc] init];
                [moreCell noClasses];
            }
        }
        
        [self.tableView reloadData];
        

        if(!dataArray || dataArray.count == 0)
        {
            third.myTypeId = @"0";
        }
        else
        {
            theTypeiD = [[dataArray objectAtIndex:0] objectForKey:@"typeId"];
            third.myTypeId = theTypeiD;
        }
        
        if([self.delegate respondsToSelector:@selector(changeWithTypeId:WithTypeName:)])
        {
            NSString *name = [NSString stringWithFormat:@"%@>",[[dataArray objectAtIndex:0] objectForKey:@"typeName"]];
            NSString *theName = [NSString stringWithFormat:@"%@%@",self.title,name];
            [self.delegate changeWithTypeId:theTypeiD WithTypeName:theName];
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
            [moreCell setFrame:CGRectMake(0, 0, self.width, self.height)];
            [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
            [moreCell.avState setFrame:CGRectMake(50, 12, 20, 20)];
            [moreCell.lblContent setFrame:CGRectMake(80, 12, ScreenWidth-20, 20)];
        }
        return moreCell;
    }
    
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        
        cell.selectionStyle = 0;
        
        [cell.contentView setFrame:CGRectMake(0, 0, self.width, self.height)];
        
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(4,0, self.width-4, 44)];
        [cellLabel setTag:10];
        [cellLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.contentView addSubview:cellLabel];

        
        UIImageView *cellIv = [[UIImageView alloc] initWithFrame:CGRectMake(0,-0.5, 4,44.5)];
        cellIv.backgroundColor = [UIColor colorWithRed:8.0/255.0 green:88.0/255.0 blue:172.0/255.0 alpha:1.0];

        [cellIv setTag:11];
        if(indexPath.row == 0)
        {
            [cellLabel setBackgroundColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]];
            cell.backgroundColor = [UIColor whiteColor];
            [cellLabel setTextColor:[UIColor colorWithRed:8.0/255.0 green:88.0/255.0 blue:172.0/255.0 alpha:1.0]];
            [cellIv setHidden:NO];
        }
        else
        {
            [cellLabel setBackgroundColor:[UIColor whiteColor]];
            [cellLabel setTextColor:[UIColor blackColor]];
            [cellIv setHidden:YES];
        }
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:cellIv];

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-0.5, 0, 0.5, cell.contentView.frame.size.height)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:lineView];
        
        [cellIvArray addObject:cellIv];
        [cellLabelArray addObject:cellLabel];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    [label setText:[NSString stringWithFormat:@"  %@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"typeName"]]];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-0.5, self.width, 0.5)];
    [lineView setBackgroundColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]];
    [cell addSubview:lineView];
    
    return cell;
}

 - (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    for(int i=0;i<cellIvArray.count;i++)
    {
        UIImageView *iv = (UIImageView *)[cellIvArray objectAtIndex:i];
        UILabel *label = (UILabel *)[cellLabelArray objectAtIndex:i];
        if(i == indexPath.row)
        {
            [label setBackgroundColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]];
            [label setTextColor:[UIColor colorWithRed:8.0/255.0 green:88.0/255.0 blue:172.0/255.0 alpha:1.0]];
            [iv setHidden:NO];
        }
        else
        {
            [label setBackgroundColor:[UIColor whiteColor]];
            [label setTextColor:[UIColor blackColor]];
            [iv setHidden:YES];
        }
    }
    
    if(!dataArray || dataArray.count == 0)
    {
        third.myTypeId = @"0";
    }
    else
    {
        theTypeiD = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"typeId"];
        third.myTypeId = theTypeiD;
    }
//    [third changeClassify:theTypeiD];
    
    if([self.delegate respondsToSelector:@selector(changeWithTypeId:WithTypeName:)])
    {
        NSString *name = [NSString stringWithFormat:@"%@>",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"typeName"]];
        NSString *theName = [NSString stringWithFormat:@"%@%@",self.title,name];
        [self.delegate changeWithTypeId:theTypeiD WithTypeName:theName];
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
@end
