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

@interface SpeedAskPriceFirstViewController ()
{
//    BOOL hasClickPicBtn;
    BOOL cameraOrPhoto;   //判断是摄像头拍照还是从照片库选择,1为从相册中选择，0为拍照
//    int processPicCount;

    NSMutableArray *chooseImageArray;
    NSMutableArray *picBtnArray;

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
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"快速询价"];
    self.navigationItem.titleView = top;
    
//    hasClickPicBtn = NO;

    [self pushAndPopStyle];
    
    self.upBtn.layer.borderColor = [UIColor blueColor].CGColor;
    self.upBtn.layer.borderWidth = 1.0f;
    [self.upBtn setTitle:@"提交" forState:UIControlStateNormal];
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
    UIButton *btn = (UIButton *) sender;
    NSLog(@"TAG = %d",btn.tag);
    
    [self setHidesBottomBarWhenPushed:YES];
    LookForBigPicViewController *lookForBigPicViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"lookForBigPicViewController"];
    lookForBigPicViewController.delegate = self;
    lookForBigPicViewController.picArray = [[NSMutableArray alloc] initWithArray:chooseImageArray];
    [self.navigationController pushViewController:lookForBigPicViewController animated:YES];
}

- (void) deletePic:(int)tag
{
    NSLog(@"tag = %d",tag);
    if(chooseImageArray && chooseImageArray.count != 0)
    {
        [chooseImageArray removeObjectAtIndex:tag];
    }
    if(picBtnArray && picBtnArray.count != 0)
    {
        [picBtnArray removeObjectAtIndex:tag];
    }
    [self refreshView];
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
        
    }


    for(int i=0;i<picBtnArray.count;i++)
    {
        UIButton *btn = [picBtnArray objectAtIndex:i];

        //相机
        if(cameraOrPhoto == 0)
        {
            [btn setFrame:CGRectMake(20*(i+1)+(ScreenWidth-80)/3*i, self.upLabel.frame.origin.y + self.upLabel.frame.size.height, (ScreenWidth-80)/3, (ScreenWidth-80)/3-5)];
        }
        else
        {
            [btn setFrame:CGRectMake(20*(i+1)+(ScreenWidth-80)/3*i, self.upLabel.frame.origin.y + self.upLabel.frame.size.height+10, (ScreenWidth-80)/3, (ScreenWidth-80)/3)];
        }
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
        [iv setImage:(UIImage *)[chooseImageArray objectAtIndex:i]];
        [btn addSubview:iv];
//        iv.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:btn];
        
        [btn setTag:i];
        [btn addTarget:self action:@selector(picBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *lastbtn = [picBtnArray lastObject];

    if(chooseImageArray.count > 0 && chooseImageArray.count < 3)
    {
        if(cameraOrPhoto == 0)
        {
            [self.lastUpPicBtn setFrame:CGRectMake(lastbtn.frame.origin.x+lastbtn.frame.size.width+20,lastbtn.frame.origin.y+10,(ScreenWidth-80)/3,(ScreenWidth-80)/3)];

        }
        else
        {
            [self.lastUpPicBtn setFrame:CGRectMake(lastbtn.frame.origin.x+lastbtn.frame.size.width+20,self.upLabel.frame.origin.y + self.upLabel.frame.size.height + 10,(ScreenWidth-80)/3,(ScreenWidth-80)/3)];

        }
    }
    if(cameraOrPhoto == 0)
    {
        [self.upBtn setFrame:CGRectMake(20, lastbtn.frame.origin.y + lastbtn.frame.size.height + 25, ScreenWidth-40, 40)];

    }
    else
    {
        [self.upBtn setFrame:CGRectMake(20, lastbtn.frame.origin.y + lastbtn.frame.size.height + 10, ScreenWidth-40, 40)];

    }
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

#pragma mark - 加载图片按钮
- (void) loadImageBtn:(NSMutableArray *)ImageArray WithFlag:(BOOL)flag
{
//    if(!chooseImageArray || chooseImageArray.count == 0)
//    {
//        chooseImageArray = [[NSMutableArray alloc] initWithArray:ImageArray];
//    }
//    else
//    {
//        [chooseImageArray removeAllObjects];
//        for(int i=0;i<ImageArray.count;i++)
//        {
//            [chooseImageArray addObject:[ImageArray objectAtIndex:i]];
//        }
//    }
//    
//    if(!picBtnArray || picBtnArray.count == 0)
//    {
//        picBtnArray = [[NSMutableArray alloc] init];
//    }
//    else
//    {
//        [picBtnArray removeAllObjects];
//    }
//    for(int i=0;i<ImageArray.count;i++)
//    {
//        UIButton *picBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        picBtn.enabled = NO;
//        
//        [picBtn setTag:i];
//        
//        [picBtn setBackgroundImage:[ImageArray objectAtIndex:i] forState:UIControlStateNormal];
//        
//        
//        [picBtnArray addObject:picBtn];
//    }
//    if(picBtnArray.count == 0 || !picBtnArray)
//    {
//        [self.lastUpPicBtn setFrame:CGRectMake(20, 20, 55, 55)];
//    }
//    else if (picBtnArray.count != 0)
//    {
//        if(picBtnArray.count == 9)
//        {
//            
//        }
//        else if (picBtnArray.count == 4 || picBtnArray.count == 8)
//        {
//            if(picBtnArray.count == 4)
//            {
//                [self.lastUpPicBtn setFrame:CGRectMake(20, 95, 55, 55)];
//            }
//            if(picBtnArray.count == 8)
//            {
//                [self.lastUpPicBtn setFrame:CGRectMake(20, 170, 55, 55)];
//            }
//        }
//        else
//        {
//            [self.lastUpPicBtn setFrame:CGRectMake([[picBtnArray lastObject] frame].origin.x + [[picBtnArray lastObject] frame].size.width + 20, [[picBtnArray lastObject] frame].origin.y, 55, 55)];
//        }
//    }
//    [self.tableView reloadData];
}

-(void)procesPic:(UIImage*)img
{
    //request server
    
//    NSString *tempStr = @"";
//    for(NSString *s in chooseClassArray)
//    {
//        if ([tempStr isEqualToString:@""])
//        {
//            tempStr = [NSString stringWithFormat:@"%@",s];
//        }
//        else
//        {
//            tempStr = [NSString stringWithFormat:@"%@,%@",tempStr,s];
//        }
//        
//    }
//    
//    conn = [[DCFConnectionUtil alloc]initWithURLTag:URLShareDymaticPicTag delegate:self];
//    NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
//    
//    NSString *strRequest = [NSString stringWithFormat:@"userId=%@&dynamicId=%lld&classIds=%@&sessionKey=%@",userId,dynamicId,tempStr,[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionKey"]];
//    
//    
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_SHARE_PICTURE,strRequest];
//    
//    NSArray *imgArr = [NSArray arrayWithObject:img];
//    NSArray *nameArr = [NSArray arrayWithObject:@"dymaticPhoto.png"];
//    NSDictionary *imgDic = [NSDictionary dictionaryWithObjects:imgArr forKeys:nameArr];
    
    
//    [conn getResultFromUrlString:urlStr dicText:nil dicImage:imgDic imageFilename:nil];
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
                //图片压缩
                CGSize imagesize = img.size;
                imagesize.height =550;
                imagesize.width = 550;
                img = [DCFCustomExtra reSizeImage:img toSize:imagesize];
                NSData *imageData = UIImageJPEGRepresentation(img, 0.00001);
                
                UIImage *upLoadImage = nil;
                if(upLoadImage == nil)
                {
                    upLoadImage = [UIImage imageWithData:imageData];
                }
                if (upLoadImage)
                {
//                    hasClickPicBtn = YES;
//                    processPicCount = 0;
                    [chooseImageArray addObject:upLoadImage];
                }
                
            }
            
        }
        else
        {
            NSDictionary *mediaInfo = (NSDictionary *)info;
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
    
    NSLog(@"chooseImageArraychooseImageArraychooseImageArray = %@",chooseImageArray);

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
        [picBtn setFrame:CGRectZero];
//        picBtn.enabled = NO;
        
        [picBtnArray addObject:picBtn];
    }
    
    NSLog(@"chooseImageArray = %@",chooseImageArray);
    NSLog(@"picBtnArray = %@",picBtnArray);
    
//    [self.tableView reloadData];
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
    if(!HUD)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setLabelText:@"发布中....."];
        [HUD setDelegate:self];
    }
//    NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
//    
//    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
//                         userId,@"userId",
//                         tv.text,@"content",
//                         chooseClassArray,@"classIds",
//                         nil];
//    NSString *pushString = [NSString stringWithFormat:@"jsonDynamicContent=%@&sessionKey=%@",[self dictoJSON:dic],[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionKey"]];
//    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLShareDymaticContentTag delegate:self];
//    [conn getResultFromUrlString:URL_SHARE_DYMATIC postBody:pushString method:POST];
//
    [self setHidesBottomBarWhenPushed:YES];
    SpeedAskPriceSecondViewController *second = [self.storyboard instantiateViewControllerWithIdentifier:@"speedAskPriceSecondViewController"];
    [self.navigationController pushViewController:second animated:YES];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
//    if(URLTag == URLShareDymaticContentTag)
//    {
//        NSLog(@"%@",dicRespon);
//        
//        if([result isEqualToString:@"1"])
//        {
//            NSDictionary *dataDic = [dicRespon objectForKey:@"data"];
//            dynamicId = [[dataDic objectForKey:@"dynamicId"] longLongValue];
//            
//            if(hasClickPicBtn == YES)
//            {
//                for(int i = 0;i<chooseImageArray.count;i++)
//                {
//                    [self procesPic:[chooseImageArray objectAtIndex:i]];
//                }
//            }
//            else
//            {
//                //请求个人信息
//                //                    [self requestPersonMsg];
//            }
//            
//        }
//        else
//        {
//            //                [DCFStringUtil showNotice:@"请求失败，请重试"];
//            //                return;
//        }
//    }
//    if(URLTag == URLShareDymaticPicTag)
//    {
//        NSLog(@"%@",dicRespon);
//        
//        if([result isEqualToString:@"1"])
//        {
//            processPicCount++;
//            if(processPicCount >= chooseImageArray.count )
//            {
//                //请求个人信息
////                [self requestPersonMsg];
//           
//                [DCFStringUtil showNotice:@"上传成功"];
//            }
//            
//            [self.lastUpPicBtn setEnabled:NO];
//            
//            
//        }
//        else
//        {
//            [self.lastUpPicBtn setEnabled:YES];
//            
//            [DCFStringUtil showNotice:@"上传失败"];
//            
//            [self.upBtn setEnabled:YES];
//        }
//    }

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
