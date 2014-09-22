//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

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

#endif
