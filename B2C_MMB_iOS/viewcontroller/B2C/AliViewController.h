//
//  ViewController.h
//  MQPDemo
//
//  Created by ChaoGanYing on 13-5-6.
//  Copyright (c) 2013年 Alipay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Product : NSObject{
@private
	float _price;
	NSString *_subject;
	NSString *_body;
	NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;

@end

@interface AliViewController : UIViewController
{
    NSMutableArray *_products;
    SEL _result;
}
@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。

@property (strong,nonatomic) NSString *shopName;
@property (strong,nonatomic) NSString *productName;
@property (strong,nonatomic) NSString *productPrice;
@property (strong,nonatomic) NSString *productOrderNum;;

//-(void)paymentResult:(NSString *)result;

- (void) testPay;
@end
