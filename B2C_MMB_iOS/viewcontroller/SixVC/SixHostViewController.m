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

@interface SixHostViewController ()
{
    UITextField *textField;
    IFlyRecognizerView *iflyRecognizerView;
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
    
    SixHostFirstTableViewController *sixFirst = [[SixHostFirstTableViewController alloc] init];
    [self addChildViewController:sixFirst];
    sixFirst.view.frame = self.firstView.bounds;

    [self.firstView addSubview:sixFirst.view];
    
    SixHostSecondTableViewController *sixSecond = [[SixHostSecondTableViewController alloc] init];
    [self addChildViewController:sixSecond];
    sixSecond.view.frame = self.secondView.bounds;
    [self.secondView addSubview:sixSecond.view];
    
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, self.navigationController.navigationBar.frame.size.width-20, self.navigationController.navigationBar.frame.size.height-10)];
    [self.navigationController.navigationBar addSubview:textField];
    [textField setPlaceholder:@"搜索内容"];
    [textField setBackgroundColor:[UIColor whiteColor]];
    
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, textField.frame.size.height-10, textField.frame.size.height-10)];
    [leftView setImage:[UIImage imageNamed:@"search.png"]];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *speakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [speakBtn setBackgroundImage:[UIImage imageNamed:@"speak"] forState:UIControlStateNormal];
    [speakBtn setFrame:CGRectMake(textField.frame.size.width-10-leftView.frame.size.width, 5, leftView.frame.size.width, leftView.frame.size.width)];
    [speakBtn addTarget:self action:@selector(speakBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    textField.rightView = speakBtn;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
//    self.navigationItem.leftBarButtonItem
    
    //初始化语音识别控件
    iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    iflyRecognizerView.delegate = self;
}

- (void) speakBtnClick:(UIButton *) sender
{
    if([textField isFirstResponder])
    {
        [textField resignFirstResponder];
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
