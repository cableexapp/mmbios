//
//  SixHostViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 15-3-25.
//  Copyright (c) 2015年 YUANDONG. All rights reserved.
//

#import "SixHostViewController.h"
#import "DCFTopLabel.h"
#import "SixHostFirstTableViewController.h"
#import "SixHostSecondTableViewController.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "JSONKit.h"
#import "DCFCustomExtra.h"
#import "MCDefine.h"
#import "SixHostSearchView.h"

@interface SixHostViewController ()
{
    UITextField *searchTextField;
    IFlyRecognizerView *iflyRecognizerView;
    
    SixHostSearchView *searchView;
}
@end

@implementation SixHostViewController

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    [iflyRecognizerView cancel];
    iflyRecognizerView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"分类"];
//    self.navigationItem.titleView = top;


    searchView = [[SixHostSearchView alloc] initWithCustomFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-64-44)];
    [searchView setBackgroundColor:[UIColor whiteColor]];
    [self.view insertSubview:searchView belowSubview:self.backView];
    
    SixHostFirstTableViewController *sixFirst = [[SixHostFirstTableViewController alloc] init];
    [self addChildViewController:sixFirst];
    sixFirst.view.frame = self.firstView.bounds;

    [self.firstView addSubview:sixFirst.view];
    
    SixHostSecondTableViewController *sixSecond = [[SixHostSecondTableViewController alloc] init];
    [self addChildViewController:sixSecond];
    sixSecond.view.frame = self.secondView.bounds;
    [self.secondView addSubview:sixSecond.view];
    
    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, self.navigationController.navigationBar.frame.size.width-20, self.navigationController.navigationBar.frame.size.height-10)];
    [self.navigationController.navigationBar addSubview:searchTextField];
    [searchTextField setPlaceholder:@"搜索内容"];
    [searchTextField setReturnKeyType:UIReturnKeyDone];
    [searchTextField setBackgroundColor:[UIColor whiteColor]];
    [searchTextField setDelegate:self];
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, searchTextField.frame.size.height-10, searchTextField.frame.size.height-10)];
    [leftView setImage:[UIImage imageNamed:@"search.png"]];
    searchTextField.leftView = leftView;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *speakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [speakBtn setBackgroundImage:[UIImage imageNamed:@"speak"] forState:UIControlStateNormal];
    [speakBtn setFrame:CGRectMake(searchTextField.frame.size.width-10-leftView.frame.size.width, 5, leftView.frame.size.width, leftView.frame.size.width)];
    [speakBtn addTarget:self action:@selector(speakBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    searchTextField.rightView = speakBtn;
    searchTextField.rightViewMode = UITextFieldViewModeAlways;
    
//    self.navigationItem.leftBarButtonItem
    
    //初始化语音识别控件
    iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    iflyRecognizerView.delegate = self;
}

- (void) speakBtnClick:(UIButton *) sender
{
    if([searchTextField isFirstResponder])
    {
        [searchTextField resignFirstResponder];
    }
    //启动识别服务
    [iflyRecognizerView start];
}

//结束识别
-(void)cancelIFlyRecognizer
{
    [iflyRecognizerView cancel];
}

#pragma mark - 语音输入回调
- (void)onResult:(NSArray *)resultArray isLast:(BOOL) isLast
{    
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic)
    {
        [result appendFormat:@"%@",key];
    }
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *arrDic = (NSDictionary *)[data mutableObjectFromJSONData];
    if([arrDic isKindOfClass:[NSNull class]] || [[arrDic allKeys] count] == 0)
    {
        NSLog(@"为空");
    }
    else
    {
        NSString *soundInput = [[[[[arrDic objectForKey:@"ws"] objectAtIndex:0] objectForKey:@"cw"] objectAtIndex:0] objectForKey:@"w"];
        NSString * str = [[NSString alloc]init];
        str = [str stringByAppendingString:soundInput];
        //去掉识别结果最后的标点符号
        if ([str isEqualToString:@"。"] || [str isEqualToString:@"？"] || [str isEqualToString:@"！"]  || [str isEqualToString:@"，"])
        {
            
        }
        else
        {
            NSLog(@"%@",str);
            //        searchBarText = str;
            //        mySearchBar.text = str;
        }
    }

}

//识别会话错误返回代理
- (void)onError: (IFlySpeechError *) error
{
    [self cancelIFlyRecognizer];
}


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view insertSubview:searchView aboveSubview:self.backView];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [searchTextField resignFirstResponder];
    [self.view insertSubview:_backView aboveSubview:searchView];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
