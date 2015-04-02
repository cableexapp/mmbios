//
//  SixHostSearchView.m
//  B2C_MMB_iOS
//
//  Created by App01 on 15-3-31.
//  Copyright (c) 2015年 YUANDONG. All rights reserved.
//

#import "SixHostSearchView.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"

@implementation SixHostSearchView

- (id) initWithCustomFrame:(CGRect)rect
{
    if(self = [super init])
    {
        self.frame = rect;
        
        searchDataArray = [[NSArray alloc] initWithObjects:@"热搜",@"123",@"213",@"321",@"e3434",@"ddsdsd",@"dsdfv",@"hjhl",@"ytyrty",@"ccxccv",@"xzx",@"wqwqw",@"jjjhjhj", nil];
        
        listArray = [[NSMutableArray alloc] init];
        
        [self loadSubView];
    }
    return self;
}

- (void) loadSubView
{
    searchSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50*ScreenScaleY)];
    [searchSV setDelegate:self];
    [searchSV setShowsHorizontalScrollIndicator:NO];
    [searchSV setShowsVerticalScrollIndicator:NO];
//    [searchSV setPagingEnabled:YES];
//    [searchSV setScrollEnabled:YES];
//    [searchSV setBounces:YES];
    [searchSV setBackgroundColor:[UIColor whiteColor]];
    [searchSV setContentSize:CGSizeMake(MainScreenWidth*3, searchSV.frame.size.height)];
    
    NSMutableArray *sizeArray = [[NSMutableArray alloc] init];
    
    for(int i=0;i<searchDataArray.count;i++)
    {
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:[searchDataArray objectAtIndex:i] WithSize:CGSizeMake(MAXFLOAT, 30*ScreenScaleY)];
        [sizeArray addObject:[NSNumber numberWithFloat:size.width]];
        
        UIButton *svBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [svBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [svBtn setTitle:[searchDataArray objectAtIndex:i] forState:UIControlStateNormal];
        [svBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        if(i == 0)
        {
            [svBtn setFrame:CGRectMake(10, 10*ScreenScaleY, size.width+10, 30*ScreenScaleY)];
        }
        else
        {
            float beforeBtnTotalWidth = 0.0;
            for(int j=0;j<i;j++)
            {
                beforeBtnTotalWidth = beforeBtnTotalWidth + [[sizeArray objectAtIndex:j] floatValue]+10;
            }
            [svBtn setFrame:CGRectMake(10*(i+1)+beforeBtnTotalWidth, 10*ScreenScaleY, size.width+10, 30*ScreenScaleY)];
        }
        svBtn.layer.cornerRadius = 2.0f;
        svBtn.layer.borderColor = [UIColor blueColor].CGColor;
        svBtn.layer.borderWidth = 1.0f;
        [svBtn setTag:10+i];
        [svBtn addTarget:self action:@selector(svBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [searchSV setContentSize:CGSizeMake(svBtn.frame.origin.x+svBtn.frame.size.width+10, 50*ScreenScaleY)];
        [searchSV addSubview:svBtn];
    }
    

    
    
//    UITableView *searchTV = [[UITableView alloc] initWithFrame:CGRectMake(0, searchSV.frame.size.height+searchSV.frame.origin.y+10, MainScreenWidth, self.frame.size.height-searchSV.frame.size.height-20)];
    searchTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, MainScreenWidth, self.frame.size.height-20)];
    [searchTV setDelegate:self];
    [searchTV setDataSource:self];
    [self addSubview:searchTV];
    
#pragma mark - tableview上面加手势，回收键盘
    searchTV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void) svBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    
    if(listArray)
    {
        NSString *title = [NSString stringWithFormat:@"%@",[searchDataArray objectAtIndex:btn.tag-10]];
        NSLog(@"title = %@",title);
        [listArray addObject:title];
       
        NSSet *set = [NSSet setWithArray:listArray];
        [listArray removeAllObjects];
        for(int i=0;i<[set allObjects].count;i++)
        {
            [listArray addObject:[[set allObjects] objectAtIndex:i]];
        }
        [searchTV reloadData];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(listArray.count == 0)
    {
        return 1;
    }
    return listArray.count+2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 50*ScreenScaleY+1;
    }
    return 44+ScreenScaleY;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.row == 0)
    {
        static NSString *cellId = @"svCellId";
        UITableViewCell *svCell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(!svCell)
        {
            svCell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
            [svCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [svCell.contentView addSubview:searchSV];

            UIView *searchSVLineView = [[UIView alloc] initWithFrame:CGRectMake(0, searchSV.frame.size.height+1, MainScreenWidth, 1)];
            [searchSVLineView setBackgroundColor:[UIColor lightGrayColor]];
            [svCell.contentView addSubview:searchSVLineView];
        }
        return svCell;
    }
    else if(indexPath.row == listArray.count+1)
    {
        if(listArray.count == 0)
        {
            
        }
        else
        {
            static NSString *cellId = @"clearBtnCellId";
            UITableViewCell *clearBtnCell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if(!clearBtnCell)
            {
                clearBtnCell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
            }
            if(!clearBtn)
            {
                clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [clearBtn setFrame:CGRectMake((MainScreenWidth-260*ScreenScaleX)/2, 5, 260*ScreenScaleX, 34*ScreenScaleY)];
                [clearBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [clearBtn setTitle:@"清空历史记录" forState:UIControlStateNormal];
                [clearBtn setBackgroundColor:[UIColor whiteColor]];
                [clearBtn.layer setCornerRadius:5.0f];
                [clearBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
                [clearBtn.layer setBorderWidth:1.0f];
                [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [clearBtnCell.contentView addSubview:clearBtn];
            }
            return clearBtnCell;
        }

    }
//    else
//    {
        if(listArray.count == 0)
        {
            
        }
        else
        {
            static NSString *cellId = @"CellId";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
            }
            [cell.textLabel setText:[NSString stringWithFormat:@" %@",[listArray objectAtIndex:indexPath.row-1]]];
            return cell;
        }

//    }
    return nil;
}

- (void) clearBtnClick:(UIButton *) sender
{
    UIAlertView *clearAV = [[UIAlertView alloc] initWithTitle:nil message:@"确定清空历史搜索吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [clearAV show];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            if(listArray.count != 0)
            {
                [listArray removeAllObjects];
                [searchTV reloadData];
            }
            NSLog(@"清空");
            break;
            
        default:
            break;
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
