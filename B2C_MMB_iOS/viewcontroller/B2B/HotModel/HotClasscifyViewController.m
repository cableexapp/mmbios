//
//  HotClasscifyViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-27.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "HotClasscifyViewController.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFCustomExtra.h"
#import "AppDelegate.h"
#import "DCFStringUtil.h"
#import "B2BAskPriceCarViewController.h"
#import "ChatListViewController.h"

#define pi 3.14159265359
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

@interface HotClasscifyViewController ()
{
    int page;
    NSMutableArray *btnArray;
    UIButton *askPriceBtn;
    
    int allPrice;
    int addPrice;
    
    NSMutableArray *addToCarArray;  //加入询价车数组
    
    AppDelegate *app;
    
    NSDictionary *dic;  //plist文件字典
}
@end

@implementation HotClasscifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
    if(HUD)
    {
        [HUD hide:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController.tabBarController.tabBar setHidden:YES];
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

- (void) askPriceBtnClick:(UIButton *) sender
{
    [self setHidesBottomBarWhenPushed:YES];
    B2BAskPriceCarViewController *b2bAskPriceCarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"b2bAskPriceCarViewController"];
    [self.navigationController pushViewController:b2bAskPriceCarViewController animated:YES];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(HUD)
    {
        [HUD hide:YES];
    }
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLBatchJoinInquiryCartTag)
    {
        [DCFStringUtil showNotice:msg];
        if(result == 1)
        {
            [self setHidesBottomBarWhenPushed:YES];
            B2BAskPriceCarViewController *b2bAskPriceCarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"b2bAskPriceCarViewController"];
            [self.navigationController pushViewController:b2bAskPriceCarViewController animated:YES];

        }
        else
        {
            [DCFStringUtil showNotice:msg];
        }
        
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    addPrice = 1;
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self pushAndPopStyle];
    
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"热门型号"];
    self.navigationItem.titleView = top;
    
    addToCarArray = [[NSMutableArray alloc] init];
    
    askPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [askPriceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [askPriceBtn setTitle:@"询价车" forState:UIControlStateNormal];
    [askPriceBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [askPriceBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [askPriceBtn setFrame:CGRectMake(0, 0, 80, 50)];
    [askPriceBtn addTarget:self action:@selector(askPriceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:askPriceBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    self.addToAskPriceBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.addToAskPriceBtn.layer.borderWidth = 1.0f;
    self.addToAskPriceBtn.layer.cornerRadius = 2.0f;
    
    [_sv setContentSize:CGSizeMake(ScreenWidth*7, self.sv.frame.size.height-200)];
    [_sv setBounces:NO];
    
    
    self.hotLineBtn.layer.borderColor = [UIColor colorWithRed:51.0/255.0 green:112.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor;
    self.hotLineBtn.layer.borderWidth = 1.0f;
    self.hotLineBtn.layer.cornerRadius = 2.0f;
    
    self.imBtn.layer.borderColor = [UIColor colorWithRed:51.0/255.0 green:112.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor;
    self.imBtn.layer.borderWidth = 1.0f;
    self.imBtn.layer.cornerRadius = 2.0f;
    
    self.moreModelBtn.layer.borderColor = [UIColor colorWithRed:51.0/255.0 green:112.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor;
    self.moreModelBtn.layer.borderWidth = 1.0f;
    self.moreModelBtn.layer.cornerRadius = 2.0f;
    
    self.directBtn.layer.borderColor = [UIColor colorWithRed:51.0/255.0 green:112.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor;
    self.directBtn.layer.borderWidth = 1.0f;
    self.directBtn.layer.cornerRadius = 2.0f;
    
    btnArray = [[NSMutableArray alloc] init];
    for(UIView *view in self.sv.subviews)
    {
        if(view.frame.origin.x >= 1820)
        {
        }
        else
        {
            for(UIButton *subBtn in view.subviews)
            {
                //图片拉伸自适应
                [subBtn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                UIImage *image = [UIImage imageNamed:@"hotModelSelected.png"];
                image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 10, 10)];
                
                [subBtn setBackgroundImage:image forState:UIControlStateSelected];
                [subBtn addTarget:self action:@selector(hotModelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                [btnLabel setText:@"+1"];
                [btnLabel setBackgroundColor:[UIColor clearColor]];
                [btnLabel setTextColor:[UIColor redColor]];
                [btnLabel setFont:[UIFont systemFontOfSize:23]];
                [btnLabel setAlpha:0];
                [subBtn addSubview:btnLabel];
                
                [btnArray addObject:subBtn];
            }
        }
        
    }
    [self allKinds:btnArray];
}


#pragma mark - 所有型号的分类，一级，二级，三级
- (void) allKinds:(NSMutableArray *) arr
{
    //读取plist文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"KindsPlist" ofType:@"plist"];
    dic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
}

- (void) hotModelBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    UILabel *b = nil;
    for(UIView *view in btn.subviews)
    {
        if([view isKindOfClass:[UILabel class]])
        {
            b = (UILabel *)view;
        }
    }
    
    if(btn.selected == YES)
    {
        [addToCarArray addObject:btn];
        
//        //加入购物车动画效果
//        CALayer *transitionLayer = [[CALayer alloc] init];
//        [CATransaction begin];
//        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//        transitionLayer.opacity = 1.0;
//        transitionLayer.contents = b.layer.contents;
//        
//        //修改动画路线宽度
//        transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:CGRectMake(0, 0, 20, 20) fromView:btn.titleLabel];
//        [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
//        [CATransaction commit];
//        
//        //路径曲线
//        UIBezierPath *movePath = [UIBezierPath bezierPath];
//        [movePath moveToPoint:transitionLayer.position];
//        
//        CGPoint toPoint = CGPointMake(askPriceBtn.center.x, askPriceBtn.center.y);
//        [movePath addQuadCurveToPoint:toPoint
//                         controlPoint:CGPointMake(askPriceBtn.center.x,transitionLayer.position.y)];
//        
//        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
//        imgView.image = img;
//        [self.view addSubview:imgView];
//        //关键帧
//        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//        positionAnimation.path = movePath.CGPath;
//        positionAnimation.removedOnCompletion = YES;
//        
//        CAAnimationGroup *group = [CAAnimationGroup animation];
//        group.beginTime = CACurrentMediaTime();
//        group.duration = 0.7;
//        group.animations = [NSArray arrayWithObjects:positionAnimation,nil];
//        group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//        group.delegate = self;
//        group.fillMode = kCAFillModeForwards;
//        group.removedOnCompletion = NO;
//        group.autoreverses= NO;
//        
//        [transitionLayer addAnimation:group forKey:@"opacity"];
//        [self performSelector:@selector(addShopFinished:) withObject:transitionLayer afterDelay:0.5f];
    }
    else
    {
        [addToCarArray removeObject:btn];
        
   
    }
    
    
//    allPrice = allPrice -1;
    
    int badge = addToCarArray.count;
    NSString *str = nil;
    if(badge <= 0)
    {
        str = [NSString stringWithFormat:@"%@",@"询价车"];
    }
    else
    {
        str = [NSString stringWithFormat:@"询价车 +%i",badge];
    }
    [askPriceBtn setTitle:str forState:UIControlStateNormal];
}


//加入购物车 步骤2
//- (void)addShopFinished:(CALayer*)transitionLayer{
//    
//    transitionLayer.opacity = 0;
//
//        allPrice = allPrice + addPrice;
//        NSString *str = [NSString stringWithFormat:@"询价车 +%i",allPrice];
//        [askPriceBtn setTitle:str forState:UIControlStateNormal];
//        
//        //加入购物车动画效果
////        UILabel *addLabel = (UILabel*)[self.view viewWithTag:66];
////        [addLabel setText:[NSString stringWithFormat:@"询价车 +%i",addPrice]];
////        [addLabel  setTextColor:[UIColor redColor]];
//    
//        CALayer *transitionLayer1 = [[CALayer alloc] init];
//        [CATransaction begin];
//        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//        transitionLayer1.opacity = 1.0;
//        transitionLayer1.contents = (id)askPriceBtn.layer.contents;
//        transitionLayer1.frame = [[UIApplication sharedApplication].keyWindow convertRect:askPriceBtn.bounds fromView:askPriceBtn];
//        [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer1];
//        [CATransaction commit];
//        
//        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
//        positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(askPriceBtn.frame.origin.x+30, askPriceBtn.frame.origin.y+20)];
//        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(askPriceBtn.frame.origin.x+30, askPriceBtn.frame.origin.y)];
//        
//        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//        opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
//        opacityAnimation.toValue = [NSNumber numberWithFloat:0];
//        
//        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
//        rotateAnimation.fromValue = [NSNumber numberWithFloat:0 * M_PI];
//        rotateAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
//        
//        CAAnimationGroup *group = [CAAnimationGroup animation];
//        group.beginTime = CACurrentMediaTime();
//        group.duration = 1.5;
//        group.animations = [NSArray arrayWithObjects:positionAnimation,opacityAnimation,nil];
//        group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        group.delegate = self;
//        group.fillMode = kCAFillModeForwards;
//        group.removedOnCompletion = NO;
//        group.autoreverses= NO;
//        [transitionLayer1 addAnimation:group forKey:@"opacity"];
//}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    
}

- (NSString *)dictoJSON:(NSDictionary *)theDic
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strP = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    return [Rsa rsaEncryptString:strP];
    return strP;
}

- (IBAction)addToAskPriceCarBtnClick:(id)sender
{
    NSLog(@"加入询价车");
    
    NSLog(@"加入询价车");
    
    NSLog(@"%@",addToCarArray);
    
    
    
    if(!addToCarArray || addToCarArray.count == 0)
    {
        [DCFStringUtil showNotice:@"您尚未选择型号"];
        return;
    }
    
    NSMutableArray *modelListArray = [[NSMutableArray alloc] init];
    for(UIButton *btn in addToCarArray)
    {
        NSString *s = [btn titleLabel].text;
        
        NSDictionary *d = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:s]];
        
        NSString *oneKind = [d objectForKey:@"oneKind"];
        NSString *twoKind = [d objectForKey:@"twoKind"];
        NSString *threeKind = [d objectForKey:@"threeKind"];
        
        NSDictionary *senderDic = [[NSDictionary alloc] initWithObjectsAndKeys:s,@"model",oneKind,@"firsttype",twoKind,@"secondtype",threeKind,@"thirdtype", nil];
        
        [modelListArray addObject:senderDic];
    }

    NSDictionary *pushDic = [[NSDictionary alloc] initWithObjectsAndKeys:modelListArray,@"modellist", nil];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"BatchJoinInquiryCart",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    
    NSString *visitorid = [app getUdid];
    
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    NSString *pushString = nil;
    if(hasLogin == YES)
    {
        pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&items=%@",memberid,token,[self dictoJSON:pushDic]];
    }
    else
    {
        pushString = [NSString stringWithFormat:@"visitorid=%@&token=%@&items=%@",visitorid,token,[self dictoJSON:pushDic]];
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"正在加入询价车..."];
    [HUD setDelegate:self];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLBatchJoinInquiryCartTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/BatchJoinInquiryCart.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    

}

- (IBAction)searchBtnClick:(id)sender
{
    NSLog(@"搜索");
}

- (IBAction)nextBtnClick:(id)sender
{
    if(page >= 6)
    {
        NSLog(@"到底了");
        return;
    }
    else
    {
        page++;
        [self.sv setContentOffset:CGPointMake(ScreenWidth*page, 0) animated:YES];
    }
}

- (IBAction)upBtnClick:(id)sender
{
    if(page <= 0)
    {
        NSLog(@"到头了");
        return;
    }
    else
    {
        page--;
        [self.sv setContentOffset:CGPointMake(ScreenWidth*page, 0) animated:YES];
    }
}



- (IBAction)hotLineBtnClick:(id)sender
{
    NSLog(@"热线");
}

- (IBAction)imbtnClick:(id)sender
{
    NSLog(@"热门型号在线咨询");
    [self setHidesBottomBarWhenPushed:YES];
    ChatListViewController *chatVC = [[ChatListViewController alloc] init];
    chatVC.fromString = @"热门型号在线咨询";
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (IBAction)moreModelBtnClick:(id)sender
{
    NSLog(@"更多");
}

- (IBAction)directBtnClick:(id)sender
{
    NSLog(@"直接");
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
