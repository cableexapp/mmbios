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
#import "PhoneHelper.h"

int messageCountNum = 0;

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
    
    NSString *MessageFlag; //商品详情是否发送商品网址链接标记
    
    NSString *MessageTempFlag; //商品快照是否发送商品网址链接标记
    
    UIButton *btn;
    
    UIButton *rightBtn;
    
    NSMutableArray *getArray;

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
//         self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [DCFColorUtil colorFromHexRGB:@"#f1f1f1"];
    
    //导航标题
    naviTitle = [[UILabel alloc] initWithFrame:CGRectMake(130,20, 120, 44)];
    naviTitle.textColor = [UIColor whiteColor];
    naviTitle.backgroundColor = [UIColor clearColor];
    naviTitle.font = [UIFont systemFontOfSize:20];
    naviTitle.text = @"在线咨询";
    naviTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = naviTitle;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [DCFColorUtil colorFromHexRGB:@"#f1f1f1"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    getArray = [[NSMutableArray alloc] init];
    
    //下拉加载
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *EGOview = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        EGOview.delegate = self;
        [self.tableView addSubview:EGOview];
        _refreshHeaderView = EGOview;
    }
    [_refreshHeaderView refreshLastUpdatedDate];

    //自定义网络状态通知视图
    noNet = [[UILabel alloc] init];
    noNet.frame = CGRectMake(0, 0, self.view.frame.size.width,32);
    noNet.backgroundColor = [DCFColorUtil colorFromHexRGB:@"#fff3bb"];
    noNet.hidden = YES;
    [self.view insertSubview:noNet aboveSubview:self.tableView];
    
    noNetView = [[UIImageView alloc] init];
    noNetView.frame = CGRectMake(20, 6, 20, 20);
    noNetView.image = [UIImage imageNamed:@"ico_error"];
    [self.view insertSubview:noNetView aboveSubview:noNet];
    
    noNetMessage = [[UILabel alloc] init];
    noNetMessage.frame = CGRectMake(55, 0, self.view.frame.size.width-55, 32);
    noNetMessage.textColor = [DCFColorUtil colorFromHexRGB:@"#333333"];
    noNetMessage.font = [UIFont systemFontOfSize:15];
    noNetMessage.textAlignment = NSTextAlignmentLeft;
    noNetMessage.text = @"当前网络不可用，请检查网络设置!";
    [self.view insertSubview:noNetMessage aboveSubview:noNet];
    
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

    //IM账号被迫下线
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offtheopenfire:) name:@"Forced off the assembly line" object:nil];
    
    ArrTimeCheck = [[NSMutableArray alloc]init];
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
    [xmppRoom leaveRoom];
    
    [self pageFromWhere];
    
    self.appDelegate.isConnect = @"断开";
}

-(void)goBackActionToHome
{
    self.appDelegate.forgroudPushMessage = @"前台推送";
    self.appDelegate.pushChatView = @"push";
     [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"message_Push"];
    [self pageFromWhere];
    
    if ([self.appDelegate.isOnLine  isEqualToString:@"available"])
    {
        self.appDelegate.isConnect = @"连接";
    }
    else
    {
         self.appDelegate.isConnect = @"断开";
    }
}

-(void)noFriendOnLineMessage:(NSNotification *)busyMessage
{
    if ([busyMessage.object isEqualToString:@"unavailable"])
    {
        [messageField resignFirstResponder];
        self.tableView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
        toolBar.hidden = YES;
        noNetMessage.text = @"本次咨询已经结束,客服已经离开!";
        noNet.hidden = NO;
        noNetView.hidden = NO;
        noNetMessage.hidden = NO;
        self.appDelegate.isConnect = @"断开";
    }    
//    NSLog(@"busyMessage.object = %@",busyMessage.object);
}

-(void)offtheopenfire:(NSNotification *)busyMessage
{
    [messageField resignFirstResponder];
    self.tableView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    toolBar.hidden = YES;
    noNetMessage.text = @"账号已在其他设备登录，请重新登录!";
    noNet.hidden = NO;
    noNetView.hidden = NO;
    noNetMessage.hidden = NO;
    self.appDelegate.isConnect = @"断开";
}

-(void)pageFromWhere
{
//    NSLog(@"返回self.appDelegate.isConnect = %@",self.appDelegate.isConnect);
//    
//    NSLog(@"返回self.fromStringFlag = %@",self.fromStringFlag);
//    
//    NSLog(@"返回ison = %@",isOn);

    if ([self.appDelegate.isConnect isEqualToString:@"连接"])
    {
        if([self.fromStringFlag isEqualToString:@"工具栏客服"])
        {
            [self.tabBarController setSelectedIndex:0];
        }
        else if([self.fromStringFlag isEqualToString:@"首页在线客服"])
        {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
    else
    {
        self.appDelegate.uesrID = nil;
        self.appDelegate.personName = nil;
      if([self.fromStringFlag isEqualToString:@"首页在线客服"] ||[self.fromStringFlag isEqualToString:@"来自快速询价客服"] || [self.fromStringFlag isEqualToString:@"热门型号在线咨询"] || [self.fromStringFlag isEqualToString:@"场合选择客服"] || [self.fromStringFlag isEqualToString:@"场合选择提交成功客服"] || [self.fromStringFlag isEqualToString:@"热门型号提交成功在线客服"] || [self.fromStringFlag isEqualToString:@"热门分类在线客服"] || [self.fromStringFlag isEqualToString:@"工具栏客服"])
        {
            NSLog(@"页面数组_综合 = %d",self.navigationController.viewControllers.count);
            if (self.navigationController.viewControllers.count == 11)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:7] animated:NO];
            }
            if (self.navigationController.viewControllers.count == 10)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:6] animated:NO];
            }
            if (self.navigationController.viewControllers.count == 9)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:5] animated:NO];
            }
            if (self.navigationController.viewControllers.count == 8)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:4] animated:NO];
            }
            if (self.navigationController.viewControllers.count == 7)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:NO];
            }
            if (self.navigationController.viewControllers.count == 6)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:NO];
            }
            if (self.navigationController.viewControllers.count == 5)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
            }
            if (self.navigationController.viewControllers.count == 4)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
            }
            if (self.navigationController.viewControllers.count == 2)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
            }
        }
       if([self.fromStringFlag isEqualToString:@"工具栏客服"])
        {
             [self.tabBarController setSelectedIndex:0];
        }
        if ([self.fromStringFlag rangeOfString:@"@"].location != NSNotFound)
        {
            if([[[self.fromStringFlag componentsSeparatedByString:@"@"] objectAtIndex:1] isEqualToString:@"家装线商品详情"])
            {
//                NSLog(@"页面数组_家装线商品详情 = %d",self.navigationController.viewControllers.count);
                if (self.navigationController.viewControllers.count == 11)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:7] animated:NO];
                }
                if (self.navigationController.viewControllers.count == 10)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:6] animated:NO];
                }
                if (self.navigationController.viewControllers.count == 9)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:5] animated:NO];
                }
                if (self.navigationController.viewControllers.count == 8)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:4] animated:NO];
                }
                if (self.navigationController.viewControllers.count == 7)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:NO];
                }
                if (self.navigationController.viewControllers.count == 6)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:NO];
                }
                if (self.navigationController.viewControllers.count == 5)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
                }
                if (self.navigationController.viewControllers.count == 4)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
                }
            }
            if([[[self.fromStringFlag componentsSeparatedByString:@"@"] objectAtIndex:1] isEqualToString:@"商品快照在线客服"])
            {
//                NSLog(@"页面数组_商品快照在线客服 = %d",self.navigationController.viewControllers.count);

                if (self.navigationController.viewControllers.count == 11)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:7] animated:NO];
                }
                if (self.navigationController.viewControllers.count == 10)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:6] animated:NO];
                }
                if (self.navigationController.viewControllers.count == 9)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:5] animated:NO];
                }
                if (self.navigationController.viewControllers.count == 8)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:4] animated:NO];
                }
                if (self.navigationController.viewControllers.count == 7)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:NO];
                }
                if (self.navigationController.viewControllers.count == 6)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:NO];
                }
                if (self.navigationController.viewControllers.count == 5)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
                }
                if (self.navigationController.viewControllers.count == 4)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
                }
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetCount" object:nil];
}


- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
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

-(void)viewDidAppear:(BOOL)animated
{
     [self.navigationController.tabBarController.tabBar setHidden:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Forced off the assembly line" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
    self.wantsFullScreenLayout = YES;
   
    [self.tabBarController.tabBar setHidden:YES];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"message_Push"];
    messageCountNum = 0;
    self.appDelegate.messageCount = 0;
    self.appDelegate.forgroudPushMessage = @"取消前台推送";
    self.appDelegate.pushChatView = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendMessageToBadge" object:[NSString stringWithFormat:@"%d",self.appDelegate.messageCount]];
    
    [self checkNet];
    
    if ([[self appDelegate].xmppStream isDisconnected])
    {
//       noNetMessage.text = @"服务器未连接，请退出重新登录!";
    }
    else
    {
        if (self.appDelegate.uesrID != nil)
        {
            [self creatRoom];
        }
    }

    [self firstPageMessageData];
    
     NSLog(@"聊天窗口self.navigationController.viewControllers = %@",self.navigationController.viewControllers);

    [self.navigationController.tabBarController.tabBar setHidden:YES];
    
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view isKindOfClass:[UIButton class]] || [view tag] == 101)
        {
            [view setHidden:YES];
        }
    }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0,0, 15, 22);
    [btn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackActionToHome) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"结束会话" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightBtn setFrame:CGRectMake(self.view.frame.size.width-65, 20, 60, 44)];
    [rightBtn addTarget:self action:@selector(endChatConfrence) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //聊天输入工具条
    if (!btn || !toolBar || !rightBtn || !keyboardButton || !sendButton || !messageField)
    {
       self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
      
        toolBar = [[UIView alloc] init];
        toolBar.frame = CGRectMake(0,self.view.frame.size.height-44, self.view.frame.size.width, 44);
        toolBar.backgroundColor = [DCFColorUtil colorFromHexRGB:@"#ffffff"];
        [self.view addSubview:toolBar];

        //键盘按钮
        keyboardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        keyboardButton.frame = CGRectMake(6, 4.5, 35, 35);
        [keyboardButton addTarget:self action:@selector(faceBoardClick) forControlEvents:UIControlEventTouchUpInside];
        [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
        [toolBar addSubview:keyboardButton];
        
        //发送按钮
        sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sendButton.frame = CGRectMake(260, 6, 54, 32);
        [sendButton addTarget:self action:@selector(sendNewChatMessage) forControlEvents:UIControlEventTouchUpInside];
        sendButton.layer.cornerRadius = 3;
        sendButton.layer.backgroundColor = [[UIColor colorWithRed:10.0/255.0 green:88.0/255.0 blue:173.0/255.0 alpha:1] CGColor];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setTintColor:[UIColor whiteColor]];
        [toolBar addSubview:sendButton];
        
        //消息输入框
        messageField = [[UITextView alloc] init];
        messageField.frame = CGRectMake(46, 6, 206, 32);
        messageField.delegate = self;
        messageField.layer.backgroundColor = [[DCFColorUtil colorFromHexRGB:@"#ffffff"] CGColor];
        messageField.layer.borderWidth = 1;
        messageField.layer.borderColor = [[DCFColorUtil colorFromHexRGB:@"#dddddd"] CGColor];
        [messageField setReturnKeyType:UIReturnKeyNext];
        messageField.layer.cornerRadius =3;
        [toolBar addSubview:messageField];
    }
//    NSLog(@"self.appDelegate.uesrID =%@",self.appDelegate.uesrID);
    if (self.appDelegate.uesrID.length > 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.appDelegate.uesrID forKey:@"toJID"];
    }
    if ([self.appDelegate.isConnect isEqualToString:@"连接"])
    {
        NSString *GoodsDetailstring =  [[NSUserDefaults standardUserDefaults] objectForKey:@"tempFlag"];
        NSString *GoodsFaststring =  [[NSUserDefaults standardUserDefaults] objectForKey:@"tempFlag"];
        if (GoodsDetailstring.length > 0)
        {
            MessageFlag = @"消息";
        }
        else
        {
            MessageFlag = nil;
        }
        if (GoodsFaststring.length > 0)
        {
            MessageTempFlag = @"消息";
        }
        else
        {
            MessageTempFlag = nil;
        }
    }
   
    if (_allMessagesFrame.count > 0)
    {
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessagesFrame.count - 1
                                                                  inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:NO];
    }
//    NSLog(@"咨询入口 = %@",self.fromStringFlag);
//    NSLog(@"viewWillAppear_self.appDelegate.isOnLine = %@",self.appDelegate.isOnLine);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
    return YES;
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
     frame.size.height -= keyboardRect.size.height;
     self.tableView.frame = frame;
     
     frame = toolBar.frame;
     frame.origin.y += keyboardHeight;
     frame.origin.y -= keyboardRect.size.height;
     toolBar.frame = frame;
     
     keyboardHeight = keyboardRect.size.height;
    }];
    if (isFirstShowKeyboard)
    {
        isFirstShowKeyboard = NO;
        isSystemBoardShow = !isButtonClicked;
    }
    if (isSystemBoardShow)
    {
        [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
    }
    else
    {
        [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_system"] forState:UIControlStateNormal];
    }
    if (_allMessagesFrame.count)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessagesFrame.count-1
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
    [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    isKeyboardShowing = NO;
    if (isButtonClicked)
    {
        isButtonClicked = NO;
        if (![messageField.inputView isEqual:faceBoard])
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
    NSString *getTime;
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
            getTime = @"0";
        }
        else if (abs(time/60) >= 3)
        {
            StrTimeCheck = loctime;
            [ArrTimeCheck addObject:@"1"];
            getTime = @"1";
        }
    }
    else
    {
        StrTimeCheck = loctime;
        [ArrTimeCheck addObject:@"1"];
        getTime = @"1";
    }
    //接收消息处理
    [self getMessageWithContent:notification.object time:loctime timeIsShow:getTime];
    
//    roomMessage = [[message elementForName:@"body"] stringValue];
      roomMessage = notification.object;
    
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

//生成随机聊天ID
-(void)chatID
{
    self.changeArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
    
    NSMutableString *getStr = [[NSMutableString alloc] initWithCapacity:5];
    
    self.changeString = [[NSMutableString alloc] initWithCapacity:6];
    for(NSInteger i = 0; i < 5; i++)
    {
        NSInteger index = arc4random() % ([self.changeArray count] - 1);
        getStr = [self.changeArray objectAtIndex:index];
        
        self.changeString = (NSMutableString *)[self.changeString stringByAppendingString:getStr];
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
            [self chatID];
            //生成XML消息文档
            NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
            if ([self.fromStringFlag isEqualToString:@"首页在线客服"] || [self.fromStringFlag isEqualToString:@"工具栏客服"])
            {
                stringLabel = [NSString stringWithFormat:@"[买卖宝iOS提示:信息来自 - 首页客服]：%@",message];
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
            else if ([self.fromStringFlag isEqualToString:@"场合选择客服"])
            {
                stringLabel = [NSString stringWithFormat:@"[买卖宝iOS提示:信息来自 - 场合选择]：%@",message];
            }
            else if ([self.fromStringFlag isEqualToString:@"场合选择提交成功客服"])
            {
                stringLabel = [NSString stringWithFormat:@"[买卖宝iOS提示:信息来自 - 场合提交]：%@",message];
            }
            else if ([self.fromStringFlag isEqualToString:@"热门型号提交成功在线客服"])
            {
                stringLabel = [NSString stringWithFormat:@"[买卖宝iOS提示:信息来自 - 热门型号提交]：%@",message];
            }
            else if([self.fromStringFlag isEqualToString:@"工具栏客服"])
            {
                stringLabel = [NSString stringWithFormat:@"[买卖宝iOS提示:信息来自 - 首页客服]：%@",message];
            }
            else
            {
                stringLabel = [NSString stringWithFormat:@"[买卖宝iOS提示:信息来自 - 首页客服]：%@",message];
            }
            if ([self.fromStringFlag rangeOfString:@"@"].location != NSNotFound)
            {
               if ([[[self.fromStringFlag componentsSeparatedByString:@"@"] objectAtIndex:1] isEqualToString:@"家装线商品详情"])
                {
                    if (MessageFlag.length == 0)
                    {
                        stringLabel = [NSString stringWithFormat:@"[买卖宝iOS提示:信息来自 - 商品详情]：\n%@\n%@",[[self.fromStringFlag componentsSeparatedByString:@"@"] objectAtIndex:0],message];
                        MessageFlag = stringLabel;
                         [[NSUserDefaults standardUserDefaults] setObject:MessageFlag forKey:@"tempFlag"];
                       
                    }
                    else
                    {
                        stringLabel = [NSString stringWithFormat:@"[买卖宝iOS提示:信息来自 - 商品详情]：%@",message];
                    }
                }
                if([[[self.fromStringFlag componentsSeparatedByString:@"@"] objectAtIndex:1] isEqualToString:@"商品快照在线客服"])
                {
                    if (MessageTempFlag.length == 0)
                    {
                        stringLabel = [NSString stringWithFormat:@"[买卖宝iOS提示:信息来自 - 商品快照]：\n%@\n%@",[[self.fromStringFlag componentsSeparatedByString:@"@"] objectAtIndex:0],message];
                        MessageTempFlag = stringLabel;
                        [[NSUserDefaults standardUserDefaults] setObject:MessageTempFlag forKey:@"MessageTempFlag"];
                    }
                    else
                    {
                        stringLabel = [NSString stringWithFormat:@"[买卖宝iOS提示:信息来自 - 商品快照]：%@",message];
                    }
                }
            }
            [body setStringValue:stringLabel];
            NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
            [mes addAttributeWithName:@"type" stringValue:@"groupchat"];
            [mes addAttributeWithName:@"id" stringValue:[NSString stringWithFormat:@"%@-10",self.changeString]];

            if (self.appDelegate.uesrID.length > 0)
            {
                [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@",self.appDelegate.uesrID]];
            }
            if (self.appDelegate.uesrID.length == 0)
            {
                [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"toJID"]]];
            }
            
            [mes addChild:body];
            [[self xmppStream] sendElement:mes];

            //获得本地时间
            NSDate *dates = [NSDate date];
            NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy:MM:dd:HH:mm:ss"];
            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
            [formatter setTimeZone:timeZone];
            NSString *loctime = [formatter stringFromDate:dates];

            
            #pragma mark - 数据检查
            NSString *sendTime;
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
                    sendTime = @"0";
                }
                else if(abs(time)/60 >= 3)
                {
                    StrTimeCheck = loctime;
                    [ArrTimeCheck addObject:@"1"];
                    sendTime = @"1";
                }
            }
            else
            {
                StrTimeCheck = loctime;
                [ArrTimeCheck addObject:@"1"];
                sendTime = @"1";
            }
            messageField.text = @"";
            
           [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
            
            //发送消息处理
            [self addMessageWithContent:message time:loctime timeIsShow:sendTime];
            
            //刷新UI界面
            [self refreshUI];
        }
    }
}


//创建房间
-(void)creatRoom
{    
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
    NSString *tempUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_username"];
    if (tempUserName.length > 0)
    {
        [xmppRoom joinRoomUsingNickname:tempUserName history:nil];
    }
    else
    {
        [xmppRoom joinRoomUsingNickname:self.appDelegate.chatRequestJID history:nil];
    }
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
    NSLog(@"收到好友名单列表 = %@\n\n",items);
}

// 收到主持人名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items
{
    NSLog(@"收到主持人名单列表 = %@\n\n",items);
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
    self.appDelegate.isConnect = @"断开";
}

//新人加入群聊
- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID
{
//    NSLog(@"新人加入群聊");
}
//有人退出群聊
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID
{
//    NSLog(@"有人退出群聊");
}

//有人在群里发言
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
//   NSLog(@"有人在群里发言+++++++++++++++++++++++++++++ = %@\n\n",message);
    tempJID =[NSString stringWithFormat:@"%@",occupantJID];
   
    if (![[[tempJID componentsSeparatedByString:@"/"] objectAtIndex:1] isEqualToString:self.appDelegate.chatRequestJID])
    {
//       roomMessage = [[message elementForName:@"body"] stringValue];
        
//      [[NSNotificationCenter defaultCenter] postNotificationName:@"messageGetting" object:roomMessage];
        
//        NSLog(@"群里发言————————————————————————————");
    }
}

-(void)firstPageMessageData
{
    pageIndex =0;
    [self getMessageData];
    
    if (_allMessagesFrame.count > 0)
    {
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessagesFrame.count - 1
                                                                  inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:NO];
    }
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
    
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    
    NSString *tempUserName = [[NSUserDefaults standardUserDefaults]  objectForKey:@"app_username"];
    
    sqlite3_stmt *statement;
    
//    NSString *delateString = @"delete from messagelist where id not in (select max(id) from messagelist group by time)";
    
    if (SQLITE_OK == result)
    {
//        NSLog(@"删除重复数据111111\n\n");
//        if (sqlite3_prepare_v2(dataBase,[delateString UTF8String],-1, &statement, nil)==SQLITE_OK)
//        {
//            NSLog(@"删除重复数据222222\n\n");
//            
//            while (sqlite3_step(statement)==SQLITE_ROW)
//            {
//                NSLog(@"删除重复数据 = %@",delateString);
//            }
//        }

        //创建SQL语句查询
        NSString *selectString;
        
        if (hasLogin == YES)
        {
            selectString = [NSString stringWithFormat:@"select * from messagelist where user_name = '%@' order by id  desc limit %d offset %d",tempUserName,10,pageIndex*10+messageCountNum];
        }
        else
        {
            selectString = [NSString stringWithFormat:@"select * from messagelist where user_name = '%@' order by id  desc limit %d offset %d",[self.appDelegate getUdid],10,pageIndex*10+messageCountNum];
        }
        if (sqlite3_prepare_v2(dataBase,[selectString UTF8String],-1, &statement, nil)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                /*recUserId:(NSString *)recUserId toUserId:(NSString *)userId toUserName:(NSString *)userName toTime:(NSString *)time toMessage:(NSString *)message
*/
                /*
                 0: 自增id
                 1: 接受者id
                 2: 发送者id
                 3: 登录用户名
                 4: 时间
                 5: 内容
                 */
                
                //查询结果处理
//                NSString *rec_userId =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
                
                NSString *sen_userId =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
                
                NSString *time =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
                
                NSString *msg =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
                
                NSDictionary * dic;

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
                message.dict = dic;
                messageFrame.message = message;

//                if ([rec_userId isEqualToString:@"1"])
//                {
//                    messageFrame.showTime = YES;
//                    NSLog(@"显示时间");
//                }
//                else
//                {
//                    messageFrame.showTime = NO;
//                    NSLog(@"不显示时间");
//                }
                messageFrame.showTime = YES;
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

//去除数组重复元素
-(NSMutableArray *)arrayWithMemberIsOnly:(NSMutableArray *)clearArray
{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [clearArray count]; i++)
    {
        {
            if ([categoryArray containsObject:[clearArray objectAtIndex:i]] == NO)
            {
                [categoryArray addObject:[clearArray objectAtIndex:i]];
            }
        }
    }
    return categoryArray;
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
    return YES;
}

#pragma mark - 数据库存入消息
//数据存入本地数据库
-(void)recUserId:(NSString *)recUserId toUserId:(NSString *)userId toUserName:(NSString *)userName toTime:(NSString *)time toMessage:(NSString *)message
{
    sqlite3 * dataBase = NULL;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *filePath = [documents stringByAppendingPathComponent:@"ChatMessageList.sqlite"];
    //打开数据库
    int result = sqlite3_open([filePath UTF8String],&dataBase);
    
    if (SQLITE_OK == result)
    {
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO MESSAGELIST(rec_user_id, user_id, user_name, time, message,creater) values ('%@','%@','%@','%@','%@','%@')",recUserId,userId,userName,time,message,@"0"];
        
        char * error = NULL;
        
        //obj-c字符串和c字符串需要转换
        sqlite3_exec(dataBase, [insert UTF8String], nil, nil, &error);
        sqlite3_close(dataBase);
    }
}

#pragma mark 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time timeIsShow:(NSString *)timeShowFlage
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
    
    messageCountNum++;
    messageFrame.message = message;
    [_allMessagesFrame addObject:messageFrame];

    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    
    NSString *tempUserName = [[NSUserDefaults standardUserDefaults]  objectForKey:@"app_username"];
    
    if(hasLogin == YES)
    {
        [self recUserId:timeShowFlage toUserId:@"0" toUserName:tempUserName toTime:message.time toMessage:message.content];
    }
    else
    {
        [self recUserId:timeShowFlage toUserId:@"0" toUserName:[self.appDelegate getUdid] toTime:message.time toMessage:message.content];
    }
    
    if (_allMessagesFrame.count > 0)
    {
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessagesFrame.count - 1
                                                                  inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:NO];
    }
}

-(void)getMessageWithContent:(NSString *)content time:(NSString *)time timeIsShow:(NSString *)timeShowFlage
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
    messageCountNum++;
    messageFrame.message = message;
    [_allMessagesFrame addObject:messageFrame];
    
    if (_allMessagesFrame.count > 0)
    {
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessagesFrame.count - 1
                                                                  inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:NO];
    }
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
