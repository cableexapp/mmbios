//
//  FourMyMMBListTableViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-17.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "FourMyMMBListTableViewController.h"
#import "MCDefine.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "FourthHostViewController.h"
#import "AccountManagerTableViewController.h"
#import "LoginNaviViewController.h"
#import "DCFCustomExtra.h"
#import "MyInquiryListFirstViewController.h"
#import "MyCableOrderHostViewController.h"
#import "LoginViewController.h"
#import "MyShoppingListViewController.h"
#import "B2BAskPriceCarViewController.h"
#import "KxMenu.h"
#import "AppDelegate.h"
#import "UIImage (fixOrientation).h"
#import "DCFStringUtil.h"
#import "DCFColorUtil.h"
#import "UIImageView+WebCache.h"
#import "FourthNaviViewController.h"
#import "FifthTableViewController.h"

@interface FourMyMMBListTableViewController ()
{
    NSMutableArray *headBtnArray;
    
    NSMutableArray *cellBtnArray;
    
    NSMutableArray *badgeArray;
    
    UIStoryboard *sb;
    
    NSMutableArray *arr;
    
    BOOL isPopShow;
    
    int tempCount;
    
    int tempShopCar;
    
    UIActionSheet *changePhotoSheet;
    UIActionSheet *albumSheet;
    
    FourthHostViewController *fourthHostViewController;
    
    AppDelegate *app;
}
@end

@implementation FourMyMMBListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) headBtnClick:(UIButton *) sender
{
    NSInteger tag = sender.tag;
    NSLog(@"tag = %ld",(long)tag);
    if(tag == 1)
    {

    }
    if(tag == 0)
    {
        [self pushToOrderListViewControllerWithBtn:sender];
    }
//    if(tag == 3)
//    {
//        [self setHidesBottomBarWhenPushed:YES];
//        AccountManagerTableViewController *accountManagerTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"accountManagerTableViewController"];
//        [self.navigationController pushViewController:accountManagerTableViewController animated:YES];
//        [self setHidesBottomBarWhenPushed:NO];
//    }
}

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    if(memberid.length == 0 || [memberid isKindOfClass:[NSNull class]])
    {
        memberid = @"";
    }
    return memberid;
}

- (void) pushToVC
{
    [self setHidesBottomBarWhenPushed:YES];
    fourthHostViewController.myStatus = @"";
    [self.navigationController pushViewController:fourthHostViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

//请求询价车商品数量
-(void)loadbadgeCount
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"InquiryCartCount",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    NSString *visitorid = [app getUdid];
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString *pushString = nil;
    if(hasLogin == YES)
    {
        pushString = [NSString stringWithFormat:@"memberid=%@&token=%@",memberid,token];
    }
    else
    {
        pushString = [NSString stringWithFormat:@"visitorid=%@&token=%@",visitorid,token];
    }
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLInquiryCartCountTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/InquiryCartCount.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

//获取购物车商品数量
-(void)loadShopCarCount
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getShoppingCartCount",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    NSString *visitorid = [app getUdid];
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString *pushString = nil;
    if(hasLogin == YES)
    {
        pushString = [NSString stringWithFormat:@"memberid=%@&token=%@",memberid,token];
    }
    else
    {
        pushString = [NSString stringWithFormat:@"visitorid=%@&token=%@",visitorid,token];
    }
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLShopCarCountTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getShoppingCartCount.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLGetCountNumTag)
    {
        if(_reloading == YES)
        {
            [self doneLoadingViewData];
        }
        else if(_reloading == NO)
        {
            
        }
        if(result == 1)
        {
            badgeArray = [[NSMutableArray alloc] initWithArray:[dicRespon objectForKey:@"items"]];
#pragma mark - 暂时写死，等接口出来再调试
            
            NSLog(@"test");
            [badgeArray removeAllObjects];
            NSLog(@"badgeArray=%@",badgeArray);
            for(int i =0;i<badgeArray.count;i++)
            {
                UIButton *cellBtn = (UIButton *)[cellBtnArray objectAtIndex:i];
                NSString *s = [NSString stringWithFormat:@"%@",[badgeArray objectAtIndex:i]];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if(s.intValue < 99 && s.intValue > 0)
                {
                    if (cellBtn.frame.size.width >= 153)
                    {
                        if (cellBtn.titleLabel.text.length == 5)
                        {
                            [btn setFrame:CGRectMake(cellBtn.frame.size.width-50, 17, 18, 18)];
                        }
                        else
                        {
                            [btn setFrame:CGRectMake(cellBtn.frame.size.width-65, 17, 18, 18)];
                        }
                    }
                    else if (cellBtn.frame.size.width >= 100 && cellBtn.frame.size.width < 153)
                    {
                        if (i == 8)
                        {
                            [btn setFrame:CGRectMake(cellBtn.frame.size.width-38, 13, 18, 18)];
                        }
                        else
                        {
                            [btn setFrame:CGRectMake(cellBtn.frame.size.width-40, 17, 18, 18)];
                        }
                    }
                    else if (cellBtn.frame.size.width >= 70 && cellBtn.frame.size.width < 100)
                    {
                        [btn setFrame:CGRectMake(cellBtn.frame.size.width-25, 17, 18, 18)];
                    }
                    [btn setBackgroundImage:[UIImage imageNamed:@"msg_bq.png"] forState:UIControlStateNormal];
                    [btn setTitle:s forState:UIControlStateNormal];
                }
                else if (s.intValue >= 99)
                {
                    if (cellBtn.frame.size.width >= 153)
                    {
                        if (cellBtn.titleLabel.text.length == 5)
                        {
                            [btn setFrame:CGRectMake(cellBtn.frame.size.width-50, 17, 22, 19)];
                        }
                        else
                        {
                            [btn setFrame:CGRectMake(cellBtn.frame.size.width-65, 17, 22, 19)];
                        }
                    }
                    else if (cellBtn.frame.size.width >= 100 && cellBtn.frame.size.width < 153)
                    {
                        if (i == 8)
                        {
                            [btn setFrame:CGRectMake(cellBtn.frame.size.width-38, 13, 22, 19)];
                        }
                        else
                        {
                            [btn setFrame:CGRectMake(cellBtn.frame.size.width-40, 17, 22, 19)];
                        }
                    }
                    else if (cellBtn.frame.size.width >= 70 && cellBtn.frame.size.width < 100)
                    {
                        [btn setFrame:CGRectMake(cellBtn.frame.size.width-25, 17, 22, 19)];
                    }
                    [btn setBackgroundImage:[UIImage imageNamed:@"msg_bqy.png"] forState:UIControlStateNormal];
                    [btn setTitle:@"99+" forState:UIControlStateNormal];
                }
                [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                
                if(s.intValue == 0)
                {
                    for(UIView *view in cellBtn.subviews)
                    {
                        if([view isKindOfClass:[UIButton class]])
                        {
                            [view removeFromSuperview];
                        }
                    }
                }
                else
                {
                    [cellBtn addSubview:btn];
                }
            }
            [self.tableView reloadData];
            
            [self loadbadgeCount];
            
        }
        else
        {
            
        }
    }
    if (URLTag == URLInquiryCartCountTag)
    {
        if(result == 1)
        {
            tempCount = [[dicRespon objectForKey:@"value"] intValue];
            
            [self loadShopCarCount];
            
        }
    }
    if (URLTag == URLShopCarCountTag)
    {
        if(result == 1)
        {
            tempShopCar = [[dicRespon objectForKey:@"total"] intValue];
        }
    }
    if (tempCount > 0 || tempShopCar > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidenRedPoint" object:@"1"];
    }
    if (tempCount == 0 && tempShopCar == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidenRedPoint" object:@"2"];
    }
    if(URLTag == URLUpImagePicTag)
    {
        if(result == 1)
        {
            NSString *headUrl = [dicRespon objectForKey:@"headPortraitUrl"];
            NSString *headPortraitUrl = [NSString stringWithFormat:@"%@%@%@",URL_HOST_CHEN,@"/",headUrl];
            [[NSUserDefaults standardUserDefaults] setObject:headPortraitUrl forKey:@"headPortraitUrl"];
            [self.tableView reloadData];
            [DCFStringUtil showNotice:msg];
        }
        else
        {
            if([DCFCustomExtra validateString:msg] == NO)
            {
                [DCFStringUtil showNotice:@"上传头像失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}

- (void) loadGetCountNumRequest
{
    NSString *memberid = [self getMemberId];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getCountNum",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@",memberid,token];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetCountNumTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getCountNum.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    fourthHostViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fourthHostViewController"];
    
    [self.tabBarController.tabBar setHidden:NO];
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    [self loadGetCountNumRequest];
    
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popShopCar_mmb:) name:@"popShopCar" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (changeClick:) name:@"dissMiss" object:nil];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"frommmb"];
    if (str.length > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToHostView_mmb" object:nil];
    }
    
    self.tableView.scrollEnabled = YES;
    isPopShow = NO;
    [KxMenu dismissMenu];
    
    if(app.isB2BPush == YES)
    {
        [self setHidesBottomBarWhenPushed:YES];
        MyCableOrderHostViewController *myCableOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableOrderHostViewController"];
        myCableOrder.btnIndex = 1;
        [self.navigationController pushViewController:myCableOrder animated:NO];
        [self setHidesBottomBarWhenPushed:NO];
    }
    if(app.isB2CPush == YES)
    {
        [self setHidesBottomBarWhenPushed:YES];
        fourthHostViewController.myStatus = @"1";
        [self.navigationController pushViewController:fourthHostViewController animated:NO];
        [self setHidesBottomBarWhenPushed:NO];
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
    if(badgeArray)
    {
        [badgeArray removeAllObjects];
        badgeArray = nil;
    }
    [self setHidesBottomBarWhenPushed:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popShopCar" object:nil];
}

- (void) setBtnClick:(UIButton *) sender
{
//    UIStoryboard *fifthSB = [UIStoryboard storyboardWithName:@"FifthSB" bundle:nil];
    FifthTableViewController *fifthTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fifthTableViewController"];
    [self.navigationController pushViewController:fifthTableViewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self pushAndPopStyle];
    //    isPopShow = NO;
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"我的买卖宝"];
    self.navigationItem.titleView = top;
    
    if(app.aliPayHasFinished == YES)
    {
        [self pushToVC];
    }
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    [setBtn setFrame:CGRectMake(0, 0, 50, 50)];
    [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    self.view1.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
//    self.view2.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
//    self.view3.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
//    self.view4.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
//    self.view5.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
//    self.view6.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
//    
//    self.view11.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
//    self.view22.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
//    self.view33.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    
    headBtnArray = [[NSMutableArray alloc] init];
    for(int i=0;i<2;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(-1, 0, ScreenWidth+1, 45)];
        [btn setTag:i];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *label_1 = [[UILabel alloc] init];
        [label_1 setTextColor:[UIColor blackColor]];
        [label_1 setFont:[UIFont systemFontOfSize:15]];
        if(i <= 1)
        {
            [label_1 setFrame:CGRectMake(45, 5, 200, 35)];
        }
        else
        {
            [label_1 setFrame:CGRectMake(45, 5, 150, 35)];
        }
        [label_1 setTextAlignment:NSTextAlignmentLeft];
        
        UILabel *label_2 = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width-140, 5, 100, 35)];
        [label_2 setTextColor:[UIColor lightGrayColor]];
        [label_2 setFont:[UIFont systemFontOfSize:14]];
        [label_2 setTextAlignment:NSTextAlignmentRight];
        [label_2 setText:@"查看全部"];
        
        if(i == 0)
        {
            [label_1 setText:@"我的订单"];
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 35, 35)];
            [iv setImage:[UIImage imageNamed:@"mmbOrder.png"]];
            [btn addSubview:iv];
            [btn addSubview:label_2];
            [btn addSubview:label_1];
        }
        if(i == 1)
        {
            [label_1 setText:@"我的定制"];
//            [btn addSubview:label_2];
            [btn addSubview:label_1];

            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 35, 35)];
            [iv setImage:[UIImage imageNamed:@"dlOrder.png"]];
            [btn addSubview:iv];
        }
//        if(i == 2)
//        {
//            [label_1 setText:@"我的家装线订单"];
//            [btn addSubview:label_2];
//            
//            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 35, 35)];
//            [iv setImage:[UIImage imageNamed:@"homeOrder.png"]];
//            [btn addSubview:iv];
//        }
//        if(i == 3)
//        {
//            [label_1 setText:@"账户安全"];
//            
//            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 35, 35)];
//            [iv setImage:[UIImage imageNamed:@"count.png"]];
//            [btn addSubview:iv];
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height-1, self.view.frame.size.width, 1)];
//            lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
//            [btn addSubview:lineView];
//        }
//        [btn addSubview:label_1];
//        if (i != 0)
//        {
//            UIImageView *arrowIv = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-40, 5, 35, 35)];
//            [arrowIv setImage:[UIImage imageNamed:@"set_clear.png"]];
//            [btn addSubview:arrowIv];
//        }
        [headBtnArray addObject:btn];
    }
    cellBtnArray = [[NSMutableArray alloc] initWithObjects:_btn_8,_btn_11,_btn_9,_btn_10,_btn_2,_btn_3,nil];
    
    for(int i=0;i<cellBtnArray.count;i++)
    {
//        UIButton *btn = (UIButton *)[cellBtnArray objectAtIndex:i];
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    }
    
    self.photoBtn = [[UIImageView alloc] init];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoBtnAction:)];
    [self.photoBtn setUserInteractionEnabled:YES];
    [self.photoBtn addGestureRecognizer:tapGesture];
    
    //ADD REFRESH VIEW
    _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -300, ScreenWidth, 300)];
    [self.refreshView setDelegate:self];
    [self.tableView addSubview:self.refreshView];
    [self.refreshView refreshLastUpdatedDate];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(tabBarController.selectedIndex == 3)    //"我的账号"
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)photoBtnAction:(id)sender
{
    albumSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
    if (self.navigationController)
    {
        [albumSheet showInView:self.navigationController.navigationBar];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isEqual:changePhotoSheet])
    {
        switch (buttonIndex)
        {
            case 0://更改头像
                [self uploadPhoto];
                break;
                
            default:
                break;
        }
    }
    else if ([actionSheet isEqual:albumSheet])
    {
        switch (buttonIndex)
        {
            case 0://手机相册
                [self performSelector:@selector(openAlbum:) withObject:nil afterDelay:0.1];
                break;
            case 1://拍照
                [self performSelector:@selector(takePhotos:) withObject:nil afterDelay:0.1];
                break;
                
            default:
                break;
        }
    }
    
}

#pragma mark - 上传头像
- (void)uploadPhoto
{
    //    albumSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"手机相册",@"拍照", nil];
    //    if (self.navigationController)
    //    {
    //        [albumSheet showInView:self.navigationController.navigationBar];
    //    }
}

- (void) openAlbum:(id) sender
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypePhotoLibrary])
    {
        
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;

    [pickerImage.navigationBar setBackgroundImage:[DCFCustomExtra imageWithColor:[DCFColorUtil colorFromHexRGB:@"#1465ba"] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    
    [pickerImage.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[UIFont systemFontOfSize:20], UITextAttributeFont,nil]];
    
    [self presentViewController:pickerImage animated:YES completion:nil];
}

- (void) takePhotos:(id) sender
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypeCamera])
    {
        
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:nil];
}

#pragma mark - 处理图片
-(void)procesPic:(UIImage*)img
{
    //图片压缩
    CGSize imagesize = img.size;
    imagesize.height =120;
    imagesize.width = 120;
    img = [DCFCustomExtra reSizeImage:img toSize:imagesize];
    NSData *data = UIImageJPEGRepresentation(img, 0.125);
    
    UIImage *image = [UIImage imageWithData:data];
    self.userImage = image;
    image = [image fixOrientation];
    
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    NSMutableArray *nameArr = [[NSMutableArray alloc] init];
    NSMutableArray *strImageFileNameArray = [[NSMutableArray alloc] init];
    NSString *strImageFileName = nil;
    
    [imgArr addObject:image];
    NSString *nameString = [NSString stringWithFormat:@"%@",img.description];
    
    NSRange range = NSMakeRange(1, nameString.length-2);
    nameString = [nameString substringWithRange:range];
    
    NSRange range_1 = NSMakeRange(9, nameString.length-9);
    nameString = [nameString substringWithRange:range_1];
    
    NSString *picName = [NSString stringWithFormat:@"%@.png",nameString];
    [nameArr addObject:picName];
    
    strImageFileName = [NSString stringWithFormat:@"%@",@"headPic"];
    [strImageFileNameArray addObject:strImageFileName];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"setHeadPortrait",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    conn = [[DCFConnectionUtil alloc]initWithURLTag:URLUpImagePicTag delegate:self];
    
    NSString *loginid = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginid"];
    if([DCFCustomExtra validateString:loginid] == NO)
    {
        loginid = @"";
    }
    NSString *strRequest = [NSString stringWithFormat:@"memberid=%@&token=%@&loginid=%@",[self getMemberId],token,loginid];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",URL_HOST_CHEN,@"/B2CAppRequest/setHeadPortrait.html?",strRequest];
    NSDictionary *imgDic = [NSDictionary dictionaryWithObjects:imgArr forKeys:nameArr];
    
    [conn getResultFromUrlString:urlString dicText:nil dicImage:imgDic imageFilename:strImageFileNameArray];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *img=[info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImageWriteToSavedPhotosAlbum(img, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (img)
    {
        [self performSelector:@selector(procesPic:) withObject:img afterDelay:0.1];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil;
    if(error != NULL)
    {
        msg = @"保存图片失败";
        [DCFStringUtil showNotice:msg];
    }
}

- (void)popShopCar_mmb:(NSNotification *)sender
{
    if (isPopShow == YES)
    {
        [KxMenu dismissMenu];
        isPopShow = NO;
        self.tableView.scrollEnabled = YES;
    }
    else
    {
        NSArray *menuItems =
        @[[KxMenuItem menuItem:[NSString stringWithFormat:@"购物车(%d)",tempShopCar]
                         image:nil
                        target:self
                        action:@selector(pushMenuItem_mmb:)],
          
          [KxMenuItem menuItem:[NSString stringWithFormat:@"询价车(%d)",tempCount]
                         image:nil
                        target:self
                        action:@selector(pushMenuItem_mmb:)],
          ];
        
        [KxMenu showMenuInView:self.view
                      fromRect:CGRectMake(self.view.frame.size.width/5-15, self.view.frame.size.height, self.view.frame.size.height/5, 49)
                     menuItems:menuItems];
        isPopShow = YES;
        self.tableView.scrollEnabled = NO;
    }
}

- (void)pushMenuItem_mmb:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    if ([[[[[[NSString stringWithFormat:@"%@",sender] componentsSeparatedByString:@" "] objectAtIndex:2] componentsSeparatedByString:@"("] objectAtIndex:0] isEqualToString:@"购物车"])
    {
        MyShoppingListViewController *shop = [[MyShoppingListViewController alloc] initWithDataArray:arr];
        [self.navigationController pushViewController:shop animated:YES];
    }
    else
    {
        B2BAskPriceCarViewController *b2bAskPriceCar = [sb instantiateViewControllerWithIdentifier:@"b2bAskPriceCarViewController"];
        b2bAskPriceCar.fromString = @"我的买卖宝";
        [self.navigationController pushViewController:b2bAskPriceCar animated:YES];
    }
    [self setHidesBottomBarWhenPushed:NO];
}

-(void)changeClick:(NSNotification *)viewChanged
{
    if (isPopShow == YES)
    {
        isPopShow = NO;
        self.tableView.scrollEnabled = YES;
    }
    else
    {
        isPopShow = YES;
        self.tableView.scrollEnabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height;
    if(section == 0)
    {
        height = 90;
    }
    else
    {
        height = 45;
    }
    return height;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
        
        [self.photoBtn setFrame:CGRectMake(20, 15, 60, 60)];
        [self.photoBtn.layer setCornerRadius:CGRectGetHeight([self.photoBtn bounds]) / 2];  //修改半径，实现头像的圆形化
        self.photoBtn.layer.masksToBounds = YES;
        NSString *headPortraitUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"headPortraitUrl"];
        [self.photoBtn setImageWithURL:[NSURL URLWithString:headPortraitUrl] placeholderImage:[UIImage imageNamed:@"headPic.png"]];
        [view addSubview:self.photoBtn];
        
        UIImageView *backView = [[UIImageView alloc] init];
        backView.frame = CGRectMake(0, 0, ScreenWidth, 90);
        backView.image = [UIImage imageNamed:@"headView.png"];
        [view insertSubview:backView belowSubview:self.photoBtn];
        
        
#pragma mark - UTF8解码
        NSString *userName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.photoBtn.frame.origin.x +self.photoBtn.frame.size.width + 10, 30, 200, 30)];
        [label setTextAlignment:NSTextAlignmentLeft];
        if([DCFCustomExtra validateString:userName] == NO)
        {
            [label setText:@""];
        }
        else
        {
            [label setText:userName];
        }
        [label setFont:[UIFont systemFontOfSize:16]];
        [label setTextColor:[UIColor blackColor]];
        [view addSubview:label];
        
        return view;
    }
    UIButton *btn = [headBtnArray objectAtIndex:section-1];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, 1)];
    [topView setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
    [btn addSubview:topView];
    
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height, btn.frame.size.width, 1)];
    [buttomView setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
    if(section != 4)
    {
        [btn addSubview:buttomView];
    }
    return btn;
}

//询价单
- (IBAction)btn2Click:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    MyInquiryListFirstViewController *myInquiryListFirstViewController = [sb instantiateViewControllerWithIdentifier:@"myInquiryListFirstViewController"];
    myInquiryListFirstViewController.orderBtnClick = @"询价单";
    [self.navigationController pushViewController:myInquiryListFirstViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

//快速询价单
- (IBAction)btn3Click:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    MyInquiryListFirstViewController *myInquiryListFirstViewController = [sb instantiateViewControllerWithIdentifier:@"myInquiryListFirstViewController"];
    myInquiryListFirstViewController.orderBtnClick = @"快速询价单";
    [self.navigationController pushViewController:myInquiryListFirstViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void) pushToMyCableWithTag:(int) tag
{
    [self setHidesBottomBarWhenPushed:YES];
    MyCableOrderHostViewController *myCableOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableOrderHostViewController"];
    myCableOrder.btnIndex = tag;
    [self.navigationController pushViewController:myCableOrder animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

//我的电缆采购订单_待确认
- (IBAction)btn5Click:(id)sender
{
    [self pushToMyCableWithTag:1];
}

//我的电缆采购订单_待付款
- (IBAction)btn6Click:(id)sender
{
    [self pushToMyCableWithTag:2];
}

//我的电缆采购订单_待收货
- (IBAction)btn7Click:(id)sender
{
    [self pushToMyCableWithTag:3];
}

//我的家装馆订单_待付款
- (IBAction)btn8Click:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    for(UIView *subview in btn.subviews)
    {
        if([subview isKindOfClass:[UIButton class]])
        {
            [subview removeFromSuperview];
        }
    }
    [self pushToOrderListViewControllerWithBtn:(UIButton *)sender];
}

//我的家装馆订单_待收货
- (IBAction)btn9Click:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    for(UIView *subview in btn.subviews)
    {
        if([subview isKindOfClass:[UIButton class]])
        {
            [subview removeFromSuperview];
        }
    }
    [self pushToOrderListViewControllerWithBtn:(UIButton *)sender];
}

//我的家装馆订单_待评价
- (IBAction)btn10Click:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    for(UIView *subview in btn.subviews)
    {
        if([subview isKindOfClass:[UIButton class]])
        {
            [subview removeFromSuperview];
        }
    }
    [self pushToOrderListViewControllerWithBtn:(UIButton *)sender];
}

//我的家装馆订单_待发货
- (IBAction)btn11Click:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    for(UIView *subview in btn.subviews)
    {
        if([subview isKindOfClass:[UIButton class]])
        {
            [subview removeFromSuperview];
        }
    }
    [self pushToOrderListViewControllerWithBtn:(UIButton *)sender];
}


- (IBAction)customOrderBtnClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    MyCableOrderHostViewController *myCableOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableOrderHostViewController"];
    myCableOrder.btnIndex = 0;
    [self.navigationController pushViewController:myCableOrder animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}


- (void) pushToOrderListViewControllerWithBtn:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    NSString *text = btn.titleLabel.text;
    if([text isEqualToString:@"待付款"])
    {
        text = @"1";
    }
    if([text isEqualToString:@"待发货"])
    {
        text = @"2";
    }
    if([text isEqualToString:@"待收货"])
    {
        text = @"3";
    }
    if([text isEqualToString:@"待评价"])
    {
        text = @"4";
    }
    if([text isEqualToString:@"全部订单"])
    {
        text = @"";
    }
    [self setHidesBottomBarWhenPushed:YES];
    fourthHostViewController.myStatus = text;
    [self.navigationController pushViewController:fourthHostViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}


#pragma  mark  -  滚动加载
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    if (self.tableView == (UITableView *)scrollView)
    {
        if (scrollView.contentSize.height > 0 && (scrollView.contentSize.height-scrollView.frame.size.height)>0)
        {
            if (scrollView.contentOffset.y >= scrollView.contentSize.height-scrollView.frame.size.height)
            {

            }
        }
    }
}

#pragma mark SCROLLVIEW DELEGATE METHODS
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.refreshView egoRefreshScrollViewDidScroll:self.tableView];
}
//
#pragma mark -
#pragma mark DATA SOURCE LOADING / RELOADING METHODS
- (void)reloadViewDataSource
{
    _reloading = YES;
    
    [self loadGetCountNumRequest];
}
//
- (void)doneLoadingViewData
{
    
    _reloading = NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}
//
//#pragma mark -
//#pragma mark REFRESH HEADER DELEGATE METHODS
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    
    [self reloadViewDataSource];
}
//
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    
    return _reloading;
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    
    return [NSDate date];
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
