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
#import "DCFStringUtil.h"

@interface DiscussViewController ()
{
    NSMutableDictionary *dic;
    
    NSMutableArray *descriptionBtnArray;
    NSMutableArray *serviceBtnArray;
    NSMutableArray *deliveryBtnArray;
    NSMutableArray *qualityBtnArray;
    
    NSMutableArray *btnPicUnSelectArray;
    NSMutableArray *btnPicLowArray;
    NSMutableArray *btnPicHightArray;

    int descriptionCount;
    int serviceCount;
    int deliveryCount;
    int qualityCount;
    
    UIImageView *btnPicUnSelect;
    UIImageView *btnPicLow;
    UIImageView *btnPicHight;
    
    
    BOOL isAnonymousFlag;
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
    
    [dic setObject:[NSString stringWithFormat:@"%d",descriptionCount] forKey:@"description"];
    [dic setObject:[NSString stringWithFormat:@"%d",serviceCount] forKey:@"service"];
    [dic setObject:[NSString stringWithFormat:@"%d",deliveryCount] forKey:@"delivery"];
    [dic setObject:[NSString stringWithFormat:@"%d",qualityCount] forKey:@"quality"];
    [dic setObject:self.textView.text forKey:@"comment"];
    [dic setObject:[NSString stringWithFormat:@"%d",isAnonymousFlag] forKey:@"isAnonymous"];
    
    
    if(self.itemArray.count != 0)
    {
        [self.itemArray removeAllObjects];
        [self.itemArray addObject:dic];
    }
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"JudgeProduct",time];
    
    NSString *token = [DCFCustomExtra md5:string];
    
    NSDictionary *pushDic = [[NSDictionary alloc] initWithObjectsAndKeys:self.itemArray,@"itemList", nil];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&shopid=%@&username=%@&ordernum=%@&items=%@",token,self.shopId,[self getUserName],self.orderNum,[self dictoJSON:pushDic]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/JudgeProduct.html?"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLJudgeProductTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
}

- (NSString *) getUserName
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    if(userName.length == 0)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
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
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_PIC_DEV,s2];
        
        pic = [NSString stringWithFormat:@"%@",has];
        
    }
    else
    {
        docIndex = pic.length - 5;
        
        NSString *s3 = [pic substringToIndex:docIndex];
        
        NSString *s4 = [s3 stringByAppendingString:@"_100"];
        
        NSString *pre = [pic substringFromIndex:docIndex];
        
        s4 = [s4 stringByAppendingString:pre];
        
        NSString *has = [NSString stringWithFormat:@"%@%@",URL_PIC_DEV,s4];
        
        pic = [NSString stringWithFormat:@"%@",has];
    }
    return pic;
}




- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, -40, ScreenWidth, ScreenHeight)];
    [UIView commitAnimations];
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    
}

- (void) textViewDidChange:(UITextView *)textView
{
    
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if([text isEqualToString:@"\n"])
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        [self.view setFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
        [UIView commitAnimations];
        

        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self.numberLabel setText:self.orderNum];
    
    self.view.backgroundColor = [UIColor whiteColor];

//    self.numberLabel.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
//    self.timeLabel.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
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
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    btnPicUnSelectArray = [[NSMutableArray alloc] init];
    btnPicLowArray = [[NSMutableArray alloc] init];
    btnPicHightArray = [[NSMutableArray alloc] init];
    
    for(int i=0;i<20;i++)
    {
        btnPicUnSelect = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.descriptionBtn_1.frame.size.width, self.descriptionBtn_1.frame.size.height)];
        [btnPicUnSelect setImage:[UIImage imageNamed:@"ratingbar_unselect.png"]];
        [btnPicUnSelect setContentMode:UIViewContentModeScaleAspectFit];
        [btnPicUnSelectArray addObject:btnPicUnSelect];
        
        btnPicLow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.descriptionBtn_1.frame.size.width, self.descriptionBtn_1.frame.size.height)];
        [btnPicLow setImage:[UIImage imageNamed:@"ratingbar_selected_low.png"]];
        [btnPicLow setContentMode:UIViewContentModeScaleAspectFit];
        [btnPicLowArray addObject:btnPicLow];
        
        btnPicHight = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.descriptionBtn_1.frame.size.width, self.descriptionBtn_1.frame.size.height)];
        [btnPicHight setImage:[UIImage imageNamed:@"ratingbar_selected.png"]];
        [btnPicHight setContentMode:UIViewContentModeScaleAspectFit];
        [btnPicHightArray addObject:btnPicHight];
    }
    
    descriptionBtnArray = [[NSMutableArray alloc] initWithObjects:self.descriptionBtn_1,self.descriptionBtn_2,self.descriptionBtn_3,self.descriptionBtn_4,self.descriptionBtn_5, nil];

    for(int i=0;i<descriptionBtnArray.count;i++)
    {
        UIButton *btn = [descriptionBtnArray objectAtIndex:i];
        [btn addSubview:[btnPicUnSelectArray objectAtIndex:i]];
    }

    serviceBtnArray = [[NSMutableArray alloc] initWithObjects:self.attibuteBtn_1,self.attibuteBtn_2,self.attibuteBtn_3,self.attibuteBtn_4,self.attibuteBtn_5, nil];
    
    for(int i=0;i<serviceBtnArray.count;i++)
    {
        UIButton *btn = [serviceBtnArray objectAtIndex:i];
        [btn addSubview:[btnPicUnSelectArray objectAtIndex:i+5]];
    }
    
    
    deliveryBtnArray = [[NSMutableArray alloc] initWithObjects:self.sendBtn_1,self.sendBtn_2,self.sendBtn_3,self.sendBtn_4,self.sendBtn_5, nil];
    
    for(int i=0;i<deliveryBtnArray.count;i++)
    {
        UIButton *btn = [deliveryBtnArray objectAtIndex:i];
        [btn addSubview:[btnPicUnSelectArray objectAtIndex:i+10]];
    }
    
    
    qualityBtnArray = [[NSMutableArray alloc] initWithObjects:self.tradeBtn_1,self.tradeBtn_2,self.tradeBtn_3,self.tradeBtn_4,self.tradeBtn_5, nil];
    
    for(int i=0;i<qualityBtnArray.count;i++)
    {
        UIButton *btn = [qualityBtnArray objectAtIndex:i];
        [btn addSubview:[btnPicUnSelectArray objectAtIndex:i+15]];
    }
    
    [self.showOrHideBtn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
    [self.showOrHideBtn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
    self.showOrHideBtn.selected = YES;
    isAnonymousFlag = YES;
}

//- (void) descriptionBtnClick:(UIButton *) sender
//{
//    descriptionCount = 0;
//    int tag = sender.tag;
//    for(UIButton *btn in descriptionBtnArray)
//    {
//        if(tag <= 1)
//        {
//            [btn setBackgroundImage:[UIImage imageNamed:@"ratingbar_selected_low.png"] forState:UIControlStateNormal];
//            descriptionCount++;
//        }
//        else
//        {
//            [btn setBackgroundImage:[UIImage imageNamed:@"ratingbar_unselect.png"] forState:UIControlStateNormal];
//        }
//    }
//    NSLog(@"descriptionCount = %d",descriptionCount);
//}
//
//- (void) serviceBtnClick:(UIButton *) sender
//{
//    
//}
//
//- (void) deliveryBtnClick:(UIButton *) sender
//{
//    
//}
//
//- (void) qualityBtnClick:(UIButton *) sender
//{
//    
//}

//字典转字符串
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
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    [UIView commitAnimations];
    
    [self.textView resignFirstResponder];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if(URLTag == URLJudgeProductTag)
    {
        if(result == 1)
        {
            [DCFStringUtil showNotice:@"评价成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"评价失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
}

- (void) removeBtnSubview:(NSMutableArray *) array
{
    for(UIButton *btn in array)
    {
        for(UIView *view in btn.subviews)
        {
            [view removeFromSuperview];
        }
    }
}

- (void) changeCount:(int) changecount WithLabel:(UILabel *) changeLabel
{
    [changeLabel setText:[NSString stringWithFormat:@"%d分",changecount]];
}

- (IBAction)descriptionBtn_1_click:(id)sender
{
    [self removeBtnSubview:descriptionBtnArray];
    
    [self.descriptionBtn_1 addSubview:[btnPicLowArray objectAtIndex:0]];
    [self.descriptionBtn_2 addSubview:[btnPicUnSelectArray objectAtIndex:1]];
    [self.descriptionBtn_3 addSubview:[btnPicUnSelectArray objectAtIndex:2]];
    [self.descriptionBtn_4 addSubview:[btnPicUnSelectArray objectAtIndex:3]];
    [self.descriptionBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:4]];

    descriptionCount = 1;
    
    [self changeCount:descriptionCount WithLabel:self.descriptionBtn_label];
}

- (IBAction)descriptionBtn_2_click:(id)sender
{
    [self removeBtnSubview:descriptionBtnArray];
    
    [self.descriptionBtn_1 addSubview:[btnPicLowArray objectAtIndex:0]];
    [self.descriptionBtn_2 addSubview:[btnPicLowArray objectAtIndex:1]];
    [self.descriptionBtn_3 addSubview:[btnPicUnSelectArray objectAtIndex:2]];
    [self.descriptionBtn_4 addSubview:[btnPicUnSelectArray objectAtIndex:3]];
    [self.descriptionBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:4]];
    
    descriptionCount = 2;
    
    [self changeCount:descriptionCount WithLabel:self.descriptionBtn_label];
}

- (IBAction)descriptionBtn_3_click:(id)sender
{
    [self removeBtnSubview:descriptionBtnArray];
    
    [self.descriptionBtn_1 addSubview:[btnPicHightArray objectAtIndex:0]];
    [self.descriptionBtn_2 addSubview:[btnPicHightArray objectAtIndex:1]];
    [self.descriptionBtn_3 addSubview:[btnPicHightArray objectAtIndex:2]];
    [self.descriptionBtn_4 addSubview:[btnPicUnSelectArray objectAtIndex:3]];
    [self.descriptionBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:4]];
    
    descriptionCount = 3;
    
    [self changeCount:descriptionCount WithLabel:self.descriptionBtn_label];
}

- (IBAction)descriptionBtn_4_click:(id)sender
{
    [self removeBtnSubview:descriptionBtnArray];
    
    [self.descriptionBtn_1 addSubview:[btnPicHightArray objectAtIndex:0]];
    [self.descriptionBtn_2 addSubview:[btnPicHightArray objectAtIndex:1]];
    [self.descriptionBtn_3 addSubview:[btnPicHightArray objectAtIndex:2]];
    [self.descriptionBtn_4 addSubview:[btnPicHightArray objectAtIndex:3]];
    [self.descriptionBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:4]];
    
    descriptionCount = 4;
    
    [self changeCount:descriptionCount WithLabel:self.descriptionBtn_label];
}

- (IBAction)descriptionBtn_5_click:(id)sender
{
    [self removeBtnSubview:descriptionBtnArray];
    
    [self.descriptionBtn_1 addSubview:[btnPicHightArray objectAtIndex:0]];
    [self.descriptionBtn_2 addSubview:[btnPicHightArray objectAtIndex:1]];
    [self.descriptionBtn_3 addSubview:[btnPicHightArray objectAtIndex:2]];
    [self.descriptionBtn_4 addSubview:[btnPicHightArray objectAtIndex:3]];
    [self.descriptionBtn_5 addSubview:[btnPicHightArray objectAtIndex:4]];
    
    descriptionCount = 5;
    
    [self changeCount:descriptionCount WithLabel:self.descriptionBtn_label];
}

- (IBAction)attibuteBtn_1_click:(id)sender
{
    [self removeBtnSubview:serviceBtnArray];
    
    [self.attibuteBtn_1 addSubview:[btnPicLowArray objectAtIndex:5]];
    [self.attibuteBtn_2 addSubview:[btnPicUnSelectArray objectAtIndex:6]];
    [self.attibuteBtn_3 addSubview:[btnPicUnSelectArray objectAtIndex:7]];
    [self.attibuteBtn_4 addSubview:[btnPicUnSelectArray objectAtIndex:8]];
    [self.attibuteBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:9]];
    
    serviceCount = 1;
    
    [self changeCount:serviceCount WithLabel:self.attibuteBtn_label];
}

- (IBAction)attibuteBtn_2_click:(id)sender
{
    [self removeBtnSubview:serviceBtnArray];
    
    [self.attibuteBtn_1 addSubview:[btnPicLowArray objectAtIndex:5]];
    [self.attibuteBtn_2 addSubview:[btnPicLowArray objectAtIndex:6]];
    [self.attibuteBtn_3 addSubview:[btnPicUnSelectArray objectAtIndex:7]];
    [self.attibuteBtn_4 addSubview:[btnPicUnSelectArray objectAtIndex:8]];
    [self.attibuteBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:9]];
    
    serviceCount = 2;
    
    [self changeCount:serviceCount WithLabel:self.attibuteBtn_label];
}

- (IBAction)attibuteBtn_3_click:(id)sender
{
    [self removeBtnSubview:serviceBtnArray];
    
    [self.attibuteBtn_1 addSubview:[btnPicHightArray objectAtIndex:5]];
    [self.attibuteBtn_2 addSubview:[btnPicHightArray objectAtIndex:6]];
    [self.attibuteBtn_3 addSubview:[btnPicHightArray objectAtIndex:7]];
    [self.attibuteBtn_4 addSubview:[btnPicUnSelectArray objectAtIndex:8]];
    [self.attibuteBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:9]];
    
    serviceCount = 3;
    
    [self changeCount:serviceCount WithLabel:self.attibuteBtn_label];
}

- (IBAction)attibuteBtn_4_click:(id)sender
{
    [self removeBtnSubview:serviceBtnArray];
    
    [self.attibuteBtn_1 addSubview:[btnPicHightArray objectAtIndex:5]];
    [self.attibuteBtn_2 addSubview:[btnPicHightArray objectAtIndex:6]];
    [self.attibuteBtn_3 addSubview:[btnPicHightArray objectAtIndex:7]];
    [self.attibuteBtn_4 addSubview:[btnPicHightArray objectAtIndex:8]];
    [self.attibuteBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:9]];
    
    serviceCount = 4;
    
    [self changeCount:serviceCount WithLabel:self.attibuteBtn_label];
}

- (IBAction)attibuteBtn_5_click:(id)sender
{
    [self removeBtnSubview:serviceBtnArray];
    
    [self.attibuteBtn_1 addSubview:[btnPicHightArray objectAtIndex:5]];
    [self.attibuteBtn_2 addSubview:[btnPicHightArray objectAtIndex:6]];
    [self.attibuteBtn_3 addSubview:[btnPicHightArray objectAtIndex:7]];
    [self.attibuteBtn_4 addSubview:[btnPicHightArray objectAtIndex:8]];
    [self.attibuteBtn_5 addSubview:[btnPicHightArray objectAtIndex:9]];
    
    serviceCount = 5;
    
    [self changeCount:serviceCount WithLabel:self.attibuteBtn_label];
}

- (IBAction)sendBtn_1_click:(id)sender
{
    [self removeBtnSubview:deliveryBtnArray];
    
    [self.sendBtn_1 addSubview:[btnPicLowArray objectAtIndex:10]];
    [self.sendBtn_2 addSubview:[btnPicUnSelectArray objectAtIndex:11]];
    [self.sendBtn_3 addSubview:[btnPicUnSelectArray objectAtIndex:12]];
    [self.sendBtn_4 addSubview:[btnPicUnSelectArray objectAtIndex:13]];
    [self.sendBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:14]];
    
    deliveryCount = 1;
    
    [self changeCount:deliveryCount WithLabel:self.sendBtn_label];
}

- (IBAction)sendBtn_2_click:(id)sender
{
    [self removeBtnSubview:deliveryBtnArray];
    
    [self.sendBtn_1 addSubview:[btnPicLowArray objectAtIndex:10]];
    [self.sendBtn_2 addSubview:[btnPicLowArray objectAtIndex:11]];
    [self.sendBtn_3 addSubview:[btnPicUnSelectArray objectAtIndex:12]];
    [self.sendBtn_4 addSubview:[btnPicUnSelectArray objectAtIndex:13]];
    [self.sendBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:14]];
    
    deliveryCount = 2;
    
    [self changeCount:deliveryCount WithLabel:self.sendBtn_label];
}

- (IBAction)sendBtn_3_click:(id)sender
{
    [self removeBtnSubview:deliveryBtnArray];
    
    [self.sendBtn_1 addSubview:[btnPicHightArray objectAtIndex:10]];
    [self.sendBtn_2 addSubview:[btnPicHightArray objectAtIndex:11]];
    [self.sendBtn_3 addSubview:[btnPicHightArray objectAtIndex:12]];
    [self.sendBtn_4 addSubview:[btnPicUnSelectArray objectAtIndex:13]];
    [self.sendBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:14]];
    
    deliveryCount = 3;
    
    [self changeCount:deliveryCount WithLabel:self.sendBtn_label];
}

- (IBAction)sendBtn_4_click:(id)sender
{
    [self removeBtnSubview:deliveryBtnArray];
    
    [self.sendBtn_1 addSubview:[btnPicHightArray objectAtIndex:10]];
    [self.sendBtn_2 addSubview:[btnPicHightArray objectAtIndex:11]];
    [self.sendBtn_3 addSubview:[btnPicHightArray objectAtIndex:12]];
    [self.sendBtn_4 addSubview:[btnPicHightArray objectAtIndex:13]];
    [self.sendBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:14]];
    
    deliveryCount = 4;
    
    [self changeCount:deliveryCount WithLabel:self.sendBtn_label];
}

- (IBAction)sendBtn_5_click:(id)sender
{
    [self removeBtnSubview:deliveryBtnArray];
    
    [self.sendBtn_1 addSubview:[btnPicHightArray objectAtIndex:10]];
    [self.sendBtn_2 addSubview:[btnPicHightArray objectAtIndex:11]];
    [self.sendBtn_3 addSubview:[btnPicHightArray objectAtIndex:12]];
    [self.sendBtn_4 addSubview:[btnPicHightArray objectAtIndex:13]];
    [self.sendBtn_5 addSubview:[btnPicHightArray objectAtIndex:14]];
    
    deliveryCount = 5;
    
    [self changeCount:deliveryCount WithLabel:self.sendBtn_label];
}

- (IBAction)tradeBtn_1_click:(id)sender
{
    [self removeBtnSubview:qualityBtnArray];
    
    [self.tradeBtn_1 addSubview:[btnPicLowArray objectAtIndex:15]];
    [self.tradeBtn_2 addSubview:[btnPicUnSelectArray objectAtIndex:16]];
    [self.tradeBtn_3 addSubview:[btnPicUnSelectArray objectAtIndex:17]];
    [self.tradeBtn_4 addSubview:[btnPicUnSelectArray objectAtIndex:18]];
    [self.tradeBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:19]];
    
    qualityCount = 1;
    
    [self changeCount:qualityCount WithLabel:self.tradeBtn_label];
}

- (IBAction)tradeBtn_2_click:(id)sender
{
    [self removeBtnSubview:qualityBtnArray];
    
    [self.tradeBtn_1 addSubview:[btnPicLowArray objectAtIndex:15]];
    [self.tradeBtn_2 addSubview:[btnPicLowArray objectAtIndex:16]];
    [self.tradeBtn_3 addSubview:[btnPicUnSelectArray objectAtIndex:17]];
    [self.tradeBtn_4 addSubview:[btnPicUnSelectArray objectAtIndex:18]];
    [self.tradeBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:19]];
    
    qualityCount = 2;
    
    [self changeCount:qualityCount WithLabel:self.tradeBtn_label];
}

- (IBAction)tradeBtn_3_click:(id)sender
{
    [self removeBtnSubview:qualityBtnArray];
    
    [self.tradeBtn_1 addSubview:[btnPicHightArray objectAtIndex:15]];
    [self.tradeBtn_2 addSubview:[btnPicHightArray objectAtIndex:16]];
    [self.tradeBtn_3 addSubview:[btnPicHightArray objectAtIndex:17]];
    [self.tradeBtn_4 addSubview:[btnPicUnSelectArray objectAtIndex:18]];
    [self.tradeBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:19]];
    
    qualityCount = 3;
    
    [self changeCount:qualityCount WithLabel:self.tradeBtn_label];
}

- (IBAction)tradeBtn_4_click:(id)sender
{
    [self removeBtnSubview:qualityBtnArray];
    
    [self.tradeBtn_1 addSubview:[btnPicHightArray objectAtIndex:15]];
    [self.tradeBtn_2 addSubview:[btnPicHightArray objectAtIndex:16]];
    [self.tradeBtn_3 addSubview:[btnPicHightArray objectAtIndex:17]];
    [self.tradeBtn_4 addSubview:[btnPicHightArray objectAtIndex:18]];
    [self.tradeBtn_5 addSubview:[btnPicUnSelectArray objectAtIndex:19]];
    
    qualityCount = 4;
    
    [self changeCount:qualityCount WithLabel:self.tradeBtn_label];
}

- (IBAction)tradeBtn_5_click:(id)sender
{
    [self removeBtnSubview:qualityBtnArray];
    
    [self.tradeBtn_1 addSubview:[btnPicHightArray objectAtIndex:15]];
    [self.tradeBtn_2 addSubview:[btnPicHightArray objectAtIndex:16]];
    [self.tradeBtn_3 addSubview:[btnPicHightArray objectAtIndex:17]];
    [self.tradeBtn_4 addSubview:[btnPicHightArray objectAtIndex:18]];
    [self.tradeBtn_5 addSubview:[btnPicHightArray objectAtIndex:19]];
    
    qualityCount = 5;
    
    [self changeCount:qualityCount WithLabel:self.tradeBtn_label];
}


- (IBAction)showOrHideBtnClick:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    isAnonymousFlag = btn.selected;
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
