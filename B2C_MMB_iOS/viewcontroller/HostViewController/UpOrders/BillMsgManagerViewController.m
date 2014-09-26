//
//  BillMsgManagerViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-26.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "BillMsgManagerViewController.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"

@interface BillMsgManagerViewController ()
{
    NSMutableArray *billBtnArray;
    NSMutableArray *billHeadBtnArray;
    
    DCFMyTextField *tf;
}
@end

@implementation BillMsgManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) billBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    int tag = btn.tag;
    btn.selected = !btn.selected;
    for(UIButton *btn in billBtnArray)
    {
        if(btn.tag == tag)
        {
            
        }
        else
        {
            [btn setSelected:NO];
        }
    }
}

- (void) billHeadBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    int tag = btn.tag;
    btn.selected = !btn.selected;
    for(UIButton *btn in billHeadBtnArray)
    {
        if(btn.tag == tag)
        {
            
        }
        else
        {
            [btn setSelected:NO];
        }
    }
}

- (void) sure:(UIButton *) sender
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"发票信息管理"];
    self.navigationItem.titleView = top;
    
    billBtnArray = [[NSMutableArray alloc] init];
    billHeadBtnArray = [[NSMutableArray alloc] init];
    
    for(int i=0;i<9;i++)
    {
        if(i <= 1)
        {
            UIButton *billBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [billBtn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
            [billBtn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
            [billBtn setSelected:NO];
            [billBtn setFrame:CGRectMake(10, 10+40*i, 30, 30)];
            [billBtn addTarget:self action:@selector(billBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [billBtnArray addObject:billBtn];
            [billBtn setTag:i];
            [self.view addSubview:billBtn];
            
            UILabel *billLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10+40*i, 200, 30)];
            if(i == 0)
            {
                [billLabel setText:@"不需要发票"];
            }
            else if (i == 1)
            {
                [billLabel setText:@"需要发票"];
            }
            [billLabel setFont:[UIFont systemFontOfSize:13]];
            [billLabel setTextAlignment:NSTextAlignmentLeft];
            [self.view addSubview:billLabel];
        }
        if(i > 1 && i <=3)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 90+40*(i-2), 300, 30)];
            if(i == 2)
            {
                [label setText:@"发票类型:普通发票"];
            }
            else if (i == 3)
            {
                [label setText:@"发票抬头:"];
            }
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setFont:[UIFont systemFontOfSize:13]];
            [self.view addSubview:label];
        }
        if(i > 3 && i <= 5)
        {
            UIButton *billHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [billHeadBtn setFrame:CGRectMake(10, 170+40*(i-4), 30, 30)];
            [billHeadBtn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
            [billHeadBtn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
            [billHeadBtn setSelected:NO];
            [billHeadBtn setTag:i];
            [billHeadBtn addTarget:self action:@selector(billHeadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [billHeadBtnArray addObject:billHeadBtn];
            [self.view addSubview:billHeadBtn];
            
            UILabel *billHeadLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 170+40*(i-4), 200, 30)];
            [billHeadLabel setTextAlignment:NSTextAlignmentLeft];
            if(i == 4)
            {
                [billHeadLabel setText:@"个人"];
            }
            else if (i == 5)
            {
                [billHeadLabel setText:@"单位"];
            }
            [billHeadLabel setFont:[UIFont systemFontOfSize:13]];
            [self.view addSubview:billHeadLabel];
        }
        if(i == 6)
        {
            tf = [[DCFMyTextField alloc] initWithFrame:CGRectMake(10, 250, 300, 30)];
            [tf setDelegate:self];
            [tf setReturnKeyType:UIReturnKeyDone];
            [tf setPlaceholder:@"请输入单位名称"];
            [self.view addSubview:tf];
        }
        if(i == 7)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 290, 300, 30)];
            [label setText:@"发票内容:您所购买的商品明细"];
            [label setFont:[UIFont systemFontOfSize:13]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [self.view addSubview:label];
        }
        if(i == 8)
        {
            UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
            [sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
            sureBtn.layer.borderColor = [UIColor blueColor].CGColor;
            sureBtn.layer.borderWidth = 1.0f;
            sureBtn.layer.cornerRadius = 5.0f;
            [self.view addSubview:sureBtn];
        }
    }
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    [tf resignFirstResponder];
    [self dismissKeyBoard];
}

- (void) dismissKeyBoard
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.view setFrame:CGRectMake(0, 64, 320, ScreenHeight)];
    [UIView commitAnimations];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.view setFrame:CGRectMake(0, -64, 320, ScreenHeight)];
    [UIView commitAnimations];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self dismissKeyBoard];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
