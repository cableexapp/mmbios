//
//  AddInvoiceNormalTableViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-15.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "AddInvoiceNormalTableViewController.h"
#import "DCFCustomExtra.h"
#import "MCDefine.h"
#import "DCFStringUtil.h"
#import "LoginNaviViewController.h"

@interface AddInvoiceNormalTableViewController ()
{
    NSMutableArray *textViewArray;
    NSMutableArray *labelArray;
    
    UITextView *headTV;
    
    
}
@end

@implementation AddInvoiceNormalTableViewController

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    textViewArray = [[NSMutableArray alloc] init];
    labelArray = [[NSMutableArray alloc] init];
    for(int i=0;i<1;i++)
    {
        UILabel *label = [[UILabel alloc] init];
        [labelArray addObject:label];
        
        UITextView *tv = [[UITextView alloc] init];
        [tv setBackgroundColor:[UIColor whiteColor]];
        [tv setTag:i];
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
                
                
            default:
                break;
        }
        size = [DCFCustomExtra adjustWithFont:[UIFont boldSystemFontOfSize:14] WithText:str WithSize:CGSizeMake(MAXFLOAT, 50)];
        
        [label setFrame:CGRectMake(10, 5, size.width, 50)];
        [label setFont:[UIFont boldSystemFontOfSize:14]];
        [label setText:str];
        
        [tv setFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 5, 5, ScreenWidth-25-label.frame.size.width, 50)];
        
    }
    
    [self.tableView reloadData];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self contentSizeToFit:textView];
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    
    return YES;
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    
    if(textView == headTV)
    {
        if(headTV.text.length > 50)
        {
            [DCFStringUtil showNotice:@"发票抬头必须在50字以内"];
        }
    }
}

- (NSArray *) validate
{
    BOOL flag  = YES;
    if(headTV.text.length > 50)
    {
        flag = NO;
    }
    
    
    NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithBool:flag],textViewArray, nil];
    return array;
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
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
        
        if(indexPath.row < 1)
        {
            if(!labelArray)
            {
                
            }
            else
            {
                UILabel *label = (UILabel *)[labelArray objectAtIndex:indexPath.row];
                NSLog(@"labe = %f  %f",label.frame.size.width,label.frame.size.height);
                [cell.contentView addSubview:label];
            }
            if(!textViewArray)
            {
                
            }
            else
            {
                NSLog(@"textViewArray = %@",textViewArray);
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
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"AddInvoice",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    //    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@",token,[self getMemberId]];
    NSString *pushString = [NSString stringWithFormat:@"token=%@&memberid=%@&type=%@&name=%@&company=%@&taxcode=%@&regaddress=%@&tel=%@&bank=%@&bankaccount=%@",token,[self getMemberId],@"1",[(UITextView *)[textViewArray objectAtIndex:0] text],@"",@"",@"",@"",@"",@""];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLB2BAddInvoiceNormalTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/AddInvoice.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if(URLTag == URLB2BAddInvoiceNormalTag)
    {
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            
            if([self.delegate respondsToSelector:@selector(popDelegate)])
            {
                [self.delegate popDelegate];
            }
            //            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            if([DCFCustomExtra validateString:msg] == NO)
            {
                [DCFStringUtil showNotice:@"新增失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
