//
//  MCDefine.h
//  coin
//
//  Created by duomai on 13-12-24.
//  Copyright (c) 2013年 tiny. All rights reserved.
//

#ifndef coin_MCDefine_h
#define coin_MCDefine_h

#define ScreenHeight self.view.frame.size.height
#define ScreenWidth self.view.frame.size.width

#define IS_IOS_7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height

#define CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT [cell.contentView.subviews lastObject]

//NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
//NSIndexPath *pt = [self.tableView indexPathForSelectedRow];



#define URL_HOST_CHEN @"http://10.10.6.134:8080" //HJ
//#define URL_HOST_CHEN @"http://mmb.fgame.com:8083" //GS


#define ENCRYPT_KEY @"A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9,+,/"
#define MDpageSize 20


#define URL_USER_LOGIN                     URL_HOST_CHEN"10001/01?"
#define URL_USER_LOGOUT                  URL_HOST_CHEN"10001/02?"
#define URL_USER_FINDBACKSEC       URL_HOST_CHEN"10001/03?"

#define URL_USER_FEED_BACK         URL_HOST_CHEN"10001/09?"   //设置页面意见反馈
#define URL_USER_SETTING_PERSON_INFOMATION    URL_HOST_CHEN"10001/07/140?"    //设置页面请求个人信息
#define URL_USER_GUARD_INFORMATION     URL_HOST_CHEN"10006/03/01?"      //孩子监护人信息
#define URL_USER_FINDBACK_SEC_TEL   URL_HOST_CHEN"10001/13?"  //根据手机号码找回账号密码
#define URL_USER_DELETE_GUID             URL_HOST_CHEN"10002/006/03?" //删除监护人
#define URL_USER_EDIT_GUID                 URL_HOST_CHEN"10002/006/04?" //编辑监护人
#define URL_USER_ADD_GUID                   URL_HOST_CHEN"10002/006/02?"//添加监护人
#define URL_USER_RELATION_SHIP                URL_HOST_CHEN"10002/006/01?" //监护人关系列表
#define URL_SEND_VERIFICATE_CODE     URL_HOST"10001/04?"            //孩子信息发送验证码

//家长学堂
#define URL_ParentsClassroomContentList   URL_HOST_CHEN"10002/002/01?"   //家长学堂列表
#define URL_ParentsClassroomClassify   URL_HOST_CHEN"10002/002/03?"   //家长学堂内容分类
#define URL_ParentsClassroomContent         URL_HOST_CHEN"10002/002/02?"  //家长学堂内容详情

//通知
#define URL_NOTICE_PUSH                   URL_HOST_CHEN"10006/05?"
#define URL_ADD_NOTICE                     URL_HOST_CHEN"10006/06?"
#define URL_NOTICE_DETAIL                 URL_HOST_CHEN"10006/04?"

//联系人
#define URL_CLASS_LIST                        URL_HOST_CHEN"10004/003/09?"      //班级列表
#define URL_CLASS_PARENT_LIST                        URL_HOST_CHEN"10006/08?"      //班级节家长列表
#define URL_CLASS_CONTACT               URL_HOST_CHEN"10006/02?"              //班级联系人
#define URL_CONTACT_DETAILS            URL_HOST_CHEN"10006/03?"              //联系人明细
#define URL_SCHOOL_CONTACT           URL_HOST_CHEN"10006/07?"               //学校联系人
#define URL_CONTACT_CAPTCHA         URL_HOST_CHEN"10001/04?"              //联系人发送验证码

//私信
#define URL_PRIVATE_LETTER                URL_HOST_CHEN"10006/01?"                 //私信
#define URL_SCHOOL_MSG                   URL_HOST_CHEN"10006/04?"                 //校讯通
#define URL_PRIVATE_LETTER_PERSON_MSG       URL_HOST_CHEN"10006/01/00?" //私信请求个人信息
//群聊
#define URL_PARENTS_GROUP_MSG   URL_HOST_CHEN"10006/01/01?"       //群聊

//作业
#define URL_GET_SUBJECT                     URL_HOST_CHEN"10004/002/03?"         //获取任课科目
#define URL_GET_CLASS_INFO               URL_HOST_CHEN"10004/002/04?"         //获取年级班级信息
#define URL_GET_TEXT_CONTENT         URL_HOST_CHEN"10004/002/05?"         //获取课文内容
#define URL_SPPEED_ARRANGE             URL_HOST_CHEN"10004/002/06?"          //快速布置

#define URL_MYARRANGE_CLASS         URL_HOST_CHEN"10002/002/04?"          //我布置的作业

#define URL_HOMEWORK_DETAIL         URL_HOST_CHEN"10004/002/02?"         //作业详情
#define URL_STATIS_REPORT                  URL_HOST_CHEN"10004/002/07?"         //统计报表

//分享动态
#define URL_SHARE_DYMATIC               URL_HOST_CHEN"10004/001/08?"         //分享动态
#define URL_SHARE_PICTURE                 URL_HOST_CHEN"10004/001/01?"        //分享动态图片
#define URL_DYMATIC_AGREE               URL_HOST_CHEN"10004/001/07?"         //动态赞/顶
#define URL_DYMATIC_DISCUSS            URL_HOST_CHEN"10004/001/05?"         //动态评论
#define URL_DYMATIC_DELETE              URL_HOST_CHEN"10004/001/06?"         //动态删除
#define URL_COMMENT_DELETE              URL_HOST_CHEN"10004/001/10?"         //删除评论
#define URL_PRAISE_UNPRAISE             URL_HOST_CHEN"10004/001/09?"         //点赞、取消点赞

//我的班级
#define URL_CLASS_HOST                     URL_HOST_CHEN"10004/003/01?"         //班级主页
#define URL_CLASS_SPACE_HOST         URL_HOST_CHEN"10004/003/03?"         //班级空间主页
#define URL_DYMATIC_LIST                   URL_HOST_CHEN"10004/001/04?"         //动态列表
#define URL_DYMATIC_LISTAgain                   URL_HOST_CHEN"10004/001/04?"         //动态列表
#define URL_CLASS_MEMBER                URL_HOST_CHEN"10004/003/02?"         //班级成员
#define URL_LIST_UNITY_ENTRANCE     URL_HOST_CHEN"10004/003/05?"         //列表统一入口
#define URL_DRAW_WRITE_DETAIL        URL_HOST_CHEN"10004/003/07?"        //绘画书法明细
#define URL_COMPOSE_DETAIL             URL_HOST_CHEN"10004/003/08?"         //作文明细
#define URL_GRADELIST                 URL_HOST_CHEN"10004/003/04?"         //年级列表
#define URL_STUDENT_ALBUM                URL_HOST_CHEN"10002/003/10?"         //学生相册列表

//我的
#define URL_MY_DYMATIC                     URL_HOST_CHEN"10004/001/02?"      //我的动态
#define URL_DYMATIC_DETAIL               URL_HOST_CHEN"10004/001/03?"       //动态详情

//个人信息
#define URL_MY_PROFILE                     URL_HOST_CHEN"10001/07?"       //个人信息
#define URL_MY_PROFILE_140                     URL_HOST_CHEN"10001/07/140?"       //个人信息
#define URL_MODIFY_USERPHOTO                     URL_HOST_CHEN"10001/05?"       //修改用户头像
#define URL_MODIFY_PHONE                   URL_HOST_CHEN"10001/06?"       //修改手机号码
#define URL_MODIFY_PASSWORD                   URL_HOST_CHEN"10001/03?"       //修改密码
#define URL_GET_USER_MSG                  URL_HOST_CHEN"10001/11?"             //找回密码时请求个人信息
#endif


//我的（上传头像）
#define URL_UPLOAD_USER_PHOTO             URL_HOST_CHEN"10001/05?"       //修改用户头像

//NOTICATION INFO

//班级评论消息
#define NOTI_WRITE_COMMENT   @"notifictionForWritingComment"
//我的评论消息
#define NOTI_WRITE_COMMENT_ME   @"notifictionForMeWritingComment"
//班级删除评论
#define NOTI_DELETE_COMMENT  @"notificationForDeleteComment"
//我的删除评论
#define NOTI_DELETE_COMMENT_ME  @"notificationForMeDeleteComment"
//更新联系方式
#define NOTI_UPDATE_MOBILE  @"notificationForUpdateMobile"
//通讯录请求结果
#define NOTI_CONTACT_RESULTS  @"notificationForContactResult"
//通讯录重新请求数据
#define NOTI_UPDATE_CONTACTS @"notificationForUpdateContacts"



/*********保存请求数据的宏************/

//我的个人信息
#define MY_INFO @"MY_PROFILE"
//联系人--老师
#define CONTACTS_TEACHER @"CONTACTS_TEACHER"
//联系人--家长
#define CONTACTS_PARENTS @"CONTACTS_PARENTS"





