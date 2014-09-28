//
//  Contact.h
//  TestConnection
//
//  Created by dqf on 4/10/14.
//  Copyright (c) 2014 dqf. All rights reserved.
//

enum{
    
    //任意网络
    NETWORK_ANY=0,
    //WIFI网络
    NETWORK_WIFI,
    //3G网络
    NETWORK_3G,
    //无网络
    NETWORK_NO,
    
    NETWORK_MAX
};

enum {
    POST = 1,
    GET = 2,
};
typedef NSUInteger URLMethod;

enum {
    URLLoginTag = 1, //登录
    URLLogoutTag,  //退出
    URLRegesterTag,  //注册
    
    URLShopListTag,  //购物车列表
    
    URLB2CGoodsListTag,  //商品列表
    
    URLB2CProductDetailTag,  //b2c商品详情
    
    URLShopCarGoodsMsgTag,   //购物车商品信息
    
    URLAddToShopCatTag,   //商品加入购物车
};
typedef NSUInteger URLTag;

enum {
    RS_Success = 1,
    RS_Error,
};
typedef NSUInteger ResultCode;


//内网地址
#define SERVICE_ADDR   @"http://192.168.0.61"

#define CREATE_URL(host,url) [NSString stringWithFormat:@"%@/%@",host,url]
//#define URL_HOST @"http://app.up360.com:81"
//#define URL_HOST @"http://192.168.18.165:8888"  //yss
//#define URL_HOST @"http://192.168.18.150:8080" //yzf
#define URL_HOST @"http://192.168.18.48/app/"  //48

#pragma mark -
#pragma mark - up360 url

#define     SHOP_SEARCH_URL  CREATE_URL(SERVICE_ADDR,@"10000/01?")

#define URL_LOGIN             URL_HOST"/app/10001/01?"       //登录
#define URL_LOGOUT            URL_HOST"/app/10001/02?"       //退出
#define URL_MODIFY_PWD            URL_HOST"/app/10001/03?"       //修改密码
#define URL_MODIFY_USER_PIC            URL_HOST"/app/10001/05?"       //修改用户头像
#define URL_MODIFY_MOBILE            URL_HOST"/app/10001/06?"       //修改手机

//短链接： /app/10001/07
//头像尺寸： /app/10001/07/32
///app/10001/07/50
///app/10001/07/60
///app/10001/07/140
#define URL_USER_INFO            URL_HOST"/app/10001/07/140?"       //个人信息
#define URL_FORGET_PWD            URL_HOST"/app/10001/11?"       //忘记密码
#define URL_CHECK_VERSION            URL_HOST"/app/10001/08?"       //检测版本
#define URL_SEND_CODE           URL_HOST"/app/10001/04?"       //发送验证码
#define URL_FEEDBACK           URL_HOST"/app/10001/09?"       //意见反馈


#define URL_GRADE_LIST           URL_HOST"/app/10004/003/04?"       //年级列表
#define URL_CONTACTS           URL_HOST"/app/10002/004/04?"       //通讯录
#define URL_TIMETABLE           URL_HOST"/app/10002/004/03?"       //课程表
#define URL_HELP_CENTER           URL_HOST"/app/10001/00?"       //帮助
#define URL_TEST           URL_HOST"/app/10000/00?"       //测试


#define URL_PRIVATE           URL_HOST"/app/10006/01?"       //私信
#define URL_NOTI           URL_HOST"/app/10006/05?"       //通知
#define URL_NOTI_DETAIL           URL_HOST"/app/10006/04?"       //通知详情
#define URL_CLASS_INFO           URL_HOST"/app/10004/003/05?"       //班级荣誉，相册，作文列表
#define URL_ESSAY_DETAIL           URL_HOST"/app/10004/003/08?"       //作文详情
#define URL_PIC_HONNOR           URL_HOST"/app/10004/003/06?"       //荣誉、相册详情
#define URL_TIME_TABLE           URL_HOST"/app/10002/004/10?"       //课程表



#define URL_PersonInformation    URL_HOST"10001/07?"       //个人信息(登陆)


















