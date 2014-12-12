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
#import "UIImageView+WebCache.h"

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
    int tag = sender.tag;
//    if (tag == 0)
//    {
//        [self setHidesBottomBarWhenPushed:YES];
//        MyInquiryListFirstViewController *myInquiryListFirstViewController = [sb instantiateViewControllerWithIdentifier:@"myInquiryListFirstViewController"];
//        [self.navigationController pushViewController:myInquiryListFirstViewController animated:YES];
//        [self setHidesBottomBarWhenPushed:NO];
//    }
    if(tag == 1)
    {
        [self setHidesBottomBarWhenPushed:YES];
        MyCableOrderHostViewController *myCableOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"myCableOrderHostViewController"];
        myCableOrder.btnIndex = tag;
        [self.navigationController pushViewController:myCableOrder animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }
    if(tag == 2)
    {
        [self pushToOrderListViewControllerWithBtn:sender];
    }
    if(tag == 3)
    {
        [self setHidesBottomBarWhenPushed:YES];
        AccountManagerTableViewController *accountManagerTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"accountManagerTableViewController"];
        [self.navigationController pushViewController:accountManagerTableViewController animated:YES];
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

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    if(memberid.length == 0 || [memberid isKindOfClass:[NSNull class]])
    {
    }
    NSLog(@"memberid = %@",memberid);
    return memberid;
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//请求询价车商品数量
-(void)loadbadgeCount
{
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"InquiryCartCount",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
    
    NSString *visitorid = [self.appDelegate getUdid];
    
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
    
    NSString *visitorid = [self.appDelegate getUdid];
    
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
//    NSLog(@"dicRespon = %@",dicRespon);
    if(URLTag == URLGetCountNumTag)
    {
        if(result == 1)
        {
            badgeArray = [[NSMutableArray alloc] initWithArray:[dicRespon objectForKey:@"items"]];
            for(int i =0;i<badgeArray.count;i++)
            {
                UIButton *cellBtn = (UIButton *)[cellBtnArray objectAtIndex:i];
//
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
//                        NSLog(@"2= %d",cellBtn.titleLabel.text.length);
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
//                        NSLog(@"3= %d",cellBtn.titleLabel.text.length);
                        [btn setFrame:CGRectMake(cellBtn.frame.size.width-25, 17, 22, 19)];
                    }
                    [btn setBackgroundImage:[UIImage imageNamed:@"msg_bqy.png"] forState:UIControlStateNormal];
                    [btn setTitle:@"99+" forState:UIControlStateNormal];
                }
                [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                
                if(s.intValue == 0)
                {
                    
                }
                else
                {
                    [cellBtn addSubview:btn];
                }
            }
        }
        else
        {
            
        }
        [self.tableView reloadData];
    }
    if (URLTag == URLInquiryCartCountTag)
    {
        tempCount = [[dicRespon objectForKey:@"value"] intValue];
    }
    if (URLTag == URLShopCarCountTag)
    {
        tempShopCar = [[dicRespon objectForKey:@"total"] intValue];
    }
    if (tempCount > 0 || tempShopCar > 0)
    {
        
    }
    if (tempCount == 0 && tempShopCar == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidenRedPoint" object:nil];
    }
    if(URLTag == URLUpImagePicTag)
    {
        NSLog(@"%@",dicRespon);
        if(result == 1)
        {
            NSString *headUrl = [dicRespon objectForKey:@"headPortraitUrl"];
            NSString *headPortraitUrl = [NSString stringWithFormat:@"%@%@%@",URL_HOST_CHEN,@"/",headUrl];
            NSLog(@"headPortraitUrl = %@",headPortraitUrl);
            [[NSUserDefaults standardUserDefaults] setObject:headPortraitUrl forKey:@"headPortraitUrl"];
            
            [self.tableView reloadData];
//            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
//            NSArray *reload = [NSArray arrayWithObject:path];
//            [self.tableView reloadRowsAtIndexPaths:reload withRowAnimation:0];
            
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    NSString *memberid = [self getMemberId];
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"getCountNum",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"memberid=%@&token=%@",memberid,token];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetCountNumTag delegate:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getCountNum.html?"];
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    
    [self loadbadgeCount];
    
    [self loadShopCarCount];
    
    self.tableView.scrollEnabled = YES;
    isPopShow = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popShopCar_mmb:) name:@"popShopCar" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (changeClick:) name:@"dissMiss" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self pushAndPopStyle];
//    isPopShow = NO;
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"我的买卖宝"];
    self.navigationItem.titleView = top;
    
    self.view1.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.view2.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.view3.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.view4.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.view5.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.view6.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    
    self.view11.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.view22.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.view33.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    
    headBtnArray = [[NSMutableArray alloc] init];
    for(int i=0;i<4;i++)
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
        if(i <= 2)
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
        [label_2 setText:@"查看全部订单"];
        
        if(i == 0)
        {
            [label_1 setText:@"我的买卖宝询价单"];
//            [btn addSubview:label_2];
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 35, 35)];
            [iv setImage:[UIImage imageNamed:@"mmbOrder.png"]];
            [btn addSubview:iv];
        }
        if(i == 1)
        {
            [label_1 setText:@"我的电缆采购订单"];
            [btn addSubview:label_2];
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 35, 35)];
            [iv setImage:[UIImage imageNamed:@"dlOrder.png"]];
            [btn addSubview:iv];
        }
        if(i == 2)
        {
            [label_1 setText:@"我的家装馆订单"];
            [btn addSubview:label_2];
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 35, 35)];
            [iv setImage:[UIImage imageNamed:@"homeOrder.png"]];
            [btn addSubview:iv];
        }
        if(i == 3)
        {
            [label_1 setText:@"账户安全"];
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 35, 35)];
            [iv setImage:[UIImage imageNamed:@"count.png"]];
            [btn addSubview:iv];
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height-1, self.view.frame.size.width, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
            [btn addSubview:lineView];
        }
        //        if(i == 4)
        //        {
        //            [label_1 setText:@"收货地址"];
        //
        //            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 35, 35)];
        //            [iv setImage:[UIImage imageNamed:@"getAddress.png"]];
        //            [btn addSubview:iv];
        //        }
        [btn addSubview:label_1];
        if (i != 0)
        {
            UIImageView *arrowIv = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-40, 5, 35, 35)];
            [arrowIv setImage:[UIImage imageNamed:@"set_clear.png"]];
            [btn addSubview:arrowIv];
        }
        [headBtnArray addObject:btn];
    }
    
//    cellBtnArray = [[NSMutableArray alloc] initWithObjects:_btn_8,_btn_9,_btn_10,_btn_11,_btn_2,_btn_3,_btn_5,_btn_6,_btn_7, nil];
    
     cellBtnArray = [[NSMutableArray alloc] initWithObjects:_btn_8,_btn_11,_btn_9,_btn_10,_btn_2,_btn_3,_btn_5,_btn_6,_btn_7, nil];
    
    for(int i=0;i<cellBtnArray.count;i++)
    {
        UIButton *btn = (UIButton *)[cellBtnArray objectAtIndex:i];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    }
   
    //陈晓修改头像上传
    self.photoBtn = [[UIImageView alloc] init];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoBtnAction:)];
    [self.photoBtn setUserInteractionEnabled:YES];
    [self.photoBtn addGestureRecognizer:tapGesture];
    
}

- (void)photoBtnAction:(id)sender
{
    changePhotoSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"更改头像", nil];
    if (self.navigationController) {
        [changePhotoSheet showInView:self.navigationController.navigationBar];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isEqual:changePhotoSheet]) {
        
        switch (buttonIndex)
        {
                NSLog(@"changePhotoSheet--->>%d",buttonIndex);
            case 0://更改头像
                [self uploadPhoto];
                break;

            default:
                break;
        }
    }else if ([actionSheet isEqual:albumSheet]){
        NSLog(@"albumSheet--->>%d",buttonIndex);

        
        switch (buttonIndex) {
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
    albumSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"手机相册",@"拍照", nil];
    if (self.navigationController) {
        [albumSheet showInView:self.navigationController.navigationBar];
    }
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
    //        imgArr = [NSArray arrayWithObject:img];
    
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
    
    NSString *strRequest = [NSString stringWithFormat:@"memberid=%@&token=%@",[self getMemberId],token];
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
    if (img) {
        
        [self performSelector:@selector(procesPic:) withObject:img afterDelay:0.1];
        
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil;
    
    if(error != NULL){
        msg = @"保存图片失败";
        [DCFStringUtil showNotice:msg];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
        //
        //                                                        message:msg
        //
        //                                                       delegate:self
        //
        //                                              cancelButtonTitle:@"确定"
        //
        //                                              otherButtonTitles:nil];
        //
        //        [alert show];
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
        height = 96;
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
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 96)];
        
        [self.photoBtn setFrame:CGRectMake(20, 18, 60, 60)];
        [self.photoBtn.layer setCornerRadius:CGRectGetHeight([self.photoBtn bounds]) / 2];  //修改半径，实现头像的圆形化
        self.photoBtn.layer.masksToBounds = YES;
        NSString *headPortraitUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"headPortraitUrl"];
        [self.photoBtn setImageWithURL:[NSURL URLWithString:headPortraitUrl] placeholderImage:[UIImage imageNamed:@"headPic.png"]];
        [view addSubview:self.photoBtn];
        
        UIImageView *backView = [[UIImageView alloc] init];
        backView.frame = CGRectMake(0, 0, ScreenWidth, 96);
        backView.image = [UIImage imageNamed:@"headView.png"];
        [view insertSubview:backView belowSubview:self.photoBtn];
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.photoBtn.frame.origin.x +self.photoBtn.frame.size.width + 10, 33, 200, 30)];
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


- (IBAction)btn2Click:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    MyInquiryListFirstViewController *myInquiryListFirstViewController = [sb instantiateViewControllerWithIdentifier:@"myInquiryListFirstViewController"];
    [self.navigationController pushViewController:myInquiryListFirstViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}


- (IBAction)btn3Click:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    MyInquiryListFirstViewController *myInquiryListFirstViewController = [sb instantiateViewControllerWithIdentifier:@"myInquiryListFirstViewController"];
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

- (IBAction)btn5Click:(id)sender
{
    [self pushToMyCableWithTag:1];
}

- (IBAction)btn6Click:(id)sender
{
    [self pushToMyCableWithTag:2];
}

- (IBAction)btn7Click:(id)sender
{
    [self pushToMyCableWithTag:3];
}

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
    [self setHidesBottomBarWhenPushed:YES];
    FourthHostViewController *fourthHostViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fourthHostViewController"];
    fourthHostViewController.myStatus = text;
    [self.navigationController pushViewController:fourthHostViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
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
