//
//  CancelOrderViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-23.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "CancelOrderViewController.h"
#import "MCDefine.h"
#import "DCFTopLabel.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFCustomExtra.h"
#import "LoginNaviViewController.h"
#import "DCFStringUtil.h"

@interface CancelOrderViewController ()
{
    NSArray *dataArray;
    
    UITextView *myTextView;
    
    UILabel *label;
    
    NSString *str;
}
@end

@implementation CancelOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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


- (void) hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"请选择取消订单原因"];
    self.navigationItem.titleView = top;
    
    [self pushAndPopStyle];
    
    
    dataArray = [[NSArray alloc] initWithObjects:@"现在不想购买",@"商品价格比较贵",@"价格波动",@"商品缺货",@"重复下单",@"添加或删除商品",@"收货人信息有误",@"发票信息有误或发票未开",@"送货时间长", nil];
    
    myTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth-10, 60-10)];
    [myTextView setDelegate:self];
    [myTextView setReturnKeyType:UIReturnKeyDone];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, myTextView.frame.size.width-10, 20)];
    [label setText:@"请简述取消原因,100字以内"];
    [label setTextColor:[UIColor lightGrayColor]];
    [myTextView addSubview:label];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:24.0/255.0 green:120.0/255.0 blue:249.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(0, 0, 50, 50)];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // Do any additional setup after loading the view.
}

- (void) rightBtnClick:(UIButton *) sender
{
    if(str.length == 0)
    {
        [DCFStringUtil showNotice:@"请选择或者输入取消原因"];
        return;
    }
    if([myTextView isFirstResponder])
    {
        [myTextView resignFirstResponder];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    [UIView commitAnimations];
    
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    
    int statusInt = [self.myStatus intValue];
    
#pragma mark - 1：未付款  2:已付款
    
    NSString *string = nil;
    NSString *urlString = nil;
    
    if(statusInt == 1)
    {
        string = [NSString stringWithFormat:@"%@%@",@"CanncelOrder",time];
        urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/CanncelOrder.html?"];
    }
    else if (statusInt == 2)
    {
        string = [NSString stringWithFormat:@"%@%@",@"CanncelOrderPay",time];
        urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/CanncelOrderPay.html?"];
    }
    else
    {
        [DCFStringUtil showNotice:@"该状态下不能取消订单"];
        return;
    }
    
    if(!HUD)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setLabelText:@"正在取消..."];
        [HUD setDelegate:self];
    }
    
    
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&reason=%@&memberid=%@&ordernum=%@",token,str,[self getMemberId],self.myOrderNum];
    
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLCanncelOrderTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}


- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if(memberid.length == 0)
    {
        LoginNaviViewController *loginNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    NSLog(@"%@",dicRespon);
    
    if(HUD)
    {
        [HUD hide:YES];
    }
    
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if(URLTag == URLCanncelOrderTag)
    {
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
        }
        else
        {
            [DCFStringUtil showNotice:@"取消失败"];
        }
    }
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 10)
    {
        return 60;
    }
    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    if(indexPath.row < 9)
    {
        [cell.textLabel setText:[dataArray objectAtIndex:indexPath.row]];
        [cell.textLabel setTextColor:[UIColor colorWithRed:24.0/255.0 green:120.0/255.0 blue:249.0/255.0 alpha:1.0]];
    }
    else if(indexPath.row == 9)
    {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];
        [iv setImage:[UIImage imageNamed:@"Set.png"]];
        [cell.contentView addSubview:iv];
        
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x + iv.frame.size.width + 5, iv.frame.origin.y, 200, iv.frame.size.height)];
        [cellLabel setTextColor:[UIColor colorWithRed:24.0/255.0 green:120.0/255.0 blue:249.0/255.0 alpha:1.0]];
        [cellLabel setText:@"其他原因"];
        [cell.contentView addSubview:cellLabel];
    }
    else
    {
        [cell.contentView addSubview:myTextView];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < 9)
    {
        str = [dataArray objectAtIndex:indexPath.row];
    }
    if(indexPath.row == 9)
    {
        
    }
    if(indexPath.row == 10)
    {
        str = [myTextView text];
    }
    NSLog(@"%@",str);
}


- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, -150, 320, self.view.frame.size.height)];
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
    if (myTextView.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            label.hidden=NO;//隐藏文字
        }else{
            label.hidden=YES;
        }
    }else{//textview长度不为0
        if (myTextView.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                label.hidden=NO;
            }else{//不是删除
                label.hidden=YES;
            }
        }else{//长度不为1时候
            label.hidden=YES;
        }
    }
    
    if([text isEqualToString:@"\n"])
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        [self.view setFrame:CGRectMake(0, 64, 320, self.view.frame.size.height)];
        [UIView commitAnimations];
        
        str = myTextView.text;
        if(str.length <= 0)
        {
            [label setHidden:NO];
        }
        else
        {
            [label setHidden:YES];
        }
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
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
