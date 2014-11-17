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





@interface HotKindFirstViewController ()
{
    NSMutableArray *dataArray;
    NSMutableArray *selectArray;
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
    
    
    [super viewDidLoad];
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"热门分类"];
    self.navigationItem.titleView = top;
    [super viewDidLoad];

    
    
    
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
    
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView.tag == 33) {
        return dataArray.count;
    }
    else{
        return selectArray.count;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *str;
    
    if (tableView.tag == 33) {
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




- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 33) {

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

        return cell;
        
        
    }else
    {
        static NSString *cellId = @"twohotKindFirstViewTableViewCell";
        HotKindFirstViewTableViewCell *cell = (HotKindFirstViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        if(!cell)
        {
            cell = [[HotKindFirstViewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];

        }
       
        cell.contentView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:228.0/255.0 blue:191.0/255.0 alpha:255.0/255.0];
        tableView.separatorColor = [ UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:255.0/255.0];
        //显示数据
        NSString *str = [NSString stringWithFormat:@"%@",[[selectArray objectAtIndex: indexPath.row] objectForKey:@"typePls"]];
        [cell.textLabel setText:str];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
//        cell.textAlignment = UITextAlignmentCenter;


        

        return cell;
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView.tag == 33) {
        self.selectView.hidden = NO;
        self.clearBtn.hidden = NO;
        [selectArray addObject:[dataArray objectAtIndex:indexPath.row]];
        [dataArray removeObjectAtIndex:indexPath.row];
    }else{
    
        [dataArray addObject:[selectArray objectAtIndex:indexPath.row]];
        [selectArray removeObjectAtIndex:indexPath.row];
    }
    
    
    
    [_testTableView reloadData];
    [_typeBtn setTitle:[NSString stringWithFormat:@"已经选中的分类 %d",selectArray.count] forState:UIControlStateNormal];
    if (selectArray.count == 0) {
        _testSubTableView.hidden = YES;
        _testTableView.userInteractionEnabled = YES;
        self.selectView.hidden = YES;
     }
  
    
    if (self.isOpened) {
        [_testSubTableView reloadData];


        //设置是控制tableview的最大高度
        float height = (selectArray.count*40 < 200) ? selectArray.count*40 : 200;
        [self.testSubTableView setFrame:CGRectMake(self.testSubTableView.frame.origin.x, self.testSubTableView.frame.origin.y, self.testSubTableView.frame.size.width, height)];

    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}




#pragma mark - 展开已选按钮
- (IBAction)typeBtn:(id)sender
{
//类型转换
//UIButton *button = (UIButton * ) sender;
 
if ( _opend )
    {
        
        self.opend = NO;
    
      _testTableView.userInteractionEnabled = YES;
        _testSubTableView.hidden = YES;

}else
    
    {
        self.opend = YES;
     
        _testSubTableView.hidden = NO;
//      未选列表不能选中
        _testTableView.userInteractionEnabled = NO;
        float height = (selectArray.count*40 < 200) ? selectArray.count*40 : 200;
        [self.testSubTableView setFrame:CGRectMake(self.testSubTableView.frame.origin.x, self.testSubTableView.frame.origin.y, self.testSubTableView.frame.size.width, height)];
        [_testSubTableView reloadData];

    }
    
}


#pragma mark - 清空按钮
- (IBAction)clearBtn:(id)sender
{
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"您确定要清空吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
    
}

#pragma mark - 提交
- (IBAction)clickSubmit:(id)sender
{
    //   隐藏底部
    [self setHidesBottomBarWhenPushed:YES];
    HotSecondViewController *secCtr = [self.storyboard instantiateViewControllerWithIdentifier:@"hotSecondViewController"];
    secCtr.upArray = selectArray;
    [self.navigationController pushViewController:secCtr animated:YES];
    
}


#pragma mark - actionsheet的代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) return;
    self.opend = NO;
    self.selectView.hidden = YES;

    _testSubTableView.hidden = YES;
    _testTableView.userInteractionEnabled = YES;
    [_testSubTableView setFrame:CGRectMake(_testSubTableView.frame.origin.x, _testSubTableView.frame.origin.y, _testSubTableView.frame.size.width, 0)];
    
    [dataArray addObjectsFromArray:selectArray];
    [selectArray removeAllObjects];
    [_testTableView reloadData];
    [_typeBtn setTitle:[NSString stringWithFormat:@"已经选中的分类 %d",selectArray.count] forState:UIControlStateNormal];
}

- (IBAction)deleteTab:(UIButton *)sender
{
    
    
    

}
@end
