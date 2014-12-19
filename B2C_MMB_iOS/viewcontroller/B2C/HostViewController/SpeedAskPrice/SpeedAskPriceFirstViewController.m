//
//  SpeedAskPriceFirstViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-21.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "SpeedAskPriceFirstViewController.h"
#import "DCFCustomExtra.h"
#import "DCFColorUtil.h"
#import "DCFTopLabel.h"
#import "DCFStringUtil.h"
#import "SpeedAskPriceSecondViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "MCDefine.h"
#import "LoginNaviViewController.h"
#import "UIImage (fixOrientation).h"

@interface SpeedAskPriceFirstViewController ()
{
    //    BOOL hasClickPicBtn;
    BOOL cameraOrPhoto;   //判断是摄像头拍照还是从照片库选择,1为从相册中选择，0为拍照
    //    int processPicCount;
    
    NSMutableArray *chooseImageArray;
    NSMutableArray *picBtnArray;
    
    BOOL deleteOrNot;
}
@end

@implementation SpeedAskPriceFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view tag] == 101 )
        {
            [view setHidden:YES];
        }
    }
    
    
    
    NSString *userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPhone"];
    NSString *tel = [[NSUserDefaults standardUserDefaults] objectForKey:@"SppedAskPriceTelNum"];
    
    if([DCFCustomExtra validateString:userPhone] == YES)
    {
        [self.tel_Tf setText:userPhone];
    }
    else
    {
        if([DCFCustomExtra validateString:tel] == NO)
        {
            [self.tel_Tf setPlaceholder:@"手机号码/固定号码"];
        }
        else
        {
            [self.tel_Tf setText:tel];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    deleteOrNot = NO;
    
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"快速询价"];
    self.navigationItem.titleView = top;
    
    //    hasClickPicBtn = NO;
    
    [self pushAndPopStyle];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tel_Tf.placeholder = @"手机号码/固定号码";
    self.tel_Tf.layer.borderWidth = 0.5;
    self.tel_Tf.layer.borderColor = [[UIColor clearColor] CGColor];
    self.tel_Tf.tintColor = [UIColor redColor];
    
    UIView *tel_lineView = [[UIView alloc] init];
    tel_lineView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    tel_lineView.frame = CGRectMake(0, self.tel_Tf.frame.origin.y+self.tel_Tf.frame.size.height-1, ScreenWidth, 1);
    [self.mySv addSubview:tel_lineView];
    
    
    UIView *content_lineViewUp = [[UIView alloc] init];
    content_lineViewUp.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    content_lineViewUp.frame = CGRectMake(0, self.content_Tv.frame.origin.y, ScreenWidth, 1);
    //    [self.view addSubview:content_lineViewUp];
    
    UIView *content_lineView = [[UIView alloc] init];
    content_lineView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    content_lineView.frame = CGRectMake(0, self.content_Tv.frame.origin.y+self.content_Tv.frame.size.height-1, ScreenWidth, 1);
    [self.mySv addSubview:content_lineView];
    
    self.content_Tv.tintColor = [UIColor redColor];
    
    self.upBtn.layer.cornerRadius = 6;
    self.upBtn.layer.backgroundColor = [[UIColor colorWithRed:237.0/255.0 green:142.0/255.0 blue:0/255.0 alpha:1.0] CGColor];
    [self.upBtn setTitle:@"提交" forState:UIControlStateNormal];
    //    self.upBtn.frame = CGRectMake(20, self.view.frame.size.height-55, self.view.frame.size.width-16, 40);
    [self.upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.lastUpPicBtn setTag:100];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    [self.mySv setContentSize:CGSizeMake(ScreenWidth, self.upBtn.frame.origin.y+self.upBtn.frame.size.height+20)];
    [self.mySv setShowsHorizontalScrollIndicator:NO];
    [self.mySv setShowsVerticalScrollIndicator:NO];
}

- (void) tap:(UITapGestureRecognizer *) sender
{
    if([self.tel_Tf isFirstResponder])
    {
        [self.tel_Tf resignFirstResponder];
    }
    if([self.content_Tv isFirstResponder])
    {
        [self.content_Tv resignFirstResponder];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(HUD)
    {
        [HUD hide:YES];
    }
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
}

- (void) picBtnClick:(UIButton *) sender
{
    deleteOrNot = NO;
    
    [self setHidesBottomBarWhenPushed:YES];
    LookForBigPicViewController *lookForBigPicViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"lookForBigPicViewController"];
    lookForBigPicViewController.delegate = self;
    lookForBigPicViewController.myPicBtnArray = [[NSMutableArray alloc] initWithArray:picBtnArray];
    lookForBigPicViewController.myImageArray = [[NSMutableArray alloc] initWithArray:chooseImageArray];
    [self.navigationController pushViewController:lookForBigPicViewController animated:YES];
    
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if(ScreenHeight <= 500)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        [self.view setFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight)];
        [UIView commitAnimations];
    }
    else
    {
        
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    if(ScreenHeight <= 500)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        [self.view setFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
        [UIView commitAnimations];
    }
    else
    {
        
    }
}

- (void) textViewDidChange:(UITextView *)textView
{
    [self.countLabel setText:[NSString stringWithFormat:@"%d",self.content_Tv.text.length]];
    if(self.content_Tv.text.length > 1000)
    {
        [self.countLabel setTextColor:[UIColor redColor]];
    }
    if(self.content_Tv.text.length == 0)
    {
        [self.showlabel setHidden:NO];
    }
    else
    {
        [self.showlabel setHidden:YES];
    }
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [self.content_Tv resignFirstResponder];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3f];
        [self.view setFrame:CGRectMake(0, 64, ScreenWidth, self.view.frame.size.height)];
        [UIView commitAnimations];
    }
    return YES;
}

- (void) deleteWithPicBtn:(NSMutableArray *)btnArray WithImageArray:(NSMutableArray *)imageArray
{
    deleteOrNot = YES;
    
    if(chooseImageArray && chooseImageArray.count != 0)
    {
        [chooseImageArray removeAllObjects];
        for(int i=0;i<imageArray.count;i++)
        {
            [chooseImageArray addObject:[imageArray objectAtIndex:i]];
        }
    }
    if(picBtnArray && picBtnArray.count != 0)
    {
        for(UIButton *btn in picBtnArray)
        {
            for(UIView *view in btn.subviews)
            {
                [view removeFromSuperview];
            }
            [btn removeFromSuperview];
        }
        [picBtnArray removeAllObjects];
        for(int i=0;i<btnArray.count;i++)
        {
            [picBtnArray addObject:[btnArray objectAtIndex:i]];
            UIButton *picBtn = [picBtnArray objectAtIndex:i];
            [picBtn setBackgroundColor:[UIColor redColor]];
            
        }
    }
    
    
    
    [self refreshView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}


- (void) refreshView
{
    
    
    if(chooseImageArray.count >= 3)
    {
        [self.lastUpPicBtn setHidden:YES];
    }
    else if(chooseImageArray.count == 0)
    {
        [self.lastUpPicBtn setHidden:NO];
        [self.lastUpPicBtn setFrame:CGRectMake(20, self.upLabel.frame.origin.y + self.upLabel.frame.size.height + 10, (ScreenWidth-80)/3, (ScreenWidth-80)/3)];
        deleteOrNot = NO;
    }
    
    
    
    for(int i=0;i<picBtnArray.count;i++)
    {
        UIButton *btn = [picBtnArray objectAtIndex:i];
        
        //相机
        if(cameraOrPhoto == 0)
        {
            if(deleteOrNot == NO)
            {
                [btn setFrame:CGRectMake(20*(i+1)+(ScreenWidth-80)/3*i, self.upLabel.frame.origin.y + self.upLabel.frame.size.height, (ScreenWidth-80)/3, (ScreenWidth-80)/3-5)];
                if(i == picBtnArray.count-1)
                {
                    [self.lastUpPicBtn setFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width+20,btn.frame.origin.y+10,(ScreenWidth-80)/3,(ScreenWidth-80)/3)];
                }
            }
            else
            {
                [btn setFrame:CGRectMake(20*(i+1)+(ScreenWidth-80)/3*i, self.upLabel.frame.origin.y + self.upLabel.frame.size.height+10, (ScreenWidth-80)/3, (ScreenWidth-80)/3-5)];
                if(i == picBtnArray.count-1)
                {
                    [self.lastUpPicBtn setFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width+20,btn.frame.origin.y,(ScreenWidth-80)/3,(ScreenWidth-80)/3)];
                }
            }
        }
        else
        {
            [btn setFrame:CGRectMake(20*(i+1)+(ScreenWidth-80)/3*i, self.upLabel.frame.origin.y + self.upLabel.frame.size.height+10, (ScreenWidth-80)/3, (ScreenWidth-80)/3)];
            if(i == picBtnArray.count-1)
            {
                [self.lastUpPicBtn setFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width+20,btn.frame.origin.y,(ScreenWidth-80)/3,(ScreenWidth-80)/3)];
            }
        }
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
        [iv setImage:(UIImage *)[chooseImageArray objectAtIndex:i]];
        [btn addSubview:iv];
        [self.mySv addSubview:btn];
        
        [btn addTarget:self action:@selector(picBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    
    UIButton *lastbtn = [picBtnArray lastObject];
    
    
    if(chooseImageArray.count > 0 && chooseImageArray.count < 3)
    {
        
        [self.lastUpPicBtn setHidden:NO];
        
    }
    
    
#pragma mark - 这里修改提交按钮frame
    //    if(cameraOrPhoto == 0)
    //    {
    [self.upBtn setFrame:CGRectMake(10, self.lastUpPicBtn.frame.origin.y + self.lastUpPicBtn.frame.size.height + 25, ScreenWidth-20, 40)];
    
    [self.mySv setContentSize:CGSizeMake(ScreenWidth, self.upBtn.frame.origin.y+self.upBtn.frame.size.height+20)];
    
    //    }
    //    else
    //    {
    //        [self.upBtn setFrame:CGRectMake(20, lastbtn.frame.origin.y + lastbtn.frame.size.height + 10, ScreenWidth-40, 40)];
    //
    //    }
}

- (IBAction)lastUpPicBtnClick:(id)sender
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像"
                                             delegate:self
                                    cancelButtonTitle:nil
                               destructiveButtonTitle:@"取消"
                                    otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像"
                                            delegate:self
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:@"取消"
                                   otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //                    hasClickPicBtn = NO;
                    return;
                case 1: //相机
                {
                    // 跳转到相机或相册页面
                    
                    cameraOrPhoto = 0;
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                    imagePickerController.delegate = self;
                    imagePickerController.allowsEditing = YES;
                    imagePickerController.sourceType = sourceType;
                    //                    hasClickPicBtn = NO;
                    [self presentViewController:imagePickerController animated:YES completion:^{}];
                }
                    break;
                case 2: //相册
                    //                    processPicCount = 0;
                    cameraOrPhoto = 1;
                    //                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    //                    elcImagePickerDemoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"elcImagePickerDemoViewController"];
                    //                    elcImagePickerDemoViewController.delegate = self;
                    //                    hasClickPicBtn = YES;
                    //                    [self.navigationController pushViewController:elcImagePickerDemoViewController animated:YES];
                    
                    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
                    imagePickerController.delegate = self;
                    imagePickerController.allowsMultipleSelection = YES;
                    //                    hasClickPicBtn = YES;
                    
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
                    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
                    {
                        [navigationController.navigationBar setBackgroundImage:[DCFCustomExtra imageWithColor:[DCFColorUtil colorFromHexRGB:@"63a309"] size:CGSizeMake(1, 1)] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
                    }
                    else
                    {
                        [navigationController.navigationBar setBackgroundImage:[DCFCustomExtra imageWithColor:[DCFColorUtil colorFromHexRGB:@"63a309"] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
                    }
                    [self presentViewController:navigationController animated:YES completion:NULL];
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
    }
}

- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if(memberid.length == 0)
    {
        //        LoginNaviViewController *loginNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        //        [self presentViewController:loginNavi animated:YES completion:nil];
        memberid = @"";
        
    }
    return memberid;
}

- (NSString *) getUserName
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    if(userName.length == 0)
    {
        userName = @"";
        //        LoginNaviViewController *loginNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        //        [self presentViewController:loginNavi animated:YES completion:nil];
    }
    return userName;
    
}

#pragma mark - 加载图片按钮
- (void) loadImageBtn:(NSMutableArray *)ImageArray WithFlag:(BOOL)flag
{
}

-(void)procesPic:(NSMutableArray*)imgarray
{
    if(imgarray.count == 0 || [imgarray isKindOfClass:[NSNull class]])
    {
        
    }
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    NSMutableArray *nameArr = [[NSMutableArray alloc] init];
    NSMutableArray *strImageFileNameArray = [[NSMutableArray alloc] init];
    NSString *strImageFileName = nil;
    
    for(int i=0;i<chooseImageArray.count;i++)
    {
        UIImage *img = [chooseImageArray objectAtIndex:i];
        
        //图片压缩
        CGSize imagesize = img.size;
        imagesize.height = ScreenHeight;
        imagesize.width = ScreenWidth;
        img = [DCFCustomExtra reSizeImage:img toSize:imagesize];
        NSData *data = UIImageJPEGRepresentation(img, 0.125);
        
        UIImage *image = [UIImage imageWithData:data];
        image = [image fixOrientation];
        
        [imgArr addObject:image];
        //        imgArr = [NSArray arrayWithObject:img];
        
        NSString *nameString = [NSString stringWithFormat:@"%@",img.description];
        
        NSRange range = NSMakeRange(1, nameString.length-2);
        nameString = [nameString substringWithRange:range];
        
        NSRange range_1 = NSMakeRange(9, nameString.length-9);
        nameString = [nameString substringWithRange:range_1];
        
        NSString *picName = [NSString stringWithFormat:@"%@.png",nameString];
        
        [nameArr addObject:picName];
        
        strImageFileName = [NSString stringWithFormat:@"pic%d",i+1];
        [strImageFileNameArray addObject:strImageFileName];
    }
    
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"SubOem",time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *loginid = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginid"];
    
    if([DCFCustomExtra validateString:loginid] == NO)
    {
        loginid = @"";
    }
    
    conn = [[DCFConnectionUtil alloc]initWithURLTag:URLUpImagePicTag delegate:self];
    
    NSString *strRequest = [NSString stringWithFormat:@"memberId=%@&token=%@&membername=%@&phone=%@&linkman=%@&content=%@&source=%@&loginid=%@",[self getMemberId],token,[self getUserName],self.tel_Tf.text,[self getUserName],[self.content_Tv.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"3",loginid];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",URL_HOST_CHEN,@"/B2BAppRequest/SubOem.html?",strRequest];
    NSDictionary *imgDic = [NSDictionary dictionaryWithObjects:imgArr forKeys:nameArr];
    
    [conn getResultFromUrlString:urlString dicText:nil dicImage:imgDic imageFilename:strImageFileNameArray];
}


#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if(!chooseImageArray || chooseImageArray.count == 0)
    {
        chooseImageArray = [[NSMutableArray alloc] init];
    }
    else if(chooseImageArray || chooseImageArray.count != 0)
    {
        //          [chooseImageArray removeAllObjects];
    }
    
    //相册
    if(cameraOrPhoto == 1)
    {
        if(imagePickerController.allowsMultipleSelection)
        {
            NSArray *mediaInfoArray = (NSArray *)info;
            
            if(mediaInfoArray.count + chooseImageArray.count > 3)
            {
                [DCFStringUtil showNotice:@"最多上传3张"];
                //                return;
            }
            
            for(int i = 0;i<mediaInfoArray.count;i++)
            {
                NSDictionary *dic = (NSDictionary *)[mediaInfoArray objectAtIndex:i];
                UIImage *img=[dic objectForKey:UIImagePickerControllerOriginalImage];
                [chooseImageArray addObject:img];
            }
        }
    }
    //相机
    else
    {
        UIImage *img=[info objectForKey:UIImagePickerControllerOriginalImage];
        if(chooseImageArray.count > 3)
        {
            [DCFStringUtil showNotice:@"最多上传3张"];
            //            return;
        }
        if (img)
        {
            //            hasClickPicBtn = YES;
            //            processPicCount = 0;
            [chooseImageArray addObject:img];
        }
    }
    if(!picBtnArray || picBtnArray.count == 0)
    {
        picBtnArray = [[NSMutableArray alloc] init];
    }
    else
    {
        for(UIButton *btn in picBtnArray)
        {
            [btn removeFromSuperview];
        }
        [picBtnArray removeAllObjects];
    }
    
    
    if(chooseImageArray.count > 3)
    {
        //        [chooseImageArray removeAllObjects];
        for(int i=chooseImageArray.count-1;i>=0;i--)
        {
            if(i <= 2)
            {
                
            }
            else
            {
                [chooseImageArray removeObjectAtIndex:i];
            }
        }
        
    }
    
    for(int i=0;i<chooseImageArray.count;i++)
    {
        UIButton *picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [picBtn setFrame:CGRectMake(20, self.upLabel.frame.origin.y+self.upLabel.frame.size.height+10, 80, 80)];
        //        [picBtn setFrame:CGRectZero];
        //        picBtn.enabled = NO;
        [picBtnArray addObject:picBtn];
    }
    
    
    [self refreshView];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Cancelled");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController
{
    //    return @"すべての写真を選択";
    return nil;
    
}

- (NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController
{
    //    return @"すべての写真の選択を解除";
    return nil;
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    //    return [NSString stringWithFormat:@"写真%d枚", numberOfPhotos];]r
    return nil;
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    //    return [NSString stringWithFormat:@"ビデオ%d本", numberOfVideos];
    return nil;
    
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    //    return [NSString stringWithFormat:@"写真%d枚、ビデオ%d本", numberOfPhotos, numberOfVideos];
    return nil;
    
}

- (IBAction)upBtnClick:(id)sender
{
    if(self.tel_Tf.text.length == 0)
    {
        [DCFStringUtil showNotice:@"请输入手机号码"];
        return;
    }
    
    BOOL validatePhone = [DCFCustomExtra validateMobile:self.tel_Tf.text];
    BOOL validateTel = [DCFCustomExtra validateTel:self.tel_Tf.text];
    if(validateTel == YES || validatePhone == YES)
    {
        
    }
    
    if(validatePhone == NO && validateTel == NO)
    {
        if(validateTel == NO)
        {
            [DCFStringUtil showNotice:@"请输入正确的电话号码"];
            return;
        }
        if(validatePhone == NO)
        {
            [DCFStringUtil showNotice:@"请输入正确的手机号码"];
            return;
        }
    }
    
    if(self.content_Tv.text.length > 1000)
    {
        [DCFStringUtil showNotice:@"您输入的文字超过了1000字"];
        return;
    }
    
    if(!HUD)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setLabelText:@"等待中....."];
        [HUD setDelegate:self];
    }
    [self procesPic:chooseImageArray];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLUpImagePicTag)
    {
        if(HUD)
        {
            [HUD hide:YES];
        }
        int result = [[dicRespon objectForKey:@"result"] intValue];
        if(result == 1)
        {
            [[NSUserDefaults standardUserDefaults] setObject:self.tel_Tf.text forKey:@"SppedAskPriceTelNum"];
            
            //            [DCFStringUtil showNotice:@"上传成功"];
            [self setHidesBottomBarWhenPushed:YES];
            SpeedAskPriceSecondViewController *second = [self.storyboard instantiateViewControllerWithIdentifier:@"speedAskPriceSecondViewController"];
            [self.navigationController pushViewController:second animated:YES];
        }
        else
        {
            [DCFStringUtil showNotice:@"请求失败"];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
