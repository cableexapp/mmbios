//
//  ViewController.m
//  MQPDemo
//
//  Created by ChaoGanYing on 13-5-6.
//  Copyright (c) 2013年 Alipay. All rights reserved.
//

#import "AliViewController.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "MCDefine.h"

@implementation Product
@synthesize price = _price;
@synthesize subject = _subject;
@synthesize body = _body;
@synthesize orderId = _orderId;

@end

@interface AliViewController ()
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

//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
			}
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
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

//    NSArray *subjects = [[NSArray alloc] initWithObjects:_shopName, nil];
//
//    NSArray *body = [[NSArray alloc] initWithObjects:_productName, nil];
//    
//	_products = [[NSMutableArray alloc] init];
//    
//	for (int i = 0; i < [subjects count]; ++i)
//    {
//		Product *product = [[Product alloc] init];
//		product.subject = [subjects objectAtIndex:i];
//		product.body = [body objectAtIndex:i];
//        NSLog(@"_productPrice = %@",_productPrice);
//        product.price = [[self getNumFromString:_productPrice] floatValue];
//
//		[_products addObject:product];
//#if ! __has_feature(objc_arc)
//		[product release];
//#endif
//	}
//	
//#if ! __has_feature(objc_arc)
//	[subjects release], subjects = nil;
//	[body release], body = nil;
//#endif
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
    /*
	 *生成订单信息及签名
	 *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
	 */
#pragma mark - 这里修改appScheme,跳回自己app,同时info里面的URL Type里面也要修改
    NSString *appScheme = @"far.east.Far-East-MMB-iOS";
    NSString* orderInfo = [self getOrderInfo:0];
    NSString* signedStr = [self doRsa:orderInfo];
    
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo, signedStr, @"RSA"];
	
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
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

-(NSString*)getOrderInfo:(NSInteger)index
{
    
    NSArray *subjects = [[NSArray alloc] initWithObjects:_shopName, nil];
    
    NSArray *body = [[NSArray alloc] initWithObjects:_productName, nil];
    
	_products = [[NSMutableArray alloc] init];
    
	for (int i = 0; i < [subjects count]; ++i)
    {
		Product *product = [[Product alloc] init];
		product.subject = [subjects objectAtIndex:i];
		product.body = [body objectAtIndex:i];
        NSLog(@"_productPrice = %@",_productPrice);
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
    
    
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
	Product *product = [_products objectAtIndex:index];
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
	order.productName = product.subject; //商品标题
	order.productDescription = product.body; //商品描述
    
	order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/payment/alipay/alipay_notify_url.html"];

	order.notifyURL =  urlString; //回调URL
	
	return [order description];
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
