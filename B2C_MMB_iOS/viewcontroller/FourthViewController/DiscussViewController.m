//
//  DiscussViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-14.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "DiscussViewController.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFCustomExtra.h"
#import "LoginNaviViewController.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "UIImageView+WebCache.h"

@interface DiscussViewController ()
{
    NSMutableDictionary *dic;
    
    NSMutableArray *descriptionBtnArray;
    NSMutableArray *serviceBtnArray;
    NSMutableArray *deliveryBtnArray;
    NSMutableArray *qualityBtnArray;

    int descriptionCount;
    int serviceCount;
    int deliveryCount;
    int qualityCount;
}
@end

@implementation DiscussViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) rightBtnClick:(UIButton *) sender
{
    NSLog(@"提交");
    
    [dic setObject:@"5" forKey:@"description"];
    [dic setObject:@"4" forKey:@"service"];
    [dic setObject:@"3" forKey:@"delivery"];
    [dic setObject:@"2" forKey:@"quality"];
    [dic setObject:@"1234567" forKey:@"comment"];
    [dic setObject:@"1" forKey:@"isAnonymous"];

    NSLog(@"%@",dic);
    
    if(self.itemArray.count != 0)
    {
        [self.itemArray removeAllObjects];
        [self.itemArray addObject:dic];
    }
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"JudgeProduct",time];
    
    NSString *token = [DCFCustomExtra md5:string];
    
    NSDictionary *pushDic = [[NSDictionary alloc] initWithObjectsAndKeys:self.itemArray,@"itemList", nil];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&shopid=%@&username=%@&items=%@",token,self.shopId,[self getUserName],[self dictoJSON:pushDic]];
    NSLog(@"push = %@",pushString);
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/JudgeProduct.html?"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLJudgeProductTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];

}

- (NSString *) getUserName
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    if(userName.length == 0)
    {
        LoginNaviViewController *loginNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
    }
    return userName;
}

- (NSString *) dealPic:(NSString *) picString
{
    NSString *pic = picString;
    //.的下标
    int docIndex = pic.length-4;
    if([pic characterAtIndex:docIndex] == '.')
    {
        
        NSString *s1 = [pic substringToIndex:docIndex];
        
        NSString *s2 = [s1 stringByAppendingString:@"_100"];
        
        NSString *pre = [pic substringFromIndex:docIndex];
        
        s2 = [s2 stringByAppendingString:pre];
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,s2];
        
        pic = [NSString stringWithFormat:@"%@",has];
        
    }
    else
    {
        docIndex = pic.length - 5;
        
        NSString *s3 = [pic substringToIndex:docIndex];
        
        NSString *s4 = [s3 stringByAppendingString:@"_100"];
        
        NSString *pre = [pic substringFromIndex:docIndex];
        
        s4 = [s4 stringByAppendingString:pre];
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,s4];
        
        pic = [NSString stringWithFormat:@"%@",has];
    }
    return pic;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSLog(@"%@",self.itemArray);
    NSLog(@"%@",self.shopId);
    
    
    NSLog(@"%@",self.orderNum);
    NSLog(@"%@",self.subDateDic);
    
    [self.numberLabel setText:self.orderNum];
    
    
    //时间戳
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[self.subDateDic objectForKey:@"time"] doubleValue]/1000];

    NSString *time = [DCFCustomExtra nsdateToString:confromTimesp];
    
    [self.timeLabel setText:time];

    dic = [[NSMutableDictionary alloc] initWithDictionary:[self.itemArray lastObject]];
    
    [self.productLabel setText:[[self.itemArray lastObject] objectForKey:@"productItmeTitle"]];

    
    NSString *picString = [self dealPic:[[self.itemArray lastObject] objectForKey:@"productItemPic"]];
    NSURL *url = [NSURL URLWithString:picString];
    [self.pic setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cabel.png"]];
    
    [self pushAndPopStyle];
    
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"发布评价"];
    self.navigationItem.titleView = top;

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:11.0/255.0 green:99.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    
    
    descriptionBtnArray = [[NSMutableArray alloc] initWithObjects:self.descriptionBtn_1,self.descriptionBtn_2,self.descriptionBtn_3,self.descriptionBtn_4,self.descriptionBtn_5, nil];
    for(UIButton *btn in descriptionBtnArray)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"ratingbar_unselect.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"ratingbar_selected_low.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(descriptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    serviceBtnArray = [[NSMutableArray alloc] initWithObjects:self.attibuteBtn_1,self.attibuteBtn_2,self.attibuteBtn_3,self.attibuteBtn_4,self.attibuteBtn_5, nil];
    for(UIButton *btn in serviceBtnArray)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"ratingbar_unselect.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"ratingbar_selected_low.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(serviceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    deliveryBtnArray = [[NSMutableArray alloc] initWithObjects:self.sendBtn_1,self.sendBtn_2,self.sendBtn_3,self.sendBtn_4,self.sendBtn_5, nil];
    for(UIButton *btn in deliveryBtnArray)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"ratingbar_unselect.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"ratingbar_selected_low.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(deliveryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    qualityBtnArray = [[NSMutableArray alloc] initWithObjects:self.tradeBtn_1,self.tradeBtn_2,self.tradeBtn_3,self.tradeBtn_4,self.tradeBtn_5, nil];
    for(UIButton *btn in qualityBtnArray)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"ratingbar_unselect.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"ratingbar_selected_low.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(qualityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void) descriptionBtnClick:(UIButton *) sender
{
    for(UIButton *btn in descriptionBtnArray)
    {
        if(btn.selected == YES)
        {
            descriptionCount = descriptionCount + 1;
        }
    }
    
    if(descriptionCount >= 3)
    {
        
    }
    
}

- (void) serviceBtnClick:(UIButton *) sender
{
    
}

- (void) deliveryBtnClick:(UIButton *) sender
{
    
}

- (void) qualityBtnClick:(UIButton *) sender
{
    
}

- (NSString *)dictoJSON:(NSDictionary *)theDic
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strP = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    return [Rsa rsaEncryptString:strP];
    return strP;
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLJudgeProductTag)
    {
        NSLog(@"%@",dicRespon);
    }
}

- (IBAction)descriptionBtn_1_click:(id)sender {
}

- (IBAction)descriptionBtn_2_click:(id)sender {
}

- (IBAction)descriptionBtn_3_click:(id)sender {
}

- (IBAction)descriptionBtn_4_click:(id)sender {
}

- (IBAction)descriptionBtn_5_click:(id)sender {
}

- (IBAction)attibuteBtn_1_click:(id)sender {
}

- (IBAction)attibuteBtn_2_click:(id)sender {
}

- (IBAction)attibuteBtn_3_click:(id)sender {
}

- (IBAction)attibuteBtn_4_click:(id)sender {
}

- (IBAction)attibuteBtn_5_click:(id)sender {
}

- (IBAction)sendBtn_1_click:(id)sender {
}

- (IBAction)sendBtn_2_click:(id)sender {
}

- (IBAction)sendBtn_3_click:(id)sender {
}

- (IBAction)sendBtn_4_click:(id)sender {
}

- (IBAction)sendBtn_5_click:(id)sender {
}

- (IBAction)tradeBtn_1_click:(id)sender {
}

- (IBAction)tradeBtn_2_click:(id)sender {
}

- (IBAction)tradeBtn_3_click:(id)sender {
}

- (IBAction)tradeBtn_4_click:(id)sender {
}

- (IBAction)tradeBtn_5_click:(id)sender {
}


- (IBAction)showOrHideBtnClick:(id)sender {
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
