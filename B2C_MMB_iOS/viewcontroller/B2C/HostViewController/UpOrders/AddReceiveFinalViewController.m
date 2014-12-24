//
//  AddReceiveFinalViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-25.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "AddReceiveFinalViewController.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"
#import "LoginNaviViewController.h"
#import "UpOrderViewController.h"
#import "ChooseReceiveAddressViewController.h"
#import "ManagReceiveAddressViewController.h"
#import "AddReceiveAddressViewController.h"
#import "B2BAskPriceInquirySheetViewController.h"

@implementation AddReceiveFinalViewController
{
    NSMutableArray *dataArray;
    NSString *finalAddress;
    //    UISwitch *swith;
    
    NSMutableArray *textFieldArray;
    
    UIStoryboard *sb;
    
    DCFMyTextField *receiverTf;
    
    DCFMyTextField *addressNameTf;
    
    DCFMyTextField *zipTf;
    
    DCFMyTextField *mobileTf;
    
    DCFMyTextField *fixedLineTelephone;   //固定电话
    
    DCFMyTextField *topTf;
    
    UIView *backView;
    
    UIButton *backBtn;
    
    UILabel *addressLabel_2;
    
    NSDictionary *addSuccessDic;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithAddressData:(B2CAddressData *) addressData;
{
    if(self = [super init])
    {
        b2cAddressData = addressData;
        
        //        NSDictionary *receiveDic = [NSDictionary dictionaryWithObjectsAndKeys:data.addressName,@"receiveaddress",data.city,@"receivecity",data.area,@"receivedistrict",data.province,@"receiveprovince",data.receiver,@"receiver",data.mobile,@"receiveTel",data.addressId,@"receiveAddressId", nil];
        
        
        chooseCity = b2cAddressData.city;
        chooseProvince = b2cAddressData.province;
        chooseAddress = b2cAddressData.area;
        chooseAddressName = b2cAddressData.addressName;
        chooseReceiver = b2cAddressData.receiver;
        chooseCode = b2cAddressData.zip;
        choosePhone = b2cAddressData.mobile;
        chooseTel = b2cAddressData.tel;
        
        //        swith.on = [[_msgDic objectForKey:@"swithStatus"] boolValue];
        
        DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"编辑收货地址"];
        self.navigationItem.titleView = top;
        
        isEditOrAdd = NO;
    }
    return self;
}

- (id) initWithAddress:(NSString *) address WithCode:(NSString *)code WithSwithStatus:(BOOL)status
{
    if(self = [super init])
    {
        finalAddress = address;
        chooseCode = code;
        
        DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"新增收货地址"];
        
        isEditOrAdd = YES;
        
        //        swith.on = status;
        
        self.navigationItem.titleView = top;
        
        NSMutableArray *docArray = [[NSMutableArray alloc] init];
        //截取字符串
        for(int i=0;i<finalAddress.length;i++)
        {
            char c = [finalAddress characterAtIndex:i];
            if(c == ',')
            {
                [docArray addObject:[NSNumber numberWithInt:i]];
            }
        }
        
        chooseProvince = [finalAddress substringToIndex:[[docArray objectAtIndex:0] intValue]];
        
        int cityLength = [[docArray objectAtIndex:1] intValue] - [[docArray objectAtIndex:0] intValue];
        chooseCity = [finalAddress substringWithRange:NSMakeRange([[docArray objectAtIndex:0] intValue]+1, cityLength-1)];
        
        int addressLength = finalAddress.length - [[docArray objectAtIndex:1] intValue];
        chooseAddress = [finalAddress substringWithRange:NSMakeRange([[docArray objectAtIndex:1] intValue]+1, addressLength-1)];
        
        finalAddress = [finalAddress stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    return self;
}

- (void) validateAddress:(int) status
{
    //1-存在 0-不存在
    if(status == 1)
    {
        [DCFStringUtil showNotice:@"该地址已经存在"];
        return;
    }
    else
    {
    }
}

#pragma mark - 完成按钮点击，没修改名字而已
- (void) backBtnClick:(UIButton *) sender
{
    [self dismissKeyBoard];
    
    receiverTf = [textFieldArray objectAtIndex:0];
    
    addressNameTf = [textFieldArray objectAtIndex:1];
    chooseAddressName = addressNameTf.text;
    
    zipTf = [textFieldArray objectAtIndex:2];
    
    mobileTf = [textFieldArray objectAtIndex:3];
    
    fixedLineTelephone = [textFieldArray lastObject];
    
    //    fullAddressTf = [textFieldArray objectAtIndex:<#(NSUInteger)#>];
    if(receiverTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请您填写收货人姓名"];
        return;
    }
    if(addressNameTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请填写详细地址信息"];
        return;
    }
    if(mobileTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"手机号码必填"];
        return;
    }
    
    BOOL validateMobile = [DCFCustomExtra validateMobile:mobileTf.text];
    if(validateMobile == NO)
    {
        [DCFStringUtil showNotice:@"请输入正确的手机号码"];
        return;
    }
    
    if(fixedLineTelephone.text.length != 0)
    {
        BOOL validateTel = [DCFCustomExtra validateTel:fixedLineTelephone.text];
        if(validateTel == NO)
        {
            [DCFStringUtil showNotice:@"请输入正确的固定电话号码"];
            return;
        }
    }
    
    if([DCFCustomExtra validateString:zipTf.text] == NO)
    {
        
    }
    else
    {
        if([DCFCustomExtra validateZip:zipTf.text] == NO)
        {
            [DCFStringUtil showNotice:@"请输入正确的邮编"];
            return;
        }
    }
    NSString *receiver = nil;
    if([DCFCustomExtra validateString:receiverTf.text] == NO)
    {
        receiver = @"";
    }
    else
    {
        receiver = receiverTf.text;
    }
    
    NSString *province = nil;
    if([DCFCustomExtra validateString:chooseProvince] == NO)
    {
        province = @"";
    }
    else
    {
        province = chooseProvince;
    }
    
    NSString *city = nil;
    if([DCFCustomExtra validateString:chooseCity] == NO)
    {
        city = @"";
    }
    else
    {
        city = chooseProvince;
    }
    
    NSString *area = nil;
    if([DCFCustomExtra validateString:chooseAddress] == NO)
    {
        area = @"";
    }
    else
    {
        area = chooseAddress;
    }
    
    NSString *addressname = nil;
    if([DCFCustomExtra validateString:chooseAddressName] == NO)
    {
        addressname = @"";
    }
    else
    {
        addressname = chooseAddressName;
    }
    
    NSString *zip = nil;
    if([DCFCustomExtra validateString:zipTf.text] == NO)
    {
        zip = @"";
    }
    else
    {
        zip = zipTf.text;
    }
    
    NSString *mobile = nil;
    if([DCFCustomExtra validateString:mobileTf.text] == NO)
    {
        mobile = @"";
    }
    else
    {
        mobile = mobileTf.text;
    }
    
    NSString *tel = nil;
    if([DCFCustomExtra validateString:fixedLineTelephone.text] == NO)
    {
        tel = @"";
    }
    else
    {
        tel = fixedLineTelephone.text;
    }
    
    NSString *fulladdress = nil;
    if([DCFCustomExtra validateString:addressNameTf.text] == NO)
    {
        fulladdress = @"";
    }
    else
    {
        fulladdress = addressNameTf.text;
    }
    
    //新增
    if(isEditOrAdd == YES)
    {
        NSString *memberid = [self getMemberId];
        
        NSString *time = [DCFCustomExtra getFirstRunTime];
        NSString *string = [NSString stringWithFormat:@"%@%@",@"addMemberAddress",time];
        NSString *token = [DCFCustomExtra md5:string];

        NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&receiver=%@&province=%@&city=%@&area=%@&addressname=%@&fulladdress=%@&zip=%@&mobile=%@&tel=%@",memberid,token,receiver,province,city,area,addressname,fulladdress,zip,mobile,tel];
        
        NSString *receiveFullAddress = [NSString stringWithFormat:@"%@%@%@%@%@",province,city,area,addressname,fulladdress];
        addSuccessDic = [[NSDictionary alloc] initWithObjectsAndKeys:receiveFullAddress,@"receiveFullAddress",receiver,@"receiver",mobile,@"mobile", nil];
        
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLAddMemberAddressTag delegate:self];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/addMemberAddress.html?"];
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    }
    //编辑
    else
    {
        NSString *memberid = [self getMemberId];
        
        NSString *time = [DCFCustomExtra getFirstRunTime];
        NSString *string = [NSString stringWithFormat:@"%@%@",@"editMemberAddress",time];
        NSString *token = [DCFCustomExtra md5:string];
        
//loginid,memberid（用户id）,token,receiver(收货人),province(省份)city(城市),area(地区),addressname(街道),fulladdress(详细地址),zip(邮编),mobile(联系电话)，tel(固定电话)，addressid(收获地址id)
        NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&receiver=%@&province=%@&city=%@&area=%@&addressname=%@&fulladdress=%@&zip=%@&mobile=%@&tel=%@&addressid=%@",memberid,token,receiver,province,city,area,addressname,fulladdress,zip,mobile,tel,b2cAddressData.addressId];
        NSLog(@"%@",pushString);
        
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLEditMemberAddressTag delegate:self];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/editMemberAddress.html?"];
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    }
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    [self pushAndPopStyle];
    
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, ScreenWidth-20, 250)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    backView.layer.borderColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:1.0].CGColor;
    backView.layer.borderWidth = 1.0f;
    [self.view addSubview:backView];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(20, backView.frame.origin.y + backView.frame.size.height + 10, ScreenWidth-40, 35)];
    [backBtn setTitle:@"完成" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor colorWithRed:10.0/255.0 green:79.0/255.0 blue:191.0/255.0 alpha:1.0]];
    backBtn.layer.cornerRadius = 5.0f;
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    textFieldArray = [[NSMutableArray alloc] init];
    
    
    [self loadSubViews];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:0 target:self action:@selector(rightBtnClick:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    [self dismissKeyBoard];
}

- (void) rightBtnClick:(id) sender
{
    [self dismissKeyBoard];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:4] animated:YES];
    
}


- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if(memberid.length == 0)
    {
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if(URLTag == URLAddMemberAddressTag)
    {
        if(result == 0)
        {
            if(msg.length == 0)
            {
                //                [DCFStringUtil showNotice:@"新增收货地址失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
        else if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddAddressSuccessForB2B" object:addSuccessDic];
            
            for(UIViewController *vc in self.navigationController.viewControllers)
            {
                if([vc isKindOfClass:[ChooseReceiveAddressViewController class]])
                {
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
                if([vc isKindOfClass:[B2BAskPriceInquirySheetViewController class]])
                {
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
            //            [self setDefaultAddress];
            
        }
    }
    if(URLTag == URLEditMemberAddressTag)
    {
        if(result == 0)
        {
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"编辑收货地址失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
        else if (result == 1)
        {
            [DCFStringUtil showNotice:msg];
//            [self.navigationController popViewControllerAnimated:YES];
            for(UIViewController *vc in self.navigationController.viewControllers)
            {
                if([vc isKindOfClass:[ChooseReceiveAddressViewController class]])
                {
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
        }
    }
}

//- (void) setDefaultAddress
//{
//    NSString *memberid = [self getMemberId];
//
//    NSString *time = [DCFCustomExtra getFirstRunTime];
//    NSString *string = [NSString stringWithFormat:@"%@%@",@"setDefaultMemberAddress",time];
//    NSString *token = [DCFCustomExtra md5:string];
//
//    NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&addressid=%@&status=%@",memberid,token,chooseCode,[NSString stringWithFormat:@"%d",swith.on]];
//
//    NSLog(@"%@",pushString);
//
//    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSetDefaultMemberAddressTag delegate:self];
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/setDefaultMemberAddress.html?"];
//    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
//
//}

- (void) loadSubViews
{
    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:@"所在地区" WithSize:CGSizeMake(MAXFLOAT, 30)];
    UILabel *addressLabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, size.width,30)];
    [addressLabel_1 setTextAlignment:NSTextAlignmentLeft];
    [addressLabel_1 setFont:[UIFont systemFontOfSize:13]];
    [addressLabel_1 setText:@"所在地区"];
    [backView addSubview:addressLabel_1];
    
    UIView *line_1 = [[UIView alloc] initWithFrame:CGRectMake(10, addressLabel_1.frame.origin.y + addressLabel_1.frame.size.height + 5, backView.frame.size.width-20, 1)];
    [line_1 setBackgroundColor:[UIColor lightGrayColor]];
    [backView addSubview:line_1];
    
    
    topTf = [[DCFMyTextField alloc] initWithFrame:CGRectMake(addressLabel_1.frame.origin.x + addressLabel_1.frame.size.width + 10, addressLabel_1.frame.origin.y, backView.frame.size.width-30-addressLabel_1.frame.size.width, 30)];
    [topTf setDelegate:self];
    //    addressLabel_2 = [[UILabel alloc] initWithFrame:CGRectMake(addressLabel_1.frame.origin.x + addressLabel_1.frame.size.width + 10, addressLabel_1.frame.origin.y, backView.frame.size.width-30-addressLabel_1.frame.size.width, 30)];
    
    if(!b2cAddressData)
    {
        [topTf setText:finalAddress];
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"%@%@%@",b2cAddressData.province,b2cAddressData.city,b2cAddressData.area];
        [topTf setText:str];
    }
    [topTf setTextAlignment:NSTextAlignmentCenter];
    [topTf setFont:[UIFont systemFontOfSize:13]];
    topTf.layer.borderColor = MYCOLOR.CGColor;
    topTf.layer.borderWidth = 1.0f;
    [topTf setTextColor:MYCOLOR];
    [backView addSubview:topTf];
    
    CGSize s1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:@"手机号码" WithSize:CGSizeMake(MAXFLOAT, 30)];
    
    for(int i=0;i<5;i++)
    {
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50+40*i, s1.width, 30)];
        [firstLabel setFont:[UIFont systemFontOfSize:13]];
        [firstLabel setTextAlignment:NSTextAlignmentLeft];
        switch (i) {
            case 0:
                [firstLabel setText:@"收货人"];
                break;
            case 1:
                [firstLabel setText:@"详细地址"];
                break;
            case 2:
                [firstLabel setText:@"邮编"];
                break;
            case 3:
                [firstLabel setText:@"手机号码"];
                break;
            case 4:
                [firstLabel setText:@"固定电话"];
            default:
                break;
        }
        if(i < 4)
        {
            UIView *line_2 = [[UIView alloc] initWithFrame:CGRectMake(10, firstLabel.frame.origin.y + firstLabel.frame.size.height + 5, backView.frame.size.width-20, 1)];
            [line_2 setBackgroundColor:[UIColor lightGrayColor]];
            [backView addSubview:line_2];
        }
        [backView addSubview:firstLabel];
        
        DCFMyTextField *tf = [[DCFMyTextField alloc] initWithFrame:CGRectMake(s1.width+20, firstLabel.frame.origin.y, backView.frame.size.width-30-s1.width, 30)];
        [tf setDelegate:self];
        [tf setFont:[UIFont systemFontOfSize:13]];
        [tf setTag:i];
        if(i < 3)
        {
            if(i == 2)
            {
                [tf setPlaceholder:@"选填"];
            }
            [tf setReturnKeyType:UIReturnKeyNext];
        }
        else
        {
            if(i == 4)
            {
                [tf setPlaceholder:@"选填，电话的格式：区号-电话号码-分机"];
            }
            [tf setReturnKeyType:UIReturnKeyDone];
        }
        [backView addSubview:tf];
        [textFieldArray addObject:tf];
        
        if(i == 0)
        {
            if(!b2cAddressData)
            {
                
            }
            else
            {
                [tf setText:[_msgDic objectForKey:@"name"]];
            }
        }
        if(i == 1)
        {
            if(!b2cAddressData)
            {
                
            }
            else
            {
                [tf setText:[_msgDic objectForKey:@"address"]];
            }
        }
        if(i == 2)
        {
            [tf setKeyboardType:UIKeyboardTypeNumberPad];
            if(!b2cAddressData)
            {
                
            }
            else
            {
                //                [tf setPlaceholder:[_msgDic objectForKey:@"name"]];
            }
        }
        if(i == 3)
        {
            [tf setKeyboardType:UIKeyboardTypeNumberPad];
            if(!b2cAddressData)
            {
                
            }
            else
            {
                [tf setText:[_msgDic objectForKey:@"tel"]];
            }
        }
        if(i == 4)
        {
            //            [tf setKeyboardType:UIKeyboardTypeNumberPad];
            //            if(!_msgDic || [[_msgDic allKeys] count] == 0)
            //            {
            //
            //            }
            //            else
            //            {
            //                [tf setText:[_msgDic objectForKey:@"tel"]];
            //            }
        }
        
        //陈晓修改
        if(isEditOrAdd == NO)
        {
            for(int i=0;i<textFieldArray.count;i++)
            {
                DCFMyTextField *textField = [textFieldArray objectAtIndex:i];
                if(i==0)
                {
                    [textField setText:chooseReceiver];
                }
                if(i == 1)
                {
                    [textField setText:chooseAddressName];
                }
                if(i == 2)
                {
                    [textField setText:chooseCode];
                }
                if(i == 3)
                {
                    [textField setText:choosePhone];
                }
                if(i == 4)
                {
                    NSLog(@"chooseTel = %@",chooseTel);
                    [textField setText:chooseTel];
                }
            }
        }
    }
}

- (void) dismissKeyBoard
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    if(ScreenHeight <= 500)
    {
        [self.view setFrame:CGRectMake(0, 64, 320, ScreenHeight)];
    }
    else
    {
        
    }
    
    [UIView commitAnimations];
    
    for(DCFMyTextField *tf in textFieldArray)
    {
        [tf resignFirstResponder];
    }
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == topTf)
    {
        [topTf resignFirstResponder];
        return YES;
    }
    int tag = textField.tag;
    [textField resignFirstResponder];
    if(tag < textFieldArray.count)
    {
        if(tag == 4)
        {
            //            DCFMyTextField *tf = [textFieldArray lastObject];
            //            [tf resignFirstResponder];
            
            [self dismissKeyBoard];
        }
        else
        {
            DCFMyTextField *tf = [textFieldArray objectAtIndex:tag+1];
            [tf becomeFirstResponder];
        }
        
    }
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == topTf)
    {
        if(isEditOrAdd == NO)
        {
            [topTf resignFirstResponder];
            AddReceiveAddressViewController *add = [[AddReceiveAddressViewController alloc] init];
            [self.navigationController pushViewController:add animated:YES];
            //            NSLog(@"%@",self.navigationController.viewControllers);
            //
            //            for(UIViewController *vc in self.navigationController.viewControllers)
            //            {
            //                if([vc isKindOfClass:[ManagReceiveAddressViewController class]])
            //                {
            //                    [self.navigationController popToViewController:vc animated:YES];
            //                }
            //            }
            
        }
    }
    
    if(textField.tag == 2 || textField.tag == 3 || textField.tag == 4)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        if(ScreenHeight <= 500)
        {
            [self.view setFrame:CGRectMake(0, -40, 320, ScreenHeight)];
        }
        else
        {
            //            [self.view setFrame:CGRectMake(0, 0, 320, ScreenHeight)];
        }
        [UIView commitAnimations];
    }
    //        if()
    //    }
}

- (void) swithChange:(UISwitch *) sender
{
    BOOL flag = sender.on;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
