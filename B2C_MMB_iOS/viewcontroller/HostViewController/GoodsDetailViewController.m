//
//  GoodsDetailViewController.m
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-9.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "DCFTopLabel.h"
#import "DCFStringUtil.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "AliViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"

@interface GoodsDetailViewController ()
{
    NSString *cell_two_content;
    NSString *cell_four_content;
}
@end

@implementation GoodsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) btnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    int tag = [sender tag];
    if(tag == 100)
    {
        NSLog(@"购买");
        
        AliViewController *ali = [[AliViewController alloc] initWithNibName:@"AliViewController" bundle:nil];
        [self.navigationController pushViewController:ali animated:YES];
    }
    else
    {
        NSLog(@"加入购物车");
        
        NSURL *urlStr = [NSURL URLWithString:@"com.easemob.enterprise.demo.ui"];
        
        if ([[UIApplication sharedApplication] canOpenURL:urlStr])
        {    NSLog(@"can go to test");
            [[UIApplication sharedApplication] openURL:urlStr];
        }
        else
        {    NSLog(@"can not go to test！！！！！");
        }
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"com.easemob.enterprise.demo.ui"]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:227.0/255.0 blue:235.0/255.0 alpha:1.0]];
    
//    [self.view setBackgroundColor:[UIColor redColor]];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装线商品详情"];
    self.navigationItem.titleView = top;
    
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-50-64, 320, 50)];
    [buttomView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:buttomView];
    
    for(int i=0;i<2;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(210*i + 5, 5, 100, 40)];
        if(i == 0)
        {
            [btn setTitle:@"立即购买" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor blueColor].CGColor;
            btn.layer.borderWidth = 1.0f;
            btn.layer.cornerRadius = 5;
        }
        if(i == 1)
        {
            [btn setTitle:@"加入购物车" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor redColor].CGColor;
            btn.layer.borderWidth = 1.0f;
            btn.layer.cornerRadius = 5;
        }
        [btn setTag:i+100];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttomView addSubview:btn];
    }
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight - 50 - 64) style:0];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:227.0/255.0 blue:235.0/255.0 alpha:1.0]];
    [self.view addSubview:tv];
    
//    NSLog(@"%f %f %f",ScreenHeight,self.view.window.frame.size.height,[[UIScreen mainScreen] bounds].size.height);
    
    cell_two_content = @"远东电线电缆BVVB 2*1平方 国际 护套铜芯电线100米";
    
    cell_four_content = @"第一次到这里买，服务好，价格公道，童叟无欺，发货快，电线电缆已经安装好，很满意，绝对正品，赞一个";
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 160;
    }
    if(indexPath.row == 1)
    {
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:cell_two_content WithSize:CGSizeMake(320, MAXFLOAT)];
        NSLog(@"height=%f",size.height);
        return size.height+14;
    }
    if(indexPath.row == 2)
    {
        return 100;
    }
    if(indexPath.row == 3)
    {
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:11] WithText:cell_four_content WithSize:CGSizeMake(320, MAXFLOAT)];
        return size.height + 50;
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setSeparatorStyle:0];
    
    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:0];
    }
    if(indexPath.row == 0)
    {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(85, 5, 150, 150)];
        [iv setImage:[UIImage imageNamed:@"cabel.png"]];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:227.0/255.0 blue:235.0/255.0 alpha:1.0]];
        [cell.contentView addSubview:iv];
    }
    if(indexPath.row == 1)
    {
        
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:cell_two_content WithSize:CGSizeMake(320, MAXFLOAT)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, size.height)];
        [label setText:cell_two_content];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:[UIColor blackColor]];
        [cell.contentView addSubview:label];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        for(int i=0;i<2;i++)
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (cell.contentView.frame.size.height-1)*i, 320, 2)];
            [lineView setBackgroundColor:[UIColor colorWithRed:110.0/255.0 green:138.0/255.0 blue:154.0/255.0 alpha:1.0]];
            [cell.contentView addSubview:lineView];
        }
        
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, cell.contentView.frame.size.height - 22, 80, 20)];
        [moneyLabel setText:@"¥500.00"];
        [moneyLabel setTextAlignment:NSTextAlignmentCenter];
        [moneyLabel setTextColor:[UIColor redColor]];
        [cell.contentView addSubview:moneyLabel];
    }
    if(indexPath.row == 2)
    {
        for(int i=0;i<8;i++)
        {
            UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellBtn setTag:i];
            cellBtn.titleLabel.numberOfLines = 0;
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:227.0/255.0 blue:235.0/255.0 alpha:1.0]];

            [cellBtn setTitleColor:[UIColor colorWithRed:110.0/255.0 green:138.0/255.0 blue:154.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [cellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [cellBtn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:229.0/255.0 green:227.0/255.0 blue:235.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [cellBtn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor blueColor] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
            
            [cellBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            switch (i) {
                case 0:
                {
                    [cellBtn setFrame:CGRectMake(0, 0, 160, 30)];
                    [cellBtn setTitle:@"远东电缆旗舰店" forState:UIControlStateNormal];

                    break;
                }
                case 1:
                {
                    [cellBtn setFrame:CGRectMake(160, 0, 160, 30)];
                    [cellBtn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];

                    break;
                }
                case 2:
                {
                    [cellBtn setFrame:CGRectMake(0, 30, 80, 40)];
                    NSString *s = [NSString stringWithFormat:@"描述相符 \n    5.0"];
                    [cellBtn setTitle:s forState:UIControlStateNormal];

                    break;
                }
                case 3:
                {
                    [cellBtn setFrame:CGRectMake(80, 30, 80, 40)];
                    NSString *s = [NSString stringWithFormat:@"服务态度 \n    5.0"];
                    [cellBtn setTitle:s forState:UIControlStateNormal];

                    break;
                }
                case 4:
                {
                    [cellBtn setFrame:CGRectMake(160, 30, 80, 40)];
                    NSString *s = [NSString stringWithFormat:@"发货速度 \n    5.0"];
                    [cellBtn setTitle:s forState:UIControlStateNormal];
                    break;
                }
                case 5:
                {
                    [cellBtn setFrame:CGRectMake(240, 30, 80, 40)];
                    NSString *s = [NSString stringWithFormat:@"产品质量 \n    5.0"];
                    [cellBtn setTitle:s forState:UIControlStateNormal];
                    break;
                }
                case 6:
                {
                    [cellBtn setFrame:CGRectMake(0, 70, 80, 30)];
                    [cellBtn setTitle:@"商品详情" forState:UIControlStateNormal];
                    break;
                }
                case 7:
                {
                    [cellBtn setFrame:CGRectMake(80, 70, 100, 30)];
                    [cellBtn setTitle:@"商品评价(3)" forState:UIControlStateNormal];
                    break;
                }
                default:
                    break;
            }
            [cell.contentView addSubview:cellBtn];
        }
    }
    if(indexPath.row == 3)
    {
        CGSize size1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:11] WithText:@"米七(匿名)" WithSize:CGSizeMake(MAXFLOAT, 20)];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, size1.width, 20)];
        [nameLabel setText:@"米七(匿名)"];
        [nameLabel setFont:[UIFont systemFontOfSize:11]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setBackgroundColor:[UIColor purpleColor]];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:227.0/255.0 blue:235.0/255.0 alpha:1.0]];

        CGSize size2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:11] WithText:@"评价日期:5.23" WithSize:CGSizeMake(MAXFLOAT, 20)];
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake((320-size2.width)/2, nameLabel.frame.origin.y, size2.width, 20)];
        [dateLabel setFont:[UIFont systemFontOfSize:11]];
        [dateLabel setTextAlignment:NSTextAlignmentLeft];
        [dateLabel setText:@"评价日期:5.23"];
        [dateLabel setBackgroundColor:[UIColor yellowColor]];
        [cell.contentView addSubview:dateLabel];
        
        
        CGSize size3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:11] WithText:@"颜色分类:红色" WithSize:CGSizeMake(MAXFLOAT,20)];
        UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-size3.width-5, dateLabel.frame.origin.y, size3.width, 20)];
        [colorLabel setFont:[UIFont systemFontOfSize:11]];
        [colorLabel setText:@"颜色分类:红色"];
        [colorLabel setTextAlignment:NSTextAlignmentLeft];
        [colorLabel setBackgroundColor:[UIColor redColor]];
        [cell.contentView addSubview:colorLabel];
        
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:11] WithText:cell_four_content WithSize:CGSizeMake(320, MAXFLOAT)];
        UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(5, dateLabel.frame.origin.y + dateLabel.frame.size.height + 5, 300, size.height)];
        [contentlabel setBackgroundColor:[UIColor whiteColor]];
        [contentlabel setTextAlignment:NSTextAlignmentLeft];
        [contentlabel setText:cell_four_content];
        [contentlabel setFont:[UIFont systemFontOfSize:11]];
        [contentlabel setNumberOfLines:0];
        [cell.contentView addSubview:contentlabel];
    }
    return cell;
}

- (void) cellBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    NSLog(@"tag = %d",[sender tag]);
}


- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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
