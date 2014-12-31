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
#import "DCFStringUtil.h"
#import "DCFCustomExtra.h"
#import "LoginNaviViewController.h"
#import "DCFCustomExtra.h"
@interface BillMsgManagerViewController ()
{
    NSMutableArray *billBtnArray;   //需不需要发票的选择按钮
    NSMutableArray *billHeadBtnArray;  //发票抬头的选择按钮
    
    DCFMyTextField *tf;
    
    UILabel *billContentLabel;
    
    NSMutableArray *myArray;
    
    UIButton *sureBtn;
    
    NSString *invoicetype;
    
//    NSString *memberid;
    
    UIStoryboard *sb;
    
    UIButton *noNeedBtn;
    UIButton *needBtn;
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

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if([tf isFirstResponder] == YES)
    {
        [tf resignFirstResponder];
    }
    
    [self dismissKeyBoard];
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    
    if(URLTag == URLAddInvoiceTag)
    {
        if(result == 0)
        {
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"新增发票失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
        else if (result == 1)
        {
            [DCFStringUtil showNotice:msg];
            
            NSString *status = nil;
            if(noNeedBtn.selected == YES)
            {
                status = @"2";
            }
            if(needBtn.selected == YES)
            {
                status = @"1";
            }
            
            if(![[NSUserDefaults standardUserDefaults] objectForKey:@"BillMsg"])
            {
                NSString *myInvoiceid = [NSString stringWithFormat:@"%@",[dicRespon objectForKey:@"value"]];
                NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:tf.text,myInvoiceid,[NSNumber numberWithInt:_billHeadTag],status,nil];
                [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"BillMsg"];
            }
            else
            {
                NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:tf.text,_invoiceid,[NSNumber numberWithInt:_billHeadTag],status,nil];
                [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"BillMsg"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if(URLTag == URLEditInvoiceTag)
    {
        if(result == 0)
        {
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"编辑发票失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
        else if (result == 1)
        {
            NSString *status = nil;
            if(noNeedBtn.selected == YES)
            {
                status = @"2";
            }
            if(needBtn.selected == YES)
            {
                status = @"1";
            }
            
            NSString *myInvoiceid = [NSString stringWithFormat:@"%@",[dicRespon objectForKey:@"value"]];
            
            if(![[NSUserDefaults standardUserDefaults] objectForKey:@"BillMsg"])
            {
                NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:tf.text,myInvoiceid,[NSNumber numberWithInt:_billHeadTag],status,nil];
                [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"BillMsg"];

            }
            else
            {
                NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:tf.text,_invoiceid,[NSNumber numberWithInt:_billHeadTag],status,nil];
                [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"BillMsg"];
            }
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
}

- (void) billBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    int tag = btn.tag;
    NSLog(@"TAG = %d",tag);
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
    if(tag == 0)
    {
        [self hideSubViews];
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"BillMsg"])
        {
            
        }
        else
        {
            [self changeBillMsgStatus:@"2"];
        }
    }
    else if (tag == 1)
    {
        [self showSubViews];
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"BillMsg"])
        {
            
        }
        else
        {
            [self changeBillMsgStatus:@"1"];
        }
    }
}

- (void) changeBillMsgStatus:(NSString *) str
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"BillMsg"]];
    [arr replaceObjectAtIndex:arr.count-1 withObject:str];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"BillMsg"];
}

- (void) billHeadBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    _billHeadTag = btn.tag;
    btn.selected = !btn.selected;
    for(UIButton *btn in billHeadBtnArray)
    {
        if(btn.tag == _billHeadTag)
        {
            
        }
        else
        {
            [btn setSelected:NO];
        }
    }
    if(_billHeadTag == 4)
    {
        [tf setPlaceholder:@"请输入个人名称"];
    }
    if(_billHeadTag == 5)
    {
        [tf setPlaceholder:@"请输入单位名称"];
    }
}


- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if([DCFCustomExtra validateString:memberid] == NO)
    {
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}

- (void) sure:(UIButton *) sender
{
    
    for(UIButton *btn in billBtnArray)
    {
        if(btn.tag == 0 && btn.selected == YES)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if(btn.tag == 1 && btn.selected == YES)
        {
            if(tf.text.length == 0)
            {
                [self dismissKeyBoard];
                [DCFStringUtil showNotice:@"请输入个人或者单位信息"];
                return;
            }
            
            int invoicetypeTag = 0;
            for(UIButton *btn in billHeadBtnArray)
            {
                
                if(btn.selected == YES)
                {
                    invoicetypeTag = btn.tag;
                }
            }
            
            if(invoicetypeTag == 4)
            {
                invoicetype = @"1";
            }
            else if (invoicetypeTag == 5)
            {
                invoicetype = @"2";
            }
      
            
            NSString *time = [DCFCustomExtra getFirstRunTime];
#pragma mark - 当editOrAddBill为0的时候表示新增发票，为1的时候表示编辑发票
            if(_editOrAddBill == NO)
            {
                NSString *string = [NSString stringWithFormat:@"%@%@",@"AddInvoice",time];
                NSString *token = [DCFCustomExtra md5:string];
                
                NSString *pushString = nil;
                
                
                pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&invoicename=%@&invoicetype=%@",[self getMemberId],token,tf.text,invoicetype];
                
                conn = [[DCFConnectionUtil alloc] initWithURLTag:URLAddInvoiceTag delegate:self];
                NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/AddInvoice.html?"];
                [conn getResultFromUrlString:urlString postBody:pushString method:POST];
            }
            else
            {
                NSString *string = [NSString stringWithFormat:@"%@%@",@"EditInvoice",time];
                NSString *token = [DCFCustomExtra md5:string];
                
                NSString *pushString = [NSString stringWithFormat:@"token=%@&invoicename=%@&invoicetype=%@&invoiceid=%@",token,tf.text,invoicetype,_invoiceid];
                
                conn = [[DCFConnectionUtil alloc] initWithURLTag:URLEditInvoiceTag delegate:self];
                NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/EditInvoice.html?"];
                [conn getResultFromUrlString:urlString postBody:pushString method:POST];
                
            }
            
            
            
            
            
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:self.naviTitle];
    self.navigationItem.titleView = top;
    
    billBtnArray = [[NSMutableArray alloc] init];
    billHeadBtnArray = [[NSMutableArray alloc] init];
    myArray = [[NSMutableArray alloc] init];
    
    NSString *status = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"BillMsg"] lastObject]];
    
    noNeedBtn = nil;
    needBtn = nil;
    for(int i=0;i<9;i++)
    {
        if(i <= 1)
        {
            UIButton *billBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [billBtn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
            [billBtn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
            [billBtn setSelected:NO];
            [billBtn setTag:i];
            [billBtn setFrame:CGRectMake(10, 10+40*i, 30, 30)];
            [billBtn addTarget:self action:@selector(billBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [billBtnArray addObject:billBtn];
            
            [self.view addSubview:billBtn];
            if(i == 0)
            {
                noNeedBtn = billBtn;
            }
            if(i == 1)
            {
                needBtn = billBtn;
            }

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
            
            [myArray addObject:label];
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
            if(_billHeadTag == 0 && i == 4)
            {
                [billHeadBtn setSelected:YES];
            }
            else
            {
                if(_billHeadTag == i)
                {
                    [billHeadBtn setSelected:YES];
                }
            }
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
            
            [myArray addObject:billHeadLabel];
        }
        if(i == 6)
        {
            tf = [[DCFMyTextField alloc] initWithFrame:CGRectMake(10, 250, 300, 30)];
            [tf setDelegate:self];
            [tf setReturnKeyType:UIReturnKeyDone];

//            [tf setText:_tfContent];
            [tf setPlaceholder:_tfContent];
            
            [self.view addSubview:tf];
            
            [myArray addObject:tf];
        }
        if(i == 7)
        {
            billContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 290, 300, 30)];
            [billContentLabel setText:@"发票内容:您所购买的商品明细"];
            [billContentLabel setFont:[UIFont systemFontOfSize:13]];
            [billContentLabel setTextAlignment:NSTextAlignmentLeft];
            [self.view addSubview:billContentLabel];
            
            [myArray addObject:billContentLabel];
        }
        if(i == 8)
        {
            sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
            [sureBtn setFrame:CGRectMake((320-200)/2, billContentLabel.frame.origin.y+billContentLabel.frame.size.height+20, 200, 50)];
            [sureBtn setTitleColor:MYCOLOR forState:UIControlStateNormal];
            [sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
            sureBtn.layer.borderColor = MYCOLOR.CGColor;
            sureBtn.layer.borderWidth = 1.0f;
            sureBtn.layer.cornerRadius = 5.0f;
            [self.view addSubview:sureBtn];
        }
    }

#pragma mark - 当editOrAddBill为0的时候表示新增发票，为1的时候表示编辑发票   当status为1的时候表示需要发票，为2的时候表示不需要发票
    if(_editOrAddBill == NO)
    {
        [noNeedBtn setSelected:YES];
        [needBtn setSelected:NO];
        [self hideSubViews];
    }
    if(_editOrAddBill == YES)
    {
        if([status intValue] == 1)
        {
            [noNeedBtn setSelected:NO];
            [needBtn setSelected:YES];
            [self showSubViews];
        }
        else if ([status intValue] == 2)
        {
            [noNeedBtn setSelected:YES];
            [needBtn setSelected:NO];
            [self hideSubViews];
        }
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void) hideSubViews
{
    for(int i=0;i<myArray.count;i++)
    {
        UIView *subviews = [myArray objectAtIndex:i];
        [subviews setHidden:YES];
    }
    for(int i=0;i<billHeadBtnArray.count;i++)
    {
        UIButton *btn = [billHeadBtnArray objectAtIndex:i];
        [btn setHidden:YES];
    }
    [sureBtn setFrame:CGRectMake((320-200)/2, [[billBtnArray lastObject] frame].origin.y+[[billBtnArray lastObject] frame].size.height + 10, 200, 50)];
}

- (void) showSubViews
{
    for(int i=0;i<myArray.count;i++)
    {
        UIView *subviews = [myArray objectAtIndex:i];
        [subviews setHidden:NO];
    }
    for(int i=0;i<billHeadBtnArray.count;i++)
    {
        UIButton *btn = [billHeadBtnArray objectAtIndex:i];
        [btn setHidden:NO];
    }
    
    [sureBtn setFrame:CGRectMake((320-200)/2, billContentLabel.frame.origin.y+billContentLabel.frame.size.height+20, 200, 50)];
    
    //    [billContentLabel setFrame:CGRectMake(10, 290, 300, 30)];
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
