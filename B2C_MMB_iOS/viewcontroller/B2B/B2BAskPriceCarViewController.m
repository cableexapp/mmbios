//
//  B2BAskPriceCarViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-3.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2BAskPriceCarViewController.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFStringUtil.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "DCFChenMoreCell.h"
#import "AppDelegate.h"
#import "B2BAskPriceDetailData.h"
#import "B2BAskPriceCarEditViewController.h"

@interface B2BAskPriceCarViewController ()
{
    UIView *buttomView;    //底部view
    
    UIButton *upBtn;   //底部提交按钮
    UIButton *backToHostBtn; //底部返回首页按钮
    
    AppDelegate *app;
    
    NSMutableArray *sectionHeadBtnArray; //section按钮数组
    NSMutableArray *editAndDelBtnArray;
    NSMutableArray *headLabelArray;
    
    B2BAskPriceDetailData *data;
    
    NSMutableArray *dataArray;
    
    NSMutableArray *cellHeightArray;
    
    NSMutableArray *chooseArray;  //选择商品的数组
    
    DCFChenMoreCell *moreCell;
    
    UIButton *subViewBtn;   //加载编辑界面的按钮
    B2BAskPriceCarEditViewController *b2bAskPriceCarEditViewController;
}
@end

@implementation B2BAskPriceCarViewController

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
    NSLog(@"上传");
}

- (void) backToHostBtnClick:(UIButton *) sender
{
    NSLog(@"回到首页");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    chooseArray = [[NSMutableArray alloc] init];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"询价车"];
    self.navigationItem.titleView = top;
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
 
    if(!buttomView || !upBtn || !backToHostBtn)
    {
        buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight-60-64, ScreenWidth, 60)];
        [self.view addSubview:buttomView];

        
        upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [upBtn setTitle:@"提交" forState:UIControlStateNormal];
        [upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [upBtn setBackgroundColor:[UIColor blueColor]];
        [upBtn setFrame:CGRectMake(ScreenWidth-120, 15, 100, 30)];
        [upBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttomView addSubview:upBtn];

    }
    
    if(!tv)
    {
        tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-buttomView.frame.size.height-64)];
        [tv setDataSource:self];
        [tv setDelegate:self];
        [tv setShowsHorizontalScrollIndicator:NO];
        [tv setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:tv];
    }
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"InquiryCartList",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    
    NSString *visitorid = [app getUdid];
    
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    NSString *pushString = nil;
    if(hasLogin == YES)
    {
        pushString = [NSString stringWithFormat:@"memberid=%@&token=%@",memberid,token];
    }
    else
    {
        pushString = [NSString stringWithFormat:@"visitorid=%@&token=%@",visitorid,token];
    }

    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLInquiryCartListTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/InquiryCartList.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];

    
    static NSString *moreCellId = @"moreCell";
    moreCell = (DCFChenMoreCell *)[tv dequeueReusableCellWithIdentifier:moreCellId];
    
    [moreCell startAnimation];
}

- (void) subViewBtnClick:(UIButton *) sender
{
    if(b2bAskPriceCarEditViewController)
    {
        [b2bAskPriceCarEditViewController.view removeFromSuperview];
        [b2bAskPriceCarEditViewController removeFromParentViewController];
        b2bAskPriceCarEditViewController = nil;
    }
    if(subViewBtn)
    {
        [subViewBtn removeFromSuperview];
        subViewBtn = nil;
        
        
    }
}

#pragma mark - 编辑
- (void) edit:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    NSLog(@"btn.tag = %d",btn.tag);
    
    subViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [subViewBtn setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [subViewBtn setBackgroundColor:[UIColor blackColor]];
    [subViewBtn setAlpha:0.6];
    [subViewBtn addTarget:self action:@selector(subViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subViewBtn];
    
    b2bAskPriceCarEditViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"b2bAskPriceCarEditViewController"];
    b2bAskPriceCarEditViewController.view.frame = subViewBtn.bounds;
    [self addChildViewController:b2bAskPriceCarEditViewController];
    [subViewBtn addSubview:b2bAskPriceCarEditViewController.view];
}

#pragma mark - 删除
- (void) del:(UIButton *) sender
{
    if(chooseArray.count == 0)
    {
        [DCFStringUtil showNotice:@"您尚未选择商品"];
        return;
    }
    
    UIButton *btn = (UIButton *) sender;
    NSLog(@"tag = %d",btn.tag);
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"DeleteInquiryCartItem",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    data = [dataArray objectAtIndex:btn.tag];
    NSString *pushString = [NSString stringWithFormat:@"token=%@&cartid=%@",token,[data cartId]];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLDeleteInquiryCartItemTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/DeleteInquiryCartItem.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLInquiryCartListTag)
    {
        dataArray = [[NSMutableArray alloc] init];

        sectionHeadBtnArray = [[NSMutableArray alloc] init];
        
        cellHeightArray = [[NSMutableArray alloc] init];
        
        editAndDelBtnArray = [[NSMutableArray alloc] init];
        
        NSLog(@"%@",dicRespon);
        
        
        
        if(result == 1)
        {
            [dataArray addObjectsFromArray:[B2BAskPriceDetailData getListArray:[dicRespon objectForKey:@"items"]]];
            
            if(dataArray.count == 0)
            {
                [moreCell noDataAnimation];
            }
            else
            {
                for(int i=0;i<dataArray.count;i++)
                {
                    UIImageView *headBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
                    [headBtnIv setImage:[UIImage imageNamed:@"unchoose.png"]];

                    UIButton *sectionHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [sectionHeadBtn setFrame:CGRectMake(0, 0, ScreenWidth, 60)];
                    
                    [sectionHeadBtn setTag:i];
                    [sectionHeadBtn addTarget:self action:@selector(sectionHeadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [sectionHeadBtn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                    [sectionHeadBtnArray addObject:sectionHeadBtn];
                    
                    //编辑删除按钮
                    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [editBtn setFrame:CGRectMake(ScreenWidth-120, 7, 50, 30)];
                    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
                    [editBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    [editBtn setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:120.0/255.0 blue:13.0/255.0 alpha:1.0]];
                    editBtn.layer.borderWidth = 1.0f;
                    [editBtn setTag:i];
                    editBtn.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:120.0/255.0 blue:13.0/255.0 alpha:1.0].CGColor;
                    editBtn.layer.cornerRadius = 5.0f;
                    [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [delBtn setFrame:CGRectMake(ScreenWidth-60, 7, 50, 30)];
                    [delBtn setTitle:@"删除" forState:UIControlStateNormal];
                    [delBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    [delBtn setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:120.0/255.0 blue:13.0/255.0 alpha:1.0]];
                    delBtn.layer.borderWidth = 1.0f;
                    [delBtn setTag:i];
                    delBtn.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:120.0/255.0 blue:13.0/255.0 alpha:1.0].CGColor;
                    delBtn.layer.cornerRadius = 5.0f;
                    [delBtn addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
                    
                    NSArray *arr = [[NSArray alloc] initWithObjects:editBtn,delBtn, nil];
                    
                    [editAndDelBtnArray addObject:arr];
                    
                    //计算高度，加入数组
                    CGFloat height = 0;
                    
                    NSString *require = [NSString stringWithFormat:@"特殊要求 %@",[[dataArray objectAtIndex:i] require]];
                    
                    CGSize size;
                    if(require.length == 0 || [require isKindOfClass:[NSNull class]])
                    {
                        size = CGSizeMake(ScreenWidth/2-20, 20);
                    }
                    else
                    {
                        size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:require WithSize:CGSizeMake(ScreenWidth/2-20, MAXFLOAT)];
                    }
                    if(size.height < 20)
                    {
                        height = 90;
                    }
                    else
                    {
                        height = size.height+70;
                    }
                    [cellHeightArray addObject:[NSNumber numberWithFloat:height]];
                }
                [moreCell stopAnimation];
            }
  
        }
        else
        {
            
            [moreCell failAcimation];
        }
        
        [tv reloadData];
    }
    if(URLTag == URLDeleteInquiryCartItemTag)
    {
        NSLog(@"%@",dicRespon);
        if(result == 1)
        {
            int index = 0;
            for(int i=0;i<dataArray.count;i++)
            {
                B2BAskPriceDetailData *b2bData = [dataArray objectAtIndex:i];
                if([data isEqual:b2bData])
                {
                    NSLog(@"第%d个",i);
                    index = i;
                    break;
                }
            }
            NSLog(@"index = %d",index);
            
            [chooseArray removeObject:data];
            [sectionHeadBtnArray removeObjectAtIndex:index];
            [cellHeightArray removeObjectAtIndex:index];
            [editAndDelBtnArray removeObjectAtIndex:index];
            [dataArray removeObjectAtIndex:index];

            if(dataArray.count == 0)
            {
                [moreCell noDataAnimation];
            }
            [tv reloadData];
        }
        else
        {
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"删除失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
}

- (void) sectionHeadBtnClick:(UIButton *) sender
{
    if(chooseArray || chooseArray.count != 0)
    {
        [chooseArray removeAllObjects];
    }

    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    for(UIButton *b in sectionHeadBtnArray)
    {
        if([b isEqual:btn])
        {
            [b setSelected:btn.selected];
            if(b.selected == YES)
            {
                int tag = b.tag;
                data = [dataArray objectAtIndex:tag];
                [chooseArray addObject:data];
            }
        }
        else
        {
            
            [b setSelected:NO];
            
        }
        

    }

    [tv reloadData];

}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return nil;
    }

    UIButton *sectionHeadBtn = (UIButton *)[sectionHeadBtnArray objectAtIndex:section];
    if([sectionHeadBtn.subviews count] != 0)
    {
//        NSLog(@"已经有了");
//        UIImageView *headIv = [headImageArray objectAtIndex:section];

//        UIButton *b = [sectionHeadBtnArray objectAtIndex:section];
//        if(b.selected == YES)
//        {
//            [headIv setImage:[UIImage imageNamed:@"choose.png"]];
//        }
//        else
//        {
//            [headIv setImage:[UIImage imageNamed:@"unchoose.png"]];
//        }

    }
    else
    {
        UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20,20)];
        [modelLabel setText:[NSString stringWithFormat:@"型号:%@",[[dataArray objectAtIndex:section] cartModel]]];
        [modelLabel setFont:[UIFont systemFontOfSize:12]];
        [sectionHeadBtn addSubview:modelLabel];
        
        NSString *kindString = [NSString stringWithFormat:@"分类:%@ %@ %@",[[dataArray objectAtIndex:section] firstType],[[dataArray objectAtIndex:section] secondType],[[dataArray objectAtIndex:section] thridType]];
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:11] WithText:kindString WithSize:CGSizeMake(modelLabel.frame.size.width, MAXFLOAT)];
        UILabel *kindLabel = [[UILabel alloc] initWithFrame:CGRectMake(modelLabel.frame.origin.x,modelLabel.frame.origin.y+modelLabel.frame.size.height, modelLabel.frame.size.width, size.height)];
        [kindLabel setText:kindString];
        [kindLabel setFont:[UIFont systemFontOfSize:11]];
        [kindLabel setNumberOfLines:0];
        [sectionHeadBtn addSubview:kindLabel];
        
        CGFloat height = modelLabel.frame.size.height + size.height+10;
        [sectionHeadBtn setFrame:CGRectMake(0, 0,ScreenWidth, height)];

        
        UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        [firstLine setBackgroundColor:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0]];
        [sectionHeadBtn addSubview:firstLine];
        
        
        UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(0, height-1, ScreenWidth, 1)];
        [secondLine setBackgroundColor:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0]];
        [sectionHeadBtn addSubview:secondLine];
    }
   
    
    return sectionHeadBtn;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!dataArray || dataArray.count == 0)
    {
        return 1;
    }
    return dataArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 1;
    }
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 0;
    }
    NSString *kindString = [NSString stringWithFormat:@"分类:%@ %@ %@",[[dataArray objectAtIndex:section] firstType],[[dataArray objectAtIndex:section] secondType],[[dataArray objectAtIndex:section] thridType]];
    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:11] WithText:kindString WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
    return size.height+30;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(!dataArray || dataArray.count == 0)
    {
        return 44;
    }
    
    if(indexPath.row == 0)
    {
        CGFloat height = [[cellHeightArray objectAtIndex:indexPath.section] floatValue];
        
        UIButton *btn = [sectionHeadBtnArray objectAtIndex:indexPath.section];
        
        if(btn.selected == YES)
        {
            return height;
        }
        else
        {
            return 0;
        }
    }
    else if (indexPath.row == 1)
    {
        return 44;
    }
    return 0;
}


//- (UITableViewCell *) returnCellWithTableView:(UITableView *) tableView WithIndexPath:(NSIndexPath *) indexPath
//{
//   }

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(!dataArray || dataArray.count == 0)
    {
 
        if(moreCell == nil)
        {
            moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
            [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        }
        return moreCell;
    }
    

    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    {
        [(UIView *) CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    
    if(indexPath.row == 0)
    {
        CGFloat halfWidth = cell.contentView.frame.size.width/2+10;
        
        NSString *num = [NSString stringWithFormat:@"数量 %@",[[dataArray objectAtIndex:indexPath.section] num]];
        NSString *deliver = [NSString stringWithFormat:@"交货期 %@",[[dataArray objectAtIndex:indexPath.section] deliver]];
        NSString *cartSpec = [NSString stringWithFormat:@"规格 %@",[[dataArray objectAtIndex:indexPath.section] cartSpec]];  //规格
        NSString *cartVoltage = [NSString stringWithFormat:@"电压 %@",[[dataArray objectAtIndex:indexPath.section] cartVoltage]];
        NSString *color = [NSString stringWithFormat:@"颜色 %@",[[dataArray objectAtIndex:indexPath.section] cartColor]];
        NSString *featureone = [NSString stringWithFormat:@"阻燃特性 %@",[[dataArray objectAtIndex:indexPath.section] featureone]];  //阻燃特性
        NSString *require = [NSString stringWithFormat:@"特殊要求 %@",[[dataArray objectAtIndex:indexPath.section] require]];
        
        NSMutableAttributedString *myNum = [[NSMutableAttributedString alloc] initWithString:num];
        [myNum addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 1)];
        [myNum addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, num.length-3)];
        
        NSMutableAttributedString *myDeliver = [[NSMutableAttributedString alloc] initWithString:deliver];
        [myDeliver addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
        [myDeliver addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(4, deliver.length-4)];
        
        NSMutableAttributedString *myCartSpec = [[NSMutableAttributedString alloc] initWithString:cartSpec];
        [myCartSpec addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 1)];
        [myCartSpec addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, cartSpec.length-3)];
        
        NSMutableAttributedString *myCartVoltage = [[NSMutableAttributedString alloc] initWithString:cartVoltage];
        [myCartVoltage addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 1)];
        [myCartVoltage addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, cartVoltage.length-3)];
        
        NSMutableAttributedString *myColor = [[NSMutableAttributedString alloc] initWithString:color];
        [myColor addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 1)];
        [myColor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, color.length-3)];
        
        NSMutableAttributedString *myFeatureone = [[NSMutableAttributedString alloc] initWithString:featureone];
        [myFeatureone addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
        [myFeatureone addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, featureone.length-5)];
        
        NSMutableAttributedString *myRequire = [[NSMutableAttributedString alloc] initWithString:require];
        [myRequire addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
        [myRequire addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, require.length-5)];
        
        CGSize size_1;
        if(num.length == 0 || [num isKindOfClass:[NSNull class]])
        {
            size_1 = CGSizeMake(100, 20);
        }
        else
        {
            size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:num WithSize:CGSizeMake(MAXFLOAT, 20)];
            
        }
        
        CGSize size_2;
        if(deliver.length == 0 || [deliver isKindOfClass:[NSNull class]])
        {
            size_2 = CGSizeMake(100, 20);
        }
        else
        {
            size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:deliver WithSize:CGSizeMake(MAXFLOAT, 20)];
            
        }
        
        CGSize size_3;
        if(cartSpec.length == 0 || [cartSpec isKindOfClass:[NSNull class]])
        {
            size_3 = CGSizeMake(100, 20);
        }
        else
        {
            size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:cartSpec WithSize:CGSizeMake(MAXFLOAT, 20)];
            
        }
        
        CGSize size_4;
        if(cartVoltage.length == 0 || [cartVoltage isKindOfClass:[NSNull class]])
        {
            size_4 = CGSizeMake(100, 20);
        }
        else
        {
            size_4 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:cartVoltage WithSize:CGSizeMake(MAXFLOAT, 20)];
            
        }
        
        CGSize size_5;
        if(color.length == 0 || [color isKindOfClass:[NSNull class]])
        {
            size_5 = CGSizeMake(100, 20);
        }
        else
        {
            size_5 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:color WithSize:CGSizeMake(MAXFLOAT, 20)];
        }
        
        CGSize size_6;
        if(featureone.length == 0 || [featureone isKindOfClass:[NSNull class]])
        {
            size_6 = CGSizeMake(100, 20);
        }
        else
        {
            size_6 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:featureone WithSize:CGSizeMake(MAXFLOAT, 20)];
        }
        
        CGSize size_7;
        if(require.length == 0 || [require isKindOfClass:[NSNull class]])
        {
            size_7 = CGSizeMake(cell.contentView.frame.size.width-20, 20);
        }
        else
        {
            size_7 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:require WithSize:CGSizeMake(cell.contentView.frame.size.width-20, MAXFLOAT)];
        }
        
        
        for(int i=0;i<7;i++)
        {
            UILabel *cellLabel = [[UILabel alloc] init];
            if(i == 0)
            {
                [cellLabel setFrame:CGRectMake(10, 5, size_1.width, 20)];
                [cellLabel setAttributedText:myNum];
            }
            if(i == 1)
            {
                [cellLabel setFrame:CGRectMake(halfWidth, 5, size_2.width, 20)];
                [cellLabel setAttributedText:myDeliver];
            }
            if(i == 2)
            {
                [cellLabel setFrame:CGRectMake(10, 25, size_3.width, 20)];
                [cellLabel setAttributedText:myCartSpec];

            }
            if(i == 3)
            {
                [cellLabel setFrame:CGRectMake(halfWidth, 25, size_4.width, 20)];
                [cellLabel setAttributedText:myCartVoltage];
            }
            if(i == 4)
            {
                [cellLabel setFrame:CGRectMake(10, 45, size_5.width, 20)];
                [cellLabel setAttributedText:myColor];
            }
            if(i == 5)
            {
                [cellLabel setFrame:CGRectMake(halfWidth, 45, size_6.width, 20)];
                [cellLabel setAttributedText:myFeatureone];
            }
            if(i == 6)
            {
                [cellLabel setFrame:CGRectMake(10, 65, cell.contentView.frame.size.width-20, size_7.height)];
                [cellLabel setAttributedText:myRequire];
            }
            
            [cellLabel setFont:[UIFont systemFontOfSize:12]];
            [cellLabel setNumberOfLines:0];
            
            [cell.contentView addSubview:cellLabel];
        }
        
        //cell收缩
        UIButton *btn = [sectionHeadBtnArray objectAtIndex:indexPath.section];
        int tag = btn.tag;
        if(tag == indexPath.section)
        {
            if(btn.selected == YES)
            {
                
            }
            else
            {
                for(UIView *view in cell.contentView.subviews)
                {
                    [view setFrame:CGRectZero];
                }
            }
        }
        else
        {
            
        }

    }
    
    if(indexPath.row == 1)
    {
        NSArray *arr = [editAndDelBtnArray objectAtIndex:indexPath.section];
        for(UIButton *btn in arr)
        {
            [cell.contentView addSubview:btn];
        }
    }
    return cell;


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
