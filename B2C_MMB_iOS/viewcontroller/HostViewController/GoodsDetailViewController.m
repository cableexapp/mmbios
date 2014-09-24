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
    
    BOOL showCell;
    
    NSMutableArray *chooseColorBtnArray;
    NSMutableArray *chooseCountBtnArray;
    
    UIView *chooseColorAndCountView; //选择颜色和数量的试图
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
    
    showCell = YES;
    
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
    
    chooseColorBtnArray = [[NSMutableArray alloc] init];
    
    chooseCountBtnArray = [[NSMutableArray alloc] init];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 160;
    }
    if(indexPath.row == 1)
    {
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:cell_two_content WithSize:CGSizeMake(300, MAXFLOAT)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, size.height)];
        [label setText:cell_two_content];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:13]];
        return label.frame.size.height + 10;
    }
    if(indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 )
    {
        return 44;
    }
    if(indexPath.row == 6)
    {
        if(showCell == YES)
        {
            return 169;
        }
        else
        {
            return 0;
        }

    }
   if (indexPath.row > 6)
    {
        if(showCell == YES)
        {
            return 0;
        }
        else
        {
            NSString *s4 = @"第一次来这里，价格公道，童叟无欺，性价比高，物流很快很给力，绝对正品，赞一个，以后还会来";
            CGSize size_4 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s4 WithSize:CGSizeMake(320, MAXFLOAT)];
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, size_4.height)];
            [contentLabel setText:s4];
            [contentLabel setFont:[UIFont systemFontOfSize:12]];
            [contentLabel setNumberOfLines:0];
            return contentLabel.frame.size.height+30;
        }

    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView setSeparatorStyle:0];
    

    
    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:229.0/255.0 blue:240.0/255.0 alpha:1.0]];
        [cell setSelectionStyle:0];
        
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
                [btn setFrame:CGRectMake(10+100*i, 5, 100, 34)];
                if(i == 0)
                {
                    if(showCell == YES)
                    {
                        [btn setSelected:YES];
                    }
                    else
                    {
                        [btn setSelected:NO];
                    }
                    [btn setTitle:@"商品详情" forState:UIControlStateNormal];
                }
                else if (i == 1)
                {
                    if(showCell == YES)
                    {
                        [btn setSelected:NO];
                    }
                    else
                    {
                        [btn setSelected:YES];
                    }
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
        if(indexPath.row == 6)
        {
            
            if(showCell == YES)
            {
                GoodsDetailTableViewCell *customCell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsDetailTableViewCell" owner:self options:nil] lastObject];
                return customCell;
                
            }
            else
            {
                
            }
            
            
        }
        if(indexPath.row > 6)
        {
            if(showCell == YES)
            {
            }
            else
            {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
                [view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
                [cell.contentView addSubview:view];
                
                NSString *s1 = @"米**七(匿名)";
                CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s1 WithSize:CGSizeMake(MAXFLOAT, 30)];
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, size_1.width, 30)];
                [nameLabel setText:s1];
                [nameLabel setTextAlignment:NSTextAlignmentLeft];
                [nameLabel setFont:[UIFont systemFontOfSize:12]];
                [nameLabel setTextColor:[UIColor colorWithRed:147.0/255.0 green:140.0/255.0 blue:154.0/255.0 alpha:1.0]];
                [view addSubview:nameLabel];
                
                NSString *s2 = @"评价日期:5.23";
                CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s2 WithSize:CGSizeMake(MAXFLOAT, 30)];
                UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 20, 0, size_2.width, 30)];
                [dateLabel setTextAlignment:NSTextAlignmentCenter];
                [dateLabel setText:s2];
                [dateLabel setFont:[UIFont systemFontOfSize:12]];
                [view addSubview:dateLabel];
                
                NSString *s3 = @"颜色分类:红色";
                CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s3 WithSize:CGSizeMake(MAXFLOAT, 30)];
                UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-10-size_3.width, 0, size_3.width, 30)];
                [colorLabel setText:s3];
                [colorLabel setTextAlignment:NSTextAlignmentLeft];
                [colorLabel setFont:[UIFont systemFontOfSize:12]];
                [view addSubview:colorLabel];
                
                NSString *s4 = @"第一次来这里，价格公道，童叟无欺，性价比高，物流很快很给力，绝对正品，赞一个，以后还会来";
                CGSize size_4 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:s4 WithSize:CGSizeMake(320, MAXFLOAT)];
                UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, size_4.height)];
                [contentLabel setTextAlignment:NSTextAlignmentLeft];
                [contentLabel setText:s4];
                [contentLabel setFont:[UIFont systemFontOfSize:12]];
                [contentLabel setNumberOfLines:0];
                [contentLabel setBackgroundColor:[UIColor whiteColor]];
                [cell.contentView addSubview:contentLabel];
                
                
            }
        }
    }
//    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
//        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
//    }
 

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
    
    if(btn.tag == 0)
    {
        if(btn.selected == YES)
        {
            showCell = YES;
            
        }
        else
        {
            showCell = NO;
        }
    }
    if(btn.tag == 1)
    {
        if(btn.selected == YES)
        {
            showCell = NO;
        }
        else
        {
            showCell = YES;
        }
    }

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
    [tv reloadData];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3)
    {
//        [self.view.window setBackgroundColor:[UIColor blackColor]];
//        [self.view.window setAlpha:0.4];
        [self.view.window addSubview:[self loadChooseColorAndCount]];
//        [self loadChooseColorAndCount];
    }
}

#pragma mark - 加载选择颜色和数量界面
- (UIView *) loadChooseColorAndCount
{
    chooseColorAndCountView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-220, 320, 290)];
    [chooseColorAndCountView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    [iv setImage:[UIImage imageNamed:@"cabel.png"]];
    [chooseColorAndCountView addSubview:iv];
    
    for(int i=0;i<3;i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x +iv.frame.size.width + 10, 5 + 25*i, 160, 20)];
        [label setFont:[UIFont systemFontOfSize:12]];
        switch (i) {
            case 0:
            {
                [label setText:@"已选颜色:红色"];
                break;
            }
            case 1:
            {
                NSString *s = @"价格:¥500.00";
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:s];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, s.length-3)];
                [label setAttributedText:str];
                break;
            }
            case 2:
            {
                [label setText:@"库存200件"];
                [label setTextColor:[UIColor lightGrayColor]];
                break;
            }
            default:
                break;
        }
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setBackgroundColor:[UIColor clearColor]];
        [chooseColorAndCountView addSubview:label];
    }
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(320-10-50, 30, 50, 30)];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeBtn setTitle:@"关闭x" forState:UIControlStateNormal];
    [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [chooseColorAndCountView addSubview:closeBtn];
    
    UILabel *colorKindLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, iv.frame.origin.y+iv.frame.size.height+20, 200, 20)];
    [colorKindLabel setText:@"颜色分类"];
    [colorKindLabel setFont:[UIFont systemFontOfSize:12]];
    [colorKindLabel setBackgroundColor:[UIColor clearColor]];
    [colorKindLabel setTextAlignment:NSTextAlignmentLeft];
    [chooseColorAndCountView addSubview:colorKindLabel];
    
    for(int i = 0;i < 5;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i == 4)
        {
            [btn setFrame:CGRectMake(10, colorKindLabel.frame.origin.y + colorKindLabel.frame.size.height + 50, 60, 30)];
            [btn setTitle:@"黄绿" forState:UIControlStateNormal];
        }
        else
        {
            [btn setFrame:CGRectMake(10+80*i, colorKindLabel.frame.origin.y + colorKindLabel.frame.size.height + 10, 60, 30)];
            if(i == 0)
            {
                [btn setTitle:@"红色" forState:UIControlStateNormal];
            }
            if(i == 1)
            {
                [btn setTitle:@"黄色" forState:UIControlStateNormal];
            }
            if(i == 2)
            {
                [btn setTitle:@"绿色" forState:UIControlStateNormal];
            }
            if(i == 3)
            {
                [btn setTitle:@"蓝色" forState:UIControlStateNormal];
            }
        }
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor blueColor] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        
        btn.layer.borderColor = [UIColor blueColor].CGColor;
        btn.layer.borderWidth = 0.5f;
        btn.layer.masksToBounds = YES;
        
        [btn setTag:100+i];
        
        [btn addTarget:self action:@selector(chooseColorClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [chooseColorBtnArray addObject:btn];
        
        [chooseColorAndCountView addSubview:btn];
        
    }
    
    
    UILabel *chooseCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 80, 20)];
    [chooseCountLabel setText:@"购买数量"];
    [chooseCountLabel setTextAlignment:NSTextAlignmentLeft];
    [chooseCountLabel setBackgroundColor:[UIColor clearColor]];
    [chooseCountLabel setFont:[UIFont systemFontOfSize:12]];
    [chooseColorAndCountView addSubview:chooseCountLabel];
    
    for(int i=0;i<3;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i == 0)
        {
            [btn setFrame:CGRectMake(150, chooseCountLabel.frame.origin.y, 20, 20)];
            [btn setTitle:@"-" forState:UIControlStateNormal];
        }
        if(i == 1)
        {
            [btn setFrame:CGRectMake(180, chooseCountLabel.frame.origin.y, 60, 20)];
            [btn setTitle:@"0" forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:10]];
            [btn setUserInteractionEnabled:NO];
        }
        if(i == 2)
        {
            [btn setFrame:CGRectMake(250, chooseCountLabel.frame.origin.y, 20, 20)];
            [btn setTitle:@"+" forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.borderWidth = 0.5f;
        btn.layer.borderColor = [UIColor blackColor].CGColor;
        [btn setTag:10+i];
        [btn addTarget:self action:@selector(chooseCountClick:) forControlEvents:UIControlEventTouchUpInside];
        [chooseColorAndCountView addSubview:btn];
        [chooseCountBtnArray addObject:btn];
    }
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setFrame:CGRectMake((320-120)/2, 240, 120, 40)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.borderColor = [UIColor blueColor].CGColor;
    sureBtn.layer.borderWidth = 1.0f;
    sureBtn.layer.cornerRadius = 5;
    [chooseColorAndCountView addSubview:sureBtn];
    
    return chooseColorAndCountView;
}

- (void) closeBtnClick:(UIButton *) sender
{
    NSLog(@"关闭");
    if(chooseColorAndCountView)
    {
        [chooseColorAndCountView removeFromSuperview];
        chooseColorAndCountView = nil;
    }
}

- (void) chooseColorClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    
    int tag = btn.tag;
    
    for(UIButton *b in chooseColorBtnArray)
    {
        if(b.tag == tag)
        {
            
        }
        else
        {
            [b setSelected:NO];
        }
    }
}

- (void) chooseCountClick:(UIButton *) sender
{
    NSLog(@"chooseCountClick");
    
    int tag = [sender tag];
    
    UIButton *middleBtn = (UIButton *)[chooseCountBtnArray objectAtIndex:1];
    NSString *title = middleBtn.titleLabel.text;
//    UIButton *leftBtn = (UIButton *)[chooseCountBtnArray objectAtIndex:0];
//    UIButton *rightBtn = (UIButton *)[chooseCountBtnArray lastObject];
    
    if(tag == 10)
    {
        if([title isEqualToString:@"0"])
        {
            [middleBtn setTitle:@"0" forState:UIControlStateNormal];
        }
        else
        {
            NSString *s = [NSString stringWithFormat:@"%d",[title intValue] - 1];
            [middleBtn setTitle:s forState:UIControlStateNormal];
        }
    }
    else if (tag == 12)
    {
        NSString *s = [NSString stringWithFormat:@"%d",[title intValue] + 1];
        [middleBtn setTitle:s forState:UIControlStateNormal];
    }
}

- (void) sureBtnClick:(UIButton *) sender
{
    NSLog(@"sureBtnClick");
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
