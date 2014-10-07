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

@interface ChooseReceiveAddressViewController ()
{
    NSMutableArray *cellBtnArray;
    
    UIButton *rightItemBtn;
    
    BOOL rightItemBtnHasClick;
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


- (id) initWithDataArray:(NSMutableArray *) arr
{
    if(self = [super init])
    {
        dataArray = [[NSMutableArray alloc] initWithArray:arr];
        
        if(dataArray.count == 0)
        {
            
        }
        else
        {
            //            for(int i = 0; i < dataArray.count; i++)
            //            {
            //                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
            //                                     @"二货",@"name",
            //                                     @"13922326230",@"tel",
            //                                     @"北京市市辖区海淀区万寿路街道",@"province",
            //                                     @"北太平路31号51幼儿园北京市海淀区北太平路31",@"address",nil];
            //                [dataArray addObject:dic];
            //            }
            
            cellBtnArray = [[NSMutableArray alloc] init];
            
            for(int i=0;i<dataArray.count;i++)
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
                [btn setSelected:NO];
                [btn setTag:i];
                [btn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cellBtnArray addObject:btn];
            }
            
        }
        if(tv)
        {
            [tv reloadData];
        }
    }
    return self;
}

- (IBAction)buttomBtnClick:(id)sender
{
    [self hideButtomView];
    
}

- (void) rightItemClick:(UIButton *) sender
{
    [self showButtomView];
    
    
    AddReceiveAddressViewController *add = [[AddReceiveAddressViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}


- (void) showButtomView
{
    rightItemBtnHasClick = NO;
    
    [self.buttomView setHidden:NO];
    [self.tvBackView setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-64-49)];
    [tv setFrame:CGRectMake(0, 0, self.tvBackView.frame.size.width, self.tvBackView.frame.size.height)];
    
    //    for(UIButton *btn in cellBtnArray)
    //    {
    //        [btn setHidden:YES];
    //    }
}

- (void) hideButtomView
{
    rightItemBtnHasClick = YES;
    
    [self.buttomView setHidden:YES];
    [self.tvBackView setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-64)];
    [tv setFrame:CGRectMake(0, 0, self.tvBackView.frame.size.width, self.tvBackView.frame.size.height)];
    
    [rightItemBtn setHidden:NO];
    
    for(UIButton *btn in cellBtnArray)
    {
        [btn setHidden:YES];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if(tv)
    {
        self.tvBackView.frame = tv.frame;
    }
    
    
    [rightItemBtn setHidden:YES];
    rightItemBtnHasClick = NO;
    
    if(cellBtnArray || cellBtnArray.count != 0)
    {
        for(UIButton *btn in cellBtnArray)
        {
            [btn setHidden:NO];
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"管理收货地址"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemBtn setFrame:CGRectMake(0, 0, 25, 25)];
    [rightItemBtn setBackgroundImage:[UIImage imageNamed:@"addAddress.png"] forState:UIControlStateNormal];
    [rightItemBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItemBtn setHidden:YES];
    
    [self.tvBackView setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - 64 - 49)];
    [self.buttomView setFrame:CGRectMake(0, self.tvBackView.frame.size.height, 320, 49)];
    
    
    
    
    
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
    if(dataArray.count == 0 || !dataArray)
    {
        return 1;
    }
    return dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(dataArray.count == 0)
    {
        return 44;
    }
    else
    {
        B2CAddressData *addressData = [dataArray objectAtIndex:indexPath.row];
        NSString *address = addressData.addressName;
        CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:address WithSize:CGSizeMake(280, MAXFLOAT)];
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
    
    if(indexPath.row == dataArray.count)
    {
        DCFChenMoreCell *moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
        [moreCell noDataAnimation];
        return moreCell;
    }
    else
    {
        B2CAddressData *addressData = [dataArray objectAtIndex:indexPath.row];

        NSString *name = addressData.receiver;
        CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:name WithSize:CGSizeMake(MAXFLOAT, 30)];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size_1.width, 30)];
        [nameLabel setText:name];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.contentView addSubview:nameLabel];
        
        NSString *tel = addressData.tel;
        CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:tel WithSize:CGSizeMake(MAXFLOAT, 30)];
        UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-50-size_2.width, 5, size_2.width, 30)];
        [telLabel setTextAlignment:NSTextAlignmentRight];
        [telLabel setText:tel];
        [telLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.contentView addSubview:telLabel];
        
        NSString *province = addressData.province;
        NSString *city = addressData.city;
        NSString *area = addressData.area;
        NSString *str = [NSString stringWithFormat:@"%@%@%@",province,city,area];
        UILabel *provinceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLabel.frame.origin.y + nameLabel.frame.size.height, 270, 30)];
        [provinceLabel setText:str];
        [provinceLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.contentView addSubview:provinceLabel];
        
        
        NSString *address = addressData.addressName;
        CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:address WithSize:CGSizeMake(280, MAXFLOAT)];
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, provinceLabel.frame.origin.y + provinceLabel.frame.size.height, 270, size_3.height)];
        [addressLabel setText:address];
        [addressLabel setFont:[UIFont systemFontOfSize:13]];
        [addressLabel setNumberOfLines:0];
        [cell.contentView addSubview:addressLabel];
        
        if(rightItemBtnHasClick == NO)
        {
            UIButton *btn = [cellBtnArray objectAtIndex:indexPath.row];
            [btn setFrame:CGRectMake(280, (size_3.height + 70 - 30)/2, 30, 30)];
            [cell.contentView addSubview:btn];
        }
        else
        {
            
        }
        
        
        return cell;
        
    }
    return nil;
}

- (void) cellBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UIButton *btn = [cellBtnArray objectAtIndex:indexPath.row];
    if(btn.hidden == YES)
    {
        AddReceiveFinalViewController *final = [[AddReceiveFinalViewController alloc] initWithAddressData:[dataArray objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:final animated:YES];
        [self showButtomView];
    }
    else
    {
        
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
    // Dispose of any resources that can be recreated.
}

@end
