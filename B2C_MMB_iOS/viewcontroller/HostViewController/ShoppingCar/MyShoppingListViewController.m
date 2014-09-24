//
//  MyShoppingListViewController.m
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-1.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import "MyShoppingListViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "MCDefine.h"
#import "DCFTopLabel.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"
#import "DCFChenMoreCell.h"
//#import "LoginViewController.h"
#import "LoginNaviViewController.h"
#import "UpOrderViewController.h"

@interface MyShoppingListViewController ()
{
    DCFChenMoreCell *moreCell;
    
    NSMutableArray *introduceDataArray;
    
    NSMutableArray *numLabelArray;
    
    NSMutableArray *numberArray;
    
    
    
    NSMutableArray *selectBtnArray;  //选中的按钮数组
    
    NSMutableArray *cellBtnArray;   //cell前面选择的按钮
    
    NSMutableArray *cellImageViewArray;
    
    UIView *buttomView;
    
    
    NSMutableArray *headBtnArray;
    NSMutableArray *headLabelArray;
    
    UIButton *buttomBtn;
    
    UIButton *rightBtn;
    
    UIStoryboard *sb;
}
@end

@implementation MyShoppingListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) buttomBtnClick:(UIButton *) sender
{
    NSLog(@"test");
    UIButton *btn = (UIButton *) sender;
    UIButton *headBtn = (UIButton *)[headBtnArray objectAtIndex:0];
    btn.selected = !btn.selected;
    if(btn.selected == YES)
    {
        for(UIButton *b in cellBtnArray)
        {
            [b setSelected:YES];
        }
        if(headBtn)
        {
            [headBtn setSelected:YES];
        }
    }
    else
    {
        for(UIButton *b in cellBtnArray)
        {
            [b setSelected:NO];
        }
        if(headBtn)
        {
            [headBtn setSelected:NO];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    //    [moreCell startAnimation];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装馆购物车"];
    self.navigationItem.titleView = top;
    
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateHighlighted];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(0, 13, 34, 25)];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 114, 320, 54)];
    [buttomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:buttomView];
    
    UIView *buttomTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [buttomTopView setBackgroundColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
    [buttomView addSubview:buttomTopView];
    
    buttomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttomBtn setFrame:CGRectMake(5, 13, 30, 30)];
    [buttomBtn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
    [buttomBtn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
    [buttomBtn setSelected:NO];
    [buttomBtn addTarget:self action:@selector(buttomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:buttomBtn];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 13, 50, 30)];
    [countLabel setTextColor:[UIColor blackColor]];
    [countLabel setTextAlignment:NSTextAlignmentLeft];
    [countLabel setText:@"合计 ¥"];
    [buttomView addSubview:countLabel];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(countLabel.frame.origin.x + countLabel.frame.size.width+5, 13, 100, 30)];
    [moneyLabel setTextColor:[UIColor redColor]];
    NSString *price = @"1000.1274566";
    [moneyLabel setText:[DCFCustomExtra notRounding:[price floatValue] afterPoint:2]];
    [moneyLabel setTextAlignment:NSTextAlignmentLeft];
    [buttomView addSubview:moneyLabel];
    
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn setFrame:CGRectMake(moneyLabel.frame.origin.x + moneyLabel.frame.size.width + 10, 10, 100, 34)];
    payBtn.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
    payBtn.layer.borderWidth = 1.0f;
    payBtn.layer.cornerRadius = 2.0f;
    payBtn.layer.masksToBounds = YES;
    [payBtn setTitle:@"结算(3)" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:payBtn];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight - 54-54)];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [self.view addSubview:tv];
    
    headLabelArray = [[NSMutableArray alloc] initWithObjects:@"远东旗舰店", nil];
    
    introduceDataArray = [[NSMutableArray alloc] initWithObjects:
                          @"cell 1 荣宜电缆BVR 6平方 国际铜芯电缆 单芯多股铜线 95米,荣宜电缆BVR 6平方",
                          @"cell 2 荣宜电缆BVR 6平方 国际铜芯电缆 单芯多股铜线 95米,国际铜芯电缆 单芯多股铜线",
                          @"cell 3 荣宜电缆BVR 6平方 国际铜芯电缆 单芯多股铜线 95米",
                          @"cell 4 荣宜电缆BVR 6平方 国际铜芯电缆 单芯多股铜线 95米",
                          @"cell 5 荣宜电缆BVR 6平方 国际铜芯电缆 单芯多股铜线 95米",
                          @"cell 6 荣宜电缆BVR 6平方 国际铜芯电缆 单芯多股铜线 95米荣宜电缆BVR 6平方 国际铜芯电缆荣宜电缆BVR 6平方 国际铜芯电缆",
                          @"cell 7 荣宜电缆BVR 6平方 国际铜芯电缆 单芯多股铜线 95米,荣宜电缆BVR 6平方 国际铜芯电缆 单芯多股铜线 95米荣宜电缆BVR 6平方 国际铜芯电缆 ",nil];
    
    numLabelArray = [[NSMutableArray alloc] init];
    
    numberArray = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    
    
    
    selectBtnArray = [[NSMutableArray alloc] init];
    
    cellBtnArray = [[NSMutableArray alloc] init];
    cellImageViewArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < introduceDataArray.count; i++)
    {
        UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [cellBtn setFrame:CGRectMake(5, 45, 30, 30)];
        
        
        [cellBtn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
        [cellBtn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
        [cellBtn setSelected:NO];
        [cellBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cellBtn setTag:i];
        
        
        [selectBtnArray addObject:cellBtn];
        
        [cellBtnArray addObject:cellBtn];
        
        UIImageView *cellIv = [[UIImageView alloc] initWithFrame:CGRectMake(cellBtn.frame.origin.x + cellBtn.frame.size.width + 5, 5, 100, 100)];
        [cellIv setImage:[UIImage imageNamed:@"cabel.png"]];
        [cellImageViewArray addObject:cellIv];
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [numLabelArray addObject:numLabel];
        
    }
    
    
    headBtnArray = [[NSMutableArray alloc] init];
    for(int i=0;i<1;i++)
    {
        UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [headBtn setFrame:CGRectMake(5, 5, 30, 30)];
        
        [headBtn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
        [headBtn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
        [headBtn setSelected:NO];
        [headBtn setTag:i];
        [headBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headBtnArray addObject:headBtn];
    }
    
    [tv reloadData];
    
    
}


- (void) headBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    NSLog(@"btn_tag = %d",btn.tag);
    btn.selected = !btn.selected;
    if(btn.selected == YES)
    {
        for(UIButton *b in cellBtnArray)
        {
            [b setSelected:YES];
        }
        if(buttomBtn)
        {
            [buttomBtn setSelected:YES];
        }
    }
    else
    {
        for(UIButton *b in cellBtnArray)
        {
            [b setSelected:NO];
        }
        if(buttomBtn)
        {
            [buttomBtn setSelected:NO];
        }
    }
    
}

- (void) payBtnClick:(UIButton *) sender
{
    NSLog(@"结算");
    
    [self setHidesBottomBarWhenPushed:YES];
    UpOrderViewController *order = [[UpOrderViewController alloc] init];
    [self.navigationController pushViewController:order animated:YES];
//    [self setHidesBottomBarWhenPushed:NO];
}


- (NSArray*)getSortArrForMainApp:(NSArray*)arrSrc {
    NSArray* arrDes = [arrSrc sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        //change your code
        NSString *value1 = obj1;
        NSString *value2 = obj2;
        return value1.intValue < value2.intValue ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    return arrDes;
}



NSComparator cmptr = ^(id obj1, id obj2){
    if ([obj1 integerValue] > [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if ([obj1 integerValue] < [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
};


- (NSMutableArray *) sort:(NSMutableArray *) arr
{
    for(int i=0;i<arr.count;i++)
    {
        for(int j=0;j<arr.count-1-i;j++)
        {
            if([arr[j+1] intValue] >= [arr[j] intValue])
            {
                int temp = [arr[j] intValue];
                arr[j] = arr[j+1];
                arr[j+1] = [NSNumber numberWithInt:temp];
            }
        }
    }
    return arr;
}

- (void) rightBtnClick:(id) sender
{
    for(int i=cellBtnArray.count-1; i >= 0; i--)
    {
        UIButton *bb = [cellBtnArray objectAtIndex:i];
        BOOL selected = bb.selected;
        if(selected == YES)
        {
            if(introduceDataArray.count != 0)
            {
                [introduceDataArray removeObjectAtIndex:i];
            }
            if(cellImageViewArray.count != 0)
            {
                [cellImageViewArray removeObjectAtIndex:i];
            }
            if(numberArray.count != 0)
            {
                [numberArray removeObjectAtIndex:i];
            }
            if(numLabelArray.count != 0)
            {
                [numLabelArray removeObjectAtIndex:i];
            }
            if(cellBtnArray.count != 0)
            {
                [cellBtnArray removeObjectAtIndex:i];
            }
        }
        [tv reloadData];
        
    }
    if(cellBtnArray && cellBtnArray.count == 0)
    {
        if(buttomBtn)
        {
            [buttomBtn setSelected:NO];
        }
        if(rightBtn)
        {
            [rightBtn setHidden:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(introduceDataArray && introduceDataArray.count == 0)
    {
        return 0;
    }
    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(introduceDataArray && introduceDataArray.count != 0)
    {
        NSString *introduce = (NSString *)[introduceDataArray objectAtIndex:indexPath.row];
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:introduce WithSize:CGSizeMake(160, MAXFLOAT)];
        if(size.height + 50 <= 100)
        {
            return 110;
        }
        else
        {
            return size.height + 50;
        }
    }
    return ScreenHeight - 34;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!headLabelArray || headLabelArray.count == 0)
    {
        return 1;
    }
    return headLabelArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!introduceDataArray || introduceDataArray.count == 0)
    {
        return 1;
    }
    return introduceDataArray.count;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    [view addSubview:[headBtnArray objectAtIndex:section]];
    
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
    [sectionLabel setText:[headLabelArray objectAtIndex:section]];
    [sectionLabel setTextAlignment:NSTextAlignmentLeft];
    [sectionLabel setTextColor:[UIColor blackColor]];
    [sectionLabel setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:sectionLabel];
    
    return view;
}

- (void) logBtnClick:(UIButton *) sender
{
    NSLog(@"登陆");
    
    
    LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
    [self presentViewController:loginNavi animated:YES completion:nil];
    //    LoginViewController *logIn = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
    //
    //    [self.navigationController presentViewController:logIn animated:YES completion:nil];
}


- (void) buyBtnClick:(UIButton *) sender
{
    NSLog(@"去购物");
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == introduceDataArray.count)
    {
        static NSString *moreCellId = @"moreCell";
        UITableViewCell *noCell = [tableView cellForRowAtIndexPath:indexPath];
        if(!noCell)
        {
            noCell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:moreCellId];
            [noCell.contentView setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 60)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
        view.layer.borderWidth = 1.0f;
        view.layer.masksToBounds = YES;
        [noCell.contentView addSubview:view];
        
        UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [logBtn setTitle:@"登陆" forState:UIControlStateNormal];
        [logBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        logBtn.layer.borderWidth = 1.0F;
        logBtn.layer.borderColor = [UIColor blueColor].CGColor;
        logBtn.layer.cornerRadius = 5;
        [logBtn setFrame:CGRectMake(10, 10, 70, 40)];
        [logBtn addTarget:self action:@selector(logBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:logBtn];
        
        UILabel *label_1 = [[UILabel alloc] initWithFrame:CGRectMake(logBtn.frame.origin.x + logBtn.frame.size.width + 15, logBtn.frame.origin.y, 200, 40)];
        [label_1 setBackgroundColor:[UIColor clearColor]];
        [label_1 setTextAlignment:NSTextAlignmentLeft];
        [label_1 setFont:[UIFont systemFontOfSize:12]];
        [label_1 setTextColor:[UIColor blackColor]];
        [label_1 setNumberOfLines:0];
        [label_1 setText:@"登陆后可以同步电脑和手机端的商品,并保存在账户中"];
        [view addSubview:label_1];
        
        
        NSString *string = @"您的购物车中暂时没有商品,现在去浏览选购商品~";
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:string WithSize:CGSizeMake(200, MAXFLOAT)];
        UILabel *label_2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 150, 200, size.height)];
        [label_2 setBackgroundColor:[UIColor clearColor]];
        [label_2 setTextAlignment:NSTextAlignmentLeft];
        [label_2 setFont:[UIFont systemFontOfSize:15]];
        [label_2 setTextColor:[UIColor blackColor]];
        [label_2 setNumberOfLines:0];
        [label_2 setText:string];
        [noCell.contentView addSubview:label_2];
        
        
        UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [buyBtn setFrame:CGRectMake(100, label_2.frame.origin.y + label_2.frame.size.height + 50, 120, 40)];
        [buyBtn setTitle:@"选购商品" forState:UIControlStateNormal];
        buyBtn.layer.borderColor = [UIColor blueColor].CGColor;
        buyBtn.layer.borderWidth = 1.0f;
        buyBtn.layer.cornerRadius = 5.0f;
        [buyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [noCell.contentView addSubview:buyBtn];
        
        return noCell;
        //        moreCell = (DCFChenMoreCell *)[tableView dequeueReusableCellWithIdentifier:moreCellId];
        //        if(moreCell == nil)
        //        {
        //            moreCell = [[DCFChenMoreCell alloc] init];
        //        }
        //        [moreCell noClasses];
        //        return moreCell;
    }
    //    else
    //    {
    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        [cell setSelectionStyle:0];
        
        
        
    }
    
    
    if(introduceDataArray.count != 0)
    {
        
        UIButton *cellBtn = (UIButton *)[cellBtnArray objectAtIndex:indexPath.row];
        [cell.contentView addSubview:cellBtn];
        
        UIImageView *cellIv = (UIImageView *)[cellImageViewArray objectAtIndex:indexPath.row];
        [cell.contentView addSubview:cellIv];
        
        NSString *introduce = (NSString *)[introduceDataArray objectAtIndex:indexPath.row];
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:introduce WithSize:CGSizeMake(160, MAXFLOAT)];
        UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellIv.frame.origin.x + cellIv.frame.size.width + 5, 5, 160, size.height)];
        [introduceLabel setTextAlignment:NSTextAlignmentLeft];
        [introduceLabel setTextColor:[UIColor blackColor]];
        [introduceLabel setNumberOfLines:0];
        [introduceLabel setFont:[UIFont systemFontOfSize:12]];
        [introduceLabel setText:introduce];
        [cell.contentView addSubview:introduceLabel];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(introduceLabel.frame.origin.x, introduceLabel.frame.origin.y + introduceLabel.frame.size.height + 10, 30, 20)];
        [countLabel setText:@"数量:"];
        [countLabel setTextAlignment:NSTextAlignmentLeft];
        [countLabel setTextColor:[UIColor blackColor]];
        [countLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:countLabel];
        
        float x = countLabel.frame.origin.x + countLabel.frame.size.width + 10;
        float y = countLabel.frame.origin.y;
        for(int i = 0; i< 2; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            switch (i)
            {
                case 0:
                {
                    [btn setFrame:CGRectMake(x,y,30, 30)];
                    [btn setTitle:@"-" forState:UIControlStateNormal];
                    [btn setTag:indexPath.row*2];
                    break;
                }
                    
                case 1:
                {
                    [btn setFrame:CGRectMake(x+90, y, 30, 30)];
                    [btn setTitle:@"+" forState:UIControlStateNormal];
                    [btn setTag:(2*indexPath.row + i)];
                    break;
                }
                default:
                    break;
            }
            btn.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
            btn.layer.borderWidth = 1.0f;
            btn.layer.masksToBounds = YES;
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.contentView addSubview:btn];
        }
        UILabel *numLabel = (UILabel *)[numLabelArray objectAtIndex:indexPath.row];
        [numLabel setFrame:CGRectMake(x+35, y, 50, 30)];
        [numLabel setText:[numberArray objectAtIndex:indexPath.row]];
        [numLabel setTextAlignment:NSTextAlignmentCenter];
        [numLabel setTextColor:[UIColor blackColor]];
        numLabel.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
        numLabel.layer.borderWidth = 1.0f;
        numLabel.layer.masksToBounds = YES;
        [numLabel setBackgroundColor:[UIColor whiteColor]];
        
        [cell.contentView addSubview:numLabel];
        
    }
    
    
    
    return cell;
    //    }
    return nil;
}

- (void) btnClick:(UIButton *) sender
{
    int tag = [sender tag];
    int btnRow = 0;
    
    
    UILabel *label = nil;
    if(tag % 2 == 0)
    {
        
        btnRow = (tag+1) / 2;
        NSString *num = (NSString *)[numberArray objectAtIndex:btnRow];
        
        label = (UILabel *)[numLabelArray objectAtIndex:btnRow];
        
        if([num intValue] <= 0)
        {
            //            [label setText:@"0"];
        }
        else
        {
            NSString *s2 = [NSString stringWithFormat:@"%d",[num intValue]-1];
            if(numberArray && numberArray.count != 0)
            {
                [numberArray replaceObjectAtIndex:btnRow withObject:s2];
            }
            [label setText:s2];
        }
    }
    else
    {
        
        btnRow = (tag - 1)/2;
        NSString *num = (NSString *)[numberArray objectAtIndex:btnRow];
        
        label = (UILabel *)[numLabelArray objectAtIndex:btnRow];
        
        
        NSString *s4 = [NSString stringWithFormat:@"%d",[num intValue]+1];
        if(numberArray && numberArray.count != 0)
        {
            [numberArray replaceObjectAtIndex:btnRow withObject:s4];
        }
        [label setText:s4];
    }
    
    [tv reloadData];
    
}

- (void) cellBtnClick:(UIButton *) sender
{
    sender.selected = !sender.selected;
    
    int tag =  [sender tag];
    NSLog(@"tag = %d",tag);
    
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    for(UIButton *btn in cellBtnArray)
//    {
//        NSString *s = [NSString stringWithFormat:@"%d",btn.selected];
//        [arr addObject:s];
//    }
//    
//    UIButton *b = (UIButton *)[headBtnArray objectAtIndex:0];
//    if([arr containsObject:@"0"] == YES)
//    {
//        [b setSelected:NO];
//        if(buttomBtn)
//        {
//            [buttomBtn setSelected:NO];
//        }
//    }
//    else
//    {
//        [b setSelected:YES];
//        if(buttomBtn)
//        {
//            [buttomBtn setSelected:YES];
//        }
//    }
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
