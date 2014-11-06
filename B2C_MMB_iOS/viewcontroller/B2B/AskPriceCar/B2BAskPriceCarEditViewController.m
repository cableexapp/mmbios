//
//  B2BAskPriceCarEditViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-5.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "B2BAskPriceCarEditViewController.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"
#import "MCDefine.h"

@interface B2BAskPriceCarEditViewController ()
{
    DCFPickerView *pickerView;
    
    
    NSMutableArray *specArray;
    
    NSMutableArray *voltageArray;
    
    NSMutableArray *featureArray;  //阻燃特性
    
    NSString *str;  //textview内容
    
    NSArray *textFieldArray;
    
    NSMutableArray *arr;
    
}
@end

@implementation B2BAskPriceCarEditViewController

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
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    self.sureBtn.layer.borderWidth = 1.0f;
    self.sureBtn.layer.borderColor = [UIColor blueColor].CGColor;
    self.sureBtn.layer.cornerRadius = 5.0f;
    
    textFieldArray = [[NSArray alloc] initWithObjects:self.numTF,self.unitTF,self.timeTF,self.specTF,self.volTF,self.colorTF,self.featureTF, nil];
    
    [self.modelLabel setText:self.myModel];
    NSLog(@"model = %@",self.myModel);
    
    self.requestTF.layer.borderColor = [UIColor blackColor].CGColor;
    self.requestTF.layer.borderWidth = 1.0f;
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getSpecVoltageByModel",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&model=%@",token,self.myModel];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetSpecVoltageByModelTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/getSpecVoltageByModel.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    //    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if(URLTag == URLGetSpecVoltageByModelTag)
    {
        NSLog(@"%@",dicRespon);
        
        specArray = [[NSMutableArray alloc] init];
        voltageArray = [[NSMutableArray alloc] init];
        featureArray = [[NSMutableArray alloc] init];
        
        if(result == 1)
        {
            //电压
            NSArray *ctems = (NSArray *)[dicRespon objectForKey:@"ctems"];
            if(ctems.count == 0 || [ctems isKindOfClass:[NSNull class]])
            {
                
            }
            else
            {
                for(NSDictionary *dic in ctems)
                {
                    NSString *vol = [NSString stringWithFormat:@"%@",[dic objectForKey:@"voltage"]];
                    [voltageArray addObject:vol];
                }
            }
            
            //规格
            NSArray *items = (NSArray *)[dicRespon objectForKey:@"items"];
            if(items.count == 0 || [items isKindOfClass:[NSNull class]])
            {
                
            }
            else
            {
                for(NSDictionary *dic in items)
                {
                    NSString *spec = [NSString stringWithFormat:@"%@",[dic objectForKey:@"spec"]];
                    [specArray addObject:spec];
                }
            }
            
            //阻燃特性
            NSArray *mtems = (NSArray *)[dicRespon objectForKey:@"mtems"];
            if(mtems.count == 0 || [mtems isKindOfClass:[NSNull class]])
            {
                
            }
            else
            {
                for(NSDictionary *dic in mtems)
                {
                    NSString *featureName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"featureName"]];
                    [featureArray addObject:featureName];
                }
            }
        }
        else
        {
            
        }
    }
    if(URLTag == URLEditInquiryItemTag)
    {
        if(result == 1)
        {
            [self.delegate removeSubView];
            [self.delegate reloadData];
        }
        else
        {
            
        }
        NSLog(@"%@",dicRespon);
    }
}


- (void) tap:(UITapGestureRecognizer *) sender
{
    //    [self.delegate removeSubView];
}

- (void) textViewDidChange:(UITextView *)textView
{
    int num = self.requestTF.text.length;
    [self.countLabel setText:[NSString stringWithFormat:@"%d/500",num]];
    if(num >= 500)
    {
        [self.countLabel setTextColor:[UIColor redColor]];
    }
    else
    {
        [self.countLabel setTextColor:[UIColor blackColor]];
    }
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    
    if (self.requestTF.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            self.requestLabel.hidden=NO;//隐藏文字
        }else{
            self.requestLabel.hidden=YES;
        }
    }else{//textview长度不为0
        if (self.requestTF.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                self.requestLabel.hidden=NO;
            }else{//不是删除
                self.requestLabel.hidden=YES;
            }
        }else{//长度不为1时候
            self.requestLabel.hidden=YES;
        }
    }
    
    if([text isEqualToString:@"\n"])
    {
        [self.requestTF resignFirstResponder];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [self.view setFrame:CGRectMake(20, 20, ScreenWidth, ScreenHeight)];
        [UIView commitAnimations];
        
        str = self.requestTF.text;
        if(str.length <= 0)
        {
            [self.requestLabel setHidden:NO];
        }
        else
        {
            [self.requestLabel setHidden:YES];
        }
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - 判断是不是纯数字
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

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    //    if(textField == self.numTF)
    //    {
    //        [self.numTF resignFirstResponder];
    //    }
    //    if(textField == self.timeTF)
    //    {
    //        [self.timeTF resignFirstResponder];
    //    }
    return [textField resignFirstResponder];
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if(textView == self.requestTF)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        [self.view setFrame:CGRectMake(20, -64,ScreenWidth, ScreenHeight)];
        [UIView commitAnimations];
    }
}

//- (void) loadSubTableViewWithWidth:(float) width WithHeight:(float) height WithOriX:(float) x WithOriY:(float) y
//{
//    if(subTV)
//    {
//        [subTV removeFromSuperview];
//        subTV = nil;
//    }
//    
//    subTV = [[UITableView alloc] initWithFrame:CGRectMake(x, y, width, height)];
//    [subTV setDataSource:self];
//    [subTV setDelegate:self];
//    [self.view addSubview:subTV];
//}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
        [(UIView *) CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    [cell.textLabel setText:[arr objectAtIndex:indexPath.row]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:11]];
    return cell;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == self.unitTF)
    {
        [self.numTF resignFirstResponder];
        [self.unitTF resignFirstResponder];
        arr = [[NSMutableArray alloc] initWithObjects:@"KM",@"吨", nil];
        
        //        [self loadSubTableViewWithWidth:self.unitTF.frame.size.width WithHeight:40 WithOriX:self.unitTF.frame.origin.x WithOriY:self.unitTF.frame.origin.y+self.unitTF.frame.size.height];
        
       [self loadPickerViewWithArray:arr WithTag:10000];
    }
    if(textField == self.specTF)
    {
        [self.specTF resignFirstResponder];
        [self loadPickerViewWithArray:specArray WithTag:10001];
    }
    if(textField == self.volTF)
    {
        [self.volTF resignFirstResponder];
        [self loadPickerViewWithArray:voltageArray WithTag:10002];
    }
    if(textField == self.colorTF)
    {
        [self.colorTF resignFirstResponder];
        arr = [[NSMutableArray alloc] initWithObjects:@"红色",@"黄色",@"蓝色",@"绿色",@"黄绿色",@"白色",@"黑色",@"其他", nil];
        [self loadPickerViewWithArray:arr WithTag:10003];
    }
    if(textField == self.featureTF)
    {
        [self.featureTF resignFirstResponder];
        [self loadPickerViewWithArray:featureArray WithTag:10004];
    }
    
    for(UITextField *text in textFieldArray)
    {
        if(text == textField)
        {
            
        }
        else
        {
            [text resignFirstResponder];
        }
    }
    
}

- (void) loadPickerViewWithArray:(NSMutableArray *) array WithTag:(int) tag
{
    pickerView = [[DCFPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.window.frame.size.height) WithArray:array WithTag:tag];
    pickerView.delegate = self;
    [self.view.window setBackgroundColor:[UIColor blackColor]];
    [self.view.window addSubview:pickerView];
}

- (void) pickerView:(NSString *) title WithTag:(int)tag
{
    NSLog(@"title = %@",title);
    NSLog(@"tag = %d",tag);
    
    if(tag == 10000)
    {
        [self.unitTF setText:title];
    }
    if(tag == 10001)
    {
        [self.specTF setText:title];
    }
    if(tag == 10002)
    {
        [self.volTF setText:title];
    }
    if(tag == 10003)
    {
        [self.colorTF setText:title];
    }
    if(tag == 10004)
    {
        [self.featureTF setText:title];
    }
    
}


- (IBAction)sureBtnClick:(id)sender
{
    
    //    token,cartid(购物车明细id),spec(规格)voltage(电压),unit(单位),num(数量),color(颜色),featureone(特性),require(特殊要求),deliver(交货期)
    if(self.numTF.text.length == 0 || [self.numTF.text isKindOfClass:[NSNull class]])
    {
        [DCFStringUtil showNotice:@"数量不能为空"];
        return;
    }
    if(self.timeTF.text.length == 0 || [self.timeTF.text isKindOfClass:[NSNull class]])
    {
        [DCFStringUtil showNotice:@"交货期不能为空"];
        return;
    }
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"EditInquiryItem",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&cartid=%@&spec=%@&voltage=%@&unit=%@&num=%@&color=%@&featureone=%@&require=%@&deliver=%@",token,self.myCartId,self.specTF.text,self.volTF.text,self.unitTF.text,self.numTF.text,self.colorTF.text,self.featureTF.text,self.requestTF.text,self.timeTF.text];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLEditInquiryItemTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/EditInquiryItem.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
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
