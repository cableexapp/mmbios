//
//  HotKindHostViewController.m
//  B2C_MMB_iOS
//
//  Created by cyumen on 14-11-7.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "HotKindFirstViewController.h"
#import "HotKindFirstViewTableViewCell.h"
#import "HotSecondViewController.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFStringUtil.h"
#import "SearchViewController.h"
#import "B2BAskPriceCarViewController.h"
#import "DCFColorUtil.h"


@interface HotKindFirstViewController ()

{
    NSMutableArray *dataArray;
    NSMutableArray *selectArray;
    UIButton *backView;
    UIButton *backBtn;  //返回按钮
    UIBarButtonItem *leftItem;
    UIView *rightButtonView;
    BOOL flag;
}

@end

@implementation HotKindFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view tag] == 101)
        {
            [view setHidden:YES];
        }
        if([view isKindOfClass:[UISearchBar class]])
        {
            [view setHidden:YES];
        }
    }
    rightButtonView.hidden = NO;
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 15, 22)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(self.testSubTableView)
    {
        [self.testSubTableView setEditing:NO];
    }

    rightButtonView.hidden = YES;
    [self deleteHistorySelestData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化
    self.opend = NO;
    self.testSubTableView.hidden = YES;
    self.selectView.hidden = YES;
    self.clearBtn.hidden = YES;
    
    //每个界面都要加这句话
    [self pushAndPopStyle];
    
    rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 0, 60, 44)];
    [self.navigationController.navigationBar addSubview:rightButtonView];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightBtn setFrame:CGRectMake(0, 0, 60, 44)];
    [rightBtn addTarget:self action:@selector(searchRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:rightBtn];
    
    //    [super viewDidLoad];
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"热门分类"];
    self.navigationItem.titleView = top;
    //    [super viewDidLoad];
    
    //读取plist文件
    NSString *filePath = [[NSString alloc] initWithFormat:@"%@",[[NSBundle mainBundle] pathForResource:@"Hotpst" ofType:@"plist"]];
    dataArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    if(_testTableView)
    {
        [_testTableView reloadData];
    }
    selectArray = [NSMutableArray arrayWithCapacity:dataArray.count];
    [self.testSubTableView setFrame:CGRectMake(self.testSubTableView.frame.origin.x, self.testSubTableView.frame.origin.y, self.testSubTableView.frame.size.width, 0)];
    self.testSubTableView.hidden = YES;
    
    // 设置按钮内部的imageView的内容模式为居中
    self.triangleBtn.imageView.contentMode = UIViewContentModeCenter;
    // 超出边框的内容不需要裁剪
    self.triangleBtn.imageView.clipsToBounds = NO;
    
    self.testTableView.separatorColor = [UIColor lightGrayColor];
    self.testTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
    
    self.testSubTableView.separatorColor = [DCFColorUtil colorFromHexRGB:@"#ba7d04"];
    self.testSubTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
   
    //    小三角按钮
    backView = [[UIButton alloc] init];
    backView.frame = CGRectMake(0, 84, self.view.frame.size.width, self.view.frame.size.height-128);
    backView.hidden = YES;
    [backView addTarget:self action:@selector(shadow) forControlEvents:UIControlEventTouchUpInside];
    backView.backgroundColor = [UIColor lightGrayColor];
    [self.view insertSubview:backView aboveSubview:self.testTableView];
    
    //     返回按钮的操作
    self.upBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
    self.upBtn.layer.cornerRadius = 5;
}

//     返回按钮的操作
- (void) back:(id) sender
{
    if ( selectArray.count == 0 )
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    else
    {
        //  跳转到首页
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"是否将已选中的分类提交询价后再返回？"
                                                    delegate:self
                                           cancelButtonTitle:@"是"
                                           otherButtonTitles:@"直接返回", nil];
        [av setTag:10];
        [av show];
    }
}

//      返回按钮的代理
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        HotSecondViewController *secCtr = [self.storyboard instantiateViewControllerWithIdentifier:@"hotSecondViewController"];
        secCtr.upArray = selectArray;
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:secCtr animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//    小三角按钮
-(void)shadow
{
    backView.hidden = YES;
    _testSubTableView.hidden = YES;
    _testTableView.userInteractionEnabled = YES;
    self.triangleBtn.imageView.transform = CGAffineTransformMakeRotation(0);  //三角按钮旋转
    self.testTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-33);
    self.opend = NO;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView.tag == 33)
    {
        return dataArray.count;
    }
    else
    {
        return selectArray.count;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str;
    if (tableView.tag == 33)
    {
        str = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"typePls"]];
    }
    else
    {
        str = [NSString stringWithFormat:@"%@",[[selectArray objectAtIndex:indexPath.row] objectForKey:@"typePls"]];
    }
    
    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:str WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
    if(size.height <= 30)
    {
        size = CGSizeMake(ScreenWidth-20, 30);
    }
    return size.height+10;
}

#pragma mark - Tableview填充数据
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 33)
    {
        static NSString *cellId = @"hotKindFirstViewTableViewCell";
        HotKindFirstViewTableViewCell *cell = (HotKindFirstViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        if(!cell)
        {
            cell = [[HotKindFirstViewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        
        while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
        {
            [(UIView *) CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex: indexPath.row] objectForKey:@"typePls"]];
        UILabel *label = [[UILabel alloc] init];
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:str WithSize:CGSizeMake(cell.contentView.frame.size.width-20, MAXFLOAT)];
        if(size.height <= 30)
        {
            size = CGSizeMake(cell.contentView.frame.size.width-20, 30);
        }
        [label setFrame:CGRectMake(10, 5, cell.contentView.frame.size.width-20, size.height)];
        [label setText:str];
        [label setFont:[UIFont systemFontOfSize:13]];
        [label setNumberOfLines:0];
        [cell.contentView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        if (selectArray.count >= 50)
        {
            cell.userInteractionEnabled= false;
        }
        if (selectArray.count < 50)
        {
            cell.userInteractionEnabled= true;
        }
        return cell;
    }
    else
    {
        static NSString *cellId = @"twohotKindFirstViewTableViewCell";
        HotKindFirstViewTableViewCell *cell = (HotKindFirstViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        if(!cell)
        {
            cell = [[HotKindFirstViewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        cell.contentView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:228.0/255.0 blue:191.0/255.0 alpha:255.0/255.0];
        
        //显示数据
        NSString *str = [NSString stringWithFormat:@"%@",[[selectArray objectAtIndex: indexPath.row] objectForKey:@"typePls"]];
        [cell.textLabel setText:str];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
        cell.textLabel.textAlignment = 1;
        
        return cell;
    }
    
}


#pragma  mark - 选中后传递给testSubTableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView.tag == 33)
    {
        self.testTableView.frame = CGRectMake(0, 36, self.view.frame.size.width, self.view.frame.size.height-73);
        self.selectView.hidden = NO;
        self.clearBtn.hidden = NO;
        self.testSubTableView.hidden = YES;
        [selectArray addObject:[dataArray objectAtIndex:indexPath.row]];
        [dataArray removeObjectAtIndex:indexPath.row];
    }
    [_testTableView reloadData];
    [_typeBtn setTitle:[NSString stringWithFormat:@"             已经选中的分类 %d",selectArray.count] forState:UIControlStateNormal];
    if (selectArray.count >= 50)
    {
        [DCFStringUtil showNotice:@"最多选择50条"];
    }
    
    if (self.isOpened)
    {
        [_testSubTableView reloadData];
        //设置是控制tableview的最大高度
        float height = (selectArray.count*40 < 200) ? selectArray.count*40 : 200;
        [self.testSubTableView setFrame:CGRectMake(self.testSubTableView.frame.origin.x, self.testSubTableView.frame.origin.y, self.testSubTableView.frame.size.width, height)];
    }
}

#pragma mark - 删除testSubTableView里的数据
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 33)
    {
        self.selectView.hidden = NO;
        self.clearBtn.hidden = NO;
        [selectArray addObject:[dataArray objectAtIndex:indexPath.row]];
        [dataArray removeObjectAtIndex:indexPath.row];
    }
    else
    {
        [dataArray addObject:[selectArray objectAtIndex:indexPath.row]];
        [selectArray removeObjectAtIndex:indexPath.row];
    }
    [_testTableView reloadData];
    
    [_typeBtn setTitle:[NSString stringWithFormat:@"             已经选中的分类 %d",selectArray.count] forState:UIControlStateNormal];
    if (selectArray.count == 0)
    {
        self.testTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-33);
        backView.hidden = YES;
        _testSubTableView.hidden = YES;
        _testTableView.userInteractionEnabled = YES;
        self.selectView.hidden = YES;
        self.opend = NO;
        [_testSubTableView reloadData];
    }
    if (self.isOpened)
    {
        [_testSubTableView reloadData];
        _testSubTableView.hidden = NO;
        //设置是控制tableview的最大高度
        float height = (selectArray.count*40 < 200) ? selectArray.count*40 : 200;
        [self.testSubTableView setFrame:CGRectMake(self.testSubTableView.frame.origin.x, self.testSubTableView.frame.origin.y, self.testSubTableView.frame.size.width, height)];
    }
}

#pragma mark - 删除风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    if ([tableView isEqual:self.testSubTableView])
    {
        result = UITableViewCellEditingStyleDelete;      //设置编辑风格为删除风格
    }
    return result;
}


#pragma mark - 展开已选按钮
- (IBAction)typeBtn:(id)sender
{
    
    if ( _opend )
    {
        //        判断字符串封装方法，如果为NO就为空。
        //        [DCFCustomExtra validateString:@"123"] == NO;
        self.opend = NO;
        backView.hidden = YES;
        
        //     2.动画效果
        [UIView animateWithDuration:0.3 animations:^{
            self.triangleBtn.imageView.transform = CGAffineTransformMakeRotation(0);  //三角按钮旋转
        }];
        
        _testTableView.userInteractionEnabled = YES;
        _testSubTableView.hidden = YES;
    }
    else
    {
        self.opend = YES;
        backView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        backView.alpha = 0.6;
        backView.hidden = NO;
        if (selectArray.count != 0)
        {
            _testSubTableView.hidden = YES;
        }
        //        动画效果
        [UIView animateWithDuration:0.3 animations:^{
            self.triangleBtn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);  //三角按钮旋转
        }];
        _testSubTableView.hidden = NO;
        _testTableView.userInteractionEnabled = NO;   // 未选列表不能选中
        float height = (selectArray.count*40 < 200) ? selectArray.count*40 : 200;
        [self.testSubTableView setFrame:CGRectMake(self.testSubTableView.frame.origin.x, self.testSubTableView.frame.origin.y, self.testSubTableView.frame.size.width, height)];
        [_testSubTableView reloadData];
    }
}


#pragma mark - 清空按钮
- (IBAction)clearBtn:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确认要清空已选择的分类吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"清空"
                                              otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}

#pragma mark - 提交
- (IBAction)clickSubmit:(id)sender
{
    //   隐藏底部
    [self setHidesBottomBarWhenPushed:YES];
    if (selectArray.count == 0)
    {
        [DCFStringUtil showNotice:@"请选择分类"];
    }
    else
    {
        HotSecondViewController *secCtr = [self.storyboard instantiateViewControllerWithIdentifier:@"hotSecondViewController"];
        secCtr.upArray = selectArray;
        [self.navigationController pushViewController:secCtr animated:YES];
    }
}

-(void)deleteHistorySelestData
{
    self.opend = NO;
    backView.hidden = YES;
    self.testTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-33);
    self.selectView.hidden = YES;
    _testSubTableView.hidden = YES;
    _testTableView.userInteractionEnabled = YES;
    [_testSubTableView setFrame:CGRectMake(_testSubTableView.frame.origin.x, _testSubTableView.frame.origin.y, _testSubTableView.frame.size.width, 0)];
    [dataArray addObjectsFromArray:selectArray];
    [selectArray removeAllObjects];
    [_testTableView reloadData];
    [_typeBtn setTitle:[NSString stringWithFormat:@"             已经选中的分类 %d",selectArray.count] forState:UIControlStateNormal];
    self.triangleBtn.imageView.transform = CGAffineTransformMakeRotation(0);  //三角按钮旋转
}

#pragma mark - actionsheet的代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.opend = NO;
        backView.hidden = YES;
        self.testTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-33);
        self.selectView.hidden = YES;
        _testSubTableView.hidden = YES;
        _testTableView.userInteractionEnabled = YES;
        [_testSubTableView setFrame:CGRectMake(_testSubTableView.frame.origin.x, _testSubTableView.frame.origin.y, _testSubTableView.frame.size.width, 0)];
        [dataArray addObjectsFromArray:selectArray];
        [selectArray removeAllObjects];
        [_testTableView reloadData];
        [_typeBtn setTitle:[NSString stringWithFormat:@"             已经选中的分类 %d",selectArray.count] forState:UIControlStateNormal];
        self.triangleBtn.imageView.transform = CGAffineTransformMakeRotation(0);  //三角按钮旋转
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (void)searchRightBtnClick
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:searchVC animated:YES];
}
@end
