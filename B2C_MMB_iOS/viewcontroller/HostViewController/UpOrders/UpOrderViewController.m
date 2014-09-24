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

@interface UpOrderViewController ()
{
    UIView *buttomView;
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
    NSLog(@"提交");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    
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
        return 1;
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
        if(indexPath.row == 0)
        {
            NSString *s1 = @"江苏省宜兴市";
            NSString  *s2 = @"江苏省宜兴市官林镇远东大道";
            
            NSString *str = [NSString stringWithFormat:@"%@ \n%@",s1,s2];
            NSLog(@"%@",str);
            CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:str WithSize:CGSizeMake(260, MAXFLOAT)];
      
            return 30+size_2.height + 10;
        }
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
            

            
            if(indexPath.section == 0)
            {
             
                
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 30)];
                [iv setImage:[UIImage imageNamed:@"magnifying glass.png"]];
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 260, 30)];
                [nameLabel setText:@"张三           110110110110110110"];
                [nameLabel setTextAlignment:NSTextAlignmentLeft];
                [nameLabel setFont:[UIFont systemFontOfSize:13]];
                
                NSString *s1 = @"江苏省宜兴市";
                NSString  *s2 = @"江苏省宜兴市官林镇远东大道";
                NSString *str = [NSString stringWithFormat:@"%@ \n %@",s1,s2];
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:str WithSize:CGSizeMake(260, MAXFLOAT)];
                UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, nameLabel.frame.origin.y + nameLabel.frame.size.height, 260, size.height)];
                [addressLabel setText:str];
                [addressLabel setFont:[UIFont systemFontOfSize:13]];
                [addressLabel setNumberOfLines:0];
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35+size.height+5)];
                [view setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
                [cell.contentView addSubview:view];
                [cell.contentView addSubview:iv];
                [cell.contentView addSubview:nameLabel];
                [cell.contentView addSubview:addressLabel];
            }
            if(indexPath.section == 1)
            {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
                [view setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
                [cell.contentView addSubview:view];
                [cell.textLabel setText:@"不需要发票"];
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
                    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"配送费:快递8元" WithSize:CGSizeMake(MAXFLOAT,20)];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(320-30-size.width, 7, size.width, 30)];
                    [label setText:@"配送费:快递8元"];
                    [label setTextAlignment:NSTextAlignmentRight];
                    [label setFont:[UIFont systemFontOfSize:12]];
                    [cell.contentView addSubview:label];
                }
            }
    }
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
