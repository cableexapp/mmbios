//
//  SettingViewController.m
//  B2C_MMB_iOS
//
//  Created by xiaochen on 14-10-10.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "SettingViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DCFTopLabel.h"

@interface SettingViewController ()
{
    NSString *sdPath;
    
    float sdPicCache;  //SDWebImage图片缓存大小
}
@end

@implementation SettingViewController

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
    [super viewWillAppear:YES];
    
//    NSLog(@"%@",NSHomeDirectory());
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSLog(@"%@",paths);
    NSString *LibraryDirectory = [paths objectAtIndex:0];
//    NSLog(@"%@",LibraryDirectory);
    sdPath = [NSString stringWithFormat:@"%@/%@/%@",LibraryDirectory,@"Caches",@"com.hackemist.SDWebImageCache.default"];
//    NSLog(@"%@",sdPath);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"设置"];
    self.navigationItem.titleView = top;
    
    [self.view setUserInteractionEnabled:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.cleanBackView.backgroundColor = [UIColor whiteColor];
    
    UIView *firstLine = [[UIView alloc] init];
    firstLine.frame = CGRectMake(0, 0, self.view.frame.size.width, 0.5);
    firstLine.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    [self.cleanBackView addSubview:firstLine];
    
    UIView *secondLine = [[UIView alloc] init];
    secondLine.frame = CGRectMake(0,49.5, self.view.frame.size.width,0.5);
    secondLine.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    [self.cleanBackView addSubview:secondLine];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.cleanBackView addGestureRecognizer:tap];
    [self.cleanBackView setUserInteractionEnabled:YES];
    
    [self.swith setOn:[[[NSUserDefaults standardUserDefaults] objectForKey:@"closeOrOpenPush"] boolValue]];
    [self.swith addTarget:self action:@selector(swichChange:) forControlEvents:UIControlEventValueChanged];
}

- (void) tap:(UITapGestureRecognizer *) sender
{    
    as = [[UIActionSheet alloc] initWithTitle:@"您确定要清除缓存图片吗？"
                                     delegate:self
                            cancelButtonTitle:@"取消"
                       destructiveButtonTitle:@"确定"
                            otherButtonTitles:nil, nil];
    [as showInView:self.view];
}

#pragma mark - 单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - 遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    sdPicCache = folderSize/(1024.0*1024.0);
    return sdPicCache;
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            BOOL bRet = [fileMgr fileExistsAtPath:sdPath];
            if (bRet)
            {
                NSError *err;
                [fileMgr removeItemAtPath:sdPath error:&err];
            }
            break;
        }
        case 1:
        {
      
             break;
        }
        default:
            break;
    }
}

- (void) swichChange:(UISwitch *) sender
{
    UISwitch *swith_1 = (UISwitch *)sender;
    BOOL isChange = [swith_1 isOn];
    if(isChange == YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"closeOrOpenPush"];
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge  | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"closeOrOpenPush"];
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
