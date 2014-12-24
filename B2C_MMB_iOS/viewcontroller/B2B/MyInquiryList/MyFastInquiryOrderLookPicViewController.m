//
//  MyFastInquiryOrderLookPicViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-12-24.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "MyFastInquiryOrderLookPicViewController.h"
#import "MCDefine.h"

@interface MyFastInquiryOrderLookPicViewController ()

@end

@implementation MyFastInquiryOrderLookPicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithArray:(NSMutableArray *) picArray WithTag:(int) tag
{
    if(self = [super init])
    {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        myPicArray = [[NSMutableArray alloc] initWithArray:picArray];
        myTag = tag;
        
        int count = myPicArray.count;

        sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, MainScreenHeight-100-64)];
        [sv setDelegate:self];
        [sv setShowsHorizontalScrollIndicator:NO];
        [sv setShowsVerticalScrollIndicator:NO];
        [sv setContentSize:CGSizeMake(ScreenWidth*count, sv.frame.size.height)];
        [sv setContentOffset:CGPointMake(ScreenWidth*myTag, 0)];
        [sv setBounces:NO];
        [sv setPagingEnabled:YES];
        [self.view addSubview:sv];
        
        for(int i=0;i<myPicArray.count;i++)
        {
            UIImage *img = (UIImage *)[myPicArray objectAtIndex:i];
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, sv.frame.size.width, sv.frame.size.height)];
            [iv setContentMode:UIViewContentModeScaleAspectFit];
            [iv setImage:img];
            [sv addSubview:iv];
        }
    }
    return self;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
