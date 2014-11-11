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

        chooseCity = b2cAddressData.city;
        chooseProvince = b2cAddressData.province;
        chooseAddress = b2cAddressData.area;
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    [self pushAndPopStyle];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    textFieldArray = [[NSMutableArray alloc] init];
    
    
    [self loadSubViews];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:0 target:self action:@selector(rightBtnClick:)];
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
    
    receiverTf = [textFieldArray objectAtIndex:0];
    
    addressNameTf = [textFieldArray objectAtIndex:1];
    chooseAddressName = addressNameTf.text;
    
    zipTf = [textFieldArray objectAtIndex:2];
    
    mobileTf = [textFieldArray objectAtIndex:3];
    
    fixedLineTelephone = [textFieldArray lastObject];
    
    if(receiverTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入收货人信息"];
        return;
    }
    if(addressNameTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入详细地址"];
        return;
    }
    //        if(zipTf.text.length == 0)
    //        {
    //            [DCFStringUtil showNotice:@"请输入邮编信息"];
    //            return;
    //        }
    if(mobileTf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入手机号码"];
        return;
    }
    
    BOOL validateTel = [DCFCustomExtra validateMobile:mobileTf.text];
    if(validateTel == NO)
    {
        [DCFStringUtil showNotice:@"请输入正确的手机号码"];
        return;
    }
    
    //新增
    if(isEditOrAdd == YES)
    {
        NSString *memberid = [self getMemberId];
        
        NSString *time = [DCFCustomExtra getFirstRunTime];
        NSString *string = [NSString stringWithFormat:@"%@%@",@"addMemberAddress",time];
        NSString *token = [DCFCustomExtra md5:string];
        
        NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&receiver=%@&province=%@&city=%@&area=%@&addressname=%@&zip=%@&mobile=%@&tel=%@",memberid,token,receiverTf.text,chooseProvince,chooseCity,chooseAddress,chooseAddressName,zipTf.text,mobileTf.text,fixedLineTelephone.text];
        
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
        
        NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&receiver=%@&province=%@&city=%@&area=%@&addressname=%@&zip=%@&mobile=%@&addressid=%@",memberid,token,receiverTf.text,chooseProvince,chooseCity,chooseAddress,chooseAddressName,zipTf.text,mobileTf.text,b2cAddressData.addressId];
        
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLEditMemberAddressTag delegate:self];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/editMemberAddress.html?"];
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    }
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
        else
        {
            [DCFStringUtil showNotice:msg];

            
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
            [self.navigationController popViewControllerAnimated:YES];
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
    UILabel *addressLabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, size.width,30)];
    [addressLabel_1 setTextAlignment:NSTextAlignmentLeft];
    [addressLabel_1 setFont:[UIFont systemFontOfSize:13]];
    [addressLabel_1 setText:@"所在地区"];
    [self.view addSubview:addressLabel_1];
    
    UILabel *addressLabel_2 = [[UILabel alloc] initWithFrame:CGRectMake(addressLabel_1.frame.origin.x + addressLabel_1.frame.size.width + 10, 20, 320-30-addressLabel_1.frame.size.width, 30)];
    
    if(!b2cAddressData)
    {
        [addressLabel_2 setText:finalAddress];
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"%@%@%@",b2cAddressData.province,b2cAddressData.city,b2cAddressData.area];
        [addressLabel_2 setText:str];
    }
    [addressLabel_2 setTextAlignment:NSTextAlignmentCenter];
    [addressLabel_2 setFont:[UIFont systemFontOfSize:13]];
    addressLabel_2.layer.borderColor = MYCOLOR.CGColor;
    addressLabel_2.layer.borderWidth = 1.0f;
    [addressLabel_2 setTextColor:MYCOLOR];
    [self.view addSubview:addressLabel_2];
    
    CGSize s1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:@"手机号码" WithSize:CGSizeMake(MAXFLOAT, 30)];
    
    for(int i=0;i<5;i++)
    {
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70+50*i, s1.width, 30)];
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
        [self.view addSubview:firstLabel];
        
        DCFMyTextField *tf = [[DCFMyTextField alloc] initWithFrame:CGRectMake(s1.width+20, firstLabel.frame.origin.y, 320-30-s1.width, 30)];
        [tf setDelegate:self];
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
        [self.view addSubview:tf];
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
        
        
//        if(i == 3)
//        {
//            UILabel *pretermissionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, tf.frame.origin.y + tf.frame.size.height + 20, 100, 30)];
//            [pretermissionLabel setText:@"是否为默认"];
//            [pretermissionLabel setTextAlignment:NSTextAlignmentLeft];
//            [pretermissionLabel setFont:[UIFont systemFontOfSize:13]];
//            [self.view addSubview:pretermissionLabel];
//            
//            swith = [[UISwitch alloc] initWithFrame:CGRectMake(pretermissionLabel.frame.origin.x + pretermissionLabel.frame.size.width + 20, pretermissionLabel.frame.origin.y, 40, 30)];
//            [swith setUserInteractionEnabled:YES];
//            [swith setOn:YES];
//            [swith addTarget:self action:@selector(swithChange:) forControlEvents:UIControlEventValueChanged];
//            [self.view addSubview:swith];
//        }
    }
}

- (void) dismissKeyBoard
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:CGRectMake(0, 64, 320, ScreenHeight)];
    
    [UIView commitAnimations];
    
    for(DCFMyTextField *tf in textFieldArray)
    {
        [tf resignFirstResponder];
    }
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
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
            [self.view setFrame:CGRectMake(0, 0, 320, ScreenHeight)];
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
