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
#import "B2BAskPriceInquirySheetViewController.h"
#import "LoginNaviViewController.h"

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

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
    int deleteBtnTag;
    
    UIStoryboard *sb;
    
    UIButton *buyBtn;
    
    UIView *backView;
    
    UIButton *logBtn;
    
    UILabel *label_1;
    
    UIImageView *shopcar;
    
    UILabel *label_2;
    
    BOOL isUp_Down;
    
    UIImageView *askView;
}
@end

@implementation B2BAskPriceCarViewController

@synthesize fromString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    return memberid;
}

- (void) upBtnClick:(UIButton *) sender
{
    if([DCFCustomExtra validateString:[self getMemberId]] == NO)
    {
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
    }
    else
    {
        B2BAskPriceInquirySheetViewController *b2bAskPriceInquirySheetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"b2bAskPriceInquirySheetViewController"];
        b2bAskPriceInquirySheetViewController.dataArray = [[NSMutableArray alloc] initWithArray:chooseArray];
        b2bAskPriceInquirySheetViewController.heightArray = [[NSMutableArray alloc] initWithArray:cellHeightArray];
        [self.navigationController pushViewController:b2bAskPriceInquirySheetViewController animated:YES];
    }
}


- (void) loadRequest
{
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

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    [self setHidesBottomBarWhenPushed:YES];
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view tag] == 101 )
        {
            [view setHidden:YES];
        }
    }
    [self loadRequest];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

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
    
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"询价车"];
    self.navigationItem.titleView = top;
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(!buttomView || !upBtn || !backToHostBtn)
    {
        buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-60-64, ScreenWidth, 60)];
        [self.view addSubview:buttomView];
        
        upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [upBtn setTitle:@"提交" forState:UIControlStateNormal];
        upBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        upBtn.layer.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:142.0/255.0 blue:0/255.0 alpha:1.0].CGColor;
        upBtn.layer.cornerRadius = 5.0f;
        [upBtn setFrame:CGRectMake(15,10,ScreenWidth-30,40)];
        [upBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttomView addSubview:upBtn];
    }
    
    noCell = [[UITableViewCell alloc] init];
    [noCell.contentView setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 60)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    
    logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logBtn setTitle:@"登录" forState:UIControlStateNormal];
    [logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
    logBtn.layer.cornerRadius = 5;
    [logBtn setFrame:CGRectMake(10, 10, 70, 40)];
    [logBtn addTarget:self action:@selector(logBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    label_1 = [[UILabel alloc] initWithFrame:CGRectMake(logBtn.frame.origin.x + logBtn.frame.size.width + 15, logBtn.frame.origin.y, 200, 40)];
    [label_1 setBackgroundColor:[UIColor clearColor]];
    [label_1 setTextAlignment:NSTextAlignmentLeft];
    [label_1 setFont:[UIFont systemFontOfSize:12]];
    [label_1 setTextColor:[UIColor blackColor]];
    [label_1 setNumberOfLines:0];
    [label_1 setText:@"登录后可以同步电脑和手机端的商品,并保存在账户中"];
    
    if(!tv)
    {
        tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-buttomView.frame.size.height-64)];
        [tv setDataSource:self];
        //        tv.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
        [tv setDelegate:self];
        tv.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tv setShowsHorizontalScrollIndicator:NO];
        [tv setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:tv];
    }
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

- (void) removeSubView
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

- (void) reloadData
{
    [self loadRequest];
    [tv reloadData];
}


#pragma mark - 编辑
- (void) edit:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    
    data = [dataArray objectAtIndex:btn.tag];
    
    subViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [subViewBtn setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
#pragma mark - 防止父视图的透明度影响子视图
    [subViewBtn setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
    [subViewBtn addTarget:self action:@selector(subViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subViewBtn];
    
    
    b2bAskPriceCarEditViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"b2bAskPriceCarEditViewController"];
    b2bAskPriceCarEditViewController.myModel = data.cartModel;
    b2bAskPriceCarEditViewController.myCartId = data.cartId;
    b2bAskPriceCarEditViewController.view.layer.cornerRadius = 5;
    b2bAskPriceCarEditViewController.view.frame = CGRectMake(20, 20, subViewBtn.frame.size.width-40, subViewBtn.frame.size.height-70);
    //    UILabel *tempLabel = [[UILabel alloc] init];
    //    tempLabel.frame = CGRectMake(0, 25, b2bAskPriceCarEditViewController.view.frame.size.width, 8);
    //    tempLabel.backgroundColor = [UIColor colorWithRed:9/255.0 green:99/255.0 blue:189/255.0 alpha:1.0];
    //    [b2bAskPriceCarEditViewController.view addSubview:tempLabel];
    b2bAskPriceCarEditViewController.delegate = self;
    [self addChildViewController:b2bAskPriceCarEditViewController];
    [subViewBtn addSubview:b2bAskPriceCarEditViewController.view];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
        {
            NSString *time = [DCFCustomExtra getFirstRunTime];
            NSString *string = [NSString stringWithFormat:@"%@%@",@"DeleteInquiryCartItem",time];
            NSString *token = [DCFCustomExtra md5:string];
            
            data = [dataArray objectAtIndex:deleteBtnTag];
            NSString *pushString = [NSString stringWithFormat:@"token=%@&cartid=%@",token,[data cartId]];
            
            conn = [[DCFConnectionUtil alloc] initWithURLTag:URLDeleteInquiryCartItemTag delegate:self];
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/DeleteInquiryCartItem.html?"];
            
            
            [conn getResultFromUrlString:urlString postBody:pushString method:POST];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 删除
- (void) del:(UIButton *) sender
{
    if(chooseArray.count == 0)
    {
        //        [DCFStringUtil showNotice:@"您尚未选择商品"];
        return;
    }
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要删除嘛" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [av show];
    
    UIButton *btn = (UIButton *) sender;
    deleteBtnTag = btn.tag;
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
        
        chooseArray = [[NSMutableArray alloc] init];
        
        if(result == 1)
        {
            [dataArray addObjectsFromArray:[B2BAskPriceDetailData getListArray:[dicRespon objectForKey:@"items"]]];
            
            if(dataArray.count == 0)
            {
                [moreCell noDataAnimation];
                buyBtn.hidden = NO;
                tv.scrollEnabled = NO;
            }
            else
            {
                buyBtn.hidden = YES;
                tv.scrollEnabled = YES;
                for(int i=0;i<dataArray.count;i++)
                {
                    [chooseArray addObject:[dataArray objectAtIndex:i]];
                    
                    UIImageView *headBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
                    [headBtnIv setImage:[UIImage imageNamed:@"unchoose.png"]];
                    
                    UIButton *sectionHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    if(i == 0)
                    {
                        [sectionHeadBtn setSelected:NO];
                    }
                    else
                    {
                        [sectionHeadBtn setSelected:YES];
                    }
                    [sectionHeadBtn setTag:i];
                    [sectionHeadBtn addTarget:self action:@selector(sectionHeadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    //                    [sectionHeadBtn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                    [sectionHeadBtn setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
                    
                    //编辑删除按钮
                    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [editBtn setFrame:CGRectMake(ScreenWidth-120, 7, 50, 30)];
                    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
                    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [editBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    [editBtn setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:142.0/255.0 blue:0/255.0 alpha:1.0]];
                    [editBtn setTag:i];
                    editBtn.layer.cornerRadius = 5.0f;
                    [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [delBtn setFrame:CGRectMake(ScreenWidth-60, 7, 50, 30)];
                    [delBtn setTitle:@"删除" forState:UIControlStateNormal];
                    [delBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    [delBtn setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:142.0/255.0 blue:0/255.0 alpha:1.0]];
                    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [delBtn setTag:i];
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
                        size = CGSizeMake(ScreenWidth-20, 20);
                    }
                    else
                    {
                        size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:require WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
                    }
                    if(size.height <= 20)
                    {
                        height = 90;
                    }
                    else
                    {
                        height = size.height+70;
                    }
                    [cellHeightArray addObject:[NSNumber numberWithFloat:height]];
                    
                    //计算head高度
                    UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth-20,20)];
                    [modelLabel setText:[NSString stringWithFormat:@"型号:  %@",[[dataArray objectAtIndex:i] cartModel]]];
                    [modelLabel setFont:[UIFont systemFontOfSize:12]];
                    [sectionHeadBtn addSubview:modelLabel];
                    
                    NSString *kindString = [NSString stringWithFormat:@"分类:  %@>%@>%@",[[dataArray objectAtIndex:i] firstType],[[dataArray objectAtIndex:i] secondType],[[dataArray objectAtIndex:i] thridType]];
                    CGSize size_head = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:11] WithText:kindString WithSize:CGSizeMake(modelLabel.frame.size.width, MAXFLOAT)];
                    UILabel *kindLabel = [[UILabel alloc] initWithFrame:CGRectMake(modelLabel.frame.origin.x,modelLabel.frame.origin.y+modelLabel.frame.size.height, modelLabel.frame.size.width, size_head.height)];
                    [kindLabel setText:kindString];
                    [kindLabel setFont:[UIFont systemFontOfSize:11]];
                    [kindLabel setNumberOfLines:0];
                    [sectionHeadBtn addSubview:kindLabel];
                    
                    [sectionHeadBtn setFrame:CGRectMake(0, 0, ScreenWidth, size_head.height+30)];
                    [sectionHeadBtnArray addObject:sectionHeadBtn];
                }
                [moreCell stopAnimation];
            }
        }
        else
        {
            
            [moreCell noClasses];
        }
        
        [tv reloadData];
    }
    if(URLTag == URLDeleteInquiryCartItemTag)
    {
        if(result == 1)
        {
            int index = 0;
            for(int i=0;i<dataArray.count;i++)
            {
                B2BAskPriceDetailData *b2bData = [dataArray objectAtIndex:i];
                if([data isEqual:b2bData])
                {
                    index = i;
                    break;
                }
            }
            [chooseArray removeObject:data];
            [sectionHeadBtnArray removeObjectAtIndex:index];
            [cellHeightArray removeObjectAtIndex:index];
            [editAndDelBtnArray removeObjectAtIndex:index];
            [dataArray removeObjectAtIndex:index];
            
            [self resetBtnTag:sectionHeadBtnArray];
            [self resetBtnTag:editAndDelBtnArray];
            
            if(dataArray.count == 0)
            {
                [moreCell noDataAnimation];
                buyBtn.hidden = NO;
                tv.scrollEnabled = NO;
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

#pragma mark - 重新设置tag
- (void) resetBtnTag:(NSMutableArray *) array
{
    
    for(int i=0;i<array.count;i++)
    {
        id object = [array objectAtIndex:i];
        if([object isKindOfClass:[UIButton class]])
        {
            UIButton *b = [array objectAtIndex:i];
            [b setTag:i];
        }
        if([object isKindOfClass:[NSArray class]])
        {
            for(UIButton *btn in object)
            {
                [btn setTag:i];
            }
        }
    }
    
}

- (void) sectionHeadBtnClick:(UIButton *) sender
{
    //    if(chooseArray || chooseArray.count != 0)
    //    {
    //        [chooseArray removeAllObjects];
    //    }
    
    //    UIImageView *currentIV= (UIImageView *)[self.view viewWithTag:3000];
    //    [UIView animateWithDuration:0.3 animations:^{
    //        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    //    }];
    
    UIButton *btn = (UIButton *) sender;

    btn.selected = !btn.selected;
    //    for(UIButton *b in sectionHeadBtnArray)
    //    {
    //        if([b isEqual:btn])
    //        {
    //            [b setSelected:btn.selected];
    //            //收起
    //            if(b.selected == YES)
    //            {
    //
    //            }
    //        }
    //        else
    //        {
    //            [b setSelected:NO];
    //        }
    //    }
    [tv reloadData];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return nil;
    }
    
    UIButton *btn = (UIButton *)[sectionHeadBtnArray objectAtIndex:section];
    
    //    if (!askView)
    //    {
    //        askView = [[UIImageView alloc] init];
    //        askView.frame = CGRectMake(ScreenWidth-35, (btn.frame.size.height-25)/2, 25, 25);
    //        askView.image = [UIImage imageNamed:@"askPriceCar_arrow"];
    //        askView.tag = 3000;
    //        [btn addSubview:askView];
    //    }
    
    return btn;
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
    
    UIButton *btn = (UIButton *)[sectionHeadBtnArray objectAtIndex:section];
    return btn.frame.size.height;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == dataArray.count)
    {
        if(!dataArray || dataArray.count == 0)
        {
            return ScreenHeight-34;
        }
        else
        {
            return 0;
        }
    }
    
    
    if(indexPath.row == 0)
    {
        CGFloat height = [[cellHeightArray objectAtIndex:indexPath.section] floatValue];
        UIButton *btn = [sectionHeadBtnArray objectAtIndex:indexPath.section];
        
        if(btn.selected == NO)
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


- (UITableViewCell *) loadNonDataTableview:tableView NoIndexPath:indexPath
{
    [noCell setSelectionStyle:0];
    
    NSString *myMemberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if([DCFCustomExtra validateString:myMemberid] == NO)
    {
        [noCell.contentView addSubview:backView];
        [backView addSubview:logBtn];
        [backView addSubview:label_1];
    }
    else
    {
        if(backView)
        {
            [logBtn removeFromSuperview];
            logBtn = nil;
            [label_1 removeFromSuperview];
            label_1 = nil;
            [backView removeFromSuperview];
            backView = nil;
        }
    }
    
    if (!shopcar)
    {
        shopcar = [[UIImageView alloc] init];
        shopcar.frame = CGRectMake(20, 130, 61, 60);
        shopcar.image = [UIImage imageNamed:@"shoppingCar"];
        [noCell.contentView addSubview:shopcar];
    }
    if (!label_2)
    {
        NSString *string = @"您的询价车中暂时没有商品,现在去浏览选购电缆吧~";
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:string WithSize:CGSizeMake(200, MAXFLOAT)];
        label_2 = [[UILabel alloc] initWithFrame:CGRectMake(85, 150, 200, size.height)];
        [label_2 setBackgroundColor:[UIColor clearColor]];
        [label_2 setTextAlignment:NSTextAlignmentLeft];
        [label_2 setFont:[UIFont systemFontOfSize:15]];
        [label_2 setTextColor:[UIColor blackColor]];
        [label_2 setNumberOfLines:0];
        [label_2 setText:string];
        [noCell.contentView addSubview:label_2];
    }
    if (!buyBtn)
    {
        buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [buyBtn setFrame:CGRectMake(90, label_2.frame.origin.y + label_2.frame.size.height + 50, 140, 43)];
        [buyBtn setTitle:@"去首页看看" forState:UIControlStateNormal];
        buyBtn.backgroundColor = [UIColor whiteColor];
        buyBtn.layer.cornerRadius = 5.0f;
        [buyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [noCell addSubview:buyBtn];

    }

    buttomView.hidden = YES;
    tv.scrollEnabled = NO;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return noCell;
}

-(void)logBtnClick
{
    LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
    [self presentViewController:loginNavi animated:YES completion:nil];
}

-(void)buyBtnClick
{
    if ([self.fromString isEqualToString:@"首页"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([self.fromString isEqualToString:@"我的买卖宝"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"mmb" forKey:@"frommmb"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([self.fromString isEqualToString:@"更多"])
    {
         [[NSUserDefaults standardUserDefaults] setObject:@"mmb" forKey:@"frommore"];
         [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([self.fromString isEqualToString:@"未登录"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"mmb" forKey:@"fromhasnologin"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == dataArray.count)
    {
        return [self loadNonDataTableview:tableView NoIndexPath:indexPath];
    }
    
    [buttomView setHidden:NO];
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    {
        [(UIView *) CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    
    if(indexPath.row == 0)
    {
        CGFloat halfWidth = cell.contentView.frame.size.width/2+10;
        
        NSString *num;
        if([DCFCustomExtra validateString:[[dataArray objectAtIndex:indexPath.section] num]] == NO || [[[dataArray objectAtIndex:indexPath.section] num] floatValue] <= 0.0)
        {
            num = [NSString stringWithFormat:@"数量 "];
        }
        else
        {
            num = [NSString stringWithFormat:@"数量 %@%@",[[dataArray objectAtIndex:indexPath.section] num],[[dataArray objectAtIndex:indexPath.section] unit]];
        }
        
        NSString *deliver;
        if([DCFCustomExtra validateString:[[dataArray objectAtIndex:indexPath.section] deliver]] == NO || [[[dataArray objectAtIndex:indexPath.section] deliver] floatValue] <= 0.0)
        {
            deliver = [NSString stringWithFormat:@"交货期 "];
        }
        else
        {
            deliver = [NSString stringWithFormat:@"交货期 %@天",[[dataArray objectAtIndex:indexPath.section] deliver]];
        }
        NSString *cartSpec = [NSString stringWithFormat:@"规格 %@平方",[[dataArray objectAtIndex:indexPath.section] cartSpec]];  //规格
        NSString *cartVoltage = [NSString stringWithFormat:@"电压 %@",[[dataArray objectAtIndex:indexPath.section] cartVoltage]];
        NSString *color = [NSString stringWithFormat:@"颜色 %@",[[dataArray objectAtIndex:indexPath.section] cartColor]];
        NSString *featureone = [NSString stringWithFormat:@"阻燃特性 %@",[[dataArray objectAtIndex:indexPath.section] featureone]];  //阻燃特性
        NSString *require = [NSString stringWithFormat:@"特殊要求 %@",[[dataArray objectAtIndex:indexPath.section] require]];
        
        NSMutableAttributedString *myNum = [[NSMutableAttributedString alloc] initWithString:num];
        [myNum addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
        [myNum addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, num.length-3)];
        
        NSMutableAttributedString *myDeliver = [[NSMutableAttributedString alloc] initWithString:deliver];
        [myDeliver addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
        [myDeliver addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(4, deliver.length-4)];
        
        NSMutableAttributedString *myCartSpec = [[NSMutableAttributedString alloc] initWithString:cartSpec];
        [myCartSpec addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
        [myCartSpec addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, cartSpec.length-3)];
        
        NSMutableAttributedString *myCartVoltage = [[NSMutableAttributedString alloc] initWithString:cartVoltage];
        [myCartVoltage addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
        [myCartVoltage addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, cartVoltage.length-3)];
        
        NSMutableAttributedString *myColor = [[NSMutableAttributedString alloc] initWithString:color];
        [myColor addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
        [myColor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, color.length-3)];
        
        NSMutableAttributedString *myFeatureone = [[NSMutableAttributedString alloc] initWithString:featureone];
        [myFeatureone addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
        [myFeatureone addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, featureone.length-5)];
        
        NSMutableAttributedString *myRequire = [[NSMutableAttributedString alloc] initWithString:require];
        [myRequire addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
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
                if([DCFCustomExtra validateString:[[dataArray objectAtIndex:indexPath.section] num]] == NO)
                {
                    [cellLabel setText:@"数量"];
                }
                else
                {
                    [cellLabel setAttributedText:myNum];
                }
            }
            if(i == 1)
            {
                [cellLabel setFrame:CGRectMake(halfWidth, 5, size_2.width, 20)];
                if([DCFCustomExtra validateString:[[dataArray objectAtIndex:indexPath.section] deliver]] == NO)
                {
                    [cellLabel setText:@"交货期"];
                }
                else
                {
                    [cellLabel setAttributedText:myDeliver];
                }
            }
            if(i == 2)
            {
                [cellLabel setFrame:CGRectMake(10, 25, size_3.width, 20)];
                if([DCFCustomExtra validateString:[[dataArray objectAtIndex:indexPath.section] cartSpec]] == NO)
                {
                    [cellLabel setText:@"规格"];
                }
                else
                {
                    [cellLabel setAttributedText:myCartSpec];
                }
                
            }
            if(i == 3)
            {
                [cellLabel setFrame:CGRectMake(halfWidth, 25, size_4.width, 20)];
                if([DCFCustomExtra validateString:[[dataArray objectAtIndex:indexPath.section] cartVoltage]] == NO)
                {
                    [cellLabel setText:@"电压"];
                }
                else
                {
                    [cellLabel setAttributedText:myCartVoltage];
                }
            }
            if(i == 4)
            {
                [cellLabel setFrame:CGRectMake(10, 45, size_5.width, 20)];
                if([DCFCustomExtra validateString:[[dataArray objectAtIndex:indexPath.section] cartColor]] == NO)
                {
                    [cellLabel setText:@"颜色"];
                }
                else
                {
                    [cellLabel setAttributedText:myColor];
                }
            }
            if(i == 5)
            {
                [cellLabel setFrame:CGRectMake(halfWidth, 45, size_6.width, 20)];
                if([DCFCustomExtra validateString:[[dataArray objectAtIndex:indexPath.section] featureone]] == NO)
                {
                    [cellLabel setText:@"阻燃特性"];
                }
                else
                {
                    [cellLabel setAttributedText:myFeatureone];
                }
            }
            if(i == 6)
            {
                [cellLabel setFrame:CGRectMake(10, 65, cell.contentView.frame.size.width-20, size_7.height)];
                if([DCFCustomExtra validateString:[[dataArray objectAtIndex:indexPath.section] require]] == NO)
                {
                    [cellLabel setText:@"特殊需求"];
                }
                else
                {
                    [cellLabel setAttributedText:myRequire];
                }
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
                for(UIView *view in cell.contentView.subviews)
                {
                    [view setFrame:CGRectZero];
                }
            }
            else
            {
                
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
}

@end
