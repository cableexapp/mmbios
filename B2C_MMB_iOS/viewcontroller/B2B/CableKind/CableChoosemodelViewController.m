//
//  CableChoosemodelViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-9.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "CableChoosemodelViewController.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "B2BGetModelByIdData.h"
#import "AppDelegate.h"
#import "DCFStringUtil.h"
#import "B2BAskPriceCarViewController.h"

@interface CableChoosemodelViewController ()
{
    NSMutableArray *dataArray;
    
    NSMutableArray *labelArray;
    NSMutableArray *btnArray;
    
    UIButton *askPriceBtn;
    
    int allPrice;
    int addPrice;
    
    NSMutableArray *addToCarArray;  //加入询价车数组
    
    AppDelegate *app;
    
    int btnTag;
    
    int carCount;  //询价车数量
    
    int badge;
    
    BOOL flag; //判断是否是搜索状态
    
    NSMutableArray *searchArray;
    
    NSMutableArray *contentArray;
    NSMutableArray *searchLabelArray;
    NSMutableArray *searchBtnArray;
    
    UIView *rightButtonView;
    UILabel *countLabel;
}
@end

@implementation CableChoosemodelViewController

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
    rightButtonView.hidden = NO;
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    flag = NO;
    if(addToCarArray)
    {
        [addToCarArray removeAllObjects];
    }
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"InquiryCartCount",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
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
    
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLInquiryCartCountTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/InquiryCartCount.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [self loadbadgeCount];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    if(conn)
    {
        [conn stopConnection];
    }
    rightButtonView.hidden = YES;
}

-(void)loadbadgeCount
{
    //请求询价车商品数量
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"InquiryCartCount",time];
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
    
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLInquiryCartCountTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/InquiryCartCount.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"型号选择"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    searchBtnArray = [[NSMutableArray alloc] init];
    searchLabelArray = [[NSMutableArray alloc] init];
    
    addToCarArray = [[NSMutableArray alloc] init];
    
    
    rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-70, 0, 60, 44)];
    [self.navigationController.navigationBar addSubview:rightButtonView];
    
    askPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [askPriceBtn setBackgroundColor:[UIColor clearColor]];
    [askPriceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [askPriceBtn setTitle:@"询价车" forState:UIControlStateNormal];
    [askPriceBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [askPriceBtn setFrame:CGRectMake(0, 0, 60, 44)];
    [askPriceBtn addTarget:self action:@selector(askPriceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:askPriceBtn];
    
    countLabel = [[UILabel alloc] init];
    countLabel.frame = CGRectMake(46, 2, 18, 18);
    countLabel.layer.borderWidth = 1;
    countLabel.layer.cornerRadius = 10;
    countLabel.textColor = [UIColor whiteColor];
    countLabel.font = [UIFont systemFontOfSize:11];
    countLabel.textAlignment = 1;
    countLabel.hidden = YES;
    countLabel.layer.borderColor = [[UIColor clearColor] CGColor];
    countLabel.layer.backgroundColor = [[UIColor redColor] CGColor];
    [rightButtonView addSubview:countLabel];

    if(!topLabel)
    {
        topLabel = [[UILabel alloc] init];
        
        NSString *str = [NSString stringWithFormat:@" 已选分类:%@",self.myTitle];
        
        CGSize size;
        if(str.length == 0 || [str isKindOfClass:[NSNull class]])
        {
            size = CGSizeMake(ScreenWidth, 0);
        }
        else
        {
            size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:str WithSize:CGSizeMake(ScreenWidth, MAXFLOAT)];
        }
        [topLabel setFrame:CGRectMake(0, 0, ScreenWidth, size.height+10)];
        [topLabel setText:str];
        [topLabel setNumberOfLines:0];
        [topLabel setTextColor:[UIColor colorWithRed:147.0/255.0 green:125.0/255.0 blue:121.0/255.0 alpha:1.0]];
        [topLabel setFont:[UIFont systemFontOfSize:13]];
        topLabel.layer.borderColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0].CGColor;
        topLabel.layer.borderWidth = 0.8f;
        [self.view addSubview:topLabel];
    }
    
    
    if(!mySearch)
    {
        mySearch = [[UISearchBar alloc] initWithFrame:CGRectMake(0, topLabel.frame.origin.y+topLabel.frame.size.height, ScreenWidth, 44)];
        [mySearch setDelegate:self];
        [(UIView *)[mySearch.subviews objectAtIndex:0] setBackgroundColor:[UIColor clearColor]];
        [mySearch setPlaceholder:@"搜索该分类下的型号"];
        [self.view addSubview:mySearch];
    }
    
    if(!myTv)
    {
        myTv = [[UITableView alloc] initWithFrame:CGRectMake(0, mySearch.frame.origin.y + mySearch.frame.size.height , ScreenWidth, ScreenHeight-mySearch.frame.size.height-topLabel.frame.size.height-64) style:0];
        [myTv setDataSource:self];
        [myTv setDelegate:self];
        myTv.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [myTv setShowsHorizontalScrollIndicator:NO];
        [myTv setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:myTv];
    }
    
    
    [self loadRequest];
}

- (void) loadRequest
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getModelByid",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&typeid=%@",token,self.myTypeId];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetModelByidTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/getModelByid.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
    
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if(URLTag == URLGetModelByidTag)
    {
        flag = NO;
        if([[dicRespon allKeys] count] == 0)
        {
            [moreCell failAcimation];
        }
        else
        {
            if(result == 1)
            {
                
                dataArray = [[NSMutableArray alloc] initWithArray:[B2BGetModelByIdData getListArray:[dicRespon objectForKey:@"items"]]];
                
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
                [moreCell noClasses];
            }
        }
        
        if(labelArray)
        {
            [labelArray removeAllObjects];
        }
        if(btnArray)
        {
            [btnArray removeAllObjects];
        }
        if(contentArray)
        {
            [contentArray removeAllObjects];
        }
        
        labelArray = [[NSMutableArray alloc] init];
        btnArray = [[NSMutableArray alloc] init];
        contentArray = [[NSMutableArray alloc] init];
        
        for(int i=0;i<dataArray.count;i++)
        {
            NSString *text = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] theModel]];
            [contentArray addObject:text];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, ScreenWidth-100, 30)];
            [label setText:text];
            [label setFont:[UIFont systemFontOfSize:13]];
            [labelArray addObject:label];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(ScreenWidth-90, 7, 80, 30)];
            [btn setTitle:@"加入询价车" forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTag:i];
            [btn setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:142.0/255.0 blue:0/255.0 alpha:1.0]];
            btn.layer.cornerRadius = 5.0f;
            [btn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            [btnLabel setText:@"+1"];
            [btnLabel setBackgroundColor:[UIColor clearColor]];
            [btnLabel setTextColor:[UIColor redColor]];
            [btnLabel setFont:[UIFont systemFontOfSize:23]];
            [btnLabel setAlpha:0];
            [btn addSubview:btnLabel];
            
            [btnArray addObject:btn];
        }
        
        [myTv reloadData];
    }
    if(URLTag == URLJoinInquiryCartTag)
    {
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            UIButton *btn = [btnArray objectAtIndex:btnTag];
            UILabel *label = nil;
            for(UIView *view in btn.subviews)
            {
                if([view isKindOfClass:[UILabel class]])
                {
                    label = (UILabel *)view;
                }
            }
            
            [addToCarArray addObject:btn];
            
            //加入购物车动画效果
            CALayer *transitionLayer = [[CALayer alloc] init];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            transitionLayer.opacity = 1.0;
            transitionLayer.contents = label.layer.contents;
            
            //修改动画路线宽度
            transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:CGRectMake(0, 0, 20, 20) fromView:btn.titleLabel];
            [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
            [CATransaction commit];
            
            //路径曲线
            UIBezierPath *movePath = [UIBezierPath bezierPath];
            [movePath moveToPoint:transitionLayer.position];
            CGPoint toPoint = CGPointMake(ScreenWidth-askPriceBtn.center.x, askPriceBtn.center.y+20);
            [movePath addQuadCurveToPoint:toPoint
                             controlPoint:CGPointMake(ScreenWidth-askPriceBtn.center.x,transitionLayer.position.y)];
            
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
            imgView.image = img;
            [self.view addSubview:imgView];
            
            //关键帧
            CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            positionAnimation.path = movePath.CGPath;
            positionAnimation.removedOnCompletion = YES;
            //
            CAAnimationGroup *group = [CAAnimationGroup animation];
            group.beginTime = CACurrentMediaTime();
            group.duration = 0.8;
            group.animations = [NSArray arrayWithObjects:positionAnimation,nil];
            group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            group.delegate = self;
            group.fillMode = kCAFillModeForwards;
            group.removedOnCompletion = NO;
            group.autoreverses= NO;
            //
            [transitionLayer addAnimation:group forKey:@"opacity"];
            [self performSelector:@selector(addShopFinished:) withObject:transitionLayer afterDelay:1.0];
        }
        else
        {
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"加入询价车失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
    if(URLTag == URLInquiryCartCountTag)
    {
        if(result == 1)
        {
            carCount = [[dicRespon objectForKey:@"value"] intValue];
        }
        else
        {
            carCount = 0;
        }
        if(carCount > 0)
        {
            [askPriceBtn setTitle:@"询价车" forState:UIControlStateNormal];
            
        }
        else
        {
            [askPriceBtn setTitle:@"询价车" forState:UIControlStateNormal];
        }
    }
    if (URLTag == URLInquiryCartCountTag)
    {
        if ([[dicRespon objectForKey:@"value"] intValue] == 0)
        {
            countLabel.hidden = YES;
        }
        else if ([[dicRespon objectForKey:@"value"] intValue] >= 1 && [[dicRespon objectForKey:@"value"] intValue] < 99)
        {
            countLabel.hidden = NO;
            countLabel.text = [dicRespon objectForKey:@"value"];
        }
        else if ([[dicRespon objectForKey:@"value"] intValue] > 99)
        {
            countLabel.frame = CGRectMake(46, 2, 21, 19);
            countLabel.hidden = NO;
            countLabel.text = @"99+";
        }
    }
}

- (void) askPriceBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    
    B2BAskPriceCarViewController *b2bAskPriceCarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"b2bAskPriceCarViewController"];
    [self.navigationController pushViewController:b2bAskPriceCarViewController animated:YES];
}

- (void) cellBtnClick:(UIButton *) sender
{
    
    if(badge >= 50)
    {
        [DCFStringUtil showNotice:@"数目不能超过50个"];
        return;
    }
    
    btnTag = sender.tag;
    
    NSString *firstType = nil;
    NSString *secondType = nil;
    NSString *thirdType = nil;
    
    int index = 0;
    for(int i=0;i<self.myTitle.length;i++)
    {
        char c = [self.myTitle characterAtIndex:i];
        if(c == '>')
        {
            //截取第一个
            if(index == 0)
            {
                firstType = [self.myTitle substringToIndex:i];
                index = i;
            }
            else
            {
                //截取第二个
                NSRange range = NSMakeRange(index+1, i-index-1);
                secondType = [self.myTitle substringWithRange:range];
                
                //截取最后一个
                thirdType = [self.myTitle substringFromIndex:i+1];
            }
        }
    }
    
    NSString *text = nil;
    if(flag == NO)
    {
        text = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:btnTag] theModel]];
    }
    else if (flag == YES)
    {
        text = [NSString stringWithFormat:@"%@",[searchArray objectAtIndex:btnTag]];
    }
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"JoinInquiryCart",time];
    NSString *token = [DCFCustomExtra md5:string];
    
//    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    
    NSString *visitorid = [app getUdid];
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString *pushString = nil;
    if([DCFCustomExtra validateString:memberid] == YES)
    {
        pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&model=%@&firsttype=%@&secondtype=%@&thirdtype=%@",memberid,token,text,firstType,secondType,thirdType];
    }
    else
    {
        pushString = [NSString stringWithFormat:@"visitorid=%@&token=%@&model=%@&firsttype=%@&secondtype=%@&thirdtype=%@",visitorid,token,text,firstType,secondType,thirdType];
    }
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLJoinInquiryCartTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/JoinInquiryCart.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}


//加入购物车 步骤2
- (void)addShopFinished:(CALayer*)transitionLayer
{
    badge = addToCarArray.count+carCount;
    NSString *str = nil;
    if(badge <= 0)
    {
        str = @"询价车";
    }
    else
    {
//        str = [NSString stringWithFormat:@"询价车 +%d",badge];
        str = @"询价车";
        countLabel.text = [NSString stringWithFormat:@"%d",badge];
        countLabel.hidden = NO;
    }
    [askPriceBtn setTitle:str forState:UIControlStateNormal];
    
    transitionLayer.opacity = 0;
    CALayer *transitionLayer1 = [[CALayer alloc] init];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    transitionLayer1.contents = (id)askPriceBtn.layer.contents;
    transitionLayer1.frame = [[UIApplication sharedApplication].keyWindow convertRect:askPriceBtn.bounds fromView:askPriceBtn];
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer1];
    [CATransaction commit];
}

#pragma mark - searchBar
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [mySearch setShowsCancelButton:YES];
#pragma mark - 修改searchbar取消按钮
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews])
    {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchLabelArray)
    {
        [searchLabelArray removeAllObjects];
    }
    if(searchBtnArray)
    {
        [searchBtnArray removeAllObjects];
    }
    
    NSString *str = [mySearch.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(str.length == 0)
    {
        flag = NO;
    }
    else
    {
        flag = YES;
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",searchText];
        searchArray = [NSMutableArray arrayWithArray:[contentArray filteredArrayUsingPredicate:pred]];
        for(int i=0;i<searchArray.count;i++)
        {
            NSString *textString = [searchArray objectAtIndex:i];
            
            NSMutableAttributedString *mytextString = [[NSMutableAttributedString alloc] initWithString:textString];
            [mytextString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 1)];
            [mytextString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, textString.length-3)];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, ScreenWidth-100, 30)];
            [label setText:[searchArray objectAtIndex:i]];
            [label setTextColor:[UIColor redColor]];
            [label setFont:[UIFont systemFontOfSize:13]];
            [searchLabelArray addObject:label];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(ScreenWidth-90, 7, 80, 30)];
            [btn setTitle:@"加入询价车" forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [btn setTitleColor:MYCOLOR forState:UIControlStateNormal];
            [btn setTag:i];
            [btn setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
            btn.layer.borderColor = MYCOLOR.CGColor;
            btn.layer.borderWidth = 0.5f;
            btn.layer.cornerRadius = 5.0f;
            [btn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            [btnLabel setText:@"+1"];
            [btnLabel setBackgroundColor:[UIColor clearColor]];
            [btnLabel setTextColor:[UIColor redColor]];
            [btnLabel setFont:[UIFont systemFontOfSize:23]];
            [btnLabel setAlpha:0];
            [btn addSubview:btnLabel];
            
            [searchBtnArray addObject:btn];
        }
    }
    [myTv reloadData];
}

- (BOOL) searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

#pragma mark - tableview
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(flag == NO)
    {
        if(!dataArray || dataArray.count == 0)
        {
            return 1;
        }
        return dataArray.count;
    }
    if(flag == YES)
    {
        if(!searchArray || searchArray.count == 0)
        {
            return 1;
        }
        return searchArray.count;
    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(flag == NO)
    {
        if(!dataArray || dataArray.count == 0)
        {
            
            if(moreCell == nil)
            {
                moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
                [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
            }
            moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return moreCell;
        }
        
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        }
        while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
        {
            [(UIView *) CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
        }
        
        [cell.contentView addSubview:(UILabel *)[labelArray objectAtIndex:indexPath.row]];
        [cell.contentView addSubview:(UIButton *)[btnArray objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if(flag == YES)
    {
        if(!searchArray || searchArray.count == 0)
        {
            
            if(moreCell == nil)
            {
                moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
                [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
            }
            [moreCell noDataAnimation];
            moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return moreCell;
        }
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        }
        while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
            [(UIView *) CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
        }
        
        [cell.contentView addSubview:(UILabel *)[searchLabelArray objectAtIndex:indexPath.row]];
        [cell.contentView addSubview:(UIButton *)[searchBtnArray objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
