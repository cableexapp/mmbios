//
//  LookForBigPicViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-22.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "LookForBigPicViewController.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"

@interface LookForBigPicViewController ()
{
    int page;
}
@end

@implementation LookForBigPicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithPicArray:(NSMutableArray *) picBtnArray WithImageArray:(NSMutableArray *) imageArray
{
    if(self = [super init])
    {

    }
    return self;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"照片预览"];
    self.navigationItem.titleView = top;
    
    
    page = 0;
    

    
    [_sv setContentSize:CGSizeMake(ScreenWidth*_myPicBtnArray.count, self.sv.frame.size.height-40)];
    [_sv setBounces:NO];
    [_sv setScrollEnabled:YES];
    [_sv setPagingEnabled:YES];
    
    for(int i=0;i<_myImageArray.count;i++)
    {
        UIImage *image = [_myImageArray objectAtIndex:i];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, self.sv.frame.size.height)];
        [iv setImage:image];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        [self.sv addSubview:iv];
    }
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 50, 50)];
    [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    

}

- (void) rightItemClick:(UIButton *) sender
{
    if(_myPicBtnArray && _myPicBtnArray.count != 0)
    {
        [_myPicBtnArray removeObjectAtIndex:page];
    }

    
    if(_myImageArray && _myImageArray.count != 0)
    {
        [_myImageArray removeObjectAtIndex:page];

        for(UIImageView *iv in _sv.subviews)
        {
            [iv removeFromSuperview];
        }
        [_sv setContentSize:CGSizeMake(ScreenWidth*_myPicBtnArray.count, self.sv.frame.size.height)];

        for(int i=0;i<_myImageArray.count;i++)
        {
            UIImage *image = [_myImageArray objectAtIndex:i];
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, self.sv.frame.size.height)];
            [iv setImage:image];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            [self.sv addSubview:iv];
        }
    }
    if(_myImageArray.count == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
   
    NSLog(@"page = %d",page);
    [self.delegate deleteWithPicBtn:_myPicBtnArray WithImageArray:_myImageArray];
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
