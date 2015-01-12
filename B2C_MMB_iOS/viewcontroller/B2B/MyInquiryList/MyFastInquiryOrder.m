//
//  MyFastInquiryOrder.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-11-10.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyFastInquiryOrder.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"
#import "SpeedAskPriceFirstViewController.h"
#import "UIImageView+WebCache.h"
#import "MyNormalInquiryDetailController.h"
#import "ZipArchive.h"
#import "DCFStringUtil.h"
#import "MyFastInquiryOrderLookPicViewController.h"

@implementation MyFastInquiryOrder
{
    NSDictionary *myDic;
    NSString *fullAddress;
    NSString *inquiryserial;
    NSString *inquiryid;
    UILabel *situationLabel;
    
    NSString *oemNo;
    
    NSMutableArray *picArray;
    
    UILabel *requestLabel;
    
    NSMutableArray *finalPicArray;
    
    UIView *situationView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
    if(HUD)
    {
        [HUD hide:YES];
    }
    
    // 1. 获取Documents目录,删除pic文件夹
    [self deletePic];
    
    //删除zip文件
//    [self deleteZip];
    
    //删除txt文件
//    [self deleteTxt];
    
}

- (void) deleteTxt
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *MapLayerDataPath = [documentsDirectory stringByAppendingPathComponent:@"text.txt"];
    BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
    if (bRet) {
        //
        NSError *err;
        [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
    }
    
}

- (void) deletePic
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *MapLayerDataPath = [documentsDirectory stringByAppendingPathComponent:@"pic"];
    BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
    if (bRet) {
        //
        NSError *err;
        [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
    }
    //    [_imageView setImage:nil];
    
}

- (void) deleteZip
{
    // 1. 获取Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *MapLayerDataPath = [documentsDirectory stringByAppendingPathComponent:@"zipfile.zip"];
    BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
    if (bRet) {
        //
        NSError *err;
        [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    
    [self deletePic];
//    [self deleteTxt];
//    [self deleteZip];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    picArray = [[NSMutableArray alloc] init];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.sv setBackgroundColor:[UIColor whiteColor]];
    
    self.againAskBtn.layer.cornerRadius = 5;
    self.againAskBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
    
    self.lookBtn.layer.cornerRadius = 5;
    self.lookBtn.backgroundColor = [UIColor colorWithRed:19/255.0 green:90/255.0 blue:168/255.0 alpha:1.0];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"快速询价单详情"];
    self.navigationItem.titleView = top;
    
    [self.orderLabel setFrame:CGRectMake(self.orderLabel.frame.origin.x, self.orderLabel.frame.origin.y, ScreenWidth-100, self.orderLabel.frame.size.height)];
    if([DCFCustomExtra validateString:self.fastData.oemNo] == NO)
    {
        oemNo = @"";
    }
    else
    {
        oemNo = self.fastData.oemNo;
    }
    [self.orderLabel setText:[NSString stringWithFormat:@"询价单号: %@",oemNo]];
    
    [self.statusLabel setText:[NSString stringWithFormat:@"状态:%@",self.fastData.speedStatus]];
    [self.statusLabel setTextAlignment:NSTextAlignmentRight];
    
    NSString *mytime = [NSString stringWithFormat:@"提交时间: %@",self.fastData.myTime];
    if([DCFCustomExtra validateString:self.fastData.myTime] == NO)
    {
        [self.upTimeLabel setFrame:CGRectMake(10, 0, ScreenWidth-20, 0)];
    }
    else
    {
        [self.upTimeLabel setFrame:CGRectMake(10, 0, ScreenWidth-20, self.upTimeLabel.frame.size.height)];
        NSMutableAttributedString *myTime = [[NSMutableAttributedString alloc] initWithString:mytime];
        [myTime addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
        [myTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, mytime.length-5)];
        [self.upTimeLabel setAttributedText:myTime];
    }
    
    NSString *myphone = [NSString stringWithFormat:@"联系电话: %@",self.fastData.phone];
    if([DCFCustomExtra validateString:self.fastData.phone] == NO)
    {
        [self.telLabel setFrame:CGRectMake(10, self.upTimeLabel.frame.origin.y+self.upTimeLabel.frame.size.height, ScreenWidth-20, 0)];
    }
    else
    {
        [self.telLabel setFrame:CGRectMake(10, self.upTimeLabel.frame.origin.y+self.upTimeLabel.frame.size.height, ScreenWidth-20, self.telLabel.frame.size.height)];
        NSMutableAttributedString *myPhone = [[NSMutableAttributedString alloc] initWithString:myphone];
        [myPhone addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
        [myPhone addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(5, myphone.length-5)];
        [self.telLabel setAttributedText:myPhone];
    }
    NSString *linkmanName = [self.fastData.linkman stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *myman = [NSString stringWithFormat:@"联系人: %@",linkmanName];
    if([DCFCustomExtra validateString:self.fastData.linkman] == NO)
    {
        [self.linkManLabel setFrame:CGRectMake(10, self.telLabel.frame.origin.y+self.telLabel.frame.size.height, ScreenWidth-20, 0)];
    }
    else
    {
        [self.linkManLabel setFrame:CGRectMake(10, self.telLabel.frame.origin.y+self.telLabel.frame.size.height, ScreenWidth-20, self.linkManLabel.frame.size.height)];
        NSMutableAttributedString *myMan = [[NSMutableAttributedString alloc] initWithString:myman];
        [myMan addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
        [myMan addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] range:NSMakeRange(4, myman.length-4)];
        [self.linkManLabel setAttributedText:myMan];
    }
    
    [self.requestFirstLabel setHidden:YES];
    [self.requestFirstLabel setFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    
    CGSize testSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:@"询价需求:" WithSize:CGSizeMake(MAXFLOAT, 30)];
    UILabel *requestFirstLabel = [[UILabel alloc] init];
    [requestFirstLabel setText:@"询价需求:"];
    [requestFirstLabel setFont:[UIFont systemFontOfSize:14]];
    [self.sv addSubview:requestFirstLabel];
    
    requestLabel = [[UILabel alloc] init];
    NSString *request = [NSString stringWithFormat:@"%@",self.fastData.content];
    
    if([DCFCustomExtra validateString:request] == NO)
    {
        [requestFirstLabel setFrame:CGRectMake(10, self.linkManLabel.frame.origin.y+self.linkManLabel.frame.size.height, testSize.width, 0)];
        [requestLabel setFrame:CGRectMake(requestFirstLabel.frame.origin.x+requestFirstLabel.frame.size.width+5, requestFirstLabel.frame.origin.y, ScreenWidth-25-requestFirstLabel.frame.size.width, 0)];
    }
    else
    {
        [requestFirstLabel setFrame:CGRectMake(10, self.linkManLabel.frame.origin.y+self.linkManLabel.frame.size.height, testSize.width, 30)];
        
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:14] WithText:request WithSize:CGSizeMake(ScreenWidth-25-requestFirstLabel.frame.size.width, MAXFLOAT)];
        if(size.height <= 30)
        {
            [requestLabel setFrame:CGRectMake(requestFirstLabel.frame.origin.x+requestFirstLabel.frame.size.width+5, requestFirstLabel.frame.origin.y, ScreenWidth-25-requestFirstLabel.frame.size.width, 30)];
        }
        else
        {
            [requestLabel setFrame:CGRectMake(requestFirstLabel.frame.origin.x+requestFirstLabel.frame.size.width+5, requestFirstLabel.frame.origin.y, ScreenWidth-25-requestFirstLabel.frame.size.width, size.height)];
        }
        [requestLabel setText:request];
    }
    [requestLabel setFont:[UIFont systemFontOfSize:14]];
    [requestLabel setNumberOfLines:0];
    [requestLabel setTextColor:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0]];
    [self.sv addSubview:requestLabel];
    
    UIImageView *iv = [[UIImageView alloc] init];
    if(!picArray || picArray.count == 0)
    {
        [iv setFrame:CGRectMake(10, requestLabel.frame.origin.y+requestLabel.frame.size.height, (ScreenWidth-30)/3, 0)];
    }
    else
    {
        [iv setFrame:CGRectMake(10, requestLabel.frame.origin.y+requestLabel.frame.size.height, (ScreenWidth-30)/3, (ScreenWidth-30)/3)];
    }

    
//    self.fastData.treatment = @"处理情况处理情况处理情况处理情况处理情况处理情况处理情况处理情况处理情况处理情况";
    situationLabel = [[UILabel alloc] init];
    NSString *string = [NSString stringWithFormat:@"%@",self.fastData.treatment];
    NSString *situation = [NSString stringWithFormat:@"处理情况: %@",string];
    
    situationView = [[UIView alloc] initWithFrame:CGRectMake(0, iv.frame.origin.y+iv.frame.size.height+10, ScreenWidth, 40)];
    [situationView setBackgroundColor:[UIColor colorWithRed:86.0/255.0 green:70.0/255.0 blue:86.0/255.0 alpha:1.0]];
    [self.sv addSubview:situationView];
    
    if([DCFCustomExtra validateString:string] == NO)
    {
        [situationView setFrame:CGRectMake(0, iv.frame.origin.y+iv.frame.size.height+10, ScreenWidth, 0)];
        [situationLabel setFrame:CGRectMake(10, iv.frame.origin.y+iv.frame.size.height+10, ScreenWidth-20, 0)];
    }
    else
    {
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont boldSystemFontOfSize:15] WithText:situation WithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT)];
        [situationView setFrame:CGRectMake(0, iv.frame.origin.y+iv.frame.size.height+10, ScreenWidth, size.height+20)];
        [situationLabel setFrame:CGRectMake(10, 10, ScreenWidth-20, size.height)];
    }
    [situationLabel setText:situation];
    [situationLabel setTextColor:[UIColor whiteColor]];
    [situationLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [situationLabel setNumberOfLines:0];
    [situationView addSubview:situationLabel];
    
    
    
    [self.sv setContentSize:CGSizeMake(ScreenWidth, situationView.frame.origin.y+situationView.frame.size.height+20)];
    [self.sv setUserInteractionEnabled:YES];
    
    int inquiryId = [[self.fastData inquiryId] intValue];
    if(inquiryId == 0)
    {
        self.againAskBtn.frame = CGRectMake(15, 9, ScreenWidth-30, 40);
        [self.lookBtn setHidden:YES];
        
    }
    else
    {
        [self.lookBtn setHidden:NO];
    }
    
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *s = [NSString stringWithFormat:@"%@%@",@"OemDetail",time];
    NSString *token = [DCFCustomExtra md5:s];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&oemid=%@",token,self.fastData.oemId];
    
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLGetInquiryInfoTag delegate:self];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2BAppRequest/OemDetail.html?"];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
//    if(!HUD)
//    {
//        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [HUD setLabelText:@"数据加载中..."];
//        [HUD setDelegate:self];
//    }
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    //    int result = [[dicRespon objectForKey:@"result"] intValue];
    if(URLTag == URLGetInquiryInfoTag)
    {
        if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
        {
            myDic = [[NSDictionary alloc] init];
        }
        else
        {
            NSArray *ctems = [NSArray arrayWithArray:[dicRespon objectForKey:@"items"]];
            if(ctems.count == 0 || [ctems isKindOfClass:[NSNull class]])
            {
                myDic = [[NSDictionary alloc] init];
            }
            else
            {
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[ctems lastObject]];
                if([[dic allKeys] count] == 0 || [dic isKindOfClass:[NSNull class]])
                {
                    myDic = [[NSDictionary alloc] init];
                }
                else
                {
                    
                    NSString *filePath = [NSString stringWithFormat:@"%@%@",@"http://www.cableex.com/",[[[dicRespon objectForKey:@"items"] lastObject] objectForKey:@"filePath"]];
                    if([DCFCustomExtra validateString:filePath] == NO)
                    {
                        
                    }
                    else
                    {
                        [self loadPicView:filePath];
                    }
                }
            }
        }
    }
}

- (void) loadPicView:(NSString *) sender
{
    
//    sender = @"http://www.icodeblog.com/wp-content/uploads/2012/08/zipfile.zip";

    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",sender]];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        
        if(!error)
        {
            NSFileManager *myFileManager=[NSFileManager defaultManager];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            
            //在路径下创建一个pic文件夹
            NSString *pathString = [path stringByAppendingPathComponent:@"pic"];
            [myFileManager createDirectoryAtPath:pathString withIntermediateDirectories:YES attributes:nil error:&error];
            
            //在pic文件夹下面创建一个zip文件
            NSString *zipPath = [pathString stringByAppendingPathComponent:@"zipfile.zip"];
            
            //把请求下来的数据写入zip文件
            [data writeToFile:zipPath options:0 error:&error];
            
            if(!error)
            {
                ZipArchive *za = [[ZipArchive alloc] init];
                if ([za UnzipOpenFile: zipPath]) {
                    BOOL ret = [za UnzipFileTo: pathString overWrite: YES];
                    if (NO == ret){} [za UnzipCloseFile];
                    
                    NSDirectoryEnumerator *myDirectoryEnumerator;
                    
                    //指定路径下的遍历
                    myDirectoryEnumerator=[myFileManager enumeratorAtPath:pathString];
                    //全部遍历
                    //                    myDirectoryEnumerator=[myFileManager enumeratorAtPath:[[NSBundle mainBundle] bundlePath]];
                    
                    NSString *file;
                    
                    while((file=[myDirectoryEnumerator nextObject]))     //遍历当前目录
                    {
                        if([[file pathExtension] isEqualToString:@"png"])   //取得后缀名这.png的文件名
                        {
                            [picArray addObject:[pathString stringByAppendingPathComponent:file]]; //存到数组
                        }
                        
                    }
                    
                    finalPicArray = [[NSMutableArray alloc] init];
                    for(int i=0;i<picArray.count;i++)
                    {
                        NSString *picPath = [picArray objectAtIndex:i];
                        if([picPath rangeOfString:@"MAC"].location != NSNotFound)
                        {
                            
                        }
                        else
                        {
                            NSData *imageData = [NSData dataWithContentsOfFile:[picArray objectAtIndex:i] options:0 error:nil];
                            UIImage *img = [UIImage imageWithData:imageData];
                            [finalPicArray addObject:img];
                        }
                    }
    
                    dispatch_async(dispatch_get_main_queue(), ^{[self refreshView:finalPicArray];});
 
                }
            }
            else
            {

            }
        }
        else
        {
            [self performSelectorOnMainThread:@selector(fail) withObject:nil waitUntilDone:YES];
        }
        
    });
    
}

- (void) picBtnClick:(UIButton *) sender
{
    
    MyFastInquiryOrderLookPicViewController *myFastInquiryOrderLookPicViewController = [[MyFastInquiryOrderLookPicViewController alloc] initWithArray:finalPicArray WithTag:sender.tag];
    [self.navigationController pushViewController:myFastInquiryOrderLookPicViewController animated:YES];
}

- (void) refreshView:(NSMutableArray *) sender
{
    NSMutableArray *array = (NSMutableArray *) sender;
    CGFloat width = (ScreenWidth-30)/3;
    for(int i = 0;i<array.count;i++)
    {
        UIButton *picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [picBtn setFrame:CGRectMake(10+(width+5)*i, requestLabel.frame.origin.y+requestLabel.frame.size.height+10, width, width)];
        [picBtn addTarget:self action:@selector(picBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [picBtn setTag:i];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[array objectAtIndex:i]];
        [iv setFrame:CGRectMake(0,0, width, width)];
        [iv setContentMode:UIViewContentModeScaleAspectFit];
        [picBtn setBackgroundImage:[array objectAtIndex:i] forState:UIControlStateNormal];
        
//        [iv setContentMode:UIViewContentModeScaleAspectFill];
        
        [self.sv addSubview:picBtn];
        if(i == 0)
        {
            [situationView setFrame:CGRectMake(0, picBtn.frame.origin.y+picBtn.frame.size.height+10, ScreenWidth, situationView.frame.size.height)];
            [self.sv setContentSize:CGSizeMake(ScreenWidth, situationView.frame.origin.y+situationView.frame.size.height+20)];
        }
    }
//    if(HUD)
//    {
//        [HUD hide:YES];
//    }
}

- (void) fail
{
//    [DCFStringUtil showNotice:@"图片下载失败"];
}

- (void) ivTap:(UITapGestureRecognizer *) sender
{
}

- (IBAction)againAskBtnClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    SpeedAskPriceFirstViewController *speedAskPriceFirstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"speedAskPriceFirstViewController"];
    [self.navigationController pushViewController:speedAskPriceFirstViewController animated:YES];
}

- (IBAction)lookBtnClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    MyNormalInquiryDetailController *myNormalInquiryDetailController = [self.storyboard instantiateViewControllerWithIdentifier:@"myNormalInquiryDetailController"];
    
#pragma mark - 这里暂时用oemid替换inquirId
    myNormalInquiryDetailController.myOrderNum = oemNo;
    
    
    NSString *status = [NSString stringWithFormat:@"%@",[self.fastData speedStatus]];
    myNormalInquiryDetailController.myStatus = status;
    
    
    NSString *upTime = [self.fastData myTime];
    myNormalInquiryDetailController.myTime = upTime;
    
    
    myNormalInquiryDetailController.myInquiryid = self.fastData.inquiryId;
    myNormalInquiryDetailController.myDic = [NSDictionary dictionaryWithDictionary:myDic];
    
    [self.navigationController pushViewController:myNormalInquiryDetailController animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
