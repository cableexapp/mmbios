//
//  B2CSearchViewController.m
//  B2C_MMB_iOS
//
//  Created by developer on 15-1-4.
//  Copyright (c) 2015年 YUANDONG. All rights reserved.
//

#import "B2CSearchViewController.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "JSONKit.h"
#import "DCFTopLabel.h"

@interface B2CSearchViewController ()
{
    UISearchBar *mySearchBar;
    UIView *speakButtonView;
    UIButton *speakButton;
}

@end

@implementation B2CSearchViewController

@synthesize tempSearchText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航栏标题
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装馆搜索"];
    self.navigationItem.titleView = top;
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width-50, 45)];
    [mySearchBar setDelegate:self];
    [mySearchBar setBarStyle:0];
    mySearchBar.backgroundColor = [UIColor whiteColor];
    mySearchBar.placeholder = @"家装馆内电线型号、品牌等";
    [self.view addSubview:mySearchBar];
    
    UIButton *rightSearchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightSearchBtn.frame = CGRectMake(mySearchBar.frame.size.width, 0, 50, 45);
    [rightSearchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightSearchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightSearchBtn addTarget:self action:@selector(rightSearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightSearchBtn.backgroundColor = [UIColor colorWithRed:201.0/255 green:201.0/255 blue:206.0/255 alpha:1.0];
    [self.view addSubview:rightSearchBtn];
    
    speakButtonView = [[UIView alloc] initWithFrame:CGRectMake(mySearchBar.frame.size.width-36, 0, 36, 45)];
    speakButtonView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:speakButtonView atIndex:2];
    
    UITapGestureRecognizer *soundSearchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(soundSrarchTap)];
    [speakButtonView addGestureRecognizer:soundSearchTap];
    
    speakButton = [[UIButton alloc] initWithFrame:CGRectMake(mySearchBar.frame.size.width-30, 12, 21, 21)];
    [speakButton setBackgroundImage:[UIImage imageNamed:@"speak"] forState:UIControlStateNormal];
    [self.view insertSubview:speakButton atIndex:1];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view isKindOfClass:[UIButton class]] || [view tag] == 101)
        {
            [view setHidden:YES];
        }
    }
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    
    //初始化语音识别控件
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyRecognizerView.delegate = self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [_iflyRecognizerView cancel];
    _iflyRecognizerView.delegate = nil;
}

-(void)rightSearchBtnClick
{
    NSLog(@"家装馆搜索");
}

-(void)soundSrarchTap
{
    NSLog(@"点击语音搜索");
    [mySearchBar resignFirstResponder];
    //启动识别服务
    [_iflyRecognizerView start];
}

//结束识别
-(void)cancelIFlyRecognizer
{
    [_iflyRecognizerView cancel];
}

//键盘手动搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"键盘手动搜索");
}

/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic)
    {
        [result appendFormat:@"%@",key];
    }
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *arrDic = (NSDictionary *)[data mutableObjectFromJSONData];
    NSString *soundInput = [[[[[arrDic objectForKey:@"ws"] objectAtIndex:0] objectForKey:@"cw"] objectAtIndex:0] objectForKey:@"w"];

    mySearchBar.text = soundInput;

    if (soundInput != nil)
    {
        [self cancelIFlyRecognizer];
        speakButtonView.hidden = YES;
        speakButton.hidden = YES;
    }
}

//识别会话错误返回代理
- (void)onError: (IFlySpeechError *) error
{
    //    [self.view addSubview:_popView];
    //    [_popView setText:@"识别结束!"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
