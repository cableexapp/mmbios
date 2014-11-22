//
//  CableThirdStepViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-8.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "CableThirdStepViewController.h"
#import "MCDefine.h"
#import "DCFChenMoreCell.h"
#import "DCFCustomExtra.h"
#import "UIViewController+AddPushAndPopStyle.h"

@interface CableThirdStepViewController ()
{
    DCFChenMoreCell *moreCell;
    
    NSMutableArray *dataArray;

    CGRect myRect;
    
}
@end

@implementation CableThirdStepViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(conn)
    {
        [conn stopConnection];
    }
}

- (void) loadRequest:(NSString *) typeId
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getProductTypeByid",time];
    NSString *token = [DCFCustomExtra md5:string];
    
#pragma mark - 一级分类
    NSString *pushString = [NSString stringWithFormat:@"token=%@&typeid=%@",token,typeId];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetProductTypeByidTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/getProductTypeByid.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self loadRequest:_myTypeId];
    
    [self pushAndPopStyle];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [self.view setFrame:CGRectMake(0, 0, self.width, self.height)];
 
    if(tv)
    {
        [tv removeFromSuperview];
        tv = nil;
    }
    else
    {
        //   [tv reloadData];
        tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.width, self.height-64)];
        [tv setDataSource:self];
        [tv setDelegate:self];
        [tv setShowsHorizontalScrollIndicator:NO];
        [tv setShowsVerticalScrollIndicator:NO];
        [tv setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [self.view addSubview:tv];
    }

}

- (void) changeClassify:(NSString *) typeId WithTitle:(NSString *) title
{
    [self loadRequest:typeId];
    _myTitle = title;
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    
    if(URLTag == URLGetProductTypeByidTag)
    {
        if([[dicRespon allKeys] count] == 0)
        {
            [moreCell noDataAnimation];
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
                [moreCell failAcimation];
            }
        }
        [tv reloadData];

        NSLog(@"%@",dataArray);
        
    }
}

- (void) done
{
    
    
//    [tv reloadData];

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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"typeName"]];
    CGSize size;
    if(str.length == 0)
    {
        size = CGSizeMake(self.width-20, 30);
    }
    else
    {
        size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(self.width-20, MAXFLOAT)];
    }
    if(size.height <= 30)
    {
        return 40;
    }
    else
    {
        return size.height+10;
    }
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 1;
    }
    return dataArray.count;

    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView setSeparatorColor:[UIColor blueColor]];
    
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
            [moreCell.lblContent setFrame:CGRectMake(moreCell.avState.frame.origin.x+moreCell.avState.frame.size.width+10, 12, self.width, 20)];
        }
        return moreCell;
    }
    
    static NSString *cellId = @"cellId";
//    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        [tableView setSeparatorStyle:0];

        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
        
        
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    UILabel *cellLabel = [[UILabel alloc] init];
    
    NSString *str = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"typeName"]];
    CGSize size;
    if(str.length == 0)
    {
        size = CGSizeMake(self.width-20, 30);
    }
    else
    {
        size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(self.width-20, MAXFLOAT)];
    }
    if(size.height <= 30)
    {
        [cellLabel setFrame:CGRectMake(0, 5, self.width-20, 30)];
    }
    else
    {
        [cellLabel setFrame:CGRectMake(0, 5, self.width-20, size.height)];
    }
    [cellLabel setText:str];
    [cellLabel setTag:10];
    [cellLabel setNumberOfLines:0];
    [cellLabel setFont:[UIFont systemFontOfSize:12]];
    [cell.contentView addSubview:cellLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height-1, self.width, 1)];
    [lineView setTag:11];
    [lineView setBackgroundColor:MYCOLOR];
    [cell.contentView addSubview:lineView];

    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = [tableView indexPathForSelectedRow];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
    
    NSString *str = nil;
    for(UIView *view in cell.contentView.subviews)
    {
        NSLog(@"view = %@",view);
        if(view.tag == 10)
        {
            str = [(UILabel *)view text];
        }
    }
    self.myTitle = [self.myTitle stringByAppendingString:str];

    NSString *myId = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"typeId"]];
    if([self.delegate respondsToSelector:@selector(pushString:WithTypeId:)])
    {
        [self.delegate pushString:self.myTitle WithTypeId:myId];
    }
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
