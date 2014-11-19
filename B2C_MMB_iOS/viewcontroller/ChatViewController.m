//
//  ChatViewController.m
//  B2C_MMB_iOS
//
//  Created by 丁瑞 on 14-10-19.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageFrame.h"
#import "Message.h"
#import "MessageCell.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "DDLog.h"
#define SUPPORT_IOS8 0
@interface ChatViewController ()
{
    UITextView *messageField;
    NSMutableArray  *_allMessagesFrame;
    UILabel *naviTitle;
    UIView *toolBar;
    UIButton *keyboardButton;
    UIButton *sendButton;
    NSString *friendName;
    NSString *tempFriendName;
    UIImage *image;
    UIImageView *imageView;
    NSMutableArray *array;
    NSMutableArray *tempMessage;
    NSTimer *timer;
    UILabel *nameLabel;
    UIStoryboard *sb;
    NSString *tempJID;
    UILabel *noNet;
    UIImageView *noNetView;
    UILabel *noNetMessage;
    NSString *stringLabel;
    NSString *roomMessage;
    int messagePush;
    NSString *isOn;
}

@end

@implementation ChatViewController
@synthesize tempNameArray;
@synthesize xmppRoom;
@synthesize fromStringFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [DCFColorUtil colorFromHexRGB:@"#f1f1f1"];
    
    //自定义导航条
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.backgroundColor = [UIColor colorWithRed:17.0/255.0 green:66.0/255.0 blue:146.0/255.0 alpha:1.0];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:nameLabel atIndex:1];
    
    //导航标题
    naviTitle = [[UILabel alloc] initWithFrame:CGRectMake(130,20, 120, 44)];
    naviTitle.textColor = [UIColor whiteColor];
    naviTitle.backgroundColor = [UIColor clearColor];
    naviTitle.textAlignment = NSTextAlignmentLeft;
    [self.view insertSubview:naviTitle atIndex:2];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 24.5, 35, 35);
    [btn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackActionToHome) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-108) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [DCFColorUtil colorFromHexRGB:@"#f1f1f1"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //下拉加载
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *EGOview = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        EGOview.delegate = self;
        [self.tableView addSubview:EGOview];
        _refreshHeaderView = EGOview;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    //聊天输入工具条
    toolBar = [[UIView alloc] init];
    toolBar.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44);
    toolBar.backgroundColor = [DCFColorUtil colorFromHexRGB:@"#ffffff"];
    [self.view addSubview:toolBar];
    
     [messageField becomeFirstResponder];
    
    //键盘按钮
    keyboardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    keyboardButton.frame = CGRectMake(6, 6, 32, 32);
    [keyboardButton addTarget:self action:@selector(faceBoardClick) forControlEvents:UIControlEventTouchUpInside];
    [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
    [toolBar addSubview:keyboardButton];
    
    //发送按钮
    sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.frame = CGRectMake(250, 6, 64, 32);
    [sendButton addTarget:self action:@selector(sendNewChatMessage) forControlEvents:UIControlEventTouchUpInside];
    sendButton.layer.cornerRadius = 3;
    sendButton.layer.backgroundColor = [[UIColor colorWithRed:18.0/255.0 green:90.0/255.0 blue:169.0/255.0 alpha:1] CGColor];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTintColor:[UIColor whiteColor]];
    [toolBar addSubview:sendButton];
    
    //消息输入框
    messageField = [[UITextView alloc] init];
    messageField.frame = CGRectMake(46, 6, 196, 32);
    messageField.delegate = self;
    messageField.layer.backgroundColor = [[DCFColorUtil colorFromHexRGB:@"#ffffff"] CGColor];
    messageField.layer.borderWidth = 1;
    messageField.layer.borderColor = [[DCFColorUtil colorFromHexRGB:@"#dddddd"] CGColor];
    [messageField setReturnKeyType:UIReturnKeyNext];
    messageField.layer.cornerRadius =3;
    [toolBar addSubview:messageField];
    
    //在线状态
    image = [UIImage imageNamed:@"online.png"];
    imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(115, 38, 10, 10);
    [self.view insertSubview:imageView atIndex:2];
    
    //自定义网络状态通知视图
    noNet = [[UILabel alloc] init];
    noNet.frame = CGRectMake(0, 64, self.view.frame.size.width,32);
    noNet.backgroundColor = [DCFColorUtil colorFromHexRGB:@"#fff3bb"];
    noNet.hidden = YES;
    [self.view insertSubview:noNet aboveSubview:self.tableView];
    
    noNetView = [[UIImageView alloc] init];
    noNetView.frame = CGRectMake(20, 70, 20, 20);
    noNetView.image = [UIImage imageNamed:@"ico_error"];
    [self.view insertSubview:noNetView aboveSubview:noNet];
    
    noNetMessage = [[UILabel alloc] init];
    noNetMessage.frame = CGRectMake(55, 64, self.view.frame.size.width-55, 32);
    noNetMessage.textColor = [DCFColorUtil colorFromHexRGB:@"#333333"];
    noNetMessage.font = [UIFont systemFontOfSize:15];
    noNetMessage.textAlignment = NSTextAlignmentLeft;
    noNetMessage.text = @"当前网络不可用，请检查网络设置!";
    [self.view insertSubview:noNetMessage aboveSubview:noNet];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"结束会话" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightBtn setFrame:CGRectMake(self.view.frame.size.width-65, 20, 60, 44)];
    [rightBtn addTarget:self action:@selector(endChatConfrence) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:rightBtn aboveSubview:nameLabel];
    
    if ( !faceBoard)
    {
        faceBoard = [[FaceBoard alloc] init];
        faceBoard.delegate = self;
        faceBoard.inputTextView = messageField;
    }
    array = [[NSMutableArray alloc] init];
    _allMessagesFrame = [[NSMutableArray alloc] init];
    tempMessage = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification  object:nil];
    
    //接收聊天消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessage:) name:@"messageGetting" object:nil];
    
    //服务器忙消息通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (ServerisBusy:) name:@"errorMessage" object:nil];
    
    //接收网络断开消息通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (NetisDisconnection:) name:@"netErrorMessage" object:nil];
    
    //接收网络连接消息通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (NetisConnection:) name:@"NetisConnect" object:nil];
    
    //接收客服会话窗口关闭通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (noFriendOnLineMessage:) name:@"noFriendOnLine" object:nil];
    
    //接收客服会话通知栏推送
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (chatRoomMessage:) name:@"chatRoomMessagePush" object:nil];
    
    ArrTimeCheck = [[NSMutableArray alloc]init];

    [self firstPageMessageData];
    
    NSLog(@"viewDidLoad_self.appDelegate.isOnLine = %@",self.appDelegate.isOnLine);
    
    if ([self.appDelegate.isOnLine isEqualToString:@"unavailable"])
    {
        NSLog(@"客服已经离开!");
        naviTitle.text = @"客服已经离开";
        noNetMessage.text = @"本次咨询已经结束,客服已经离开!";
        noNet.hidden = NO;
        noNetView.hidden = NO;
        noNetMessage.hidden = NO;
        [messageField resignFirstResponder];
        self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
        toolBar.hidden = YES;
    }
    else
    {
         NSLog(@"客服在线!");
        naviTitle.text = @"正在咨询";
        imageView.image = image;
    }
    
}

//检查网络是否连接
-(void)checkNet
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([r currentReachabilityStatus]==NotReachable)
    {
        noNet.hidden = NO;
        noNetView.hidden = NO;
        noNetMessage.hidden = NO;
    }
    else
    {
        noNet.hidden = YES;
        noNetView.hidden = YES;
        noNetMessage.hidden = YES;
    }
}

-(void)endChatConfrence
{
    NSLog(@"endChatConfrence");
   
    [xmppRoom leaveRoom];
    [self.appDelegate goOffline];
    [self.appDelegate disconnect];
    [self.appDelegate reConnect];
     [self dismissViewControllerAnimated:NO completion:nil];
    [self pageFromWhere];
}

-(void)goBackActionToHome
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self pageFromWhere];
    messagePush = 1;
}

-(void)pageFromWhere
{
    self.appDelegate.uesrID = nil;
    self.appDelegate.personName = nil;
    if ([self.fromStringFlag isEqualToString:@"首页在线客服"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disMissSelfPage" object:nil];
        [self.navigationController.tabBarController.tabBar setHidden:NO];
    }
    else if([self.fromStringFlag isEqualToString:@"来自快速询价客服"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToAskPricePage" object:nil];
    }
    else if ([self.fromStringFlag isEqualToString:@"热门型号在线咨询"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToAskPricePage" object:nil];
         [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -3)] animated:YES];
    }
    else if ([self.fromStringFlag isEqualToString:@"热门分类在线客服"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToAskPricePage" object:nil];
        [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -1)] animated:YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disMissSelfPage" object:nil];
        [self.navigationController.tabBarController.tabBar setHidden:NO];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetCount" object:nil];
}

-(void)chatRoomMessage:(NSNotification *)chatRoomMessage
{
    #if SUPPORT_IOS8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else
  #endif
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    UILocalNotification *_localNotification=[[UILocalNotification alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSLog(@"running in the background");
        
        _localNotification.applicationIconBadgeNumber = 1;
        _localNotification.timeZone = [NSTimeZone defaultTimeZone];
        _localNotification.alertBody = roomMessage;
        _localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        _localNotification.soundName= UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:_localNotification];
    });
    self.appDelegate.pushChatView = @"push";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushChatView" object:@"push"];
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)noFriendOnLineMessage:(NSNotification *)busyMessage
{
    isOn = @"unavailable";
    
    [messageField resignFirstResponder];
    self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    toolBar.hidden = YES;
    noNetMessage.text = @"本次咨询已经结束,客服已经离开!";
    noNet.hidden = NO;
    noNetView.hidden = NO;
    noNetMessage.hidden = NO;
}

//服务器繁忙提示
-(void)ServerisBusy:(NSNotification *)busyMessage
{
    //noNetMessage.text = @"服务器忙，请稍后重试!";
}

//网络已连接提示
-(void)NetisConnection:(NSNotification *)NetisConnectionMessage
{
    noNet.hidden = YES;
    noNetView.hidden = YES;
    noNetMessage.hidden = YES;
}

//网络未连接提示
-(void)NetisDisconnection:(NSNotification *)busyMessage
{
    noNet.hidden = NO;
    noNetView.hidden = NO;
    noNetMessage.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
     NSLog(@"viewWillAppear_self.appDelegate.isOnLine = %@",self.appDelegate.isOnLine);
    
    [self checkNet];
    NSLog(@"self.fromStringFlag = %@",self.fromStringFlag);
    if ([[self appDelegate].xmppStream isDisconnected])
    {
//        noNetMessage.text = @"服务器未连接，请退出重新登录!";
    }
    else
    {
        if (self.appDelegate.uesrID != nil)
        {
            [self creatRoom];
        }
    }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    messagePush = 0;
}


#pragma mark 键盘即将显示
- (void)keyboardWillShow:(NSNotification *)notification
{
    isKeyboardShowing = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
     CGRect frame = self.tableView.frame;
     
     frame.size.height += keyboardHeight;
    //frame.size.height -= keyboardRect.size.height-49;
     frame.size.height -= keyboardRect.size.height;
     self.tableView.frame = frame;
     
     frame = toolBar.frame;
    //frame.origin.y += keyboardHeight+49;
     frame.origin.y += keyboardHeight;
     frame.origin.y -= keyboardRect.size.height;
     toolBar.frame = frame;
     
    //keyboardHeight = keyboardRect.size.height-49;
    keyboardHeight = keyboardRect.size.height;
    }];
    if ( isFirstShowKeyboard )
    {
        isFirstShowKeyboard = NO;
        isSystemBoardShow = !isButtonClicked;
    }
    if ( isSystemBoardShow )
    {
        [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
    }
    else
    {
        [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_system"] forState:UIControlStateNormal];
    }
    if (_allMessagesFrame.count)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessagesFrame.count - 1
                                                                    inSection:0]
                                atScrollPosition:UITableViewScrollPositionBottom
                                        animated:NO];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = self.tableView.frame;
                         frame.size.height += keyboardHeight;
                         self.tableView.frame = frame;
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         toolBar.frame = frame;
                         
                         keyboardHeight = 0;
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    isKeyboardShowing = NO;
    if (isButtonClicked)
    {
        isButtonClicked = NO;
        if ( ![messageField.inputView isEqual:faceBoard] )
        {
            isSystemBoardShow = NO;
            messageField.inputView = faceBoard;
        }
        else
        {
            isSystemBoardShow = YES;
            messageField.inputView = nil;
        }
        [messageField becomeFirstResponder];
    }
}

-(void)faceBoardClick
{
    isButtonClicked = YES;
  
    if (isKeyboardShowing)
    {
        [messageField resignFirstResponder];
    }
    else
    {
        if (isFirstShowKeyboard)
        {
            isFirstShowKeyboard = NO;
            isSystemBoardShow = NO;
        }
        if ( !isSystemBoardShow )
        {
            messageField.inputView = faceBoard;
        }
        [messageField becomeFirstResponder];
    }
}

- (void)textViewDidChange:(UITextView *)_textview
{
    
}

//接收消息
-(void)getMessage:(NSNotification *)notification
{
    //获得本地时间
    NSDate *dates = [NSDate date];
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy:MM:dd:HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    NSString *loctime = [formatter stringFromDate:dates];
#pragma mark - 数据检查
    if (StrTimeCheck)
    {
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
        [inputFormatter setDateFormat:@"yyyy:MM:dd:HH:mm:ss"];
        
        NSDate * beginTime = [inputFormatter dateFromString:StrTimeCheck];
        NSDate * endTime = [inputFormatter dateFromString:loctime];
        //增加一个范围时间。
        NSTimeInterval time=[endTime timeIntervalSinceDate:beginTime];
        if (abs(time/60) < 3)
        {
            [ArrTimeCheck addObject:@"0"];
        }
        else if (abs(time/60) >= 3)
        {
            StrTimeCheck = loctime;
            [ArrTimeCheck addObject:@"1"];
        }
    }
    else
    {
        StrTimeCheck = loctime;
        [ArrTimeCheck addObject:@"1"];
    }
    //接收消息处理
    [self getMessageWithContent:notification.object time:loctime];
    [self messageMusic];
    
    //刷新UI界面
    [self refreshUI];
}
-(void)refreshUI
{
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessagesFrame.count - 1
                                                                inSection:0]
                            atScrollPosition:UITableViewScrollPositionBottom
                                    animated:NO];
}

-(XMPPStream *)xmppStream
{
    return [[self appDelegate] xmppStream];
}

-(void)messageMusic
{
    //消息音提示
    NSString *strPath = [[NSBundle mainBundle]pathForResource:@"sms01" ofType:@"mp3"];
    NSData * voiceData = [[NSData alloc]initWithContentsOfFile:strPath];
    messageSound = [[AVAudioPlayer alloc]initWithData:voiceData error:nil];
    if ([messageSound isPlaying])
    {
        [messageSound stop];
    }
    else
    {
        [messageSound play];
    }
}

//发送消息
-(void)sendNewChatMessage
{
    if ([[self appDelegate].xmppStream isDisconnected])
    {
        messageField.text = @"";
    }
    else
    {
        NSString *message = messageField.text;
        if (message.length > 0)
        {
            //生成XML消息文档
            NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
            if ([self.fromStringFlag isEqualToString:@"首页在线客服"])
            {
                stringLabel = [NSString stringWithFormat:@"[买卖宝iOS提示:信息来自 - 在线客服]：%@",message];
            }
            else if ([self.fromStringFlag isEqualToString:@"来自快速询价客服"])
            {
                stringLabel = [NSString stringWithFormat:@"[买卖宝iOS提示:信息来自 - 快速询价]：%@",message];
            }
            else if ([self.fromStringFlag isEqualToString:@"热门型号在线咨询"])
            {
                stringLabel = [NSString stringWithFormat:@"[买卖宝iOS提示:信息来自 - 热门型号]：%@",message];
            }
            else if ([self.fromStringFlag isEqualToString:@"热门分类在线客服"])
            {
                stringLabel = [NSString stringWithFormat:@"[买卖宝iOS提示:信息来自 - 热门分类]：%@",message];
            }
//            NSString *stringLabel = [NSString stringWithFormat:@"[买卖宝iOS提示:信息来自 - 商品详情]：%@",message];
            [body setStringValue:stringLabel];
            NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
            [mes addAttributeWithName:@"type" stringValue:@"groupchat"];
            [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@",self.appDelegate.uesrID]];
            [mes addChild:body];
            [[self xmppStream] sendElement:mes];

            //获得本地时间
            NSDate *dates = [NSDate date];
            NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy:MM:dd:HH:mm:ss"];
            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
            [formatter setTimeZone:timeZone];
            NSString *loctime = [formatter stringFromDate:dates];
            NSLog(@"locttime = %@",loctime);
                
           #pragma mark - 数据检查
            if (StrTimeCheck)
            {
                NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
                [inputFormatter setDateFormat:@"yyyy:MM:dd:HH:mm:ss"];
                
                NSDate * beginTime = [inputFormatter dateFromString:StrTimeCheck];
                NSDate * endTime = [inputFormatter dateFromString:loctime];
                //增加一个范围时间。
                NSTimeInterval time=[endTime timeIntervalSinceDate:beginTime];
                
                if (abs(time)/60 < 3)
                {
                    [ArrTimeCheck addObject:@"0"];
                }
                else if(abs(time)/60 >= 3)
                {
                    StrTimeCheck = loctime;
                    [ArrTimeCheck addObject:@"1"];
                }
            }
            else
            {
                StrTimeCheck = loctime;
                [ArrTimeCheck addObject:@"1"];
            }
            messageField.text = @"";
            
//           [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
            
            //发送消息处理
            [self addMessageWithContent:message time:loctime];
            //刷新UI界面
            [self refreshUI];
        }
    }
}

//创建房间
-(void)creatRoom
{
    naviTitle.text = @"正在咨询";
    imageView.image = image;
    //初始化聊天室
    XMPPRoomCoreDataStorage *roomMemory = [[XMPPRoomCoreDataStorage alloc] init];
    
    if (roomMemory==nil)
    {
        roomMemory = [[XMPPRoomCoreDataStorage alloc] init];
    }
    XMPPJID *roomJID = [XMPPJID jidWithString:self.appDelegate.uesrID];
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:roomMemory jid:roomJID];
    XMPPStream *stream = [self xmppStream];
    [xmppRoom activate:stream];
    [xmppRoom configureRoomUsingOptions:nil];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoom joinRoomUsingNickname:self.appDelegate.chatRequestJID history:nil];
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
//    NSLog(@"didFetchConfigurationForm");
}


-(void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitation:(XMPPMessage *)message
{

}

//获取聊天室信息
- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
//    NSLog(@"获取聊天室信息");
    [xmppRoom fetchConfigurationForm];
    [xmppRoom fetchBanList];
    [xmppRoom fetchMembersList];
    [xmppRoom fetchModeratorsList];
}


//如果房间存在，会调用委托
// 收到禁止名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items
{
//   NSLog(@"didFetchBanList = %@\n\n",items);
}

// 收到好友名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
//    NSLog(@"收到好友名单列表 = %@\n\n",items);
}

// 收到主持人名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items
{
//    NSLog(@"收到主持人名单列表 = %@\n\n",items);
}

//创建聊天室成功
- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
//    NSLog(@"创建聊天室成功");
}

//离开聊天室
- (void)xmppRoomDidLeave:(XMPPRoom *)sender
{
    NSLog(@"离开聊天室");
}

//新人加入群聊
- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID
{
    NSLog(@"新人加入群聊");
}
//有人退出群聊
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID
{
    NSLog(@"有人退出群聊");
}
//有人在群里发言
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
    NSLog(@"有人在群里发言 = %@\n\n",message);
    tempJID =[NSString stringWithFormat:@"%@",occupantJID];
   
    if (![[[tempJID componentsSeparatedByString:@"/"] objectAtIndex:1] isEqualToString:self.appDelegate.chatRequestJID])
    {
       roomMessage = [[message elementForName:@"body"] stringValue];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"messageGetting" object:roomMessage];
        if (messagePush == 1)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"chatRoomMessagePush" object:nil];
        }
    }
}

-(void)firstPageMessageData
{
    pageIndex =1;
    [self getMessageData];
}

#pragma mark - 读取本地消息
//从数据库中查询聊天记录
- (void)getMessageData
{
    sqlite3 * dataBase = NULL;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *filePath = [documents stringByAppendingPathComponent:@"ChatMessageList.sqlite"];
    //打开数据库
    int result = sqlite3_open([filePath UTF8String],&dataBase);
    
    if (SQLITE_OK == result)
    {
        //创建SQL语句查询
        //10条数据为一个区间
        NSString *insert = [NSString stringWithFormat:@"select  o.* from (select * from messagelist where creater = %@ and (rec_user_id = %@  or user_id =%@) order by time desc) o limit %d,%d  ",@"0",@"0",@"0",(pageIndex-1)*10,pageIndex*10];
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(dataBase,[insert UTF8String],-1, &statement, nil)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                /*
                 0: 自增id
                 1: 接受者id
                 2: 发送者id
                 3: 时间
                 4: 内容
                 */
                
                //查询结果处理
                NSString *sen_userId =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
                
                NSString *time =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
                
                NSString *msg =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
                
                NSDictionary * dic;
                //收发判断
                if ([sen_userId isEqualToString:@"0"])
                {
                   dic = [[NSDictionary alloc]initWithObjectsAndKeys:msg,@"content",time,@"time",@"0",@"type",@"icon01.png" ,@"icon",nil];
                }
                else
                {
                   dic = [[NSDictionary alloc]initWithObjectsAndKeys:msg,@"content",time,@"time",@"1",@"type" ,@"icon02.png",@"icon",nil];
                }
                MessageFrame *messageFrame = [[MessageFrame alloc] init];
                Message *message = [[Message alloc] init];
                messageFrame.showTime = YES;
                message.dict = dic;
               
                NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
                [inputFormatter setDateFormat:@"yyyy:MM:dd:HH:mm:ss"];
                
//                if ([self CheckTimeIsShow:[inputFormatter dateFromString:message.time]])
//                {
//                    messageFrame.showTime = YES;
//                }
//                else
//                {
//                   messageFrame.showTime = NO;
//                   self.tempDate = nil;
//                }
                    messageFrame.showTime = NO;
                    messageFrame.message = message;
                   [_allMessagesFrame insertObject:messageFrame atIndex:0];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    //界面刷新
    if (_allMessagesFrame.count>0)
    {
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allMessagesFrame count]-1 inSection:0]
                              atScrollPosition: UITableViewScrollPositionBottom
                                      animated:YES];
    }
}

//时间检测
-(BOOL)CheckTimeIsShow:(NSDate *)date
{
    if (self.tempDate)
    {
        NSTimeInterval time = [date timeIntervalSinceDate:self.tempDate];
        return  abs(time)/60 >= 3?YES:NO;
    }
    else
    {
        self.tempDate = date;
        return YES;
    }
}

#pragma mark - 数据库存入消息
//数据存入本地数据库
-(void)recUserId:(NSString *)recUserId toUserId:(NSString *)userId toTime:(NSString *)time toMessage:(NSString *)message
{
    sqlite3 * dataBase = NULL;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *filePath = [documents stringByAppendingPathComponent:@"ChatMessageList.sqlite"];
    //打开数据库
    int result = sqlite3_open([filePath UTF8String],&dataBase);
    
    if (SQLITE_OK == result)
    {
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO MESSAGELIST(rec_user_id, user_id, time, message,creater) values ('%@','%@','%@','%@','%@')",recUserId,userId,time,message,@"0"];
        
        char * error = NULL;
        
        //obj-c字符串和c字符串需要转换
        sqlite3_exec(dataBase, [insert UTF8String], nil, nil, &error);
        sqlite3_close(dataBase);
    }
}


#pragma mark 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time
{
    MessageFrame *messageFrame = [[MessageFrame alloc] init];
    Message *message = [[Message alloc] init];
    message.content = content;
    message.time = time;
    message.icon = @"icon01.png";
    message.type = MessageTypeMe;
    
#pragma mark - 时间检测逻辑
    NSString * StrIsShow = [ArrTimeCheck objectAtIndex:ArrTimeCheck.count-1];
    if ([StrIsShow isEqualToString:@"1"])
    {
       messageFrame.showTime = YES;
    }
    else
    {
        messageFrame.showTime = NO;
    }
    [self recUserId:@"1" toUserId:@"0" toTime:message.time toMessage:message.content];
    messageFrame.message = message;
    [_allMessagesFrame addObject:messageFrame];
}

-(void)getMessageWithContent:(NSString *)content time:(NSString *)time
{
    MessageFrame *messageFrame = [[MessageFrame alloc] init];
    Message *message = [[Message alloc] init];
    message.content = content;
    message.time = time;
    message.icon = @"icon02.png";
    message.type = MessageTypeOther;

#pragma mark - 时间检测逻辑
    NSString * StrIsShow = [ArrTimeCheck objectAtIndex:ArrTimeCheck.count-1];
    
    if ([StrIsShow isEqualToString:@"1"])
    {
         messageFrame.showTime = YES;
    }
    else
    {
        messageFrame.showTime = NO;
    }
    [self recUserId:@"0" toUserId:@"1" toTime:message.time toMessage:message.content];
    messageFrame.message = message;
    [_allMessagesFrame addObject:messageFrame];
}

#pragma mark - tableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allMessagesFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.messageFrame = _allMessagesFrame[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_allMessagesFrame[indexPath.row] cellHeight];
}

#pragma mark - 代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)reloadTableViewDataSource
{
    NSLog(@"==开始加载数据");
    pageIndex++;
    [self getMessageData];
    _reloading = YES;
}

- (void)doneLoadingTableViewData
{
    NSLog(@"===加载完数据");
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
