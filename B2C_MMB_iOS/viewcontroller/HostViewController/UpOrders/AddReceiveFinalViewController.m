//
//  AddReceiveFinalViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-25.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "AddReceiveFinalViewController.h"
#import "DCFCustomExtra.h"

@implementation AddReceiveFinalViewController
{
    NSMutableArray *dataArray;
    NSString *finalAddress;
    UISwitch *swith;
    
    NSMutableArray *textFieldArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithAddress:(NSString *) address
{
    if(self = [super init])
    {
        finalAddress = address;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    [self pushAndPopStyle];
    
    textFieldArray = [[NSMutableArray alloc] init];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"新增收货地址"];
    self.navigationItem.titleView = top;
    
    [self loadSubViews];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:0 target:self action:@selector(rightBtnClick:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void) rightBtnClick:(id) sender
{
    [self dismissKeyBoard];
    for(DCFMyTextField *tf in textFieldArray)
    {
//        if(tf.becomeFirstResponder == YES)
//        {
            [tf resignFirstResponder];
//        }
    }
}

- (void) loadSubViews
{
    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:@"所在地区" WithSize:CGSizeMake(MAXFLOAT, 30)];
    UILabel *addressLabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, size.width,30)];
    [addressLabel_1 setTextAlignment:NSTextAlignmentLeft];
    [addressLabel_1 setFont:[UIFont systemFontOfSize:13]];
    [addressLabel_1 setText:@"所在地区"];
    [self.view addSubview:addressLabel_1];
    
    UILabel *addressLabel_2 = [[UILabel alloc] initWithFrame:CGRectMake(addressLabel_1.frame.origin.x + addressLabel_1.frame.size.width + 10, 20, 320-30-addressLabel_1.frame.size.width, 30)];
    [addressLabel_2 setText:finalAddress];
    [addressLabel_2 setTextAlignment:NSTextAlignmentCenter];
    [addressLabel_2 setFont:[UIFont systemFontOfSize:13]];
    addressLabel_2.layer.borderColor = [UIColor blueColor].CGColor;
    addressLabel_2.layer.borderWidth = 1.0f;
    [addressLabel_2 setTextColor:[UIColor blueColor]];
    [self.view addSubview:addressLabel_2];
    
    CGSize s1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:@"手机号码" WithSize:CGSizeMake(MAXFLOAT, 30)];
    
    for(int i=0;i<4;i++)
    {
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70+50*i, s1.width, 30)];
        [firstLabel setFont:[UIFont systemFontOfSize:13]];
        [firstLabel setTextAlignment:NSTextAlignmentLeft];
        switch (i) {
            case 0:
                [firstLabel setText:@"收货人"];
                break;
            case 1:
                [firstLabel setText:@"街道"];
                break;
            case 2:
                [firstLabel setText:@"邮编"];
                break;
            case 3:
                [firstLabel setText:@"手机号码"];
                break;
            default:
                break;
        }
        [self.view addSubview:firstLabel];
        
        DCFMyTextField *tf = [[DCFMyTextField alloc] initWithFrame:CGRectMake(s1.width+20, firstLabel.frame.origin.y, 320-30-s1.width, 30)];
        [tf setDelegate:self];
        [tf setTag:i];
        if(i < 3)
        {
            [tf setReturnKeyType:UIReturnKeyNext];
        }
        else
        {
            [tf setReturnKeyType:UIReturnKeyDone];
        }
        [self.view addSubview:tf];
        [textFieldArray addObject:tf];
        
        if(i == 3)
        {
            UILabel *pretermissionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, tf.frame.origin.y + tf.frame.size.height + 20, 100, 30)];
            [pretermissionLabel setText:@"是否为默认"];
            [pretermissionLabel setTextAlignment:NSTextAlignmentLeft];
            [pretermissionLabel setFont:[UIFont systemFontOfSize:13]];
            [self.view addSubview:pretermissionLabel];
            
            swith = [[UISwitch alloc] initWithFrame:CGRectMake(pretermissionLabel.frame.origin.x + pretermissionLabel.frame.size.width + 20, pretermissionLabel.frame.origin.y, 40, 30)];
            [swith setUserInteractionEnabled:YES];
            [swith setOn:YES];
            [swith addTarget:self action:@selector(swithChange:) forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:swith];
        }
    }
}

- (void) dismissKeyBoard
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:CGRectMake(0, 64, 320, ScreenHeight)];

    [UIView commitAnimations];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    int tag = textField.tag;
    [textField resignFirstResponder];
    if(tag < textFieldArray.count)
    {
        if(tag == 3)
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
    
    if(ScreenHeight <= 500)
    {
        if(textField.tag == 2)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [self.view setFrame:CGRectMake(0, -40, 320, ScreenHeight)];
            [UIView commitAnimations];
        }
//        if()
    }
}

- (void) swithChange:(UISwitch *) sender
{
    BOOL flag = sender.on;
    NSLog(@"flag = %d",flag);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
