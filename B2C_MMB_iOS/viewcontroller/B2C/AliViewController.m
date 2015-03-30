//
//  ViewController.m
//  MQPDemo
//
//  Created by ChaoGanYing on 13-5-6.
//  Copyright (c) 2013年 Alipay. All rights reserved.
//

#import "AliViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UIViewController+AddPushAndPopStyle.h"
#import "MCDefine.h"
#import "AppDelegate.h"

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088111057436819"
//收款支付宝账号
#define SellerID  @"cableex@cableex.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"ayfetbfdmhhrobkemfo8im1y2rk4jf7f"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOl5rueC9UMZaNmlZyMDRttPEucFyuFid5MxvFt2HKyoFj/b9eS6U8pUgoWzHYly9akKWPchwS75JlkIPUQvuE1WJtOfWjPw40l5X2n6PN05McI8mKWZff0Tv2GDgpYYjdcQMXrhvx6FMHXbVf3+2G2d+OcuPL6rqVqZPVZQJyPdAgMBAAECgYB2BLSNAn3H9Ugy/JEt+bIPmeEMNrlfRM788N8tvH6yKCVXEnExtZ41YJK50tjTafEUCc7+3WkxvW/NAYU2uoiGV+jT6SlQxTWbZDfBjqr+m67ndvO0ZlpLimIVQJKsdB9IrUnMDF98lnxR06tdPwlzIiX8IV0yk5uCvbFB45mcAQJBAP9MF/4dI6Jj9FEt6hkNvDKoDPS4c8AsXthdw5RBTL3gBxHvnWaAGpvrLTjBWb3DzgkBZlmmoUtKsTojJTkYOaECQQDqHjY0hGPWhAbBDUorZU4aZtEd3/u9YsomgRYn0ldVxCeO1klfdhcXYcfcxpX0fqEZgILv9naEDh8xUvJN7Zi9AkBRB5Th6dvCkhkcnwcbVpmyNlaOYfETQMIFyJTn/GXgKjf0QGpj+yr27AkZZ30VVw2RHCmhMNsm65key8LnwUGhAkEAz8lcpqPR0HSBYhofeACDn18dvnwq+92QOThcp59CMDbWPSnnGTjAKdp4/nOqZ8NzzCSJEd0XNwEpoidSMuPrqQJBAOkhsSMydV69KpYXWk8cRO7Yk1HyVxE3oNaigFMn42ny3KekLhxylak8Z05eXxbe0FIOMLaWK32aaoQWKoPcCqY="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

@implementation Product
@synthesize price = _price;
@synthesize subject = _subject;
@synthesize body = _body;
@synthesize orderId = _orderId;

@end

@interface AliViewController ()
{
    UIStoryboard *sb;
}
@end


@implementation AliViewController
@synthesize result = _result;


-(void)dealloc
{
#if ! __has_feature(objc_arc)
    [_products release];
    [super dealloc];
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    _result = @selector(paymentResult:);
    [self generateData];
	// Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 *产生商品列表数据
 */
- (void)generateData
{

}

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

- (void) testPay
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSArray *subjects = [[NSArray alloc] initWithObjects:_shopName, nil];
    
    NSArray *body = [[NSArray alloc] initWithObjects:_productName, nil];
    
    _products = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [subjects count]; ++i)
    {
        Product *product = [[Product alloc] init];
        product.subject = [subjects objectAtIndex:i];
        product.body = [body objectAtIndex:i];
        product.price = [[self getNumFromString:_productPrice] floatValue];
        
        [_products addObject:product];
#if ! __has_feature(objc_arc)
        [product release];
#endif
    }
    
#if ! __has_feature(objc_arc)
    [subjects release], subjects = nil;
    [body release], body = nil;
#endif
    
    //_________
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    Product *product = [_products objectAtIndex:0];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = PartnerID;
    NSString *seller = SellerID;
    NSString *privateKey = PartnerPrivKey;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = product.subject; //商品标题
    order.productDescription = product.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/payment/alipay/alipay_notify_url.html"];
    order.notifyURL =  urlString; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
#pragma mark - 支付宝返回当前APP
    NSString *appScheme = @"far.east.Far-East-MMB-iOS";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSString *resultStatus = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]];
            if([resultStatus isEqualToString:@"9000"])
            {
                [app aliPayChange];
            }
     
        }];
    }

}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55.0f;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#if ! __has_feature(objc_arc)
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
													reuseIdentifier:@"Cell"] autorelease];
#else
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"Cell"];
#endif
	Product *product = [_products objectAtIndex:indexPath.row];
	UIView *adaptV = [[UIView alloc] initWithFrame:CGRectMake(10, 0,
															  cell.bounds.size.width-10, cell.bounds.size.height)];
	
	UILabel *subjectLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, adaptV.bounds.size.width, 20)];
	subjectLb.text = product.subject;
	[subjectLb setFont:[UIFont boldSystemFontOfSize:14]];
	subjectLb.backgroundColor = [UIColor clearColor];
	[adaptV addSubview:subjectLb];
#if ! __has_feature(objc_arc)
	[subjectLb release];
#endif
	UILabel *bodyLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 25,
																adaptV.bounds.size.width, 20)];
	bodyLb.text = product.body;
	[bodyLb setFont:[UIFont systemFontOfSize:12]];
	[adaptV addSubview:bodyLb];
#if ! __has_feature(objc_arc)
	[bodyLb release];
#endif
	UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 100, 20)];
	priceLb.text = [NSString stringWithFormat:@"一口价：%.2f",product.price];
	[priceLb setFont:[UIFont systemFontOfSize:12]];
	[adaptV addSubview:priceLb];
#if ! __has_feature(objc_arc)
	[priceLb release];
#endif
	[cell.contentView addSubview:adaptV];
#if ! __has_feature(objc_arc)
	[adaptV release];
#endif
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}


- (NSString *)generateTradeNO
{
//	const int N = 15;
	
	NSString *sourceString = self.productOrderNum;
    return sourceString;
//	NSMutableString *result = [[NSMutableString alloc] init] ;
//	srand(time(0));
//	for (int i = 0; i < N; i++)
//	{
//		unsigned index = rand() % [sourceString length];
//		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
//		[result appendString:s];
//	}
//	return result;
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    
}

@end
