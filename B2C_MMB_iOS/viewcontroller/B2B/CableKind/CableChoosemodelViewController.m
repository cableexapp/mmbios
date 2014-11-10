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

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    if(conn)
    {
        [conn stopConnection];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"型号选择"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    
    addToCarArray = [[NSMutableArray alloc] init];
    
    askPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [askPriceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [askPriceBtn setTitle:@"询价车" forState:UIControlStateNormal];
    [askPriceBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [askPriceBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [askPriceBtn setFrame:CGRectMake(0, 0, 80, 50)];
    [askPriceBtn addTarget:self action:@selector(askPriceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:askPriceBtn];
    self.navigationItem.rightBarButtonItem = item;

    
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
   
//        [mySearch setBarStyle:UIBarStyleBlackOpaque];
        [mySearch setPlaceholder:@"搜索该分类下的型号"];
        [self.view addSubview:mySearch];
    }
    
    if(!myTv)
    {
        myTv = [[UITableView alloc] initWithFrame:CGRectMake(0, mySearch.frame.origin.y + mySearch.frame.size.height , ScreenWidth, ScreenHeight-mySearch.frame.size.height-topLabel.frame.size.height-64) style:0];
        [myTv setDataSource:self];
        [myTv setDelegate:self];
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
        
        
        labelArray = [[NSMutableArray alloc] init];
        btnArray = [[NSMutableArray alloc] init];
        for(int i=0;i<dataArray.count;i++)
        {
            NSString *text = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] theModel]];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, ScreenWidth-100, 30)];
            [label setText:text];
            [label setFont:[UIFont systemFontOfSize:13]];
            [labelArray addObject:label];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(ScreenWidth-90, 7, 80, 30)];
            [btn setTitle:@"加入询价车" forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btn setTag:i];
            [btn setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
            btn.layer.borderColor = [UIColor blueColor].CGColor;
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
            CGPoint toPoint = CGPointMake(askPriceBtn.center.x, askPriceBtn.center.y+20);
            [movePath addQuadCurveToPoint:toPoint
                             controlPoint:CGPointMake(askPriceBtn.center.x,transitionLayer.position.y)];
            
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
        NSLog(@"%@",dicRespon);
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
            [askPriceBtn setTitle:[NSString stringWithFormat:@"询价车 +%d",carCount] forState:UIControlStateNormal];
        }
        else
        {
            [askPriceBtn setTitle:@"询价车" forState:UIControlStateNormal];
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
    
    NSString *text = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:btnTag] theModel]];

    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"JoinInquiryCart",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    
    NSString *visitorid = [app getUdid];
    
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    NSString *pushString = nil;
    if(hasLogin == YES)
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
        str = [NSString stringWithFormat:@"%@",@"询价车"];
    }
    else
    {
        str = [NSString stringWithFormat:@"询价车 +%d",badge];
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
    if(!dataArray || dataArray.count == 0)
    {
        return 1;
    }
    return dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 44;

}
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
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
        [(UIView *) CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    
    [cell.contentView addSubview:(UILabel *)[labelArray objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:(UIButton *)[btnArray objectAtIndex:indexPath.row]];
    
    return cell;
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
