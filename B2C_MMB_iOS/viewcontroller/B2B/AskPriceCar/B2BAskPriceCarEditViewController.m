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
    NSMutableArray *specPreArray;
    
    NSMutableArray *voltageArray;
    
    NSMutableArray *featureArray;  //阻燃特性
    
    NSString *str;  //textview内容
    
    
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
    
    self.numTF.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.numTF.layer.borderWidth = 0.5f;
    [self.numTF setTextAlignment:NSTextAlignmentCenter];
    
    self.timeTF.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.timeTF.layer.borderWidth = 0.5f;
    [self.timeTF setTextAlignment:NSTextAlignmentCenter];
    
    self.specTf.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.specTf.layer.borderWidth = 0.5f;
    [self.specTf setReturnKeyType:UIReturnKeyDone];
    [self.specTf setTextAlignment:NSTextAlignmentCenter];
    [self.specTf setTextColor:[UIColor lightGrayColor]];
    //    [self.specTf setKeyboardType:UIKeyboardTypeNumberPad];
    
    self.sureBtn.layer.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:142.0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    self.sureBtn.layer.cornerRadius = 5.0f;
    self.sureBtn.frame = CGRectMake(15,self.view.frame.size.height - 60,self.view.frame.size.width-30,40);
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.unitBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.unitBtn.layer.borderWidth = 0.5f;
    [self.unitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.unitBtn setTitle:@"KM" forState:UIControlStateNormal];
    
    self.specBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.specBtn.layer.borderWidth = 0.5f;
    [self.specBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    self.featherBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.featherBtn.layer.borderWidth = 0.5f;
    [self.featherBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    self.volBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.volBtn.layer.borderWidth = 0.5f;
    [self.volBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    self.colorBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.colorBtn.layer.borderWidth = 0.5f;
    [self.colorBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    [self.modelLabel setText:self.myModel];
    self.modelLabel.textColor = [UIColor whiteColor];
    self.modelLabel.layer.cornerRadius = 5;
    
    self.requestTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.requestTF.layer.borderWidth = 0.5f;
    
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
    [self.sureBtn setEnabled:YES];
    
    int result = [[dicRespon objectForKey:@"result"] intValue];
    //    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if(URLTag == URLGetSpecVoltageByModelTag)
    {
        
        specArray = [[NSMutableArray alloc] init];
        voltageArray = [[NSMutableArray alloc] init];
        featureArray = [[NSMutableArray alloc] init];
        //        specPreArray = [[NSMutableArray alloc] init];
        
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
            [DCFStringUtil showNotice:@"编辑成功"];
            [self.delegate removeSubView];
            [self.delegate reloadData];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.unitBtn.titleLabel.text forKey:@"unit"];
        }
        else
        {
            [DCFStringUtil showNotice:@"编辑失败"];
        }
    }
}

- (IBAction)unitBtnClick:(id)sender
{
    arr = [[NSMutableArray alloc] initWithObjects:@"KM",@"吨", nil];
    [self loadPickerViewWithArray:arr WithTag:10000];
}

- (IBAction)specBtnClick:(id)sender
{
    [self loadPickerViewWithArray:specArray WithTag:10001];
}

- (IBAction)volBtnClick:(id)sender
{
    if(voltageArray.count == 0 || [voltageArray isKindOfClass:[NSNull class]])
    {
        [DCFStringUtil showNotice:@"暂无电压信息"];
        return;
    }
    [self loadPickerViewWithArray:voltageArray WithTag:10002];
}

- (IBAction)colorBtnClick:(id)sender
{
    arr = [[NSMutableArray alloc] initWithObjects:@"红色",@"黄色",@"蓝色",@"绿色",@"黄绿色",@"白色",@"黑色",@"其他", nil];
    [self loadPickerViewWithArray:arr WithTag:10003];
}

- (IBAction)featherBtnClick:(id)sender
{
    if(featureArray.count == 0 || [featureArray isKindOfClass:[NSNull class]])
    {
        [DCFStringUtil showNotice:@"暂无阻燃信息"];
        return;
    }
    [self loadPickerViewWithArray:featureArray WithTag:10004];
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    if([self.numTF isFirstResponder])
    {
        [self.numTF resignFirstResponder];
    }
    if([self.timeTF isFirstResponder])
    {
        [self.timeTF resignFirstResponder];
    }
    if([self.specTf isFirstResponder])
    {
        [self.specTf resignFirstResponder];
    }
    //    [self.delegate removeSubView];
    //    if(pickerView)
    //    {
    //        [pickerView inAndOut];
    //    }
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
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.specTf)
    {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",textField.text];
        specPreArray = [NSMutableArray arrayWithArray:[specArray filteredArrayUsingPredicate:pred]];
        if(specPreArray.count == 0)
        {
            [DCFStringUtil showNotice:@"暂无该规格信息"];
        }
        else
        {
            [self loadPickerViewWithArray:specPreArray WithTag:10005];
        }
    }
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
    if(textField == self.numTF)
    {
        if([self.timeTF isFirstResponder])
        {
            [self.timeTF resignFirstResponder];
        }
        if([self.specTf isFirstResponder])
        {
            [self.specTf resignFirstResponder];
        }
    }
    if(textField == self.timeTF)
    {
        if([self.numTF isFirstResponder])
        {
            [self.numTF resignFirstResponder];
        }
        if([self.specTf isFirstResponder])
        {
            [self.specTf resignFirstResponder];
        }
    }
    if(textField == self.specTf)
    {
        if([self.numTF isFirstResponder])
        {
            [self.numTF resignFirstResponder];
        }
        if([self.timeTF isFirstResponder])
        {
            [self.timeTF resignFirstResponder];
        }
    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{   //string就是此时输入的那个字符
    //textField就是此时正在输入的那个输入框
    //返回YES可以改变输入框的值  NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.timeTF == textField || self.numTF == textField)  //判断是否是我们想要限定的那个输入框
    {
        if ([toBeString length] >5)
        {
            //如果输入框内容大于5则弹出警告
//            textField.text = [toBeString substringToIndex:5];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                             message:@"超过最大字数不能输入了"
//                                                            delegate:nil
//                                                   cancelButtonTitle:@"Ok"
//                                                   otherButtonTitles:nil, nil];
//            [alert show];
            
            //如果输入框内容大于5则禁止输入
            [textField resignFirstResponder];
            
            return NO;
        }
    }
    return YES;
}

- (void) loadPickerViewWithArray:(NSMutableArray *) array WithTag:(int) tag
{
    [self.numTF resignFirstResponder];
    [self.timeTF resignFirstResponder];
    [self.specTf resignFirstResponder];
    [self.requestTF resignFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:CGRectMake(20, 20, ScreenWidth, ScreenHeight)];
    [UIView commitAnimations];
    
    pickerView = [[DCFPickerView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, self.view.window.frame.size.height) WithArray:array WithTag:tag];
    pickerView.delegate = self;
    [self.view.window setBackgroundColor:[UIColor blackColor]];
    [self.view.window addSubview:pickerView];
}

- (void) pickerView:(NSString *) title WithTag:(int)tag
{

    
    if(tag == 10000)
    {
        [self.unitBtn setTitle:title forState:UIControlStateNormal];
    }
    if(tag == 10001)
    {
        [self.specBtn setTitle:title forState:UIControlStateNormal];
    }
    if(tag == 10002)
    {
        [self.volBtn setTitle:title forState:UIControlStateNormal];
    }
    if(tag == 10003)
    {
        [self.colorBtn setTitle:title forState:UIControlStateNormal];
    }
    if(tag == 10004)
    {
        [self.featherBtn setTitle:title forState:UIControlStateNormal];
    }
    if(tag == 10005)
    {
        [self.specTf setText:title];
    }
}

- (void) pickerViewWithCancel:(NSString *)title WithTag:(int)tag
{
    if(tag == 10005)
    {
        [self.specTf setText:title];
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
    
    NSString *specTfText = self.specTf.text;
    NSString *specTfString = nil;
    if([specArray containsObject:specTfText] == YES)
    {
        specTfString = specTfText;
    }
    else
    {
        specTfString = @"";
    }
    
    NSString *volString = nil;
    if([DCFCustomExtra validateString:self.volBtn.titleLabel.text] == NO)
    {
        volString = @"";
    }
    else
    {
        volString = self.volBtn.titleLabel.text;
    }
    
    NSString *colorString = nil;
    if([DCFCustomExtra validateString:self.colorBtn.titleLabel.text] == NO)
    {
        colorString = @"";
    }
    else
    {
        colorString = self.colorBtn.titleLabel.text;
    }
    
    NSString *feathString = nil;
    if([DCFCustomExtra validateString:self.featherBtn.titleLabel.text] == NO)
    {
        feathString = @"";
    }
    else
    {
        feathString = self.featherBtn.titleLabel.text;
    }
    
    NSString *requireString = nil;
    if([DCFCustomExtra validateString:self.requestTF.text] == NO)
    {
        requireString = @"";
    }
    else
    {
        requireString = self.requestTF.text;
    }
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&cartid=%@&spec=%@&voltage=%@&unit=%@&num=%@&color=%@&featureone=%@&require=%@&deliver=%@",token,self.myCartId,specTfString,volString,self.unitBtn.titleLabel.text,self.numTF.text,colorString,feathString,requireString,self.timeTF.text];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLEditInquiryItemTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/EditInquiryItem.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [self.sureBtn setEnabled:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
