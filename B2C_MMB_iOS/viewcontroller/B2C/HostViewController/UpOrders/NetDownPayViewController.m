//
//  NetDownPayViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 15-4-3.
//  Copyright (c) 2015年 YUANDONG. All rights reserved.
//

#import "NetDownPayViewController.h"
#import "MCDefine.h"
#import "DCFTopLabel.h"
#import "DCFStringUtil.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "UIImage (fixOrientation).h"
#import "DCFCustomExtra.h"
#import "DCFColorUtil.h"

@interface NetDownPayViewController ()
{
    UIButton *lastUpPicBtn;
    
    UIButton *upBtn;
    
    UIButton *onlinePayBtn;
    
    BOOL cameraOrPhoto;   //判断是摄像头拍照还是从照片库选择,1为从相册中选择，0为拍照
    //    int processPicCount;
    
    NSMutableArray *chooseImageArray;
    NSMutableArray *picBtnArray;
    
    BOOL deleteOrNot;
}
@end

@implementation NetDownPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.uplabel setFrame:CGRectMake(self.uplabel.frame.origin.x, self.uplabel.frame.origin.y, self.uplabel.frame.size.width,30*ScreenScaleY)];
    
    lastUpPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastUpPicBtn setBackgroundColor:[UIColor redColor]];
//    [lastUpPicBtn setBackgroundImage:[UIImage imageNamed:@"icon_addpic_unfocused.png"] forState:UIControlStateNormal];
    [lastUpPicBtn setFrame:CGRectMake(20, self.uplabel.frame.origin.y+10, (MainScreenWidth-80)/3, (MainScreenWidth-80)/3)];
    [lastUpPicBtn addTarget:self action:@selector(lastUpPicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastUpPicBtn];

    upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [upBtn setTitle:@"提交" forState:UIControlStateNormal];
    [upBtn setBackgroundColor:[UIColor redColor]];
    [upBtn setFrame:CGRectMake(20, lastUpPicBtn.frame.origin.y + lastUpPicBtn.frame.size.height + 10, 100*ScreenScaleX, 30*ScreenScaleY)];
    [upBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upBtn];

    onlinePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [onlinePayBtn setTitle:@"在线支付:" forState:UIControlStateNormal];
    [onlinePayBtn setBackgroundColor:[UIColor redColor]];
    [onlinePayBtn setFrame:CGRectMake(20, upBtn.frame.origin.y + upBtn.frame.size.height + 10, 100*ScreenScaleX, 30*ScreenScaleY)];
    [onlinePayBtn addTarget:self action:@selector(onlinePayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upBtn];
}

- (void) lastUpPicBtnClick:(UIButton *) sender
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
    else
    {
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
    if (actionSheet.tag == 255)
    {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            switch (buttonIndex)
            {
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
                        [navigationController.navigationBar setBackgroundImage:[DCFCustomExtra imageWithColor:[DCFColorUtil colorFromHexRGB:@"#1465ba"] size:CGSizeMake(1, 1)] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
                    }
                    else
                    {
                        [navigationController.navigationBar setBackgroundImage:[DCFCustomExtra imageWithColor:[DCFColorUtil colorFromHexRGB:@"#1465ba"] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
                    }
                    [self presentViewController:navigationController animated:YES completion:NULL];
                    break;
            }
        }
        else
        {
            if (buttonIndex == 0)
            {
                return;
            }
            else
            {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
    }
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
        
#pragma mark - 图片压缩
        CGSize imagesize = img.size;
        CGFloat scale = 0.0;
        CGFloat Height = 0.0;
        CGFloat Width = 0.0;
        CGSize size;
        if(imagesize.height >= imagesize.width)
        {
            scale = imagesize.height/ScreenHeight;
            Height = ScreenHeight;
            Width = imagesize.width/scale;
        }
        else
        {
            scale = imagesize.width/MainScreenWidth;
            Height = imagesize.height/scale;
            Width = MainScreenWidth;
        }
        size = CGSizeMake(Width, Height);
        //        imagesize.height = ScreenHeight;
        //        imagesize.width = ScreenWidth;
        img = [DCFCustomExtra reSizeImage:img toSize:size];
        NSData *data = UIImageJPEGRepresentation(img, 0.5);
        
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
        //[chooseImageArray removeAllObjects];
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
        [picBtn setFrame:CGRectMake(20, self.uplabel.frame.origin.y+self.uplabel.frame.size.height+10, 80, 80)];
        [picBtnArray addObject:picBtn];
    }
    
    
    [self refreshView];
}

- (void) refreshView
{
    
    
    if(chooseImageArray.count >= 3)
    {
        [lastUpPicBtn setHidden:YES];
    }
    else if(chooseImageArray.count == 0)
    {
        [lastUpPicBtn setHidden:NO];
        [lastUpPicBtn setFrame:CGRectMake(20, lastUpPicBtn.frame.origin.y , lastUpPicBtn.frame.size.width,lastUpPicBtn.frame.size.height)];
        deleteOrNot = NO;
    }
    
    
    
    for(int i=0;i<picBtnArray.count;i++)
    {
        UIButton *btn = [picBtnArray objectAtIndex:i];
        UIImageView *iv = [[UIImageView alloc] init];
        //相机
        if(cameraOrPhoto == 0)
        {
            if(deleteOrNot == NO)
            {
                [btn setFrame:CGRectMake(20*(i+1)+(MainScreenWidth-80)/3*i, self.uplabel.frame.origin.y + self.uplabel.frame.size.height, (MainScreenWidth-80)/3, (MainScreenWidth-80)/3)];
//                if(i == picBtnArray.count-1)
//                {
//                    [lastUpPicBtn setFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width+20,btn.frame.origin.y,(MainScreenWidth-80)/3,(MainScreenWidth-80)/3)];
//                }
            }
            else
            {
                [btn setFrame:CGRectMake(20*(i+1)+(MainScreenWidth-80)/3*i, self.uplabel.frame.origin.y + self.uplabel.frame.size.height+10, (MainScreenWidth-80)/3, (MainScreenWidth-80)/3-5)];
            }
            if(i == picBtnArray.count-1)
            {
                [lastUpPicBtn setFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width+20,btn.frame.origin.y,(MainScreenWidth-80)/3,(MainScreenWidth-80)/3)];
            }
        }
        else
        {
            [btn setFrame:CGRectMake(20*(i+1)+(MainScreenWidth-80)/3*i, self.uplabel.frame.origin.y + self.uplabel.frame.size.height+10, (MainScreenWidth-80)/3, (MainScreenWidth-80)/3)];
            if(i == picBtnArray.count-1)
            {
                [lastUpPicBtn setFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width+20,btn.frame.origin.y,(ScreenWidth-80)/3,(MainScreenWidth-80)/3)];
            }
        }
        iv.frame = CGRectMake(0,0, (MainScreenWidth-80)/3, (MainScreenWidth-80)/3);
        [iv setImage:(UIImage *)[chooseImageArray objectAtIndex:i]];
        [btn addSubview:iv];
        [self.view addSubview:btn];
        
        [btn addTarget:self action:@selector(picBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    
    //    UIButton *lastbtn = [picBtnArray lastObject];
    
    
    if(chooseImageArray.count > 0 && chooseImageArray.count < 3)
    {
        
        [lastUpPicBtn setHidden:NO];
        
    }
}

- (void) picBtnClick:(UIButton *) sender
{
    deleteOrNot = NO;
  
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    [self setHidesBottomBarWhenPushed:YES];
    LookForBigPicViewController *lookForBigPicViewController = [sb instantiateViewControllerWithIdentifier:@"lookForBigPicViewController"];
    lookForBigPicViewController.delegate = self;
    lookForBigPicViewController.myPicBtnArray = [[NSMutableArray alloc] initWithArray:picBtnArray];
    lookForBigPicViewController.myImageArray = [[NSMutableArray alloc] initWithArray:chooseImageArray];
    [self.navigationController pushViewController:lookForBigPicViewController animated:YES];
    
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
            //            [picBtn setBackgroundColor:[UIColor redColor]];
            
        }
    }
    
    NSLog(@"%@",chooseImageArray);
    
    [self refreshView];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
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

- (void) upBtnClick:(UIButton *) sender
{
    
}

- (void) onlinePayBtnClick:(UIButton *) sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
