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
#import "GoodsDetailTableViewCell.h"

@interface GoodsDetailViewController ()
{
    NSString *cell_two_content;
    NSString *cell_four_content;
    
    NSMutableArray *cellBtnArray;
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
    
    
    cell_two_content = @"远东电线电缆BVVB 2*1平方 国际 护套铜芯电线100米";
    
    cell_four_content = @"第一次到这里买，服务好，价格公道，童叟无欺，发货快，电线电缆已经安装好，很满意，绝对正品，赞一个";
    
    cellBtnArray = [[NSMutableArray alloc] init];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 160;
    }
    if(indexPath.row == 1)
    {
//        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:cell_two_content WithSize:CGSizeMake(320, MAXFLOAT)];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, size.height)];
//        [label setText:cell_two_content];
//        [label setFont:[UIFont systemFontOfSize:13]];
//        [label setNumberOfLines:0];
//        
//        return label.frame.size.height+10;
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height;
    }
    if(indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5)
    {
        return 44;
    }
    if(indexPath.row == 6)
    {
        return 165;

    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView setSeparatorStyle:0];
    
    if(indexPath.row == 6)
    {
        GoodsDetailTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsDetailTableViewCell" owner:self options:nil] lastObject];
        return cell;
    }
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:0];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
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
        
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:cell_two_content WithSize:CGSizeMake(300, MAXFLOAT)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, size.height)];
        [label setText:cell_two_content];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:13]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:[UIColor blackColor]];
        [cell.contentView addSubview:label];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];

    }
    if(indexPath.row == 2)
    {
        CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"价格" WithSize:CGSizeMake(MAXFLOAT, 30)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size_1.width, 30)];
        [label setText:@"价格"];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:label];
        
        CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"¥500.00－¥550.00" WithSize:CGSizeMake(MAXFLOAT, 30)];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 20, 5, size_2.width, 30)];
        [priceLabel setTextAlignment:NSTextAlignmentLeft];
        [priceLabel setText:@"¥500.00－¥550.00"];
        [priceLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:priceLabel];
        
        CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"运费5元" WithSize:CGSizeMake(MAXFLOAT, 30)];
        UILabel *tradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-size_3.width-10, 5, size_3.width, 30)];
        [tradeLabel setText:@"运费5元"];
        [tradeLabel setTextAlignment:NSTextAlignmentRight];
        [tradeLabel setTextColor:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0]];
        [tradeLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:tradeLabel];

    }
    if(indexPath.row == 3)
    {
        [cell.textLabel setText:@"颜色分类"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    }
    if(indexPath.row == 4)
    {
        UIImageView *firstIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [firstIv setImage:[UIImage imageNamed:@"magnifying glass.png"]];
        
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"远东电缆旗舰店" WithSize:CGSizeMake(MAXFLOAT,30)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, size.width, 30)];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setText:@"远东电缆旗舰店"];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:[UIColor blueColor]];
        
        UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, label.frame.size.width+40, 30)];
        [firstView addSubview:firstIv];
        [firstIv addSubview:label];
        [cell.contentView addSubview:firstView];
        
        UITapGestureRecognizer *tap_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstTap:)];
        [firstView addGestureRecognizer:tap_1];
        
        CGFloat starViewWidth = 0.0;
        UIView *starView = [[UIView alloc] initWithFrame:CGRectMake(firstView.frame.origin.x + firstView.frame.size.width + 10,12,starViewWidth, 20)];

        for(int i = 0;i < 5; i++)
        {
            UIImageView *starIv = [[UIImageView alloc] initWithFrame:CGRectMake(20*i, 0, 20, 20)];
            [starIv setImage:[UIImage imageNamed:@"star.png"]];
            if(i == 4)
            {
                starViewWidth = starIv.frame.origin.x + starIv.frame.size.width;
                
            }
            [starView addSubview:starIv];
        }
        [starView setFrame:CGRectMake(firstView.frame.origin.x + firstView.frame.size.width + 10,12,starViewWidth, 20)];
        UITapGestureRecognizer *starViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starViewTap:)];
        [starView addGestureRecognizer:starViewTap];
        [cell.contentView addSubview:starView];
        
        UIImageView *chatIv = [[UIImageView alloc] initWithFrame:CGRectMake(320-40, 7, 30, 30)];
        [chatIv setUserInteractionEnabled:YES];
        [chatIv setImage:[UIImage imageNamed:@"magnifying glass.png"]];
        
        UITapGestureRecognizer *chatTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatTap:)];
        [chatIv addGestureRecognizer:chatTap];
        [cell.contentView addSubview:chatIv];
    }
    if(indexPath.row == 5)
    {
        for(int i = 0;i < 2;i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(10+100*i, 0, 100, 44)];
            if(i == 0)
            {
                [btn setTitle:@"商品详情" forState:UIControlStateNormal];
            }
            else if (i == 1)
            {
                [btn setTitle:@"商品评价(3)" forState:UIControlStateNormal];
            }
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor blueColor] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
            
            [btn setTag:i];
            
            [btn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [cellBtnArray addObject:btn];
            
            [cell.contentView addSubview:btn];
            
        }
    }

    return cell;
}

- (void) firstTap:(UITapGestureRecognizer *) sender
{
    NSLog(@"firstTap");
}

- (void) starViewTap:(UITapGestureRecognizer *) sender
{
    NSLog(@"starViewTap");
}

- (void) chatTap:(UITapGestureRecognizer *) sender
{
    NSLog(@"chatTap");
}


- (void) cellBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    NSLog(@"tag = %d",[sender tag]);
    
    for(UIButton *btn in cellBtnArray)
    {
        if(btn.tag == [sender tag])
        {
            
        }
        else
        {
            [btn setSelected:NO];
        }
    }
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
