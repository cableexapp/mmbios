//
//  UpOrderViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-9-23.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "UpOrderViewController.h"
#import "DCFCustomExtra.h"
#import "DCFTopLabel.h"
#import "BillMsgManagerViewController.h"
#import "ChoosePayTableViewController.h"
#import "LoginNaviViewController.h"
#import "DCFStringUtil.h"
#import "B2CAddressData.h"
#import "B2CShopCarListData.h"
#import "UIImageView+WebCache.h"
#import "DCFMyTextField.h"
#import "DCFColorUtil.h"

@interface UpOrderViewController ()
{
    UIView *buttomView;
    
    DCFPickerView *pickerView;
    
    NSString *billMsg;
    NSString *billId;  //发票id
    
    UIStoryboard *sb;
    
    NSMutableArray *addressListDataArray;   //收货地址数组
    
    
    NSString *myAddressId;
    
    UILabel *totalMoneyLabel;
    UILabel *moneyLabel;
    
    int totalSection;
    
    NSMutableArray *cellTextFieldArray;
    
    NSDictionary *addressDic;
    
    NSMutableArray *chooseSendMethodArray;
    NSMutableArray *chooseSendTitleArray;
    //    NSMutableArray *totalMoneyArray;
    
    //    int totalMoney;
    
    int myTag;
    
    NSString *orderNum;
    
    NSString *totalPrice;
    
    UILabel *billReceiveAddressLabel_1;
    UILabel *billReceiveAddressLabel_2;
    
    NSString *receiveprovince;
    NSString *receivecity;
    NSString *receivedistrict;
    NSString *receiveaddress;
    NSString *receiver;
    NSString *receiveAddressId;
    NSString *receiveTel;
    NSString *invoiceId;
    NSString *usefp;
    
    //    UILabel *sendMoneyLabel;
    
    NSMutableArray *sendMethodBtnArray;
    
    NSMutableArray *priceArray;
    
    DCFMyTextField *theTextField;
    
    
    ChooseReceiveAddressViewController *chooseAddress;
}
@end

@implementation UpOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) changeReceiveAddress:(NSDictionary *) dic
{
    addressDic = [[NSDictionary alloc] initWithDictionary:dic];
    
    if(!billReceiveAddressLabel_1)
    {
        billReceiveAddressLabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(53, 5, ScreenWidth-63, 30)];
        [billReceiveAddressLabel_1 setFont:[UIFont systemFontOfSize:14]];
        billReceiveAddressLabel_1.textColor = [DCFColorUtil colorFromHexRGB:@"#ba7d04"];
    }
    if(!billReceiveAddressLabel_2)
    {
        billReceiveAddressLabel_2 = [[UILabel alloc] init];
        [billReceiveAddressLabel_2 setFont:[UIFont systemFontOfSize:13]];
        billReceiveAddressLabel_2.textColor = [DCFColorUtil colorFromHexRGB:@"#ba7d04"];
        [billReceiveAddressLabel_2 setNumberOfLines:2];
    }
    
    if([[addressDic allKeys] count] == 0 || [addressDic isKindOfClass:[NSNull class]])
    {
        [billReceiveAddressLabel_1 setText:@"暂无收货地址"];
        [billReceiveAddressLabel_2 setFrame:CGRectMake(53, billReceiveAddressLabel_1.frame.origin.y + billReceiveAddressLabel_1.frame.size.height, ScreenWidth-63, 0)];
        
        receiveaddress = @"";
        receivecity = @"";
        receivedistrict = @"";
        receiveprovince = @"";
        receiver = @"";
        receiveTel = @"";
        receiveAddressId = @"";
        addressDic = [[NSDictionary alloc] init];
        
    }
    else
    {
        
        receiver = [NSString stringWithFormat:@"%@",[addressDic objectForKey:@"receiver"]];
        receiveTel = [NSString stringWithFormat:@"%@",[addressDic objectForKey:@"receiveTel"]];
        receiveprovince = [NSString stringWithFormat:@"%@",[addressDic objectForKey:@"receiveprovince"]];
        receivecity = [NSString stringWithFormat:@"%@",[addressDic objectForKey:@"receivecity"]];
        receivedistrict = [NSString stringWithFormat:@"%@",[addressDic objectForKey:@"receivedistrict"]];
        receiveaddress = [NSString stringWithFormat:@"%@",[addressDic objectForKey:@"receiveaddress"]];
        receiveAddressId = [NSString stringWithFormat:@"%@",[addressDic objectForKey:@"receiveAddressId"]];
        
        [billReceiveAddressLabel_1 setText:[NSString stringWithFormat:@"收货人: %@             %@",receiver,receiveTel]];
        
        NSString *fullAddress = [NSString stringWithFormat:@"%@%@%@%@",receiveprovince,receivecity,receivedistrict,receiveaddress];
        if([DCFCustomExtra validateString:fullAddress] == NO)
        {
            [billReceiveAddressLabel_2 setFrame:CGRectMake(53, billReceiveAddressLabel_1.frame.origin.y + billReceiveAddressLabel_1.frame.size.height, ScreenWidth-63, 0)];
        }
        else
        {
            //            CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:fullAddress WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
            [billReceiveAddressLabel_2 setFrame:CGRectMake(53, billReceiveAddressLabel_1.frame.origin.y + billReceiveAddressLabel_1.frame.size.height-5, ScreenWidth-83, 45)];
        }
        //        [billReceiveAddressLabel_2 setFrame:CGRectMake(10, billReceiveAddressLabel_1.frame.origin.y + billReceiveAddressLabel_1.frame.size.height, ScreenWidth-20, 30)];
        [billReceiveAddressLabel_2 setText:[NSString stringWithFormat:@"收货地址: %@",fullAddress]];
        
    }
    if(tv)
    {
        [tv reloadData];
        //        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        //        NSArray *arr = [NSArray arrayWithObject:path];
        //        [tv reloadRowsAtIndexPaths:arr withRowAnimation:0];
    }
}

- (void) receveAddress:(NSDictionary *)dic
{
    [self changeReceiveAddress:dic];
}

#pragma mark - tag为1表示从购物车列表进来，0表示从商品详情页点击立即购买进来
- (id) initWithDataArray:(NSMutableArray *) dataArray WithMoney:(double) money WithOrderData:(B2CUpOrderData *) orderData WithTag:(int)tag
{
    if(self = [super init])
    {
        
        chooseAddress = [[ChooseReceiveAddressViewController alloc] init];
        chooseAddress.delegate = self;
        [chooseAddress loadRequest];
        
        goodsMoney = money;
        NSLog(@"goodsMoney = %f",goodsMoney);
        goodsListArray = [[NSMutableArray alloc] init];
        
        myTag = tag;
        
        //收货地址
        b2cOrderData = orderData;
        if(b2cOrderData.addressArray.count == 0)
        {
            
        }
        else
        {
            //            for(NSDictionary *dic in b2cOrderData.addressArray)
            //            {
            //                if([dic.allKeys count] == 0)
            //                {
            //
            //                }
            //                else
            //                {
            //                    if([[dic objectForKey:@"isDefault"] isEqualToString:@"1"])
            //                    {
            //                        addressDic = [[NSDictionary alloc] initWithDictionary:dic];
            //                    }
            //                }
            //            }
        }
        
        chooseSendMethodArray = [[NSMutableArray alloc] init];
        chooseSendTitleArray = [[NSMutableArray alloc] init];
        //运费
        if(b2cOrderData.summariesArray.count == 0)
        {
            
        }
        else
        {
            
            for(int i=0;i<b2cOrderData.summariesArray.count;i++)
            {
                NSDictionary *dic = [b2cOrderData.summariesArray objectAtIndex:i];
                NSString *freightType = [dic objectForKey:@"freightType"];
                
                NSMutableArray *sendMethodArray = nil;
                if([freightType isEqualToString:@"1"])
                {
                    sendMethodArray = [[NSMutableArray alloc] init];
                }
                else if ([freightType isEqualToString:@"2"])
                {
                    sendMethodArray = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"normalFreight"]];
                }
                else if ([freightType isEqualToString:@"3"])
                {
                    sendMethodArray = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"templateFreight"]];
                }
                else
                {
                    sendMethodArray = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"mixFreight"]];
                }
                [chooseSendMethodArray addObject:sendMethodArray];
            }
        }
        
        if(chooseSendMethodArray.count == 0)
        {
            
        }
        else
        {
            NSLog(@"chooseSendMethodArray = %@",chooseSendMethodArray);
            for(int i=0;i<chooseSendMethodArray.count;i++)
            {
                NSArray *tempArr = [NSArray arrayWithArray:[chooseSendMethodArray objectAtIndex:i]];
                if(tempArr.count == 0)
                {
                    
                }
                else
                {
                    NSDictionary *d = [NSDictionary dictionaryWithDictionary:[tempArr lastObject]];
                    NSArray *childrenArray = [NSArray arrayWithArray:[d objectForKey:@"children"]];
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    for(int j=0;j<childrenArray.count;j++)
                    {
                        NSDictionary *childrenDic = [NSDictionary dictionaryWithDictionary:[childrenArray objectAtIndex:j]];
                        NSString *childrenName = [NSString stringWithFormat:@"%@",[childrenDic objectForKey:@"value"]];
                        [array addObject:childrenName];
                    }
                    
                    int min = [self getMin:array WithSize:array.count];
                    for(int k=0;k<childrenArray.count;k++)
                    {
                        NSDictionary *childrenDic = [NSDictionary dictionaryWithDictionary:[childrenArray objectAtIndex:k]];
                        if([[childrenDic objectForKey:@"value"] intValue] == min)
                        {
                            [chooseSendTitleArray addObject:[NSString stringWithFormat:@"%@",[childrenDic objectForKey:@"name"]]];
                            break;
                        }
                    }
                }
            }
        }
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        priceArray = [[NSMutableArray alloc] init];
        
        NSString *totalString = nil;
        //购物车进来
        if(myTag == 1)
        {
            
            for(int i=0;i<dataArray.count;i++)
            {
                B2CShopCarListData *listData = [dataArray objectAtIndex:i];
                [tempArray addObject:listData.shopId];
            }
            
            //去处重复元素
            NSSet *set = [NSSet setWithArray:tempArray];
            
            
            for(int i=0;i<[[set allObjects] count];i++)
            {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for(B2CShopCarListData *data in dataArray)
                {
                    if([data.shopId isEqualToString:[[set allObjects] objectAtIndex:i]])
                    {
                        [arr addObject:data];
                    }
                }
                [goodsListArray addObject:arr];
            }
            totalSection = goodsListArray.count+3;
            
            cellTextFieldArray = [[NSMutableArray alloc] init];
            sendMethodBtnArray = [[NSMutableArray alloc] init];
            
            for(int i=0;i<goodsListArray.count;i++)
            {
                DCFMyTextField *tf = [[DCFMyTextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
                [tf setDelegate:self];
                [tf setReturnKeyType:UIReturnKeyDone];
                [cellTextFieldArray addObject:tf];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTag:i];
                [sendMethodBtnArray addObject:btn];
                
                //                double doublePrice = 0.00;
            }
            
            double mon = 0.0;
            for(int i=0;i<goodsListArray.count;i++)
            {
                NSMutableArray *a = (NSMutableArray *)[goodsListArray objectAtIndex:i];
                for(int j=0;j<a.count;j++)
                {
                    B2CShopCarListData *data = [a objectAtIndex:j];
                    NSString *numberr = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",data.num]];
                    double money = [numberr intValue] * [data.price doubleValue];
                    mon = mon + money;
                }
            }
            for(int i=0;i<chooseSendTitleArray.count;i++)
            {
                NSString *title = [chooseSendTitleArray objectAtIndex:i];
                [priceArray addObject:[NSNumber numberWithDouble:[[self getNumFromString:title] doubleValue]]];
                
                mon = mon + [[self getNumFromString:title] doubleValue];
            }
            totalString = [NSString stringWithFormat:@"¥%@",[DCFCustomExtra notRounding:mon afterPoint:2]];
//            CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:totalString WithSize:CGSizeMake(MAXFLOAT, 20)];
//            [moneyLabel setFrame:CGRectMake(ScreenWidth-110-size.width, 10, size.width, 20)];
//            [moneyLabel setText:totalString];
//            
//            [totalMoneyLabel setFrame:CGRectMake(moneyLabel.frame.origin.x-55, 10, 50, 20)];
            
        }
        //立即购买进来
        else if (myTag == 0)
        {
            [goodsListArray addObject:dataArray];
            totalSection = 4;
            
            cellTextFieldArray = [[NSMutableArray alloc] init];
            sendMethodBtnArray = [[NSMutableArray alloc] init];
            
            NSString *title = nil;
            if(!chooseSendTitleArray || chooseSendTitleArray.count == 0)
            {
                title = @"";
            }
            else
            {
                title = [chooseSendTitleArray objectAtIndex:0];
            }
            [priceArray addObject:[NSNumber numberWithDouble:[[self getNumFromString:title] doubleValue]]];
            double doubleMoney = goodsMoney + [[self getNumFromString:title] doubleValue];
            totalString = [NSString stringWithFormat:@"%@",[DCFCustomExtra notRounding:doubleMoney afterPoint:2]];
            
            
            for(int i=0;i<goodsListArray.count;i++)
            {
                DCFMyTextField *tf = [[DCFMyTextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
                [tf setDelegate:self];
                [tf setReturnKeyType:UIReturnKeyDone];
                [cellTextFieldArray addObject:tf];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTag:i];
                [sendMethodBtnArray addObject:btn];
                
            }
        }
        
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:totalString WithSize:CGSizeMake(MAXFLOAT, 20)];
        [moneyLabel setFrame:CGRectMake(ScreenWidth-110-size.width, 10, size.width, 20)];
        [moneyLabel setText:totalString];
        
        [totalMoneyLabel setFrame:CGRectMake(moneyLabel.frame.origin.x-55, 10, 50, 20)];
        [tv reloadData];
    }
    return self;
}

#pragma mark - 取数组中最小值/最大值
- (int) getMin:(NSMutableArray *) arr WithSize:(int) size
{
    int i;
    int min = [arr[0] intValue];
    for (i = 1; i < size; i++)
    {
        if (min > [arr[i] intValue]) min = [arr[i] intValue];
    }
    return min;
    
    //    int i;
    //    int max = arr[0];
    //    for (i = 1; i < size; i++)
    //    {
    //        if (max < arr[i]) max = arr[i];
    //    }
    //    return max;
    
}

- (void) cellBtnClick:(UIButton *) sender
{
    int tag = sender.tag;
    if(myTag == 1)
    {
        
        if([[chooseSendMethodArray objectAtIndex:tag] count] == 0)
        {
            
        }
        else
        {
            pickerView = [[DCFPickerView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, self.view.window.frame.size.height) WithArray:[chooseSendMethodArray objectAtIndex:tag] WithTag:tag];
            pickerView.delegate = self;
            [self.view.window setBackgroundColor:[UIColor blackColor]];
            [self.view.window addSubview:pickerView];
        }
    }
    else
    {
        if([[chooseSendMethodArray objectAtIndex:tag] count] == 0)
        {
            
        }
        else
        {
            pickerView = [[DCFPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.window.frame.size.height) WithArray:[chooseSendMethodArray objectAtIndex:tag] WithTag:tag];
            pickerView.delegate = self;
            [self.view.window setBackgroundColor:[UIColor blackColor]];
            [self.view.window addSubview:pickerView];
        }
    }
    
}

- (NSString *)dictoJSON:(NSDictionary *)theDic
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strP = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    return [Rsa rsaEncryptString:strP];
    return strP;
}

- (void) upBtnClick:(UIButton *) sender
{
    //商铺数组
    NSMutableArray *shopArray = [[NSMutableArray alloc] init];
    
    for(int i=0;i<goodsListArray.count;i++)
    {
        NSString *logo = [self getNumFromString:[chooseSendTitleArray objectAtIndex:i]];
        if(logo.length == 0 || [logo isKindOfClass:[NSNull class]])
        {
            logo = @"0";
        }
        NSString *shopId = nil;
        NSString *shopName = nil;
        
        //商品数组
        NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
        
        if(myTag == 1)
        {
            shopId = [[[goodsListArray objectAtIndex:i] lastObject] shopId];
            shopName = [[[goodsListArray objectAtIndex:i] lastObject] sShopName];
            
            for(int j=0;j<[[goodsListArray objectAtIndex:i] count];j++)
            {
                //行（每个商铺里面有几个商品）
                B2CShopCarListData *carListData = [[goodsListArray objectAtIndex:i] objectAtIndex:j];
                
                //商品字典
                NSDictionary *goodsDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          carListData.colorId,@"colorId",
                                          carListData.colorName,@"colorName",
                                          carListData.recordId,@"recordId",
                                          @"",@"createDate",
                                          carListData.isAvaliable,@"isAvaliable",
                                          carListData.itemId,@"itemId",
                                          carListData.isDelete,@"isDelete",
                                          carListData.num,@"count",
                                          carListData.productItemPic,@"p1Path",
                                          carListData.productId,@"productId",
                                          carListData.productItemSku,@"productName",
                                          carListData.price,@"productPrice",
                                          carListData.productItmeTitle,@"productTitle",
                                          nil];
                
                [goodsArray addObject:goodsDic];
            }
        }
        else
        {
            NSArray *itemArray = [[[[[goodsListArray lastObject] lastObject] summariesArray] lastObject] objectForKey:@"items"];
            NSDictionary *itemDic = [[NSDictionary alloc] initWithDictionary:[itemArray lastObject]];
            
            
            shopId = [[itemArray lastObject] objectForKey:@"shopId"];
            shopName = [[itemArray lastObject] objectForKey:@"sShopName"];
            
            //商品字典
            NSDictionary *goodsDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      [itemDic objectForKey:@"recordId"],@"colorId",
                                      [itemDic objectForKey:@"colorName"],@"colorName",
                                      [itemDic objectForKey:@"recordId"],@"recordId",
                                      @"",@"createDate",
                                      [itemDic objectForKey:@"isAvaliable"],@"isAvaliable",
                                      [itemDic objectForKey:@"recordId"],@"itemId",
                                      [itemDic objectForKey:@"isDelete"],@"isDelete",
                                      [itemDic objectForKey:@"num"],@"count",
                                      [itemDic objectForKey:@"productItemPic"],@"p1Path",
                                      [itemDic objectForKey:@"productId"],@"productId",
                                      [itemDic objectForKey:@"productItemSku"],@"productName",
                                      [itemDic objectForKey:@"price"],@"productPrice",
                                      [itemDic objectForKey:@"productItmeTitle"],@"productTitle",
                                      nil];
            
            [goodsArray addObject:goodsDic];
        }
        
        DCFMyTextField *tf = [cellTextFieldArray objectAtIndex:i];
        NSDictionary *shopDic  = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  goodsArray,@"goodsList",
                                  logo,@"logostocsPrice",
                                  tf.text,@"remark",
                                  shopId,@"shopId",
                                  shopName,@"shopName",
                                  nil];
        [shopArray addObject:shopDic];
    }
    if(billId.length == 0)
    {
        billId = @"";
    }
    else
    {
        
    }
    
    NSString *s1 = billReceiveAddressLabel_1.text;
    NSString *s2 = billReceiveAddressLabel_2.text;
    if([DCFCustomExtra validateString:s1] == NO || [DCFCustomExtra validateString:s2] == NO)
    {
        [DCFStringUtil showNotice:@"收货地址不能为空"];
        return;
    }
    
    for(UIButton *b in sendMethodBtnArray)
    {
        if([b.titleLabel.text isEqualToString:@"配送费:"])
        {
            [DCFStringUtil showNotice:@"请选择配送方式"];
            return;
        }
        
    }
    NSDictionary *pushDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             shopArray,@"shopList",
                             [addressDic objectForKey:@"receiveAddressId"],@"address",
                             billId,@"invonice",
                             [self getMemberId],@"memberid",
                             nil];
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"SubOrder",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&items=%@",token,[self dictoJSON:pushDic]];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLSubOrderTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/SubOrder.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    
}


- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if(memberid.length == 0)
    {
        sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"BillMsg"])
    {
        billMsg = @"不需要发票";
        billId = 0;
    }
    else
    {
        NSMutableArray *billMsgArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"BillMsg"];
        billMsg = [billMsgArray objectAtIndex:0];
        billId = [billMsgArray objectAtIndex:1];
        
    }
    
    
    
    
    //    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"defaultReceiveAddress"])
    //    {
    //    }
    //    else
    //    {
    //
    //    }
    
    
    if(tv)
    {
        [tv reloadData];
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
    if(chooseAddress)
    {
        [chooseAddress cancelRequest];
    }
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLSubOrderTag)
    {
        if(result == 1)
        {
            NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[b2cOrderData.summariesArray lastObject]];
            NSArray *itemsArray = [dic objectForKey:@"items"];
            NSDictionary *itemDic = [[NSDictionary alloc] initWithDictionary:[itemsArray lastObject]];
            NSString *sShopName = [itemDic objectForKey:@"sShopName"];
            NSString *productItemSku = [itemDic objectForKey:@"productItemSku"];
            
            orderNum = [NSString stringWithFormat:@"%@",[dicRespon objectForKey:@"value"]];
            orderNum = [orderNum stringByReplacingOccurrencesOfString:@"'" withString:@""];
            
            totalPrice = [NSString stringWithFormat:@"%@",[dicRespon objectForKey:@"total"]];
            totalPrice = [totalPrice stringByReplacingOccurrencesOfString:@"'" withString:@""];
            
            ChoosePayTableViewController *pay = [[ChoosePayTableViewController alloc] initWithTotal:totalPrice WithValue:orderNum WithShopName:sShopName WithProductTitle:productItemSku];
            [self.navigationController pushViewController:pay animated:YES];
            
        }
        else
        {
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"提交失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
}

-(void) keyboardWillShow:(NSNotification *) note
{
    NSDictionary*info=[note userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    //    if(ScreenHeight < 500)
    //    {
    [self.view setFrame:CGRectMake(0, -kbSize.height+150, ScreenWidth, ScreenHeight)];
    //    }
    //    else
    //    {
    //
    //    }
    [UIView commitAnimations];
}

#pragma mark 键盘隐藏的监听方法
-(void) keyboardWillHide:(NSNotification *) note
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    [UIView commitAnimations];
    //    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    //
    //    // 获取输入框的位置和大小
    //    CGRect containerFrame = theTextField.frame;
    //    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    //
    //    // 动画改变位置
    //    [UIView animateWithDuration:[duration doubleValue] animations:^{
    //        [UIView setAnimationBeginsFromCurrentState:YES];
    //        [UIView setAnimationDuration:[duration doubleValue]];
    //        [UIView setAnimationCurve:[curve intValue]];
    //        // 更改输入框的位置
    //        theTextField.frame = containerFrame;
    //    }];
}

- (void) doBCReceiveAddressHasChange:(NSNotification *) noti
{
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[noti object]];
    [self changeReceiveAddress:dic];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doBCReceiveAddressHasChange:) name:@"B2CReceiveAddressHasChange" object:nil];
    
#pragma mark - 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装线订单提交"];
    self.navigationItem.titleView = top;
    
    
    //    sendMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 7,ScreenWidth-30, 0)];
    //    [sendMoneyLabel setTextAlignment:NSTextAlignmentRight];
    //    [sendMoneyLabel setFont:[UIFont systemFontOfSize:12]];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 50)];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setShowsVerticalScrollIndicator:NO];
    tv.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [tv setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tv];
    
    buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-50-64, ScreenWidth, 50)];
    [buttomView setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    [self.view addSubview:buttomView];
    
    moneyLabel = [[UILabel alloc] init];
    CGSize moneySize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:[DCFCustomExtra notRounding:goodsMoney afterPoint:2] WithSize:CGSizeMake(MAXFLOAT, 20)];
    [moneyLabel setText:[DCFCustomExtra notRounding:goodsMoney afterPoint:2]];
    [moneyLabel setFont:[UIFont systemFontOfSize:12]];
    [moneyLabel setTextColor:[UIColor colorWithRed:203.0/255.0 green:24.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [moneyLabel setFrame:CGRectMake(ScreenWidth-120-moneySize.width, 10, moneySize.width, 20)];
    [moneyLabel setTextAlignment:NSTextAlignmentRight];
    [buttomView addSubview:moneyLabel];
    
    totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(moneyLabel.frame.origin.x-55, 10, 50, 20)];
    [totalMoneyLabel setTextColor:[UIColor blackColor]];
    [totalMoneyLabel setFont:[UIFont systemFontOfSize:12]];
    [totalMoneyLabel setTextAlignment:NSTextAlignmentRight];
    [totalMoneyLabel setText:@"合计:¥"];
    [buttomView addSubview:totalMoneyLabel];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(totalMoneyLabel.frame.origin.x, totalMoneyLabel.frame.origin.y+totalMoneyLabel.frame.size.height, totalMoneyLabel.frame.size.width+moneyLabel.frame.size.width+5, 14)];
    [l setTextAlignment:NSTextAlignmentRight];
    [l setFont:[UIFont systemFontOfSize:12]];
    [l setText:@"含运费"];
    [buttomView addSubview:l];
    
    
    
    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [upBtn setTitle:@"提交" forState:UIControlStateNormal];
    [upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [upBtn setFrame:CGRectMake(ScreenWidth-100, 5, 90, 40)];
    [upBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    upBtn.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:142.0/255.0 blue:0/255.0 alpha:1.0];
    upBtn.layer.cornerRadius = 5.0f;
    [buttomView addSubview:upBtn];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return totalSection;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        //        if(!b2cOrderData || b2cOrderData.addressArray == 0)
        //        {
        return 1;
        //        }
        //        else
        //        {
        //            return addressListDataArray.count;
        //        }
    }
    if(section == 1)
    {
        return 1;
    }
    if(section == 2)
    {
        return 0;
    }
    if(section > 2 && section <= totalSection-1)
    {
        if(!goodsListArray || goodsListArray.count == 0)
        {
            return 0;
        }
        else
        {
            if(myTag == 1)
            {
                return [[goodsListArray objectAtIndex:section-3] count] + 2;
            }
            else
            {
                return 3;
            }
        }
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    if(section > 2)
    {
        return 0;
    }
    return 35;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        
        if(!addressDic || [[addressDic allKeys] count] == 0 || [addressDic isKindOfClass:[NSNull class]])
        {
            return 40;
        }
        else
        {
            receiver = [NSString stringWithFormat:@"%@",[addressDic objectForKey:@"receiver"]];
            receiveTel = [NSString stringWithFormat:@"%@",[addressDic objectForKey:@"receiveTel"]];
            receiveprovince = [NSString stringWithFormat:@"%@",[addressDic objectForKey:@"receiveprovince"]];
            receivecity = [NSString stringWithFormat:@"%@",[addressDic objectForKey:@"receivecity"]];
            receivedistrict = [NSString stringWithFormat:@"%@",[addressDic objectForKey:@"receivedistrict"]];
            receiveaddress = [NSString stringWithFormat:@"%@",[addressDic objectForKey:@"receiveaddress"]];
            NSString *fullAddress = [NSString stringWithFormat:@"%@%@%@%@",receiveprovince,receivecity,receivedistrict,receiveaddress];
            if([DCFCustomExtra validateString:fullAddress] == NO)
            {
                return 40;
            }
            else
            {
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:13] WithText:fullAddress WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
                return size.height+70;
            }
            
        }
        
    }
    if(indexPath.section == 2)
    {
        return 0;
    }
    if(indexPath.section > 2 && indexPath.section <= totalSection -1)
    {
        if(myTag == 1)
        {
            if(indexPath.row < [[goodsListArray objectAtIndex:indexPath.section-3] count])
            {
                NSString *str = [[[goodsListArray objectAtIndex:indexPath.section-3] objectAtIndex:indexPath.row] productItmeTitle];
                CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(220, MAXFLOAT)];
                
                
                CGSize size_4 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"¥500" WithSize:CGSizeMake(MAXFLOAT, 20)];
                
                
                CGFloat height = size_3.height+size_4.height;
                if(height <= 40)
                {
                    return 85;
                }
                else
                {
                    return 35+height+10;
                    
                }
            }
            else
            {
                return 44;
            }
        }
        else
        {
            if(indexPath.row == 0)
            {
                
                NSArray *itemArray = [[[[[goodsListArray lastObject] lastObject] summariesArray] lastObject] objectForKey:@"items"];
                NSDictionary *itemDic = [[NSDictionary alloc] initWithDictionary:[itemArray lastObject]];
                
                NSString *str = [itemDic objectForKey:@"productItmeTitle"];
                CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(220, MAXFLOAT)];
                
                
                CGSize size_4 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"¥500" WithSize:CGSizeMake(MAXFLOAT, 20)];
                
                
                CGFloat height = size_3.height+size_4.height;
                if(height <= 40)
                {
                    return 85;
                }
                else
                {
                    return 35+height+10;
                    
                }
            }
            else
            {
                return 44;
            }
        }
        
    }
    return 44;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label;
    if (section == 0)
    {
        
    }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(-1, 0, 322, 30)];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
    }
    if(section == 0)
    {
        //        [label setText:@"  收货地址"];
    }
    if(section == 1)
    {
        [label setText:@"  发票信息"];
    }
    if(section == 2)
    {
        [label setText:@"  商品信息"];
    }
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:15]];
    return label;
    
    if(section > 2 )
    {
        return nil;
    }
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    //    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        
        if ((indexPath.section == 0 && indexPath.row == 0) || (indexPath.section > 2 && indexPath.section <= totalSection -1))
        {
            
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell setSelectionStyle:0];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil) {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    if(indexPath.section == 0)
    {
        if([[addressDic allKeys] count] == 0 || [addressDic isKindOfClass:[NSNull class]])
        {
            [cell.textLabel setText:@"暂无收货地址"];
        }
        else
        {   UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(10, (cell.frame.size.height-40)/2+20, 40, 40);
            imageView.image = [UIImage imageNamed:@"location"];
            [cell addSubview:imageView];
            
            UIImageView *arrowImageView = [[UIImageView alloc] init];
            arrowImageView.frame = CGRectMake(ScreenWidth-30, (cell.frame.size.height-20)/2+20, 20, 20);
            arrowImageView.image = [UIImage imageNamed:@"location_arrow"];
            [cell addSubview:arrowImageView];
            
            cell.backgroundColor = [DCFColorUtil colorFromHexRGB:@"#f8e9cb"];
            [cell.contentView addSubview:billReceiveAddressLabel_1];
            [cell.contentView addSubview:billReceiveAddressLabel_2];
        }
        
    }
    if(indexPath.section == 1)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        [cell.contentView addSubview:view];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        [cell.textLabel setText:billMsg];
    }
    if(indexPath.section == 2)
    {
        
    }
    if(indexPath.section > 2 && indexPath.section <= totalSection -1)
    {
        if(myTag == 1)
        {
            if(indexPath.row < [[goodsListArray objectAtIndex:indexPath.section-3] count])
            {
                B2CShopCarListData *data = [[goodsListArray objectAtIndex:indexPath.section-3] objectAtIndex:indexPath.row];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
                [label setText:data.sShopName];
                [label setFont:[UIFont systemFontOfSize:12]];
                
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(20, label.frame.origin.y + label.frame.size.height + 10, 40, 40)];
                NSURL *url = [NSURL URLWithString:data.productItemPic];
                [iv setImageWithURL:url placeholderImage:[UIImage imageNamed:@"magnifying glass.png"]];
                
                
                NSString *str = [data productName];
                CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(220, MAXFLOAT)];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, iv.frame.origin.y-5, 160, 50)];
                [titleLabel setText:str];
                [titleLabel setFont:[UIFont systemFontOfSize:12]];
                [titleLabel setNumberOfLines:0];
                
                NSString *numberr = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",data.num]];
                double money = [numberr intValue] * [data.price doubleValue];
                NSString *smallCal = [NSString stringWithFormat:@"合计: ¥%@",[DCFCustomExtra notRounding:money afterPoint:2]];
                CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:smallCal WithSize:CGSizeMake(MAXFLOAT, 20)];
                UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-size_3.width, 60, size_3.width, 20)];
                [totalLabel setText:smallCal];
                [totalLabel setFont:[UIFont systemFontOfSize:12]];
                
                NSString *color = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"颜色:%@",data.colorName]];
                CGSize size_color = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:smallCal WithSize:CGSizeMake(MAXFLOAT, 20)];
                UILabel *colorLabel = [[UILabel alloc] init];
                colorLabel.frame = CGRectMake(ScreenWidth-size_color.width, 25, size_color.width, 20);
                colorLabel.text = color;
                colorLabel.font = [UIFont systemFontOfSize:12];
                
                CGSize size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:[NSString stringWithFormat:@"¥%@",data.price] WithSize:CGSizeMake(MAXFLOAT, 20)];
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-size_1.width,5, size_1.width, 20)];
                [priceLabel setText:[NSString stringWithFormat:@"¥%@",data.price]];
                [priceLabel setFont:[UIFont systemFontOfSize:12]];
                
                NSString *number = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",data.num]];
                CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:[NSString stringWithFormat:@"×%@",number] WithSize:CGSizeMake(MAXFLOAT, 20)];
                UILabel *countlabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-size_2.width-10,42, size_2.width, 20)];
                [countlabel setText:[NSString stringWithFormat:@"×%@",number]];
                [countlabel setFont:[UIFont systemFontOfSize:12]];
                
                
                
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
                //                [view setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
                CGFloat height = size.height+size_1.height;
                if(height <= 40)
                {
                    [view setFrame:CGRectMake(0, 0, ScreenWidth, 85)];
                }
                else
                {
                    [view setFrame:CGRectMake(0, 0, ScreenWidth, 35+height+10)];
                }
                [cell.contentView addSubview:view];
                [cell.contentView addSubview:label];
                [cell.contentView addSubview:iv];
                [cell.contentView addSubview:titleLabel];
                [cell.contentView addSubview:priceLabel];
                [cell.contentView addSubview:countlabel];
                [cell.contentView addSubview:totalLabel];
                [cell.contentView addSubview:colorLabel];
            }
            else
            {
                if(indexPath.row == [[goodsListArray objectAtIndex:indexPath.section-3] count])
                {
                    //                    [cell.textLabel setText:@"商品备注"];
                    DCFMyTextField *tf = [cellTextFieldArray objectAtIndex:indexPath.section-3];
                    [tf setFrame:CGRectMake(15, -0.5, ScreenWidth-30, cell.contentView.frame.size.height+0.5)];
                    //                    [tf setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
                    [tf setPlaceholder:@"   商品备注"];
                    [cell addSubview:tf];
                }
                else
                {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
                    //                    [view setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
                    [cell.contentView addSubview:view];
                    
                    NSString *str = nil;
                    if(b2cOrderData.summariesArray.count == 0 || [[[b2cOrderData.summariesArray objectAtIndex:indexPath.section - 3] allKeys] count] == 0)
                    {
                        str = [NSString stringWithFormat:@"配送费:%@",@""];
                    }
                    else
                    {
                        if([[chooseSendMethodArray objectAtIndex:indexPath.section-3] count] == 0)
                        {
                            str = @"快递免邮";
                        }
                        else
                        {
                            if(chooseSendTitleArray.count == 0)
                            {
                                str = [NSString stringWithFormat:@"配送费:%@",@""];
                                
                            }
                            else
                            {
                                if([[chooseSendTitleArray objectAtIndex:indexPath.section-3] length] == 0)
                                {
                                    str = [NSString stringWithFormat:@"配送费:%@",@""];
                                }
                                else
                                {
                                    str = [chooseSendTitleArray objectAtIndex:indexPath.section-3];
                                }
                            }
                        }
                        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(MAXFLOAT,20)];
                        UIButton *btn = [sendMethodBtnArray objectAtIndex:indexPath.section-3];
                        [btn setFrame:CGRectMake(cell.contentView.frame.size.width-30-size.width, 7, size.width, 30)];
                        [btn setTitle:str forState:UIControlStateNormal];
                        //                            [sendMoneyLabel setText:str];
                        [cell.contentView addSubview:btn];
                    }
                    
                    
                }
            }
        }
        else
        {
            if(indexPath.row == 0)
            {
                NSArray *itemArray = [[[[[goodsListArray lastObject] lastObject] summariesArray] lastObject] objectForKey:@"items"];
                NSDictionary *itemDic = [[NSDictionary alloc] initWithDictionary:[itemArray lastObject]];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
                [label setText:[itemDic objectForKey:@"sShopName"]];
                [label setFont:[UIFont systemFontOfSize:12]];
                
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(20, label.frame.origin.y + label.frame.size.height + 10, 40, 40)];
                NSURL *url = [NSURL URLWithString:[itemDic objectForKey:@"productItemPic"]];
                [iv setImageWithURL:url placeholderImage:[UIImage imageNamed:@"magnifying glass.png"]];
                
                UILabel *titleLabel = nil;
                NSString *str = [itemDic objectForKey:@"productItmeTitle"];
                CGSize size = CGSizeZero;
                if(str.length == 0)
                {
                    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, iv.frame.origin.y, 220, 30)];
                    [titleLabel setText:str];
                    
                }
                else
                {
                    size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(220, MAXFLOAT)];
                    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, iv.frame.origin.y, 220, size.height)];
                    [titleLabel setText:str];
                    
                }
                [titleLabel setFont:[UIFont systemFontOfSize:12]];
                [titleLabel setNumberOfLines:0];
                
                NSString *price = [NSString stringWithFormat:@"%@",[itemDic objectForKey:@"price"]];
                UILabel *priceLabel = nil;
                CGSize size_1 = CGSizeZero;
                if(price.length == 0)
                {
                    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, titleLabel.frame.origin.y + titleLabel.frame.size.height,40, 20)];
                    [priceLabel setText:@""];
                    //                        [priceLabel setFont:[UIFont systemFontOfSize:12]];
                }
                else
                {
                    size_1 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:price WithSize:CGSizeMake(MAXFLOAT, 20)];
                    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, titleLabel.frame.origin.y + titleLabel.frame.size.height, size_1.width, 20)];
                    [priceLabel setText:price];
                }
                [priceLabel setFont:[UIFont systemFontOfSize:12]];
                
                
                NSString *number = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"num"]]];
                UILabel *countlabel = nil;
                if(number.length == 0)
                {
                    countlabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.size.width + 5, priceLabel.frame.origin.y, 30, 20)];
                    [countlabel setText:[NSString stringWithFormat:@"×%@",@""]];
                }
                else
                {
                    CGSize size_2 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:[NSString stringWithFormat:@"×%@",number] WithSize:CGSizeMake(MAXFLOAT, 20)];
                    countlabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.size.width + 5, priceLabel.frame.origin.y, size_2.width, 20)];
                    [countlabel setText:[NSString stringWithFormat:@"×%@",number]];
                }
                [countlabel setFont:[UIFont systemFontOfSize:12]];
                
                
                double money = [number intValue] * [price doubleValue];
                NSString *smallCal = [NSString stringWithFormat:@"合计:¥%@",[DCFCustomExtra notRounding:money afterPoint:2]];
                UILabel *totalLabel = nil;
                if(smallCal.length == 0)
                {
                    totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-30-30, countlabel.frame.origin.y, 30, 20)];
                    [totalLabel setText:@""];
                }
                else
                {
                    CGSize size_3 = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:smallCal WithSize:CGSizeMake(MAXFLOAT, 20)];
                    totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-30-size_3.width, countlabel.frame.origin.y, size_3.width, 20)];
                    [totalLabel setText:smallCal];
                }
                [totalLabel setFont:[UIFont systemFontOfSize:12]];
                
                
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
                [view setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
                CGFloat height = size.height+size_1.height;
                if(height <= 40)
                {
                    [view setFrame:CGRectMake(0, 0, ScreenWidth, 85)];
                }
                else
                {
                    [view setFrame:CGRectMake(0, 0, ScreenWidth, 35+height+10)];
                }
                [cell.contentView addSubview:view];
                [cell.contentView addSubview:label];
                [cell.contentView addSubview:iv];
                [cell.contentView addSubview:titleLabel];
                [cell.contentView addSubview:priceLabel];
                [cell.contentView addSubview:countlabel];
                [cell.contentView addSubview:totalLabel];
            }
            else
            {
                if(indexPath.row == 1)
                {
                    //                    [cell.textLabel setText:@"商品备注"];
                    DCFMyTextField *tf = [cellTextFieldArray lastObject];
                    [tf setFrame:CGRectMake(15, -0.5, ScreenWidth-15, cell.contentView.frame.size.height+0.5)];
                    [tf setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
                    [tf setPlaceholder:@"商品备注"];
                    [cell addSubview:tf];
                }
                else
                {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
                    [view setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
                    [cell.contentView addSubview:view];
                    
                    NSString *str = nil;
                    if(b2cOrderData.summariesArray.count == 0 || [[[b2cOrderData.summariesArray objectAtIndex:indexPath.section - 3] allKeys] count] == 0)
                    {
                        str = [NSString stringWithFormat:@"配送费:%@",@""];
                    }
                    else
                    {
                        if([[chooseSendMethodArray objectAtIndex:indexPath.section-3] count] == 0)
                        {
                            str = @"配送费由商家承担";
                        }
                        else
                        {
                            if(chooseSendTitleArray.count == 0)
                            {
                                str = [NSString stringWithFormat:@"配送费:%@",@""];
                                
                            }
                            else
                            {
                                if([[chooseSendTitleArray objectAtIndex:indexPath.section-3] length] == 0)
                                {
                                    str = [NSString stringWithFormat:@"配送费:%@",@""];
                                }
                                else
                                {
                                    str = [chooseSendTitleArray objectAtIndex:indexPath.section-3];
                                }
                            }
                        }
                        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:str WithSize:CGSizeMake(MAXFLOAT,20)];
                        UIButton *btn = [sendMethodBtnArray objectAtIndex:indexPath.section  - 3];
                        [btn setFrame:CGRectMake(cell.contentView.frame.size.width-30-size.width, 7, size.width, 30)];
                        [btn setTitle:str forState:UIControlStateNormal];
                        //                            [sendMoneyLabel setText:str];
                        [cell.contentView addSubview:btn];
                    }
                    
                    
                }
            }
        }
        
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        [self.navigationController pushViewController:chooseAddress animated:YES];
        //        }
        
    }
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        BillMsgManagerViewController *billManager = [[BillMsgManagerViewController alloc] init];
        
        NSString *invoId = nil;
        NSString *headTag = nil;
        
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"BillMsg"])
        {
            billMsg = @"请输入个人名称";
            invoId = @"";
            headTag = @"0";
            billManager.editOrAddBill = NO;
            billManager.naviTitle = @"新增发票";
        }
        else
        {
            NSMutableArray *billMsgArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"BillMsg"];
            billMsg = [billMsgArray objectAtIndex:0];
            invoId = [billMsgArray objectAtIndex:1];
            headTag = [billMsgArray objectAtIndex:2];
            billManager.editOrAddBill = YES;
            billManager.naviTitle = @"编辑发票";
            
        }
        
        
        billManager.tfContent = billMsg;
        billManager.invoiceid = invoId;
        billManager.billHeadTag = [headTag intValue];
        
        [self.navigationController pushViewController:billManager animated:YES];
    }
    if(indexPath.section == 2)
    {
        
    }
    if(indexPath.section > 2 && indexPath.section <= totalSection -1)
    {
        
        if(myTag == 1)
        {
            if(indexPath.row == 0)
            {
                
            }
            if(indexPath.row == 1)
            {
                
            }
            else if(indexPath.row == 2)
            {
                //                if([[chooseSendMethodArray objectAtIndex:indexPath.section-3] count] == 0)
                //                {
                //
                //                }
                //                else
                //                {
                //                    pickerView = [[DCFPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.window.frame.size.height) WithArray:[chooseSendMethodArray objectAtIndex:indexPath.section-3] WithTag:indexPath.section-3];
                //                    pickerView.delegate = self;
                //                    [self.view.window setBackgroundColor:[UIColor blackColor]];
                //                    [self.view.window addSubview:pickerView];
                //                }
                
                
            }
        }
        else
        {
            if(indexPath.row == 0)
            {
                
            }
            if(indexPath.row == 1)
            {
                //商品备注
            }
            else if(indexPath.row == 2)
            {
                //                if([[chooseSendMethodArray objectAtIndex:indexPath.section-3] count] == 0)
                //                {
                //
                //                }
                //                else
                //                {
                //                    pickerView = [[DCFPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.window.frame.size.height) WithArray:[chooseSendMethodArray objectAtIndex:indexPath.section-3] WithTag:indexPath.section-3];
                //                    pickerView.delegate = self;
                //                    [self.view.window setBackgroundColor:[UIColor blackColor]];
                //                    [self.view.window addSubview:pickerView];
                //                }
                
                
            }
        }
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    theTextField = (DCFMyTextField *)textField;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3f];
    [self.view setFrame:CGRectMake(0, -64, ScreenWidth, ScreenHeight)];
    [UIView commitAnimations];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationDuration:0.3f];
    //    [self.view setFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    //    [UIView commitAnimations];
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    
}




- (void) pickerView:(NSString *)title WithTag:(int)tag
{
    [chooseSendTitleArray replaceObjectAtIndex:tag withObject:title];
    [tv reloadData];
    
    double titleMoney = [[self getNumFromString:title] doubleValue];
    [priceArray replaceObjectAtIndex:tag withObject:[NSNumber numberWithDouble:titleMoney]];
    
    double myTotalMoney = goodsMoney;
    for(int i=0;i<priceArray.count;i++)
    {
        
        myTotalMoney = myTotalMoney + [[priceArray objectAtIndex:i] doubleValue];
        
    }
    NSString *totalString = [NSString stringWithFormat:@"%@",[DCFCustomExtra notRounding:myTotalMoney afterPoint:2]];
    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:totalString WithSize:CGSizeMake(MAXFLOAT, 20)];
    [moneyLabel setFrame:CGRectMake(ScreenWidth-110-size.width, 10, size.width, 20)];
    [moneyLabel setText:totalString];
    
    [totalMoneyLabel setFrame:CGRectMake(moneyLabel.frame.origin.x-55, 10, 50, 20)];
    
}

#pragma mark - 从字符串中取出数字
- (NSString *) getNumFromString:(NSString *) string
{
    NSString *price = @"";
    for(int i=0;i<string.length;i++)
    {
        char c = [string characterAtIndex:i];
        if(c == '.' || c == '0' || c == '1' || c == '2' || c == '3' || c == '4' || c == '5' || c == '6' || c == '7' || c == '8' || c == '9')
        {
            price = [price stringByAppendingFormat:@"%c",c];
        }
    }
    return price;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
