//
//  AddInvoiceAddedTableViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "AddInvoiceAddedTableViewController.h"
#import "DCFCustomExtra.h"
#import "MCDefine.h"
#import "DCFStringUtil.h"
#import "LoginNaviViewController.h"

@interface AddInvoiceAddedTableViewController ()
{
    NSMutableArray *textViewArray;
    NSMutableArray *labelArray;
    
    UITextView *headTV;
    UITextView *companyTV;
    UITextView *tokenTV;
    UITextView *addressTV;
    UITextView *telTV;
    UITextView *bankTV;
    UITextView *accountTV;
    
}
@end

@implementation AddInvoiceAddedTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    //    UITextView *headTV;
    //    UITextView *companyTV;
    //    UITextView *tokenTV;
    //    UITextView *addressTV;
    //    UITextView *telTV;
    //    UITextView *bankTV;
    //    UITextView *accountTV;
    if([headTV isFirstResponder])
    {
        [headTV resignFirstResponder];
    }
    if([companyTV isFirstResponder])
    {
        [companyTV resignFirstResponder];
    }
    if([tokenTV isFirstResponder])
    {
        [tokenTV resignFirstResponder];
    }
    if([addressTV isFirstResponder])
    {
        [addressTV resignFirstResponder];
    }
    if([telTV isFirstResponder])
    {
        [telTV resignFirstResponder];
    }
    if([bankTV isFirstResponder])
    {
        [bankTV resignFirstResponder];
    }
    if([accountTV isFirstResponder])
    {
        [accountTV resignFirstResponder];
    }
    
    if(textViewArray)
    {
        for(UITextView *tv in textViewArray)
        {
            [tv removeObserver:self forKeyPath:@"contentSize" context:NULL];
        }
    }
}
- (void)contentSizeToFit:(UITextView *) sender
{
    if([sender.text length]>0) {
        CGSize contentSize = sender.contentSize;
        //NSLog(@"w:%f h%f",contentSize.width,contentSize.height);
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        if(contentSize.height <= sender.frame.size.height)
        {
            CGFloat offsetY = (sender.frame.size.height - contentSize.height)/2;
            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
        }
        else
        {
            newSize = sender.frame.size;
            offset = UIEdgeInsetsZero;
            CGFloat fontSize = 18;
            while (contentSize.height > sender.frame.size.height)
            {
                [sender setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
                contentSize = sender.contentSize;
            }
            newSize = contentSize;
        }
        [sender setContentSize:newSize];
        [sender setContentInset:offset];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    //Center vertical alignment
    //CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    //topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    //tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
    //Bottom vertical alignment
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height);
    topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    textViewArray = [[NSMutableArray alloc] init];
    labelArray = [[NSMutableArray alloc] init];
    for(int i=0;i<7;i++)
    {
        UILabel *label = [[UILabel alloc] init];
        [labelArray addObject:label];
        
        UITextView *tv = [[UITextView alloc] init];
        [tv setBackgroundColor:[UIColor whiteColor]];
        [tv setTag:i];
        [tv addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
        [tv setReturnKeyType:UIReturnKeyDone];
        //        [tv setScrollEnabled:NO];
        [tv setShowsVerticalScrollIndicator:NO];
        [tv setFont:[UIFont systemFontOfSize:14]];
        [tv setDelegate:self];
        //        [self contentSizeToFit:tv];
        [textViewArray addObject:tv];
        
        NSString *str = nil;
        
        CGSize size;
        switch (i)
        {
            case 0:
                str = @"发票抬头:";
                headTV = tv;
                break;
            case 1:
                str = @"单位名称:";
                companyTV = tv;
                break;
            case 2:
                str = @"纳税人识别号:";
                tokenTV = tv;
                break;
            case 3:
                str = @"注册地址:";
                addressTV = tv;
                break;
            case 4:
                str = @"电话:";
                telTV = tv;
                break;
            case 5:
                str = @"开户银行:";
                bankTV = tv;
                break;
            case 6:
                str = @"开户行账号:";
                accountTV = tv;
                break;
                
            default:
                break;
        }
        size = [DCFCustomExtra adjustWithFont:[UIFont boldSystemFontOfSize:14] WithText:str WithSize:CGSizeMake(MAXFLOAT, 50)];
        
        [label setFrame:CGRectMake(10, 5, size.width, 50)];
        [label setFont:[UIFont boldSystemFontOfSize:14]];
        [label setText:str];
        
        [tv setFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 5, 0, ScreenWidth-25-label.frame.size.width, 50)];
        
    }
    
    [self.tableView reloadData];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //    [self contentSizeToFit:textView];
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    
    return YES;
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    [self validate:textView];
}

- (void) validate:(UITextView *) textView
{
    if(textView == headTV)
    {
        if(headTV.text.length > 50)
        {
            [DCFStringUtil showNotice:@"发票抬头必须在50字以内"];
            return;
        }
    }
    if(textView == companyTV)
    {
        if(companyTV.text.length > 64)
        {
            [DCFStringUtil showNotice:@"单位名称必须在64位以内"];
            return;
        }
    }
    if(textView == tokenTV)
    {
        if(tokenTV.text.length > 32)
        {
            [DCFStringUtil showNotice:@"纳税人识别号必须在32位以内"];
            return;
        }
    }
    if(textView == addressTV)
    {
        if(addressTV.text.length > 64)
        {
            [DCFStringUtil showNotice:@"注册地址名称必须在64位以内"];
            return;
        }
    }
    if(textView == telTV)
    {
        if([DCFCustomExtra validateMobile:telTV.text] == NO)
        {
            [DCFStringUtil showNotice:@"请输入正确的手机号码"];
            return;
        }
    }
    if(textView == bankTV)
    {
        if(bankTV.text.length > 64)
        {
            [DCFStringUtil showNotice:@"开户银行名称必须在64位以内"];
            return;
        }
    }
    if(textView == accountTV)
    {
        if(accountTV.text.length > 32)
        {
            [DCFStringUtil showNotice:@"开户行账号必须在32位以内"];
            return;
        }
        if([self isAllNum:accountTV.text] != YES)
        {
            [DCFStringUtil showNotice:@"开户行账号必须是纯数字"];
            return;
        }
    }
    
    //    BOOL flag  = YES;
    //    if(headTV.text.length > 50)
    //    {
    //        //        [DCFStringUtil showNotice:@"发票抬头必须在50字以内"];
    //        flag = NO;
    //    }
    //
    //
    //    if(companyTV.text.length > 64)
    //    {
    //        //        [DCFStringUtil showNotice:@"单位名称必须在64位以内"];
    //        flag = NO;
    //
    //    }
    //
    //    if(tokenTV.text.length > 32)
    //    {
    //        //        [DCFStringUtil showNotice:@"纳税人识别号必须在32位以内"];
    //        flag = NO;
    //
    //    }
    //
    //
    //    if(addressTV.text.length > 64)
    //    {
    //        //        [DCFStringUtil showNotice:@"注册地址名称必须在64位以内"];
    //        flag = NO;
    //
    //    }
    //
    //
    //    if([DCFCustomExtra validateMobile:telTV.text] == NO)
    //    {
    //        //        [DCFStringUtil showNotice:@"请输入正确的手机号码"];
    //        flag = NO;
    //
    //    }
    //
    //
    //    if(bankTV.text.length > 64)
    //    {
    //        //        [DCFStringUtil showNotice:@"开户银行名称必须在64位以内"];
    //        flag = NO;
    //
    //    }
    //
    //
    //    if(accountTV.text.length > 32)
    //    {
    //        //        [DCFStringUtil showNotice:@"开户行账号必须在32位以内"];
    //        flag = NO;
    //
    //    }
    //    if([self isAllNum:accountTV.text] != YES)
    //    {
    //        //        [DCFStringUtil showNotice:@"开户行账号必须是纯数字"];
    //        flag = NO;
    //
    //    }
    //    NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithBool:flag],textViewArray, nil];
    //    return array;
}


- (BOOL)isAllNum:(NSString *)string
{
    unichar c;
    for (int i=0; i<string.length; i++)
    {
        c=[string characterAtIndex:i];
        if (!isdigit(c))
        {
            return NO;
        }
    }
    return YES;
}

- (void) keyBoardHide
{
    [headTV resignFirstResponder];
    [companyTV resignFirstResponder];
    [tokenTV resignFirstResponder];
    [addressTV resignFirstResponder];
    [telTV resignFirstResponder];
    [bankTV resignFirstResponder];
    [accountTV resignFirstResponder];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:0];
        
        if(indexPath.row < 7)
        {
            if(!labelArray)
            {
                
            }
            else
            {
                UILabel *label = (UILabel *)[labelArray objectAtIndex:indexPath.row];
                [cell.contentView addSubview:label];
            }
            if(!textViewArray)
            {
                
            }
            else
            {
                UITextView *tv = (UITextView *)[textViewArray objectAtIndex:indexPath.row];
                [cell.contentView addSubview:tv];
            }
            
            
            
        }
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, cell.contentView.frame.size.width-20, 40)];
            [label setText:@"发票内容: 您所购买的商品具体信息"];
            [label setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.contentView addSubview:label];
        }
    }
    return cell;
}

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    if(memberid.length == 0 || [memberid isKindOfClass:[NSNull class]])
    {
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}

- (void) loadRequest
{
    //    if(textView == headTV)
    //    {
    if(headTV.text.length > 50)
    {
        [DCFStringUtil showNotice:@"发票抬头必须在50字以内"];
        return;
    }
    //    }
    //    if(textView == companyTV)
    //    {
    if(companyTV.text.length > 64)
    {
        [DCFStringUtil showNotice:@"单位名称必须在64位以内"];
        return;
    }
    //    }
    //    if(textView == tokenTV)
    //    {
    if(tokenTV.text.length > 32)
    {
        [DCFStringUtil showNotice:@"纳税人识别号必须在32位以内"];
        return;
    }
    //    }
    //    if(textView == addressTV)
    //    {
    if(addressTV.text.length > 64)
    {
        [DCFStringUtil showNotice:@"注册地址名称必须在64位以内"];
        return;
    }
    //    }
    //    if(textView == telTV)
    //    {
    if([DCFCustomExtra validateMobile:telTV.text] == NO)
    {
        [DCFStringUtil showNotice:@"请输入正确的手机号码"];
        return;
    }
    //    }
    //    if(textView == bankTV)
    //    {
    if(bankTV.text.length > 64)
    {
        [DCFStringUtil showNotice:@"开户银行名称必须在64位以内"];
        return;
    }
    //    }
    //    if(textView == accountTV)
    //    {
    if(accountTV.text.length > 32)
    {
        [DCFStringUtil showNotice:@"开户行账号必须在32位以内"];
        return;
    }
    if([self isAllNum:accountTV.text] != YES)
    {
        [DCFStringUtil showNotice:@"开户行账号必须是纯数字"];
        return;
    }
    //    }
    
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"AddInvoice",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    //token,memberid(用户id),type(类型1-普通2-增值税),name(抬头),company(公司名),tel(电话),taxcode(纳税人识别号),regaddress(注册地址),bank(开户银行),bankaccount(开户账号)
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&type=%@&name=%@&company=%@&taxcode=%@&regaddress=%@&tel=%@&bank=%@&bankaccount=%@",token,[self getMemberId],@"2",[(UITextView *)[textViewArray objectAtIndex:0] text],[(UITextView *)[textViewArray objectAtIndex:1] text],[(UITextView *)[textViewArray objectAtIndex:2] text],[(UITextView *)[textViewArray objectAtIndex:3] text],[(UITextView *)[textViewArray objectAtIndex:4] text],[(UITextView *)[textViewArray objectAtIndex:5] text],[(UITextView *)[textViewArray objectAtIndex:6] text]];
    NSLog(@"push = %@",pushString);
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2BAddInvoiceAddTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/AddInvoice.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    if([self.delegate respondsToSelector:@selector(isRequestAdded:)])
    {
        [self.delegate isRequestAdded:@"0"];
    }
}


- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if([self.delegate respondsToSelector:@selector(isRequestAdded:)])
    {
        [self.delegate isRequestAdded:@"1"];
    }
    
    
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if([DCFCustomExtra validateString:msg] == NO)
    {
        [DCFStringUtil showNotice:@"新增失败"];
        return;
    }
    [DCFStringUtil showNotice:msg];
    
    if(URLTag == URLB2BAddInvoiceAddTag)
    {
        if(result == 1)
        {
            if([self.delegate respondsToSelector:@selector(popDelegate_2)])
            {
                [self.delegate popDelegate_2];
            }
            
            //            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
