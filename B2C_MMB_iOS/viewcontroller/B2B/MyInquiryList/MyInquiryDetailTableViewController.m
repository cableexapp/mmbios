//
//  MyInquiryDetailTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-11-7.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyInquiryDetailTableViewController.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "DCFChenMoreCell.h"
#import "LoginNaviViewController.h"

@interface MyInquiryDetailTableViewController ()
{
    DCFChenMoreCell *moreCell;
    NSMutableArray *dataArray;
    
    //    CGFloat labelHeight_1;
    //    CGFloat labelHeight_2;
    //    CGFloat labelHeight_3;
    //    CGFloat labelHeight;
    
    CGFloat height_1;
    CGFloat height_2;
    CGFloat height_3;
    CGFloat height_4;
    
    NSDictionary *ctemsDic;
    
    NSString *ordernum;
}
@end

@implementation MyInquiryDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getInquiryInfo",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&inquiryid=%@",token,self.myInquiryid];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLInquiryDetailTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/getInquiryInfo.html?"];
    
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    [moreCell startAnimation];
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

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    if(URLTag == URLInquiryDetailTag)
    {
        if([[dicRespon allKeys] count] == 0 || [[dicRespon objectForKey:@"ctems"] count] == 0 || [[dicRespon objectForKey:@"ctems"] isKindOfClass:[NSNull class]])
        {
            [moreCell noDataAnimation];
        }
        else
        {
            if(result == 1)
            {
                
                
                ctemsDic = [[NSDictionary alloc] initWithDictionary:[[dicRespon objectForKey:@"ctems"] lastObject]];
                NSString *inquiryserial = [NSString stringWithFormat:@"%@",[ctemsDic objectForKey:@"inquiryserial"]];
                
                int status = [[ctemsDic objectForKey:@"status"] intValue];
                NSString *myStatus = nil;
                if(status == 0)
                {
                    myStatus = @"";
                }
                if(status == 1)
                {
                    myStatus = @"待审核";
                }
                if(status == 2)
                {
                    myStatus = @"询价中";
                }
                if(status == 3)
                {
                    myStatus = @"待接受";
                }
                if(status == 4)
                {
                    myStatus = @"完成询价";
                }
                if(status == 5)
                {
                    myStatus = @"已关闭";
                }
                if(status == 6)
                {
                    myStatus = @"部分完成";
                }

                NSArray *arr = [[NSArray alloc] initWithObjects:inquiryserial,myStatus, nil];
                if([self.delegate respondsToSelector:@selector(ChangeStatusDelegate:)])
                {
                    [self.delegate ChangeStatusDelegate:arr];
                }
                
                if(status == 1)
                {
                    dataArray = [[NSMutableArray alloc] initWithArray:[ctemsDic objectForKey:@"items"]];
                }
                else
                {
                    dataArray = [[NSMutableArray alloc] initWithArray:[ctemsDic objectForKey:@"ctems"]];
                }
                if(dataArray.count == 0)
                {
                    [moreCell noClasses];
                }
                
                
                NSString *time = [DCFCustomExtra getFirstRunTime];
                NSString *string = [NSString stringWithFormat:@"%@%@",@"OrderDetailByNum",time];
                NSString *token = [DCFCustomExtra md5:string];
                
                NSString *pushString = [NSString stringWithFormat:@"token=%@&inquiryid=%@&memberid=%@",token,self.myInquiryid,[self getMemberId]];
                
                conn = [[DCFConnectionUtil alloc] initWithURLTag:URLOrderDetailByNumTag delegate:self];
                
                NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/OrderDetailByNum.html?"];
                
                
                [conn getResultFromUrlString:urlString postBody:pushString method:POST];

            }
            else
            {
                dataArray = [[NSMutableArray alloc] init];
                [moreCell failAcimation];
            }
        }
        
    }
    if(URLTag == URLOrderDetailByNumTag)
    {
        ordernum = [NSString stringWithFormat:@"%@",[dicRespon objectForKey:@"ordernum"]];
        [self performSelectorOnMainThread:@selector(doOrdernum) withObject:nil waitUntilDone:YES];
    }
    [self.tableView reloadData];
}

- (void) doOrdernum
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doOrdernum" object:ordernum];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!dataArray || dataArray.count == 0)
    {
        return 1;
    }
    return 2;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 0;
    }
    if(section == 0)
    {
        return 20;
    }
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    //    [view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    if(section == 0)
    {
        [view setFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        [label setFrame:CGRectMake(10, 0, ScreenWidth-20, 19.5)];
    }
    if(section == 1)
    {
        [view setFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        [label setFrame:CGRectMake(10, 0, ScreenWidth-20, 39.5)];
        [label setText:@"型号信息"];
    }
    [label setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    [view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    [view addSubview:label];
    
    for(int i=0;i<2;i++)
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (view.frame.size.height-0.5)*i, ScreenWidth, 0.5)];
        [lineView setBackgroundColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        [view addSubview:lineView];
    }
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return 1;
    }
    if(section == 0)
    {
        return 1;
    }
    return dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        return 44;
    }
    if(indexPath.section == 0)
    {
        NSString *address = [NSString stringWithFormat:@"%@%@%@%@",[ctemsDic objectForKey:@"province"],[ctemsDic objectForKey:@"city"],[ctemsDic objectForKey:@"district"],[ctemsDic objectForKey:@"address"]];
        CGSize size;
        if([DCFCustomExtra validateString:address] == NO)
        {
            size = CGSizeMake(30, 0);
        }
        else
        {
            size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:address WithSize:CGSizeMake(ScreenWidth-40, MAXFLOAT)];
        }
        return size.height+50;
    }
    else
    {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[dataArray objectAtIndex:indexPath.row]];
        
        
        NSString *theInquirySpec = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquirySpec"]]; //规格
        NSString *theInquiryVoltage = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquiryVoltage"]]; //电压
        NSString *theInquiryFeature = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquiryFeature"]]; //阻燃
        NSString *thecolor = [NSString stringWithFormat:@"%@",[dic objectForKey:@"color"]]; //颜色
        
        NSString *thePrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]]; //价格
        NSString *theRequire = [NSString stringWithFormat:@"%@",[dic objectForKey:@"require"]]; //特殊要求
        
        CGFloat h1 = 0.0;
        CGFloat h2 = 0.0;
        CGFloat h3 = 0.0;
        CGFloat h4 = 0.0;
        if([DCFCustomExtra validateString:theInquirySpec] == NO && [DCFCustomExtra validateString:theInquiryVoltage] == NO)
        {
            h1 = 0;
        }
        else
        {
            h1 = 20;
        }
        if([DCFCustomExtra validateString:theInquiryFeature] == NO && [DCFCustomExtra validateString:thecolor] == NO)
        {
            h2 = 0;
        }
        else
        {
            h2 = 20;
        }
        if([DCFCustomExtra validateString:thePrice] == NO)
        {
            h3 = 0;
        }
        else
        {
            h3 = 20;
        }
        CGSize requestSize;
        if([DCFCustomExtra validateString:theRequire] == NO)
        {
            h4 = 0;
            requestSize = CGSizeMake(ScreenWidth-20, 0);
        }
        else
        {
            requestSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:theRequire WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
            h4 = requestSize.height;
        }
        return 90.5+h1+h2+h3+h4+5;
    }
    
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        static NSString *moreCellId = @"moreCell";
        moreCell = (DCFChenMoreCell *)[tableView dequeueReusableCellWithIdentifier:moreCellId];
        
        if(moreCell == nil)
        {
            moreCell = [[[NSBundle mainBundle] loadNibNamed:@"DCFChenMoreCell" owner:self options:nil] lastObject];
            [moreCell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        }
        return moreCell;
    }
    
    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
//        [cell setSelectionStyle:0];
        
        if(indexPath.section == 0)
        {
            if([[ctemsDic allKeys] count] == 0 || [ctemsDic isKindOfClass:[NSNull class]])
            {
                
            }
            else
            {
                if(indexPath.row == 0)
                {
                    NSString *name_1 = [ctemsDic objectForKey:@"recipint"];
                    NSString *name_2 = nil;
                    if([name_1 rangeOfString:@"(null)"].location != NSNotFound)
                    {
                        name_2 = [name_1 stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        name_2 = [name_1 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"(null)"]];

                    }
                    else if([name_1 rangeOfString:@"null"].location != NSNotFound)
                    {
                        name_2 = [name_1 stringByReplacingOccurrencesOfString:@"null" withString:@""];
                        name_2 = [name_1 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"null"]];
                    }
                    else
                    {
                        name_2 = name_1;
                    }
                    
                    NSString *tel = [NSString stringWithFormat:@"%@",[ctemsDic objectForKey:@"tel"]];
                    NSString *tel_2 = nil;
                    if([tel rangeOfString:@"(null)"].location != NSNotFound)
                    {
                        tel_2 = [tel stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        tel_2 = [tel stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"(null)"]];
                    }
                    else if([tel rangeOfString:@"null"].location != NSNotFound)
                    {
                        tel_2 = [tel stringByReplacingOccurrencesOfString:@"null" withString:@""];
                        tel_2 = [tel stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"null"]];
                    }
                    else
                    {
                        tel_2 = tel;
                    }
                    NSString *str = [NSString stringWithFormat:@"收货人: %@      %@",name_2,tel_2];
                    UILabel *nameAndTelLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, cell.contentView.frame.size.width-20, 30)];
                    
                    NSMutableAttributedString *myName = [[NSMutableAttributedString alloc] initWithString:str];
                    [myName addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
                    [myName addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(4, str.length-4)];
                    [nameAndTelLabel setAttributedText:myName];
                    [nameAndTelLabel setFont:[UIFont systemFontOfSize:12]];
                    [cell.contentView addSubview:nameAndTelLabel];
                    
                    NSString *address = [NSString stringWithFormat:@"收货地址: %@%@%@%@",[ctemsDic objectForKey:@"province"],[ctemsDic objectForKey:@"city"],[ctemsDic objectForKey:@"district"],[ctemsDic objectForKey:@"address"]];
                    NSString *myAdd = nil;
                    if([address rangeOfString:@"(null)"].location != NSNotFound)
                    {
                        myAdd = [address stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        myAdd = [address stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"(null)"]];
                    }
                    else if([address rangeOfString:@"null"].location != NSNotFound)
                    {
                        myAdd = [address stringByReplacingOccurrencesOfString:@"null" withString:@""];
                        myAdd = [address stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"null"]];
                    }
                    else
                    {
                        myAdd = address;
                    }
                    
                    CGSize size;
                    if([DCFCustomExtra validateString:myAdd] == NO)
                    {
                        size = CGSizeMake(30, 30);
                    }
                    else
                    {
                        size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:myAdd WithSize:CGSizeMake(cell.contentView.frame.size.width-20, MAXFLOAT)];
                    }
                    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, nameAndTelLabel.frame.origin.y + nameAndTelLabel.frame.size.height, size.width, size.height)];
                    NSMutableAttributedString *myAddress = [[NSMutableAttributedString alloc] initWithString:myAdd];
                    [myAddress addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
                    [myAddress addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(5, myAdd.length-5)];
                    [addressLabel setAttributedText:myAddress];
                    [addressLabel setFont:[UIFont systemFontOfSize:12]];
                    [addressLabel setNumberOfLines:0];
                    [cell.contentView addSubview:addressLabel];
                }
            }
       
        }
        else
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, 65)];
            [view setBackgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:view];
            
            CGFloat halfWidth = (ScreenWidth-20)/2;
            
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[dataArray objectAtIndex:indexPath.row]];
            
            //型号
            NSString *model = [NSString stringWithFormat:@"型号: %@",[dic objectForKey:@"inquiryModel"]];
            NSMutableAttributedString *myModel = [[NSMutableAttributedString alloc] initWithString:model];
            [myModel addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
            [myModel addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, model.length-3)];
            
            //分类
            NSString *firstType = (NSString *)[dic objectForKey:@"firstType"];
            NSString *secondType = (NSString *)[dic objectForKey:@"secondType"];
            NSString *thridType = (NSString *)[dic objectForKey:@"thridType"];
            NSString *type_1 = [NSString stringWithFormat:@"分类: %@%@%@",firstType,secondType,thridType];
            NSString *type = nil;
            if([type_1 rangeOfString:@"(null)"].location != NSNotFound)
            {
                type = [type_1 stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                type = [type_1 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"(null)"]];
            }
            else if([type_1 rangeOfString:@"null"].location != NSNotFound)
            {
                type = [type_1 stringByReplacingOccurrencesOfString:@"null" withString:@""];
                type = [type_1 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"null"]];
            }
            else
            {
                type = type_1;
            }
            
            
            NSMutableAttributedString *myType = [[NSMutableAttributedString alloc] initWithString:type];
            [myType addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [myType addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, type.length-3)];
            
            UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 30)];
            [modelLabel setAttributedText:myModel];
            [modelLabel setFont:[UIFont systemFontOfSize:12]];
            [view addSubview:modelLabel];
            
            UILabel *fenleiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, modelLabel.frame.origin.y + modelLabel.frame.size.height, modelLabel.frame.size.width, 30)];
            [fenleiLabel setAttributedText:myType];
            [fenleiLabel setNumberOfLines:0];
            [fenleiLabel setFont:[UIFont systemFontOfSize:12]];
            [view addSubview:fenleiLabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.origin.y+view.frame.size.height, cell.contentView.frame.size.width, 0.5)];
            [lineView setBackgroundColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
            [cell.contentView addSubview:lineView];
            
            NSString *theNumber;   //数量
            NSString *unit = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unit"]];
            if([[dic objectForKey:@"num"] floatValue] <= 0.0)
            {
                theNumber = [NSString stringWithFormat:@"数量:"];
            }
            else
            {
               theNumber = [NSString stringWithFormat:@"数量: %@%@",[dic objectForKey:@"num"],unit];
            }
            
            NSMutableAttributedString *myNumber = [[NSMutableAttributedString alloc] initWithString:theNumber];
            [myNumber addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
            [myNumber addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, theNumber.length-3)];
            
            
            NSString *thDeliver;  //交货期
            if([[dic objectForKey:@"deliver"] floatValue] <= 0.0)
            {
                thDeliver = [NSString stringWithFormat:@"交货期:"];
            }
            else
            {
                thDeliver = [NSString stringWithFormat:@"交货期: %@天",[dic objectForKey:@"deliver"]];
            }
            NSMutableAttributedString *myDeliver = [[NSMutableAttributedString alloc] initWithString:thDeliver];
            [myDeliver addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [myDeliver addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(4, thDeliver.length-4)];
            
            NSString *theInquirySpec = [NSString stringWithFormat:@"规格: %@平方",[dic objectForKey:@"inquirySpec"]]; //规格
            NSMutableAttributedString *myInquirySpec = [[NSMutableAttributedString alloc] initWithString:theInquirySpec];
            [myInquirySpec addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
            [myInquirySpec addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, theInquirySpec.length-3)];
            
            NSString *theInquiryVoltage = [NSString stringWithFormat:@"电压: %@",[dic objectForKey:@"inquiryVoltage"]]; //电压
            NSMutableAttributedString *myInquiryVoltage = [[NSMutableAttributedString alloc] initWithString:theInquiryVoltage];
            [myInquiryVoltage addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
            [myInquiryVoltage addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, theInquiryVoltage.length-3)];
            
            
            NSString *theInquiryFeature = [NSString stringWithFormat:@"阻燃耐火: %@",[dic objectForKey:@"inquiryFeature"]]; //阻燃
            NSMutableAttributedString *myInquiryFeature = [[NSMutableAttributedString alloc] initWithString:theInquiryFeature];
            [myInquiryFeature addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
            [myInquiryFeature addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, theInquiryFeature.length-5)];
            
            
            NSString *thecolor = [NSString stringWithFormat:@"颜色: %@",[dic objectForKey:@"color"]]; //颜色
            NSMutableAttributedString *myColor = [[NSMutableAttributedString alloc] initWithString:thecolor];
            [myColor addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
            [myColor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(3, thecolor.length-3)];
            
            NSString *thePrice;//价格
            NSMutableAttributedString *myPrice;
            if([[dic objectForKey:@"price"] floatValue] <= 0.0)
            {
                thePrice = [NSString stringWithFormat:@""];
            }
            else
            {
                thePrice = [NSString stringWithFormat:@"询价结果: %@元/%@",[dic objectForKey:@"price"],unit];
                myPrice = [[NSMutableAttributedString alloc] initWithString:thePrice];
                [myPrice addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
                [myPrice addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, thePrice.length-5)];
            }
            
            NSString *theRequire = [NSString stringWithFormat:@"特殊要求: %@",[dic objectForKey:@"require"]]; //特殊要求
            NSMutableAttributedString *myRequire = [[NSMutableAttributedString alloc] initWithString:theRequire];
            [myRequire addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
            [myRequire addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, theRequire.length-5)];
            
            
            for(int i=0;i<6;i++)
            {
                UILabel *label = [[UILabel alloc] init];
                if(i % 2 != 0)
                {
                    [label setTextAlignment:NSTextAlignmentCenter];
                }
                else
                {
                    [label setTextAlignment:NSTextAlignmentLeft];
                }
                [label setFont:[UIFont systemFontOfSize:12]];
                switch (i) {
                    case 0:
                    {
                        
                        NSString *tempNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"num"]];
                        [label setFrame:CGRectMake(10, lineView.frame.origin.y+5.5, halfWidth, 20)];
                        if([DCFCustomExtra validateString:tempNum] == NO)
                        {
                            [label setText:@"采购数量:"];
                        }
                        else
                        {
                            [label setAttributedText:myNumber];
                        }
                        break;
                    }
                    case 1:
                    {
                        [label setFrame:CGRectMake(10+halfWidth, lineView.frame.origin.y+5.5, halfWidth, 20)];
                        NSString *tempDeliver = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deliver"]];
                        if([DCFCustomExtra validateString:tempDeliver] == NO)
                        {
                            [label setText:[NSString stringWithFormat:@"交货期:%@",@""]];
                        }
                        else
                        {
                            [label setAttributedText:myDeliver];
                        }
                        break;
                    }
                        
                    case 2:
                    {
                        NSString *tempInquirySpec = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquirySpec"]];
                        if([DCFCustomExtra validateString:tempInquirySpec] == NO)
                        {
                            [label setFrame:CGRectMake(10, 90.5, halfWidth, 0)];
                        }
                        else
                        {
                            [label setFrame:CGRectMake(10, 90.5, halfWidth, 20)];
                            [label setAttributedText:myInquirySpec];
                        }
                        break;
                    }
                        
                    case 3:
                    {
                        NSString *tempInquiryVoltage = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquiryVoltage"]];
                        if([DCFCustomExtra validateString:tempInquiryVoltage] == NO)
                        {
                            [label setFrame:CGRectMake(10+halfWidth, 90.5, halfWidth, 0)];
                        }
                        else
                        {
                            [label setAttributedText:myInquiryVoltage];
                            [label setFrame:CGRectMake(10+halfWidth,90.5, halfWidth, 20)];
                        }
                         NSString *tempInquirySpec = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquirySpec"]];
                        if([DCFCustomExtra validateString:tempInquirySpec] == NO && [DCFCustomExtra validateString:tempInquiryVoltage] == NO)
                        {
                            height_1 = 0;
                        }
                        else
                        {
                            height_1 = 20;
                        }
                        
                        break;
                    }
                        
                    case 4:
                    {
                        NSString *tempInquiryFeature = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquiryFeature"]];
                        if([DCFCustomExtra validateString:tempInquiryFeature] == NO)
                        {
                            [label setFrame:CGRectMake(10, 90.5+height_1, halfWidth, 0)];
                        }
                        else
                        {
                            [label setAttributedText:myInquiryFeature];
                            [label setFrame:CGRectMake(10, 90.5+height_1, halfWidth, 20)];
                        }
                        break;
                    }
                        
                    case 5:
                    {
                         NSString *tempColor = [NSString stringWithFormat:@"%@",[dic objectForKey:@"color"]];
                        if([DCFCustomExtra validateString:tempColor] == NO)
                        {
                            [label setFrame:CGRectMake(10+halfWidth, 90.5+height_1, halfWidth, 0)];
                        }
                        else
                        {
                            [label setAttributedText:myColor];
                            [label setFrame:CGRectMake(10+halfWidth, 90.5+height_1, halfWidth, 20)];
                        }
                        NSString *tempInquiryFeature = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inquiryFeature"]];
                        if([DCFCustomExtra validateString:tempInquiryFeature] == NO && [DCFCustomExtra validateString:tempColor] == NO)
                        {
                            height_2 = 0;
                        }
                        else
                        {
                            height_2 = 20;
                        }
                        
                        break;
                    }
                        
                    default:
                        break;
                }
                
                [cell.contentView addSubview:label];
            }
            
            
            UILabel *pricelabel = [[UILabel alloc] init];
            [pricelabel setFont:[UIFont systemFontOfSize:12]];
            NSString *tempPrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];
            if([DCFCustomExtra validateString:tempPrice] == NO)
            {
                [pricelabel setFrame:CGRectMake(10, 90.5+height_1+height_2,ScreenWidth-20,0)];
                height_3 = 0;
            }
            else
            {
                [pricelabel setFrame:CGRectMake(10, 90.5+height_1+height_2,ScreenWidth-20,20)];
                height_3 = 20;
                [pricelabel setAttributedText:myPrice];
            }
            [cell.contentView addSubview:pricelabel];
            
            
            UILabel *requestLabel = [[UILabel alloc] init];
            [requestLabel setFont:[UIFont systemFontOfSize:12]];
            [requestLabel setNumberOfLines:0];
            
            CGSize requestSize;
             NSString *tempRequire = [NSString stringWithFormat:@"%@",[dic objectForKey:@"require"]];
            if([DCFCustomExtra validateString:tempRequire] == NO)
            {
                [requestLabel setFrame:CGRectMake(10, 90.5+height_1+height_2+height_3, ScreenWidth-20, 0)];
                requestSize = CGSizeMake(ScreenWidth-20, 0);
                height_4 = 0;
            }
            else
            {
                requestSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:theRequire WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
                [requestLabel setFrame:CGRectMake(10, 90.5+height_1+height_2+height_3, ScreenWidth-20, requestSize.height)];
                [requestLabel setAttributedText:myRequire];
                height_4 = requestSize.height;
            }
            
            [cell.contentView addSubview:requestLabel];
        }
    }
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
@end
